#!/bin/bash
set -euo pipefail
DEST="$(readlink -m ${1})"
SIZE="$(readlink -m .size)"

mkdir -p .build && cd $_
wget -O vim-8.2.tar.gz  https://github.com/vim/vim/archive/refs/tags/v8.2.${RELEASE}.tar.gz
tar --strip-components=1 -xzf vim-8.2.tar.gz
patch -p1  <../patch/enable-ttyfail.patch
./configure --prefix=/usr/local/wyga/vim --with-features=normal --enable-multibyte --disable-gui --disable-xsmp --disable-xsmp-interact --disable-netbeans --disable-nls --enable-acl --disable-gpm --disable-canberra --disable-selinux --disable-smack --enable-terminal --without-x --with-compiledby=wyga@wyga.build --enable-fail-if-missing --disable-arabic --enable-xim=no --with-global-runtime=/usr/local/wyga/vim/runtime
 
#export CFLAGS="-DSYS_VIMRC_FILE="'\"/etc/site/wyga/vimrc\"'""
make VIMRCLOC=/etc VIMRUNTIMEDIR=/usr/local/wyga/vim/runtime MAKE="make -e" -j8
make install DESTDIR=${DEST}
mv ${DEST}/usr/local/wyga/vim/share/vim/vim82 ${DEST}/usr/local/wyga/vim/runtime
rm -rf ${DEST}/usr/local/wyga/vim/share
rm ${DEST}/usr/local/wyga/vim/bin/{vimtutor,view,rvim,rview,ex}

find ${DEST}/usr/local/wyga/vim/ -name "*.txt" -delete
find ${DEST}/usr/local/wyga/vim -name "*_example.vim" -delete
find ${DEST}/usr/local/wyga/vim/runtime/autoload/ -name "netrw*.vim" -delete
for d in doc spell compiler tutor tools pack macros import
do
  find ${DEST}/usr/local/wyga/vim/runtime/${d} -mindepth 1 -delete
done
du -sB1024 "${DEST}" | cut -f1  >${SIZE}
