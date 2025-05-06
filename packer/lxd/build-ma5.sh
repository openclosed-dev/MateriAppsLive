#!/bin/bash -eu

ARCH=$(arch)
if [ "$ARCH" = "x86_64" ]; then
  	arch="amd64"
else
  	arch="arm64"
fi

packer build --var-file ma5.pkrvars.hcl --var "architecture=${arch}" ma.pkr.hcl \
	| tee build-ma5-${arch}.log
