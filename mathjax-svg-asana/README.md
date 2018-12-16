# Stripped-MathJax

Releases of mathjax-svg-asana (https://github.com/tim-janik/assets/tree/master/mathjax-svg-asana) are
based on the original MathJax, stripped of a number of output renderers and fonts.
The aim is to provide a small subset of MathJax that is suitable for embedded HTML
documentation without requiring online access to assets like fonts.

Initial objectives:

- [√] Keep the *compressed* size around or below 1MB to make embedding affordable.
- [√] Support rendering from file:/// URLs.
	- At least Firefox has problems loading the font files for HTML-CSS and
	  CommonHTML from local files. But this can be achieved with using the SVG output.
- [√] Support rendering with non-TeX fonts, i.e. Asana-Math.
	- At the moment (MathJax-2.7.5), only the HTML-CSS and SVG outputs support
	  font selections other than TeX.
- [√] Allow "Copy & Paste" for formulas.
	- Firefox supports "Copy & Paste" from the HTML-CSS, CommonHTML and PreviewHTML
	  outputs. Chrome inflates the pasted contents from CommonHTML with an additional
	  newline per character, but otherwise seems to work well. Pasting from the SVG
	  output is not possible.
	- Achieved by selecting the PreviewHTML output.

Extract the release tarball and use it as: \
	`<script src="./stripped-mathjax/MathJax.js?config=TeX-AMS_SVG-full" type="text/javascript"></script>`

* **stripped-mathjax-2.7.5.2.tar.xz**: Change of location and improved automation
* **stripped-mathjax-2.7.5.1.tar.xz**: First release





