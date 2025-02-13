const fs = require("node:fs");
const regNoSpace = /\S/g;
const regNoWord = /\W/g;

const SCALAR_TYPES = new Map([
    ["double", "double"],
    ["float", "float"],
    ["int32", "int"],
    ["int64", "int64_t"],
    ["uint32", "uint32_t"],
    ["uint64", "uint64_t"],
    ["sint32", "int"],
    ["sint64", "int64_t"],
    ["fixed32", "uint32_t"],
    ["fixed64", "uint64_t"],
    ["sfixed32", "int"],
    ["sfixed64", "int64_t"],
    ["bool", "bool"],
    ["string", "std::string"],
    ["bytes", "std::string"],
]);

const FieldDescriptor_Type = {
    double: 1,
    float: 2,
    int64: 3,
    uint64: 4,
    int32: 5,
    fixed64: 6,
    fixed32: 7,
    bool: 8,
    string: 9,
    group: 10,
    message: 11,
    bytes: 12,
    uint32: 13,
    enum: 14,
    sfixed32: 15,
    sfixed64: 16,
    sint32: 17,
    sint64: 18,
};

const isScalar = type => {
    return SCALAR_TYPES.has(type);
};

const isPrimitive = type => {
    return type !== "string" && type !== "bytes" && isScalar(type);
};

const getTypeName = proto => {
    const pos = proto.lastIndexOf(".");
    return proto.slice(pos + 1);
};

const getEnumFQN = (proto, enum_field) => {
    const pos = proto.lastIndexOf(".");
    return proto.slice(0, pos + 1) + enum_field;
};

class Parser {
    static createOutputs() {
        return {
            decls: [],
            generated_include: [],
            typedefs: new Map(),
        };
    }

    constructor() {
        this.pos = 0;
        this.imports = new Map();
        this.import_enums = new Set();
        this.exports = new Map();
        this.export_enums = new Set();
        this.extensions = new Map();
        this.package = "";
        this.messages = [];
    }

    getFQN(message, scopes = this.messages) {
        const parts = this.package.split(".");
        parts.pop();
        parts.push(...scopes);
        parts.push(...message.split("."));
        return parts;
    }

    isEnum(type, scopes) {
        const fqn = this.getCppType(type, scopes).replaceAll("::", ".");
        return this.export_enums.has(fqn) || this.import_enums.has(fqn);
    }

    getCppType(type, scopes) {
        if (isScalar(type)) {
            return SCALAR_TYPES.get(type);
        }

        const pkg = type[0] === "." ? "" : `${ this.package }${ scopes.join(".") }.`;
        const message = type[0] === "." ? type.slice(1) : type;
        scopes = pkg.split(".");

        // lookup in exports
        for (let i = scopes.length - 1; i >= -1; i--) {
            const fqn = i === -1 ? message : `${ scopes.slice(0, i).join(".") }.${ message }`;
            if (this.exports.has(fqn)) {
                return fqn.replaceAll(".", "::");
            }
        }

        // lookup in imports
        for (let i = scopes.length - 1; i >= -1; i--) {
            const fqn = i === -1 ? message : `${ scopes.slice(0, i).join(".") }.${ message }`;
            if (this.imports.has(fqn)) {
                return fqn.replaceAll(".", "::");
            }
        }

        return this.getFQN(type, scopes).join("::");
    }

    getFieldType(type, scopes) {
        if (isScalar(type)) {
            return FieldDescriptor_Type[type];
        }

        if (this.isEnum(type, scopes)) {
            return FieldDescriptor_Type.enum;
        }

        return FieldDescriptor_Type.message;
    }

