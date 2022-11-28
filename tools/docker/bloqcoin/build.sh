#!/bin/bash

./build-container.sh
./build-state.js

# compress blockstate
zstd --ultra -22 -f ../../../images/bloqstate.bin

# compress 9p filesystem
#zstd --ultra -22 -r -f ../../../images/ubuntu-bloqcoin-9p-rootfs-flat/
#rm -rf ../../../images/ubuntu-bloqcoin-9p-rootfs-flat/*.bin