const fs = require("node:fs");
const regNoSpace = /\S/g;
const regNoWord = /\W/g;

const SCALAR_TYPES = new Map([
    ["double", "double"],
    ["float", "float"],
    ["int32", "int32"],
    ["int64", "int64"],
    ["uint32", "uint32"],
    ["uint64", "uint64"],
    ["sint32", "int32"],
    ["sint64", "int64"],
    ["fixed32", "uint32"],
    ["fixed64", "uint64"],
    ["sfixed32", "int32"],
    ["sfixed64", "int64"],
    ["bool", "bool"],
    ["string", "string"],
    ["bytes", "string"],
]);

const isScalar = type => {
    return SCALAR_TYPES.has(type);
}

const getTypeName = proto => {
    const pos = proto.lastIndexOf(".");
    return proto.slice(pos + 1);
};

const getEnumFQN = (proto, enum_field) => {
    const pos = proto.lastIndexOf(".");
    return proto.slice(0, pos + 1) + enum_field;
};

const createOutputs = () => {
    return {
        decls: [],
        generated_include: [],
    };
};

class Parser {
    constructor() {
        this.pos = 0;
        this.imports = new Map();
        this.import_enums = new Set();
        this.exports = new Map();
        this.export_enums = new Set();
        this.package = "";
        this.messages = [];
    }

    getFQN(message) {
        const parts = this.package.split(".");
        parts.pop();
        parts.push(...this.messages);
        parts.push(...message.split("."));
        return parts;
    }

    isEnum(type) {
        const fqn = this.getCppType(type).split("::").join(".");
        return this.export_enums.has(fqn) || this.import_enums.has(fqn);
    }

    getCppType(type) {
        if (isScalar(type)) {
            return [type, SCALAR_TYPES.get(type)];
        }

        const message = type;

        // lookup in exports
        for (let i = this.messages.length - 1; i >= -1; i--) {
            const fqn = i === -1 ? message : `${ this.messages.slice(0, i + 1) }.${ message }`;
            if (this.exports.has(fqn)) {
                return fqn;
            }
        }

        // lookup in imports with package
        const imported = `${ this.package }.${ message }`;
        if (this.imports.has(imported)) {
            return imported;
        }

        // lookup in imports without package
        if (this.imports.has(message)) {
            return message;
        }

        return this.getFQN(type).join("::");
    }

    getImport(filename, relpath) {
        filename = fs.realpathSync(filename);

        if (!this.cache.has(filename)) {
            const parser = new Parser();
            const _filename = this.options.filename;
            this.options.filename = relpath;
            parser.parseFile(filename, this.options, this.outputs, this.cache);
            this.options.filename = _filename;
        }

        return this.cache.get(filename);
    }

    parseFile(filename, options = {}, outputs = createOutputs(), cache = new Map()) {
        filename = fs.realpathSync(filename);

        cache.set(filename, {
            exports: this.exports,
            export_enums: this.export_enums
        });

        const proto = fs.readFileSync(filename).toString();
        this.parseText(proto, options, outputs, cache);
    }

