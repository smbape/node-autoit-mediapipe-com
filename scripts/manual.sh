#!/usr/bin/env bash

# ================================
# stash for release
# ================================
git stash push --include-untracked


# ================================
# tidy
# ================================
node ../${ESLINT_CONFIG_PROJECT}/node_modules/eslint/bin/eslint.js --config=../${ESLINT_CONFIG_PROJECT}/.eslintrc --fix 'src/**/*.js' 'scripts/*.js' && \
find examples autoit-mediapipe-com/udf -type d -name 'BackUp' -prune -o -type f -name '*.au3' -not -name '*test.au3' | xargs -I '{}' 'C:\Program Files (x86)\AutoIt3\AutoIt3.exe' 'C:\Program Files (x86)\AutoIt3\SciTE\AutoIt3Wrapper\AutoIt3Wrapper.au3' //Tidy //in '{}' && \
find examples autoit-mediapipe-com/udf -type d -name 'BackUp' -exec rm -rf '{}' \; && \
git add --renormalize .


# ================================
# generate doctoc
# ================================
node scripts/update-readme.js /d/Programs/AutoIt/UDF/mediapipe-udf-test && \
node node_modules/doctoc/doctoc.js README.md && \
git add --renormalize .


# ================================
# create a new version
# ================================
npm version patch


# ================================
# build
# ================================
rm -rf /c/_bazel_ opencv-4.*.0-windows autoit-mediapipe-com/{build_x64,generated} && \
time CMAKE_BUILD_TYPE=Release cmd.exe //c $(cygpath -w autoit-*-com/build.bat) -UOpenCV_VERSION -UMEDIAPIPE_VERSION && \
time CMAKE_BUILD_TYPE=Debug cmd.exe //c $(cygpath -w autoit-*-com/build.bat) -UOpenCV_VERSION -UMEDIAPIPE_VERSION


# ================================
# test local
# ================================
node scripts/test.js --bash --Release > $(for ifile in autoit-*-com/build_x64/bin; do echo $ifile/test_all.sh; done) && \
./autoit-*-com/build_x64/bin/test_all.sh


# ================================
# pack release
# ================================
find examples autoit-mediapipe-com/udf -type d -name 'BackUp' -prune -o -type f -name '*.au3' -not -name '*test.au3' | xargs -I '{}' 'C:\Program Files (x86)\AutoIt3\AutoIt3.exe' 'C:\Program Files (x86)\AutoIt3\SciTE\AutoIt3Wrapper\AutoIt3Wrapper.au3' //Tidy //in '{}' && \
find examples autoit-mediapipe-com/udf -type d -name 'BackUp' -exec rm -rf '{}' \; && \
bash -c 'source scripts/tasks.sh && update_new_version' && \
node scripts/build.js


# ================================
# test release
# ================================
test -d /d/Programs/AutoIt/UDF/mediapipe-udf-test/opencv-4.11.0-windows || ./opencv-4.11.0-windows.exe -o/d/Programs/AutoIt/UDF/mediapipe-udf-test/opencv-4.11.0-windows -y && \
rm -rf /d/Programs/AutoIt/UDF/mediapipe-udf-test/{autoit-mediapipe-*,autoit-opencv-*,examples,test} && \
git archive --format zip --output /d/Programs/AutoIt/UDF/mediapipe-udf-test/autoit-mediapipe-com.zip HEAD && \
7z x autoit-mediapipe-*.7z -aoa -o/d/Programs/AutoIt/UDF/mediapipe-udf-test/autoit-mediapipe-com && \
7z x autoit-opencv-*.7z -aoa -o/d/Programs/AutoIt/UDF/mediapipe-udf-test/autoit-opencv-com && \
echo 'ff4a2a85d0ac0c73ff1acdf5ceda47cb3640566e0430e056c7f12e44cb5c81bd mediapipe-0.10.24-src.tar.gz' | sha256sum --check --status || \
curl -L 'https://github.com/google-ai-edge/mediapipe/archive/refs/tags/v0.10.24.tar.gz' -o mediapipe-0.10.24-src.tar.gz && \
tar xzf mediapipe-0.10.24-src.tar.gz -C /d/Programs/AutoIt/UDF/mediapipe-udf-test/ 'mediapipe-0.10.24/mediapipe/tasks/testdata' && \
cp -rf /d/Programs/AutoIt/UDF/mediapipe-udf-test/mediapipe-0.10.24/* /d/Programs/AutoIt/UDF/mediapipe-udf-test/ && \
rm -rf /d/Programs/AutoIt/UDF/mediapipe-udf-test/mediapipe-0.10.24 && \
7z x /d/Programs/AutoIt/UDF/mediapipe-udf-test/autoit-mediapipe-com.zip -aoa -o/d/Programs/AutoIt/UDF/mediapipe-udf-test 'examples\*' 'test\*' && \
node scripts/test.js --bash --Release /d/Programs/AutoIt/UDF/mediapipe-udf-test > $(for ifile in autoit-*-com/build_x64/bin; do echo $ifile/test_all.sh; done) && \
./autoit-*-com/build_x64/bin/test_all.sh
