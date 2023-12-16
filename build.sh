#!/bin/bash
set -euo pipefail
export RELEASE=5172
[[ -d .deb ]] && rm -rf .deb || true
./prereq
mkdir -p .deb
./build.vim .deb
rsync -aq --exclude /DEBIAN/control DEBIAN .deb/
export SIZE_OF_PACKAGE="$(<.size)"
envsubst '$RELEASE $SIZE_OF_PACKAGE' <DEBIAN/control >.deb/DEBIAN/control
dpkg-deb --root-owner-group -b .deb wyga-vim_8.2.deb
