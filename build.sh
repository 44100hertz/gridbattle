#!/bin/sh

cd dist/
pushd luasdl2
rm -r build/
mkdir build/
cd build/
cmake .. -DWITH_LUAVER=JIT
make

popd

pushd luafilesystem/
make

popd
