#!/bin/bash

./build-container.sh
./build-state.js

# compress blockstate
zstd --ultra -22 -f ../../../images/blockstate.bin

# compress 9p filesystem
#zstd --ultra -22 -r -f ../../../images/ubuntu-9p-rootfs-flat/
#rm -rf ../../../images/ubuntu-9p-rootfs-flat/*.bin

# brotli
#brotli --best --verbose -f ../../../images/blockstate.bin -o ../../../images/blockstate.bin.br

# copy