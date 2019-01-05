#!/usr/bin/env bash

firecfg &>/dev/null
ln -s /usr/bin/firejail /usr/local/bin/draw.io
sed -i 's#/usr/bin/draw.io#/usr/local/bin/draw.io#g' /usr/share/applications/draw.io.desktop

ln -s /usr/bin/firejail /usr/local/bin/bibtex
ln -s /usr/bin/firejail /usr/local/bin/latex
ln -s /usr/bin/firejail /usr/local/bin/pdflatex
ln -s /usr/bin/firejail /usr/local/bin/gummi
ln -s /usr/bin/firejail /usr/local/bin/vim