    parseText(proto, options = {}, outputs = createOutputs(), cache = new Map()) {
        this.proto = proto;
        this.len = proto.length;
        this.options = options;
        this.outputs = outputs;
        this.cache = cache;

        const {decls} = outputs

        while (this.pos < this.len) {
            this.consumeCommentOrSpace();
            if (!this.maybePackage() && !this.maybeImport() && !this.maybeMessage() && !this.maybeEnum()) {
                break;
            }
        }

        if (this.pos !== this.len) {
            const lines = [0];
            let pos = 0
            while ((pos = this.proto.indexOf("\n", pos)) !== -1 && pos < this.pos) {
                lines.push(++pos);
            }
            const start = lines.pop();
            const end = pos === -1 ? this.pos + 10 : Math.min(this.pos + 10, pos - 1);
            const space = " ".repeat(this.pos - start) + "^";
            throw new Error(`Failed to parse proto. Unexpected token at line ${ lines.length }\n${ proto.slice(start, end) }\n${ space }`);
        }

        const filename = options.filename || "globals.proto";
        const top = filename.replaceAll("/", ".").replace(".proto", "") + "_pb2.";
        outputs.generated_include.push(`#incldue "${ filename.replace(".proto", ".pb.h") }"`);

        const classes = new Map([
            [top, []]
        ]);

        // expose a package property like in mediapipe python
        // package.A.B.C
        // => package. A /R /S
        // => package.A. B /R /S
        // => package.A.B. C /R /S
        for (const [proto, raw_fields] of this.exports.entries()) {
            if (this.imports.has(proto)) {
                continue;
            }

            if (this.export_enums.has(proto)) {
                const fields = [];
                this.outputs.decls.push([`enum ${ proto }`, "", [], fields]);
                for (const [enum_field, enum_value] of raw_fields) {
                    fields.push([`const ${ getEnumFQN(proto, enum_field) }`, enum_value, []]);
                }
                continue;
            }

            const type_name = getTypeName(proto);
            const fields = [];

            this.outputs.decls.push(...[
                [`class ${ proto }`, ": google::protobuf::Message", ["/Simple"], fields, "", ""],
                [`${ proto }.${ type_name }`, "", [], [], "", ""],
            ]);

            for (const [field_type, field_name, is_repeated] of raw_fields) {
                const cpptype = this.getCppType(field_type);

                if (is_repeated) {
                    // TODO handle repeated : return RepeatedField
                } else if (isScalar(field_type) || this.isEnum(field_type)) {
                    fields.push([field_type, field_name, "", [`/R=${ field_name }`, `/W=set_${ field_name }`]]);
                } else {
                    this.outputs.decls.push(...[
                        [`${ proto }.mutable_${ field_name }`, `${ cpptype }*`, ["/attr=propget", `=get_${ field_name }`, `/idlname=${ field_name }`], [], "", ""],
                    ]);
                }
            }

            const parts = proto.slice(this.package.length).split(".");
            for (let i = 0; i < parts.length; i++) {
                const pkg = top + (i === 0 ? "" : parts.slice(0, i).join(".") + ".");
                const name = parts[i];
                if (!classes.has(pkg)) {
                    classes.set(pkg, []);
                }
                const cpptype = this.package.replaceAll(".", "::") + parts.slice(0, i + 1).join("::");
                if (!classes.get(pkg).some(([, prop]) => prop === name)) {
                    classes.get(pkg).push([cpptype, name, "", ["/R", "=this", "/S"]]);
                }
            }
        }

        for (const [pkg, properties] of classes.entries()) {
            decls.push([pkg, "", ["/Properties"], properties, "", ""]);
        }

        return outputs;
    }

    maybePackage() {
        const {pos} = this;
        const identifier = this.maybeWord();

        if (identifier !== "package") {
            this.pos = pos;
            return false;
        }

        this.consumeCommentOrSpace();

        const start = this.pos;

        while (/[\w.]/.test(this.proto[this.pos])) {
            this.pos++;
        }

        const pkg = this.proto.slice(start, this.pos);

        if (!this.maybeFieldEnd()) {
            this.pos = pos;
            return false;
        }

        this.package = pkg + ".";
        return true;
    }

    maybeImport() {
        const {pos} = this;
        const identifier = this.maybeWord();

        if (identifier !== "import") {
            this.pos = pos;
            return false;
        }

        this.consumeCommentOrSpace();

        const isPublic = this.maybeWord() === "public";

        this.consumeCommentOrSpace();

        if (this.proto[this.pos] !== '"') {
            this.pos = pos;
            return false;
        }

        const start = ++this.pos;
        const end = this.proto.indexOf('"', start);
        if (end === -1) {
            this.pos = pos;
            return false;
        }

        const relpath = this.proto.slice(start, end);
        const filename = relpath;

        if (this.options.proto_path && this.options.proto_path.length !== 0) {
            for (const proto_path of this.options.proto_path) {
                if (fs.existsSync(proto_path + "/" + filename)) {
                    filename = proto_path + "/" + filename;
                    break;
                }
            }
        }

        const imported = this.getImport(filename, relpath);

        for (const [fqn_imported, fields_imported] of imported.exports.entries()) {
            this.imports.set(fqn_imported, fields_imported);
            if (isPublic) {
                this.exports.set(fqn_imported, fields_imported);
            }
        }

        for (const [fqn_imported, fields_imported] of imported.exports_enums.entries()) {
            this.imports_enums.set(fqn_imported, fields_imported);
            if (isPublic) {
                this.exports_enums.set(fqn_imported, fields_imported);
            }
        }

        return true;
    }

    maybeMessage() {
        const {pos} = this;
        const identifier = this.maybeWord();

        if (identifier !== "message") {
            this.pos = pos;
            return false;
        }

        this.consumeCommentOrSpace();

        const message = this.maybeWord();
        if (!message) {
            this.pos = pos;
            return false;
        }

        if (!this.maybeCharSeq("{")) {
            this.pos = pos;
            return false;
        }

        const proto = this.getFQN(message).join(".");
        const fields = [];

        this.exports.set(proto, fields);

        this.messages.push(message);

        this.consumeCommentOrSpace();

        while (this.maybeMessage() || this.maybeEnum() || this.maybeField(fields)) {
            this.consumeCommentOrSpace();
        }

        this.messages.pop();

        if (!this.maybeCharSeq("}")) {
            this.pos = pos;
            return false;
        }

        return true;
    }

