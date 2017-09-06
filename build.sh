#!/bin/bash

set -eux

set -o pipefail

top=$(pwd)

git clone -q https://git.ipxe.org/ipxe.git
cp -R src ipxe
pushd ipxe
gv=$(git rev-parse --short HEAD)
pushd src

for cfg in ${top}/src/config/* ; do
 b=${cfg##*/}
 case ${b} in
  com*) embed="EMBED=com.ipxe" ;;
  *) embed="" ;;
 esac
 targs="bin/ipxe.lkrn bin-x86_64-efi/ipxe.efi bin-i386-efi/ipxe.efi"
 make -s NO_WERROR=1 V=1 GITVERSION=${gv} CROSS_COMPILE=x86_64-linux-gnu- CONFIG=${b} ${targs} ${embed}
 mkdir -p ${top}/release/${b}
 mv bin/ipxe.lkrn ${top}/release/${b}/ipxe.lkrn
 mv bin-x86_64-efi/ipxe.efi ${top}/release/${b}/ipxe-amd64.efi
 mv bin-i386-efi/ipxe.efi ${top}/release/${b}/ipxe-ia32.efi
 make clean
done

popd && popd

pushd release
tar czf ../ipxe-${gv}.tgz .
popd
