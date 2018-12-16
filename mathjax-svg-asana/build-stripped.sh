#!/bin/bash
set -xEeuo pipefail

ODIR=stripped-mathjax
BASE=stripped-mathjax-2.7.5.2
MJDIR=MathJax-2.7.5

# Fetch original MathJax
echo "b72e09f94f457e02216d9db0609a9b55426c21194f4e3a15041a3a0b9c67e341  $MJDIR.zip" >.sum
sha256sum -c .sum || (
  wget -c "https://github.com/mathjax/MathJax/archive/${MJDIR#*-}.zip" -O $MJDIR.zip
  sha256sum -c .sum
)
rm -f .sum

# Extract and change WORKDIR
rm -fr $MJDIR
unzip -q $MJDIR.zip
cd $MJDIR/

# Adjust README.md
cat ../README.md README.md >README.new
mv README.new README.md

# Construct stripped MathJax directory
rm -fr $ODIR
mkdir -p $ODIR/config

# Start with full set of output modules, strip later
cp  -a \
    LICENSE \
    README.md \
    MathJax.js \
    extensions/ \
    jax/ \
    localization/ \
    $ODIR

# Pick configs, the *-full files transclude most extensions
cp  -a \
    config/TeX-AMS_SVG-full.js \
    config/Safe.js \
    $ODIR/config/

# Get rid of HTML-CSS and CommonHTML (and related font data)
rm  -r \
    $ODIR/jax/output/HTML-CSS \
    $ODIR/jax/output/CommonHTML

# Strip transcluded JS files
rm  -r \
    $ODIR/extensions/tex2jax.js \
    $ODIR/extensions/MathEvents.js \
    $ODIR/extensions/MathZoom.js \
    $ODIR/extensions/MathMenu.js \
    $ODIR/extensions/toMathML.js \
    $ODIR/extensions/TeX/noErrors.js \
    $ODIR/extensions/TeX/noUndefined.js \
    $ODIR/extensions/TeX/AMSmath.js \
    $ODIR/extensions/TeX/AMSsymbols.js \
    $ODIR/extensions/fast-preview.js \
    $ODIR/extensions/AssistiveMML.js \
    $ODIR/extensions/a11y/accessibility-menu.js \
    $ODIR/jax/output/SVG/jax.js \
    $ODIR/jax/input/TeX/jax.js

# Remove non-functional "HTML-CSS" and "CommonHTML" items from minified menu
: &&
  grep -q '\.RADIO(\["HTML-CSS"' $ODIR/config/TeX-AMS_SVG-full.js &&
  grep -q '\.RADIO(\["CommonHTML"' $ODIR/config/TeX-AMS_SVG-full.js &&
  sed  -i $ODIR/config/TeX-AMS_SVG-full.js \
       -e 's/\b\w\+\.RADIO(\["HTML-CSS"[^]()]]*[^()]*),//' \
       -e 's/\b\w\+\.RADIO(\["CommonHTML"[^]()]]*[^()]*),//' &&
  ! grep -q '\.RADIO(\["HTML-CSS"' $ODIR/config/TeX-AMS_SVG-full.js &&
  ! grep -q '\.RADIO(\["CommonHTML"' $ODIR/config/TeX-AMS_SVG-full.js ||
    { echo 'Failed to detect+remove RADIO menu items' >&2 ; exit $? ; }

# Keep only $ODIR/jax/output/SVG/fonts/Asana-Math
rm  -r \
    $ODIR/jax/output/SVG/fonts/Gyre-Pagella \
    $ODIR/jax/output/SVG/fonts/Gyre-Termes \
    $ODIR/jax/output/SVG/fonts/Latin-Modern \
    $ODIR/jax/output/SVG/fonts/Neo-Euler \
    $ODIR/jax/output/SVG/fonts/STIX-Web \
    $ODIR/jax/output/SVG/fonts/TeX

# Configure SVG font availability
( cd stripped-mathjax/config/
  cat <<\__EOF | patch --no-backup-if-mismatch )
--- TeX-AMS_SVG-full.js	2018-11-25 00:34:37.707811015 +0100
+++ TeX-AMS_SVG-full.js	2018-11-25 00:34:39.787827550 +0100
@@ -38,2 +38,3 @@
 MathJax.Hub.Config({
+  SVG: { font: "Asana-Math" },
   extensions: ['[a11y]/accessibility-menu.js']
__EOF

# Create Tarball, cleanup, pop WORKDIR
tar cf ../$BASE.tar $ODIR
cd ..
rm -fr $MJDIR

# Figure packed size
rm -f $BASE.tar.xz $BASE.tar.gz $BASE.tar.bz2 $BASE.tar.zst
gzip -9 -k $BASE.tar
bzip2 -9 -k $BASE.tar
zstd -19 -k $BASE.tar
xz -9 -k $BASE.tar
ls -alSh $BASE.tar*

# rm -rf tmpsz && cp -a stripped-mathjax/ tmpsz && find tmpsz/ -type f -exec xz -9 {} \; && find tmpsz/ -type f -printf '%s %M %10s %T+ %p\n' | sort -n | sed 's/[^ ]* //'
