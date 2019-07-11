
# fa4-sprites

The Font Awesome 4.7 package comes as font files, in contrast to
its version 5 counterpart, which provides SVG sprite files.

The following process can be applied to produce a similar
SVG sprite file from the Font Awesome 4.7 glyphs:

1. Using the the [Font-Awesome-SVG-PNG](https://github.com/encharm/Font-Awesome-SVG-PNG)
   project, the glyphs from the Font Awesome 4.7 font can be extracted as SVG files:

        node_modules/.bin/font-awesome-svg-png --color black --sizes 64

2. The extracted SVG files need only minor modifications to be turned into symbol elements:

        for i in *.svg ; do
          d="${i%.svg}" ;
          sed <$i "s/<svg.*viewBox/<symbol id='$d' viewBox/; s/xmlns=\"[^\"]*\"//; s,</svg>,</symbol>,; s/^<?xml.*//; " ;
        done > symbols.svg

3. Adding an SVG header and footer to `symbols.svg` is the only thing left to yield the sprites file.

The Font Awesome 4.7 package is licensed under [SIL OFL 1.1](http://scripts.sil.org/OFL), 
which also determines the license for derivative works.
