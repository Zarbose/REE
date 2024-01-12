#!/bin/bash

# git clone https://github.com/Zarbose/REE.git
# cd REE

chmod 755 REE-DEB/DEBIAN/postinst
chmod 755 REE-DEB/DEBIAN/preinst
chmod 755 REE-DEB/usr/local/bin/hello
dpkg-deb --build --root-owner-group REE-DEB

sudo dpkg -i REE-DEB.deb