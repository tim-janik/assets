#!/bin/bash
# This Source Code Form is licensed MPL-2.0: http://mozilla.org/MPL/2.0
set -Eeuo pipefail
set -x

CSSURL='https://fonts.googleapis.com/icon?family=Material+Icons'

rm -fr material-icons/ material-icons-*-h*.tar.xz
mkdir -p material-icons/
cd material-icons/

# == fetch CSS ==
UA='Mozilla/5.0 (compatible; wget) Gecko/20100101 Firefox/68.0'
wget -U "$UA" "$CSSURL" -O material-icons.css

# == fetch WOFF ==
WOFFURL=$(egrep -o 'https:[^:()]*woff2' material-icons.css)
wget -U "$UA" "$WOFFURL" -O material-icons.woff2
sed 's/url([^()]*)/url(material-icons.woff2)/' -i material-icons.css
egrep http material-icons.css && { echo "$0: failed to patch material-icons/material-icons.css"; false; }

# == LICENSE ==
wget 'https://raw.githubusercontent.com/google/material-design-icons/master/LICENSE'

# == TARBALL ==
HASH=$(sha256sum *woff2 | egrep -o '^.........')
cd ..
DATE=$(date +%y%m%d)
TARBALL=material-icons-$DATE-1-h$HASH.tar.xz
tar cJf $TARBALL material-icons/
tar tvf $TARBALL
ls -l $TARBALL
sha256sum $TARBALL
