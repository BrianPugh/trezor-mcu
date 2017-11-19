#!/bin/bash
set -e

IMAGE=trezor-mcu-build
BINFILE=build/trezor-custom.bin
ELFFILE=build/trezor-custom.elf

docker build -t $IMAGE .
docker run -t -v $(pwd):/trezor-mcu:z $IMAGE /bin/sh -c "\
	cd trezor-mcu && \
	git submodule update --init && \
	make -C vendor/libopencm3 && \
	make -C vendor/nanopb/generator/proto && \
	make -C firmware/protob && \
	make && \
	make -C firmware sign && \
    mkdir -p build && \
	cp firmware/trezor.bin $BINFILE && \
	cp firmware/trezor.elf $ELFFILE"

/usr/bin/env python -c "
from __future__ import print_function
import hashlib
import sys
fn = sys.argv[1]
data = open(fn, 'rb').read()
print('\n\n')
print('Filename    :', fn)
print('Fingerprint :', hashlib.sha256(data[256:]).hexdigest())
print('Size        : %d bytes (out of %d maximum); %.2f%%' % (len(data), 491520, len(data)/4915.2))
" $BINFILE
