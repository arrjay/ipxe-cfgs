#!/bin/bash

set -eux

set -o pipefail

top=$(pwd)

git clone -q https://git.ipxe.org/ipxe.git
cp -R src ipxe
pushd ipxe
gv=$(git rev-parse --short HEAD)
patch -p1 < ../Makefile.housekeeping.patch
pushd src

for cfg in ${top}/src/config/* ; do
 b=${cfg##*/}
 case ${b} in
  com*) embed="EMBED=${b}.ipxe" ;;
  *) embed="" ;;
 esac
 targs="bin/ipxe.pxe bin/ipxe.lkrn bin-x86_64-efi/ipxe.efi bin-i386-efi/ipxe.efi"
 make -j2 -s NO_WERROR=1 V=0 GITVERSION=${gv} CROSS_COMPILE=x86_64-linux-gnu- CONFIG=${b} ${targs} ${embed}
 mkdir -p ${top}/release/${b}
 mv bin/ipxe.lkrn ${top}/release/${b}/ipxe-pcbios.lkrn
 mv bin/ipxe.pxe ${top}/release/${b}/ipxe-pcbios.pxe
 mv bin-x86_64-efi/ipxe.efi ${top}/release/${b}/ipxe-x86_64.efi
 mv bin-i386-efi/ipxe.efi ${top}/release/${b}/ipxe-i386.efi
 make clean
done

popd && popd

pushd release
tar czf ../ipxe-${gv}.tgz .
popd
