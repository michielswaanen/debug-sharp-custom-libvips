echo "Building custom libvips image... (output suppressed)"

docker build --quiet -t libvips-custom-8.15.2 -f libvips.Dockerfile .

echo "Printing libvips config:"

# Exec a command in the container
docker run -it --rm libvips-custom-8.15.2 vips --vips-config

echo "Continuing with build in 5 seconds..."

docker build --quiet -t debug-sharp-with-custom-libvips -f Dockerfile .

docker run -it --rm debug-sharp-with-custom-libvips