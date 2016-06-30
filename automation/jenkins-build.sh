#!/bin/bash

set -o errexit
set -o pipefail

for arch in $ARCHS; do
	case "$arch" in
		'amd64')
			base_image="nghiant2710/alpine-pkg-builder:amd64"
			package="https://github.com/nghiant2710/docker-glibc-builder/releases/download/2.23-resin/glibc-amd64-alpine-2.23.tar.gz"
		;;
		'i386')
			base_image="nghiant2710/alpine-pkg-builder:i386"
			package="https://github.com/nghiant2710/docker-glibc-builder/releases/download/2.23-resin/glibc-i386-alpine-2.23.tar.gz"
		;;
		'armv7hf')
			base_image="nghiant2710/alpine-pkg-builder:armhf"
			package="https://github.com/nghiant2710/docker-glibc-builder/releases/download/2.23-resin/glibc-armv7hf-alpine-2.23.tar.gz"
		;;
		'rpi')
			base_image="nghiant2710/alpine-pkg-builder:armhf"
			package="https://github.com/nghiant2710/docker-glibc-builder/releases/download/2.23-resin/glibc-rpi-alpine-2.23.tar.gz"
		;;
	esac
	cp -f APKBUILD.$arch APKBUILD
	mkdir -p packages
	docker run \
		-e PACKAGE="$package" \
		-v `pwd`":/source" \
		-v `pwd`"/packages:/output" \
		nghiant2710/alpine-pkg-builder:$arch bash /usr/bin/abuilder-glibc.sh
done