    maybeEnum() {
        const {pos} = this;
        const identifier = this.maybeWord();

        if (identifier !== "enum") {
            this.pos = pos;
            return false;
        }

        this.consumeCommentOrSpace();

        const enum_name = this.maybeWord();
        if (!enum_name) {
            this.pos = pos;
            return false;
        }

        if (!this.maybeCharSeq("{")) {
            this.pos = pos;
            return false;
        }

        const proto = this.getFQN(enum_name).join(".");
        const fields = [];

        this.export_enums.add(proto)
        this.exports.set(proto, fields);

        while (this.maybeEnumField(fields)) {
            // Nothing to do
        }

        if (!this.maybeCharSeq("}")) {
            this.pos = pos;
            return false;
        }

        return true;
    }

    maybeComment() {
        if (this.proto.startsWith("//", this.pos)) {
            this.pos = this.proto.indexOf("\n", this.pos + "//".length);
            if (this.pos === -1) {
                this.pos = this.len;
            }
            this.pos += "\n".length;
            return true;
        }

        const {pos} = this;
        if (this.proto.startsWith("/*", this.pos)) {
            this.pos = this.proto.indexOf("*/", this.pos + "/*".length);
            if (this.pos === -1) {
                this.pos = pos;
                return false;
            }
            this.pos += "*/".length;
            return true;
        }

        return false;
    }

    maybeSpace() {
        regNoSpace.lastIndex = this.pos;
        const match = regNoSpace.exec(this.proto);

        if (match === null) {
            this.pos = this.len;
            return true;
        }

        if (this.pos === match.index) {
            return false;
        }

        this.pos = match.index;
        return true;
    }

    maybeWord() {
        regNoWord.lastIndex = this.pos;
        const match = regNoWord.exec(this.proto);
        if (match === null || this.pos === match.index) {
            return false;
        }

        const word = this.proto.slice(this.pos, match.index);
        this.pos = match.index;
        return word;
    }

    consumeCommentOrSpace() {
        while (this.maybeSpace() || this.maybeComment()) {
            if (this.pos === this.len) {
                break;
            }
        }
    }

    maybeField(fields) {
        const {pos} = this;

        const identifier = this.maybeWord();
        if (identifier === "reserved") {
            if (!this.maybeFieldEnd()) {
                this.pos = pos;
                return false;
            }
            return true;
        }

        let is_repeated = identifier === "repeated";
        let field_type;
        let start = pos;;

        if (identifier === "required" || identifier === "optional" || is_repeated) {
            this.consumeCommentOrSpace();
            start = this.pos;
            this.maybeWord();
        }

        while (this.pos < this.len && this.proto[this.pos] === ".") {
            this.pos++;
            this.maybeWord();
        }

        field_type = this.proto.slice(start, this.pos);

        if (!field_type) {
            this.pos = pos;
            return false;
        }

        this.consumeCommentOrSpace();

        const field_name = this.maybeWord();
        if (!field_name) {
            this.pos = pos;
            return false;
        }

        this.consumeCommentOrSpace();

        if (!this.maybeFieldEnd()) {
            this.pos = pos;
            return false;
        }

        fields.push([field_type, field_name, is_repeated]);

        return true;
    }

    maybeEnumField(fields) {
        const {pos} = this;

        this.consumeCommentOrSpace();

        const enum_field = this.maybeWord();
        if (enum_field === "option") {
            if (!this.maybeFieldEnd()) {
                this.pos = pos;
                return false;
            }
            return true;
        }

        if (!this.maybeCharSeq("=")) {
            this.pos = pos;
            return false;
        }

        this.consumeCommentOrSpace();

        const enum_value = this.maybeWord();
        if (!enum_value) {
            this.pos = pos;
            return false;
        }

        if (!this.maybeFieldEnd()) {
            this.pos = pos;
            return false;
        }

        fields.push([enum_field, enum_value]);

        return true;
    }

    maybeFieldEnd() {
        const {pos} = this.pos;
        this.consumeCommentOrSpace();
        this.pos = this.proto.indexOf(";", this.pos);
        if (this.pos === -1) {
            this.pos = pos;
            return false;
        }
        this.pos += ";".length;
        return true;
    }

    maybeCharSeq(seq) {
        const {pos} = this;
        this.consumeCommentOrSpace();

        if (!this.proto.startsWith(seq, this.pos)) {
            this.pos = pos;
            return false;
        }

        this.pos += seq.length;

        return true;
    }
}

module.exports = Parser;
