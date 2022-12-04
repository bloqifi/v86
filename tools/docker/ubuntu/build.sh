#!/bin/bash

./build-container.sh
./build-state.js

# compress blockstate
zstd --ultra -22 -f ../../../images/blockstate.bin

# compress 9p filesystem
#zstd --ultra -22 -f ../../../images/ubuntu-9p-rootfs-flat/*.bin
brotli --best --verbose -f ../../../images/ubuntu-9p-rootfs-flat/*.bin
rm -rf ../../../images/ubuntu-9p-rootfs-flat/*.bin

# Rename all *.br to *.bin
for file in ../../../images/ubuntu-9p-rootfs-flat/*.br; do
  mv -- "$file" "${file%.bin.br}.bin"
done