#!/usr/bin/env bash

# ================================
# stash for release
# ================================
git stash push --include-untracked


# ================================
# tidy
# ================================
node ../${ESLINT_CONFIG_PROJECT}/node_modules/eslint/bin/eslint.js --config=../${ESLINT_CONFIG_PROJECT}/.eslintrc --fix 'src/**/*.js' 'scripts/*.js'
find examples autoit-mediapipe-com/udf -type d -name 'BackUp' -prune -o -type f -name '*.au3' -not -name '*test.au3' | xargs -I '{}' 'C:\Program Files (x86)\AutoIt3\AutoIt3.exe' 'C:\Program Files (x86)\AutoIt3\SciTE\AutoIt3Wrapper\AutoIt3Wrapper.au3' //Tidy //in '{}'
find examples autoit-mediapipe-com/udf -type d -name 'BackUp' -exec rm -rf '{}' \;


# ================================
# generate doctoc
# ================================
node scripts/update-readme.js /d/Programs/AutoIt/UDF/mediapipe-udf-test && \
node node_modules/doctoc/doctoc.js README.md && dos2unix README.md


# ================================
# create a new version
# ================================
npm version patch


# ================================
# build
# ================================
rm -rf /c/_bazel_ opencv-4.*.0-windows autoit-mediapipe-com/{build_x64,generated} && \
time CMAKE_BUILD_TYPE=Release cmd.exe //c $(cygpath -w autoit-*-com/build.bat) && time CMAKE_BUILD_TYPE=Debug cmd.exe //c $(cygpath -w autoit-*-com/build.bat)


# ================================
# test local
# ================================
node scripts/test.js --bash --Release > $(for ifile in autoit-*-com/build_x64/bin; do echo $ifile/test_all.sh; done) && \
./autoit-*-com/build_x64/bin/test_all.sh


# ================================
# pack release
# ================================
node scripts/build.js


# ================================
# test release
# ================================
test -d /d/Programs/AutoIt/UDF/mediapipe-udf-test/opencv-4.10.0-windows || ./opencv-4.10.0-windows.exe -o/d/Programs/AutoIt/UDF/mediapipe-udf-test/opencv-4.10.0-windows -y && \
rm -rf /d/Programs/AutoIt/UDF/mediapipe-udf-test/{autoit-mediapipe-*,autoit-opencv-*,examples,test} && \
git archive --format zip --output /d/Programs/AutoIt/UDF/mediapipe-udf-test/autoit-mediapipe-com.zip main && \
7z x autoit-mediapipe-*.7z -aoa -o/d/Programs/AutoIt/UDF/mediapipe-udf-test/autoit-mediapipe-com && \
7z x autoit-opencv-*.7z -aoa -o/d/Programs/AutoIt/UDF/mediapipe-udf-test/autoit-opencv-com && \
echo '9d46fa5363f5c4e11c3d1faec71b0746f15c5aab7b5460d0e5655d7af93c6957 mediapipe-0.10.14-src.tar.gz' | sha256sum --check --status || \
curl -L 'https://github.com/google-ai-edge/mediapipe/archive/refs/tags/v0.10.14.tar.gz' -o mediapipe-0.10.14-src.tar.gz && \
tar xzf mediapipe-0.10.14-src.tar.gz -C /d/Programs/AutoIt/UDF/mediapipe-udf-test/ 'mediapipe-0.10.14/mediapipe/tasks/testdata' && \
cp -rf /d/Programs/AutoIt/UDF/mediapipe-udf-test/mediapipe-0.10.14/* /d/Programs/AutoIt/UDF/mediapipe-udf-test/ && \
rm -rf /d/Programs/AutoIt/UDF/mediapipe-udf-test/mediapipe-0.10.14 && \
7z x /d/Programs/AutoIt/UDF/mediapipe-udf-test/autoit-mediapipe-com.zip -aoa -o/d/Programs/AutoIt/UDF/mediapipe-udf-test 'examples\*' 'test\*' && \
node scripts/test.js --bash --Release /d/Programs/AutoIt/UDF/mediapipe-udf-test > $(for ifile in autoit-*-com/build_x64/bin; do echo $ifile/test_all.sh; done) && \
./autoit-*-com/build_x64/bin/test_all.sh
