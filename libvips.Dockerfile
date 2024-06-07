FROM --platform=linux/amd64 alpine:3.18

ARG VIPS_VERSION=8.15.2
ARG ALPINE_VERSION=3.18
ARG PDFIUM_VERSION=6517

# Environment variables
ENV VIPS_HOME=/usr/local/vips-${VIPS_VERSION}
ENV VIPS_BLOCK_UNTRUSTED=true \
    PDFIUM_VERSION=${PDFIUM_VERSION} \
    LD_LIBRARY_PATH=$VIPS_HOME/lib \
    PKG_CONFIG_PATH=$VIPS_HOME/lib/pkgconfig \
    PATH=$PATH:$VIPS_HOME/bin \
    WORKDIR=/usr/local/src

WORKDIR $WORKDIR

RUN mkdir pdfium-${PDFIUM_VERSION} \
    && cd pdfium-${PDFIUM_VERSION} \
    && wget https://github.com/bblanchon/pdfium-binaries/releases/download/chromium/${PDFIUM_VERSION}/pdfium-linux-musl-x64.tgz \

    #######################
    #     Pdfium setup    #
    #######################

    && mkdir -p $PKG_CONFIG_PATH \
    && cd $VIPS_HOME \
    && tar -xf $WORKDIR/pdfium-$PDFIUM_VERSION/pdfium-linux-musl-x64.tgz \
    && echo "prefix=$VIPS_HOME" >> lib/pkgconfig/pdfium.pc \
    && echo "exec_prefix=\${prefix}" >> lib/pkgconfig/pdfium.pc \
    && echo "libdir=\${exec_prefix}/lib" >> lib/pkgconfig/pdfium.pc \
    && echo "includedir=\${prefix}/include" >> lib/pkgconfig/pdfium.pc \
    && echo "Name: pdfium" >> lib/pkgconfig/pdfium.pc \
    && echo "Description: pdfium" >> lib/pkgconfig/pdfium.pc \
    && echo "Version: $PDFIUM_VERSION" >> lib/pkgconfig/pdfium.pc \
    && echo "Requires: " >> lib/pkgconfig/pdfium.pc \
    && echo "Libs: -L\${libdir} -lpdfium" >> lib/pkgconfig/pdfium.pc \
    && echo "Cflags: -I\${includedir}" >> lib/pkgconfig/pdfium.pc \

    #######################
    #     Libvips pull    #
    #######################

    && apk add xz \
    && wget https://github.com/libvips/libvips/releases/download/v${VIPS_VERSION}/vips-${VIPS_VERSION}.tar.xz \
    && tar -xf vips-${VIPS_VERSION}.tar.xz \
    && cd vips-${VIPS_VERSION} \
    && apk add \

    #######################
    #    Deps exiftool    #
    #######################

    exiftool \

    #######################
    #      Deps meson     #
    #######################

    meson \
    build-base \

    #######################
    #     Deps libvips    #
    #######################

    vips-dev \
    fftw-dev \

    # Portability layer
    glib-dev \

    # Rich I/O support: https://pagure.io/libaio
    libaio-dev \
    libgsf-dev \

    # XML parser: https://libexpat.github.io/
    expat-dev expat \

    # Exif support for JPEG files: https://libexif.github.io/
    libexif-dev \

    # WebP support: https://developers.google.com/speed/webp/docs/api
    libwebp-dev \

    # JPEG support: http://libjpeg.sourceforge.net/
    libjpeg-turbo-dev \

    # TFF support: http://www.libtiff.org/
    tiff-dev \

    # SVG support: https://gitlab.gnome.org/GNOME/librsvg
    librsvg-dev \

    # Pngquant support: https://pngquant.org/
    libimagequant-dev \

    # HEIF/HEIC support: https://github.com/strukturag/libheif
    libheif-dev \

    # PNG support: https://github.com/randy408/libspng
    libspng-dev \

    #######################
    #    Build libvips    #
    #######################

    && meson setup build-dir -Dintrospection=disabled -Dmodules=disabled -Dexamples=false --buildtype release \
    && cd build-dir \
    && meson compile \
    && meson install \

    #######################
    #       Clean up      #
    #######################

    && apk del build-base \
    && rm -rf /var/cache/apk/* \
    && rm -rf $WORKDIR/vips-${VIPS_VERSION}.tar.xz