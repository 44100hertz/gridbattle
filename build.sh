#!/bin/sh

pushd ./dist/luasdl2
mkdir build/
cd build/
cmake ..
make
