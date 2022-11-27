#!/bin/bash

./build-state.js

# compress
zstd -19 -f ../../../images/blockstate.bin -o ../../../images/blockstate.bin.zstd