You can build a Linux image for use with v86:

1. Run `./build-container.sh` to build the Docker container and v86 images (requires dockerd)
2. Run `./build-state.js` to build a state image in order to skip the boot process
3. Optionally, compress the `blockstate.bin` file using zstd (v86 automatically detects the zstd magic and decompresses on the fly)

# debug
docker run --rm -it --entrypoint bash <image-name-or-id>