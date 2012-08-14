#!/bin/sh
# Set up gnome-ostree build system on an Amazon Linux instance
#
# Copyright (C) 2012 Colin Walters <walters@verbum.org>
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the
# Free Software Foundation, Inc., 59 Temple Place - Suite 330,
# Boston, MA 02111-1307, USA.

set -e

exec 1>/var/log/cloud-init.log
exec 2>&1

PACKAGES="
git
make
gcc
gettext
autoconf automake libtool
libffi-devel
libxml2-devel
"

yum -y install $PACKAGES

cat > /etc/yum.repos.d/cdn-verbum-org.repo <<EOF
[cdn-verbum-org]
name=cdn.verbum.org/rpms
baseurl=http://cdn.verbum.org/rpms
gpgcheck=0
EOF

yum -y install linux-user-chroot

adduser ostree

su - ostree -c 'set -e ; cd; mkdir src;
git clone --depth=1 git://git.gnome.org/gnome-ostree;
./gnome-ostree/install/ostree-user-install.sh'
