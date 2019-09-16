FROM ubuntu:disco

RUN apt-get update \
    && apt-get -y install \
        build-essential \
        wget \
        curl \
        gcc-aarch64-linux-gnu \
        binutils-aarch64-linux-gnu \
    && apt-get clean

WORKDIR /root/

RUN wget -qO- https://jaist.dl.sourceforge.net/project/gnu-efi/gnu-efi-3.0.8.tar.bz2 | tar -jxv \
    && cd gnu-efi-3.0.8 \
    && make PREFIX=/usr/aarch64-linux-gnu/ ARCH=aarch64 CROSS_COMPILE=aarch64-linux-gnu- \
    && make PREFIX=/usr/aarch64-linux-gnu/ ARCH=aarch64 CROSS_COMPILE=aarch64-linux-gnu- install

CMD ["/bin/bash"]