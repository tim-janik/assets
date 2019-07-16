# Material Icons Packaging

* Material Icons List: https://material.io/tools/icons/
* The Github repo is extremely outdated and doesn't include many icons found on the website.
* The webfont is being kept uptodate though: https://fonts.googleapis.com/icon?family=Material+Icons

Packaging:

1. Fetch CSS: wget 'https://fonts.googleapis.com/icon?family=Material+Icons' -O material-icons.css -U "Mozilla/5.0 (compatible; wget) Gecko/20100101 Firefox/68.0"
2. Fetch font file from link in the CSS, rename and adjust CSS.
3. Add: wget 'https://raw.githubusercontent.com/google/material-design-icons/master/LICENSE'
4. Tar: (cd .. && tar Jcvf material-icons-DATE.X.tar.xz material-icons/ )

Usage:

* Add to HTML head: `<link rel="stylesheet" href="assets/material-icons.css">`
* Use: `<i role="icon" aria-hidden="true" class="material-icons">local_cafe</i>`
