#!/bin/sh
# @author    Andreas Fischer <af@bantuX.org>
# @copyright 2015 Andreas Fischer
# @license   http://www.opensource.org/licenses/mit-license.html MIT License
if [ "$#" -ne 1 ]; then
    script=$(basename "$0")
    echo "Description: Puts an image onto an A4 PDF page." >&2
    echo "      Usage: $script imgpath" >&2
    echo "    Example: $script some/path/XYZ.jpg (yields some/path/XYZ.jpg.pdf)" >&2
    exit 1
fi
srcImg="$1"
srcImgTarget="$srcImg.pdf"
if [ -e "$srcImgTarget" ]; then
    echo "[Error] Target file $srcImgTarget already exists." >&2
    exit 1
fi
srcImgBase=$(basename "$srcImg")
srcDir=$(dirname "$srcImg")
tmpTex=$(mktemp --tmpdir="$srcDir" --suffix=".tex")
tmpTexBase=$(basename "$tmpTex" ".tex")
tmpDir=$(mktemp --directory)
scriptDir=$(dirname "$0")
sed "s/XXXXXXXX/$srcImgBase/" < "$scriptDir/img2a4pdf.tex.tpl" > "$tmpTex"
pdflatex -output-directory="$tmpDir" "$tmpTex"
mv "$tmpDir/$tmpTexBase.pdf" "$srcImgTarget"
rm "$tmpTex"
rm -r "$tmpDir"
