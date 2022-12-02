#!/bin/bash

docker build -t buildroot .

docker run --rm --name build-v86 -v $PWD/dist:/build -v $PWD/buildroot-v86/:/buildroot-v86 buildroot

# If you need to re-configure things, instead of just running the build, do the following:
# docker run --rm --name build-v86 -v $PWD/dist:/build -v $PWD/buildroot-v86/:/buildroot-v86 -ti --entrypoint "bash" buildroot
# Now in the resulting bash terminal, you can run make menuconfig and other make commands.