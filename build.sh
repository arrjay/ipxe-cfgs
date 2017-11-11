#!/bin/bash

set -eux

set +u
if [ -z "${MAKEFLAGS}" ] ; then
  MAKEFLAGS=""
fi
set -u

set -o pipefail

top=$(pwd)

if [ ! -d ipxe/.git ] ; then
git clone -q https://git.ipxe.org/ipxe.git
fi
cp -R src ipxe
pushd ipxe
gv=$(git rev-parse --short HEAD)
if [ "$(egrep -q '\[(BUILD|DEPS)\]' src/Makefile.housekeeping ; echo $?)" != 1 ] ; then
  patch -p1 < ../Makefile.housekeeping.patch
fi
pushd src

for cfg in ${top}/src/config/* ; do
 b=${cfg##*/}
 case ${b} in
  com*) embed="EMBED=${b}.ipxe" ;;
  *) embed="" ;;
 esac
 targs="bin/ipxe.pxe bin/ipxe.lkrn bin-x86_64-efi/ipxe.efi bin-i386-efi/ipxe.efi"
 # shellcheck disable=SC2086
 make ${MAKEFLAGS} NO_WERROR=1 V=0 GITVERSION="${gv}" CROSS_COMPILE=x86_64-linux-gnu- CONFIG="${b}" ${targs} ${embed}
 mkdir -p "${top}/release/${b}"
 mv bin/ipxe.lkrn "${top}/release/${b}/ipxe-pcbios.lkrn"
 mv bin/ipxe.pxe "${top}/release/${b}/ipxe-pcbios.pxe"
 mv bin-x86_64-efi/ipxe.efi "${top}/release/${b}/ipxe-x86_64.efi"
 mv bin-i386-efi/ipxe.efi "${top}/release/${b}/ipxe-i386.efi"
 make clean
done

popd && popd

pushd release
echo "${gv}" > IPXE_VERSION
tar czf ../ipxe-binaries.tgz .
popd