    getTypeTraits(type, scopes) {
        if (isPrimitive(type)) {
            return `PrimitiveTypeTraits<${ type }>`;
        }

        if (type === "string" || type === "bytes") {
            return "StringTypeTraits";
        }

        const ExtendingType = this.getCppType(type, scopes);

        if (this.isEnum(type, scopes)) {
            return `EnumTypeTraits<${ ExtendingType }>`;
        }

        return `MessageTypeTraits<::${ ExtendingType }>`;
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

    parseFile(filename, options = {}, outputs = Parser.createOutputs(), cache = new Map()) {
        filename = fs.realpathSync(filename);

        if (cache.has(filename)) {
            return;
        }

        cache.set(filename, {
            exports: this.exports,
            export_enums: this.export_enums
        });

        const proto = fs.readFileSync(filename).toString();
        this.parseText(proto, options, outputs, cache);
    }

    parseText(input, options = {}, outputs = Parser.createOutputs(), cache = new Map()) {
        this.input = input;
        this.len = input.length;
        this.options = options;
        this.outputs = outputs;
        this.cache = cache;

        const globalOptions = [];
        const { decls, typedefs } = outputs;
        const { self_get, language} = options;

        this.consumeCommentOrSpace();
        this.maybeSyntax();

        while (this.pos < this.len) {
            this.consumeCommentOrSpace();
            if (
                !this.maybePackage()
                && !this.maybeImport()
                && !this.maybeOption(globalOptions)
                && !this.maybeMessage()
                && !this.maybeEnum()
                && !this.maybeExtend()
            ) {
                break;
            }
        }

        const filename = options.filename || "globals.proto";

        if (this.pos !== this.len) {
            const lines = [0];
            let pos = 0;
            while ((pos = input.indexOf("\n", pos)) !== -1 && pos < this.pos) {
                lines.push(++pos);
            }
            const start = lines.pop();
            const end = pos === -1 ? this.pos + 50 : Math.min(this.pos + 50, pos);
            const space = `${ " ".repeat(this.pos - start) }^`;
            throw new Error(`Failed to parse proto ${ filename }.\nUnexpected token at line ${ lines.length + 1 }\n${ input.slice(start, end) }\n${ space }`);
        }

        const top = `${ filename.replaceAll("/", ".").replace(/\.proto$/, "") }_pb2.`;
        outputs.generated_include.push(`#include "${ filename.replace(".proto", ".pb.h") }"`);

        const classes = new Map([
            [top, []]
        ]);

        const cmessage = `::google::protobuf::${ language }::cmessage`;

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
            const ctor = [`${ proto }.${ type_name }`, "", [], [], "", ""];
            const [, , func_modifiers, list_of_arguments] = ctor;
            const body = [];

            this.outputs.decls.push(...[
                [`class ${ proto }`, ": google::protobuf::Message", ["/Simple"], fields, "", ""],
                ctor,
            ]);

            const {scopes} = raw_fields;

            for (const [field_type, field_name, field_rule] of raw_fields.fields) {
                const is_map = field_type.startsWith("map<");
                const is_scalar = isScalar(field_type) || this.isEnum(field_type, scopes);
                const cpptype = this.getCppType(field_type, scopes);
                const i = list_of_arguments.length;

                if (is_map) {
                    // TODO handle map : return MapContainer
                    console.log("map is not currently supported", field_type, field_name);
                    continue;
                }

                let argtype = cpptype;

                if (field_rule === "repeated") {
                    argtype = "VARIANT*";
                    this.addRepeatedField(proto, fields, field_type, field_name, scopes, body, i);
                } else if (is_scalar) {
                    argtype = `std::optional<${ cpptype }>`;
                    body.push(`
                        if (${ field_name }.has_value()) {
                            shared_message->set_${ field_name }(${ field_name }.value());
                        }
                    `.trim().replace(/^ {24}/mg, ""));

                    fields.push([cpptype, field_name, "", [`/R=${ field_name }`, `/W=set_${ field_name }`]]);
                } else {
                    argtype = `std::shared_ptr<${ cpptype }>`;
                    body.push(`
                        if (!PARAMETER_MISSING(pArg${ i })) {
                            MP_RETURN_HR_IF_ERROR(${ cmessage }::CopyFrom(shared_message->mutable_${ field_name }(), ${ field_name }.get()));
                        }
                    `.trim().replace(/^ {24}/mg, ""));

                    fields.push([`${ cpptype }*`, field_name, "", [
                        `/R=mutable_${ field_name }`,
                        `/WExpr=MP_RETURN_HR_IF_ERROR(${ cmessage }::CopyFrom(${ self_get(`mutable_${ field_name }()`) }, static_cast<\${propccotype}*>($value)->${ self_get() }))`,
                    ]]);
                }

                list_of_arguments.push([argtype, field_name, `${ argtype }()`, []]);
                body.push("");
            }

            if (body.length !== 0) {
                func_modifiers.push(`/Body=
                    auto shared_message = std::make_shared<${ proto.replaceAll(".", "::") }>();
                    hr = autoit_from(shared_message, _retval);
                    if (SUCCEEDED(hr)) {
                        ${ body.join("\n").trim().split("\n").join(`\n${ " ".repeat(24) }`) }
                    }
                `.trim().replace(/^ {20}/mg, ""));
            }

            // TODO if has no options fields => google.protobuf.MessageOptions options /R=options

            const parts = proto.slice(this.package.length).split(".");
            for (let i = 0; i < parts.length; i++) {
                const pkg = top + (i === 0 ? "" : `${ parts.slice(0, i).join(".") }.`);
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

        // expose a package property like in mediapipe python
        // package.A.B.C
        // => filename. A /R /S
        // => filename.A. B /R /S
        // => filename.A.B. C /R /S
        for (const [pkg, properties] of classes.entries()) {
            decls.push([pkg, "", ["/Properties"], properties, "", ""]);
        }

        for (const [extended, scoped] of this.extensions.entries()) {
            for (const [_scopes, raw_fields] of scoped.entries()) {
                const scopes = _scopes.length !== 0 ? _scopes.split(".") : [];

                const ExtendedType = this.getCppType(extended, scopes);
                const ExtendingType = scopes.length !== 0 ? this.getCppType(scopes[scopes.length - 1], scopes.slice(0, -1)) : "";

                const fqn = ExtendedType.replaceAll("::", ".");

                for (const [field_type, field_name, field_rule, is_packed] of raw_fields) {
                    const FieldType = this.getFieldType(field_type, scopes);

                    let TypeTraitsType = this.getTypeTraits(field_type, scopes);
                    if (field_rule === "repeated") {
                        TypeTraitsType = `Repeated${ TypeTraitsType }`;
                    }

                    let value_type = this.getCppType(field_type, scopes);
                    const key_type = `google::protobuf::${ language }::Extend_${ ExtendedType.replaceAll("::", "_") }With${ value_type.replaceAll("::", "_") }`;
                    const cpptype = `::google::protobuf::internal::ExtensionIdentifier<::${ ExtendedType }, ::google::protobuf::internal::${ TypeTraitsType }, ${ FieldType }, ${ is_packed }>`;
                    const byref = !isScalar(field_type) && !this.isEnum(field_type, scopes);

                    if (byref) {
                        value_type += "*";
                    }

                    if (!typedefs.has(key_type)) {
                        typedefs.set(key_type, cpptype);
                        decls.push([`class ${ key_type }`, "", [], [], "", ""]);
                    }

                    decls.push(...[
                        [`${ fqn }.${ byref ? "Mutable" : "Get" }Extension`, value_type, ["/attr=propget", "/idlname=Extensions", "=get_Extensions"], [
                            [key_type, "vKey", "", ["/C", "/Ref"]],
                        ], "", ""],
                    ]);

                    if (!byref) {
                        decls.push(...[
                            [`${ fqn }.SetExtension`, "void", ["/attr=propput", "/idlname=Extensions", "=put_Extensions"], [
                                [key_type, "vKey", "", ["/C", "/Ref"]],
                                [value_type, "vItem", "", []],
                            ], "", ""],
                        ]);
                    }

                    const pkg = scopes.length === 0 ? this.package : ExtendingType.replaceAll("::", ".");
                    decls.push([`${ pkg }.`, "", ["/Properties"], [
                        [`${ key_type }*`, field_name, "", ["/R", "/S", "/RExpr=&$0"]],
                    ], "", ""]);
                }
            }
        }

        // outputs.extensions = this.extensions;

        return outputs;
    }

    maybeSyntax() {
        const {pos} = this;
        const identifier = this.maybeWord();

        if (identifier !== "syntax") {
            this.pos = pos;
            return false;
        }

        if (!this.maybeFieldEnd()) {
            this.pos = pos;
            return false;
        }

        return true;
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

        while (/[\w.]/.test(this.input[this.pos])) {
            this.pos++;
        }

        const pkg = this.input.slice(start, this.pos);

        if (!this.maybeFieldEnd()) {
            this.pos = pos;
            return false;
        }

        this.package = `${ pkg }.`;
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

        if (this.input[this.pos] !== "\"") {
            this.pos = pos;
            return false;
        }

        const start = ++this.pos;
        const end = this.input.indexOf("\"", start);
        if (end === -1 || !this.maybeFieldEnd()) {
            this.pos = pos;
            return false;
        }

        const relpath = this.input.slice(start, end);
        let filename = relpath;

        if (this.options.proto_path && this.options.proto_path.length !== 0) {
            for (const proto_path of this.options.proto_path) {
                if (fs.existsSync(`${ proto_path }/${ filename }`)) {
                    filename = `${ proto_path }/${ filename }`;
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

        for (const fqn_imported of imported.export_enums) {
            this.import_enums.add(fqn_imported);
            if (isPublic) {
                this.export_enums.add(fqn_imported);
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
        const options = [];

        this.messages.push(message);

        this.exports.set(proto, {
            scopes: this.messages.slice(),
            fields,
            options,
        });

        this.consumeCommentOrSpace();

        while (this.maybeMessage() || this.maybeEnum() || this.maybeExtend() || this.maybeOption(options) || this.maybeOneof(fields) || this.maybeField(fields)) {
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

        this.export_enums.add(proto);
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

    maybeExtend() {
        const {pos} = this;
        const identifier = this.maybeWord();

        if (identifier !== "extend") {
            this.pos = pos;
            return false;
        }

        this.consumeCommentOrSpace();

        const extented = this.maybeFQN(true);
        if (!extented) {
            this.pos = pos;
            return false;
        }

        if (!this.maybeCharSeq("{")) {
            this.pos = pos;
            return false;
        }

        if (!this.extensions.has(extented)) {
            this.extensions.set(extented, new Map());
        }

        const scopes = this.messages.join(".");
        if (!this.extensions.get(extented).has(scopes)) {
            this.extensions.get(extented).set(scopes, []);
        }

        const fields = this.extensions.get(extented).get(scopes);

        this.consumeCommentOrSpace();

        while (this.maybeField(fields)) {
            this.consumeCommentOrSpace();
        }

        if (!this.maybeCharSeq("}")) {
            this.pos = pos;
            return false;
        }

        return true;
    }

    maybeComment() {
        if (this.input.startsWith("//", this.pos)) {
            this.pos = this.input.indexOf("\n", this.pos + "//".length);
            if (this.pos === -1) {
                this.pos = this.len;
            }
            this.pos += "\n".length;
            return true;
        }

        const {pos} = this;
        if (this.input.startsWith("/*", this.pos)) {
            this.pos = this.input.indexOf("*/", this.pos + "/*".length);
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
        const match = regNoSpace.exec(this.input);

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
        const match = regNoWord.exec(this.input);
        if (match === null || this.pos === match.index) {
            return false;
        }

        const word = this.input.slice(this.pos, match.index);
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

    maybeOption(options) {
        const {pos} = this;
        const identifier = this.maybeWord();

        if (identifier !== "option") {
            this.pos = pos;
            return false;
        }

        this.consumeCommentOrSpace();

        let is_custom_option = false;
        if (this.pos < this.len && this.input[this.pos] === "(") {
            is_custom_option = true;
            this.pos++;
        }

        const option = this.maybeFQN();
        if (!option) {
            this.pos = pos;
            return false;
        }

        if (is_custom_option && (this.pos === this.len || this.input[this.pos] !== ")")) {
            this.pos = pos;
            return false;
        }

        if (!this.maybeFieldEnd()) {
            this.pos = pos;
            return false;
        }

        options.push(option);

        return true;
    }

    maybeOneof(fields) {
        const {pos} = this;
        const identifier = this.maybeWord();

        if (identifier !== "oneof") {
            this.pos = pos;
            return false;
        }

        this.consumeCommentOrSpace();

        const oneof = this.maybeWord();
        if (!oneof) {
            this.pos = pos;
            return false;
        }

        if (!this.maybeCharSeq("{")) {
            this.pos = pos;
            return false;
        }

        this.consumeCommentOrSpace();

        while (this.maybeField(fields)) {
            this.consumeCommentOrSpace();
        }

        if (!this.maybeCharSeq("}")) {
            this.pos = pos;
            return false;
        }

        return true;
    }

    maybeField(fields) {
        const {pos} = this;
        let start = pos;

        const identifier = this.maybeFQN();
        if (identifier === "reserved" || identifier === "extensions") {
            if (!this.maybeFieldEnd()) {
                this.pos = pos;
                return false;
            }
            return true;
        }

        const is_repeated = identifier === "repeated";

        if (identifier === "required" || identifier === "optional" || identifier === "singular" || is_repeated) {
            this.consumeCommentOrSpace();
            start = this.pos;
            if (!this.maybeFQN()) {
                this.pos = pos;
                return false;
            }
        }

        const is_map = this.input.slice(start, this.pos) === "map";

        if (is_map) {
            if (this.input[this.pos] !== "<") {
                this.pos = pos;
                return false;
            }
            this.pos++;

            this.consumeCommentOrSpace();

            if (!this.maybeWord()) {
                this.pos = pos;
                return false;
            }

            this.consumeCommentOrSpace();

            if (this.input[this.pos] !== ",") {
                this.pos = pos;
                return false;
            }
            this.pos++;

            this.consumeCommentOrSpace();

            if (!this.maybeFQN()) {
                this.pos = pos;
                return false;
            }

            if (this.input[this.pos] !== ">") {
                this.pos = pos;
                return false;
            }
            this.pos++;
        }

        const field_type = this.input.slice(start, this.pos);

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

        const optstart = this.pos;

        if (!this.maybeFieldEnd()) {
            this.pos = pos;
            return false;
        }

        const is_packed = this.input.slice(optstart, this.pos).includes("packed");

        fields.push([field_type, field_name, is_repeated ? identifier : "", is_packed]);

        return true;
    }

    maybeFQN(abs = false) {
        const {pos} = this;

        if (abs && this.input[this.pos] === ".") {
            this.pos++;
        }

        while (this.maybeWord() && this.pos < this.len && this.input[this.pos] === ".") {
            this.pos++;
        }
        return pos === this.pos ? false : this.input.slice(pos, this.pos);
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
        this.pos = this.input.indexOf(";", this.pos);
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

        if (!this.input.startsWith(seq, this.pos)) {
            this.pos = pos;
            return false;
        }

        this.pos += seq.length;

        return true;
    }

    addRepeatedField(proto, fields, field_type, field_name, scopes, body, i) {
        const { decls, typedefs } = this.outputs;
        const { self_get, language } = this.options;

        const isEnum = this.isEnum(field_type, scopes);
        const value_type = isEnum ? "int" : this.getCppType(field_type, scopes);
        const byref = isScalar(field_type) || isEnum ? "" : "*";
        const name = `Repeated_${ value_type.replace(/\b(u?int(?:8|16|32|64))_t\b/g, "$1").replaceAll("::", "_") }`;
        const fqn = `google.protobuf.${ name }`;
        const cpptype = fqn.replaceAll(".", "::");
        const newVal = "$value";
        const is_string = value_type === "std::string";
        const ptr = is_string || byref ? "Ptr" : "";
        const setter = `
            auto mutable_${ field_name }  = shared_message->mutable_${ field_name }();
            auto iterator_${ field_name } = Repeated${ ptr }FieldBackInserter(mutable_${ field_name });
            hr = google::protobuf::${ language }::RepeatedField_Set(*shared_message.get(), "${ field_name }", ${ newVal }, mutable_${ field_name }, iterator_${ field_name })
        `.replace(/^ {12}/mg, "").trim();

        fields.push([`${ cpptype }*`, field_name, "", [
            `/R=mutable_${ field_name }`,
            "/WIDL=VARIANT*",
            `/WExpr=
                auto& shared_message = *__self;
                ${ setter.split("\n").join(`\n${ " ".repeat(16) }`) }
            `.replace(/^ {16}/mg, "").trim()
        ]]);

        body.push(`
            if (!PARAMETER_MISSING(pArg${ i })) {
                ${ setter.split("\n").join(`\n${ " ".repeat(16) }`) };
            }
        `.trim().replace(/^ {12}/mg, "").replaceAll(newVal, field_name));

        if (typedefs.has(cpptype)) {
            return;
        }

        typedefs.set(cpptype, `::google::protobuf::Repeated${ ptr }Field<${ value_type }>`);

        decls.push(...[
            [`class ${ fqn }`, "", ["/Simple"], [
                ["int", "Count", "", ["/R=size", ]]
            ], "", ""],
            [`${ fqn }.${ name }`, "", [], [], "", ""],

            [`${ fqn }.empty`, "bool", [], [], "", ""],
            [`${ fqn }.size`, "int", [], [], "", ""],
            [`${ fqn }.Clear`, "void", ["=clear"], [], "", ""],
            [`${ fqn }.MergeFrom`, "void", [], [
                [cpptype, "other", "", ["/C", "/ref"]]
            ], "", ""],
            [`${ fqn }.CopyFrom`, "void", [], [
                [cpptype, "other", "", ["/C", "/ref"]]
            ], "", ""],
            [`${ fqn }.Swap`, "void", [], [
                [`${ cpptype }*`, "other", "", []]
            ], "", ""],
            [`${ fqn }.SwapElements`, "void", [], [
                ["int", "index1", "", []],
                ["int", "index2", "", []],
            ], "", ""],
            [`${ fqn }.reverse`, "void", [`/Call=::google::protobuf::${ language }::RepeatedField_Reverse`, `/Expr=${ self_get() }`], [], "", ""],

            [`${ fqn }.${ byref ? "Mutable" : "Get" }`, `${ value_type }${ byref }`, ["/attr=propget", "/idlname=Item", "=get_Item", "/id=DISPID_VALUE"], [
                ["int", "index", "", []],
            ], "", ""],

            [`${ fqn }.sort`, "void", ["/External"], [
                ["void*", "comparator", "", []],
                ["size_t", "start", "0", []],
                ["size_t", "count", self_get("size()"), []],
            ], "", ""],

            [`${ fqn }.sort_variant`, "void", ["/External"], [
                ["void*", "comparator", "", []],
                ["size_t", "start", "0", []],
                ["size_t", "count", self_get("size()"), []],
            ], "", ""],
        ]);

        if (byref) {
            decls.push(...[
                [`${ fqn }.Add`, `${ value_type }*`, ["=add"], [], "", ""],
                [`${ fqn }.Add`, `${ value_type }*`, ["=add", `/Call=::google::protobuf::${ language }::RepeatedField_AddMessage`, `/Expr=${ self_get() }, $0`], [
                    [`${ value_type }*`, "value", "", ["/C"]]
                ], "", ""],
                [`${ fqn }.Add`, `${ value_type }*`, ["=append", `/Call=::google::protobuf::${ language }::RepeatedField_AddMessage`, `/Expr=${ self_get() }, $0`], [
                    [`${ value_type }*`, "value", "", ["/C"]]
                ], "", ""],
                [`${ fqn }.Add`, `${ value_type }*`, ["=append", `/Call=::google::protobuf::${ language }::RepeatedField_AddMessage`, `/Expr=${ self_get() }, $0`], [
                    ["std::map<std::string, _variant_t>", "attrs", "", []]
                ], "", ""],
                [`${ fqn }.splice`, "absl::Status", [`/Call=::google::protobuf::${ language }::RepeatedField_SpliceMessage`, `/Expr=${ self_get() }, $0`], [
                    [`std::vector<std::shared_ptr<${ value_type }>>`, "list", "", ["/O"]],
                    ["SSIZE_T", "start", "", []],
                    ["SSIZE_T", "deleteCount", "", []],
                ], "", ""],
                [`${ fqn }.splice`, "absl::Status", [`/Call=::google::protobuf::${ language }::RepeatedField_SpliceMessage`, `/Expr=${ self_get() }, $0`], [
                    [`std::vector<std::shared_ptr<${ value_type }>>`, "list", "", ["/O"]],
                    ["SSIZE_T", "start", "0", []],
                ], "", ""],
                [`${ fqn }.slice`, "void", [`/Call=::google::protobuf::${ language }::RepeatedField_SliceMessage`, `/Expr=${ self_get() }, $0`], [
                    [`std::vector<std::shared_ptr<${ value_type }>>`, "list", "", ["/O"]],
                    ["SSIZE_T", "start", "", []],
                    ["SSIZE_T", "count", "", []],
                ], "", ""],
                [`${ fqn }.slice`, "void", [`/Call=::google::protobuf::${ language }::RepeatedField_SliceMessage`, `/Expr=${ self_get() }, $0`], [
                    [`std::vector<std::shared_ptr<${ value_type }>>`, "list", "", ["/O"]],
                    ["SSIZE_T", "start", "0", []],
                ], "", ""],
                [`${ fqn }.extend`, "absl::Status", [`/Call=::google::protobuf::${ language }::RepeatedField_ExtendMessage`, `/Expr=${ self_get() }, $0`], [
                    [cpptype, "items", "", ["/Ref", "/C"]],
                ], "", ""],
                [`${ fqn }.extend`, "absl::Status", [`/Call=::google::protobuf::${ language }::RepeatedField_ExtendMessage`, `/Expr=${ self_get() }, $0`], [
                    [`std::vector<std::shared_ptr<${ value_type }>>`, "items", "", ["/Ref", "/C"]],
                ], "", ""],
                [`${ fqn }.extend`, "absl::Status", [`/Call=::google::protobuf::${ language }::RepeatedField_ExtendMessage`, `/Expr=${ self_get() }, $0`], [
                    ["std::vector<_variant_t>", "items", "", ["/Ref", "/C"]],
                ], "", ""],
                [`${ fqn }.insert`, "absl::Status", [`/Call=::google::protobuf::${ language }::RepeatedField_InsertMessage`, `/Expr=${ self_get() }, $0`], [
                    ["SSIZE_T", "index", "", []],
                    [`${ value_type }*`, "item", "", ["/Ref", "/C"]],
                ], "", ""],
                [`${ fqn }.pop`, `std::shared_ptr<${ value_type }>`, [`/Call=::google::protobuf::${ language }::RepeatedField_PopMessage`, `/Expr=${ self_get() }, $0`], [
                    ["SSIZE_T", "index", "-1", []],
                ], "", ""],
            ]);
        } else {
            decls.push(...[
                [`${ fqn }.Set`, "void", ["=set", `/Output=*${ self_get("Mutable(index)") } = value`], [
                    ["int", "index", "", []],
                    [value_type, "value", "", ["/Ref", "/C"]],
                ], "", ""],
                [`${ fqn }.Add`, "void", ["=append"], [
                    [value_type, "value", "", [is_string ? "/RRef" : "", "/C"]],
                ], "", ""],
                [`${ fqn }.splice`, "absl::Status", [`/Call=::google::protobuf::${ language }::RepeatedField_SpliceScalar`, `/Expr=${ self_get() }, $0`], [
                    [`std::vector<${ value_type }>`, "list", "", ["/O"]],
                    ["SSIZE_T", "start", "", []],
                    ["SSIZE_T", "deleteCount", "", []],
                ], "", ""],
                [`${ fqn }.splice`, "absl::Status", [`/Call=::google::protobuf::${ language }::RepeatedField_SpliceScalar`, `/Expr=${ self_get() }, $0`], [
                    [`std::vector<${ value_type }>`, "list", "", ["/O"]],
                    ["SSIZE_T", "start", "0", []],
                ], "", ""],
                [`${ fqn }.slice`, "void", [`/Call=::google::protobuf::${ language }::RepeatedField_SliceScalar`, `/Expr=${ self_get() }, $0`], [
                    [`std::vector<${ value_type }>`, "list", "", ["/O"]],
                    ["SSIZE_T", "start", "", []],
                    ["SSIZE_T", "deleteCount", "", []],
                ], "", ""],
                [`${ fqn }.slice`, "void", [`/Call=::google::protobuf::${ language }::RepeatedField_SliceScalar`, `/Expr=${ self_get() }, $0`], [
                    [`std::vector<${ value_type }>`, "list", "", ["/O"]],
                    ["SSIZE_T", "start", "0", []],
                ], "", ""],
                [`${ fqn }.extend`, "void", [`/Call=::google::protobuf::${ language }::RepeatedField_ExtendScalar`, `/Expr=${ self_get() }, $0`], [
                    [cpptype, "items", "", ["/Ref", "/C"]],
                ], "", ""],
                [`${ fqn }.extend`, "void", [`/Call=::google::protobuf::${ language }::RepeatedField_ExtendScalar`, `/Expr=${ self_get() }, $0`], [
                    [`std::vector<${ value_type }>`, "items", "", ["/Ref", "/C"]],
                ], "", ""],
                [`${ fqn }.insert`, "absl::Status", [`/Call=::google::protobuf::${ language }::RepeatedField_InsertScalar`, `/Expr=${ self_get() }, $0`], [
                    ["SSIZE_T", "index", "", []],
                    [value_type, "item", "", ["/Ref", "/C"]],
                ], "", ""],
                [`${ fqn }.pop`, value_type, [`/Call=::google::protobuf::${ language }::RepeatedField_PopScalar<${ value_type }>`, `/Expr=${ self_get() }, $0`], [
                    ["SSIZE_T", "index", "-1", []],
                ], "", ""],
            ]);
        }

        // TODO : CV_WRAP_AS(deepcopy) _variant_t DeepCopy();
    }
}

module.exports = Parser;
