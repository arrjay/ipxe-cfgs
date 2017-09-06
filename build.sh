#!/bin/bash

set -eux

set -o pipefail

top=$(pwd)

git clone https://git.ipxe.org/ipxe.git
cp -Rv src ipxe
cd ipxe
gv=$(git rev-parse --short HEAD)
cd src

for cfg in ${top}/src/config/* ; do
 b=${cfg##*/}
 targs="bin/ipxe.lkrn bin-x86_64-efi/ipxe.efi bin-i386-efi/ipxe.efi"
 make -s NO_WERROR=1 V=1 GITVERSION=${gv} CROSS_COMPILE=x86_64-linux-gnu- CONFIG=${b} ${targs}
 mkdir -p ${top}/release/${b}
 mv bin/ipxe.lkrn ${top}/release/${b}/ipxe.lkrn
 mv bin-x86_64-efi/ipxe.efi ${top}/release/${b}/ipxe-amd64.efi
 mv bin-i386-efi/ipxe.efi ${top}/release/${b}/ipxe-ia32.efi
 make clean
done
