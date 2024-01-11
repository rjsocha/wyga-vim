#!/bin/bash
set -euo pipefail
export VERSION=1
export RELEASE=5172
[[ -d .deb ]] && rm -rf .deb || true
[[ -d .build ]] && rm -rf .build || true
mkdir -p .deb
./build-vim.sh .deb
rsync -aq --exclude /DEBIAN/control DEBIAN .deb/
export SIZE_OF_PACKAGE="$(<.size)"
envsubst '$RELEASE $VERSION $SIZE_OF_PACKAGE' <DEBIAN/control >.deb/DEBIAN/control
cp config/vimrc .deb/usr/local/wyga/vim/vimrc
dpkg-deb --root-owner-group -b .deb wyga-vim_8.2.${RELEASE}-${VERSION}.deb
