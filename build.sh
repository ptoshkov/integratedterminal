#!/usr/bin/env bash
set -xe

## Check dependencies
command -V matlab
command -V node
command -V npm
command -V pkg
command -V make
command -V pandoc
command -V weasyprint

## Set up frontend
cd integratedterminal/frontend
npm install
cd ../..

## Set up backend
cd integratedterminal/backend
npm install
npm run build
chmod a+x index-win.exe
chmod a+x index-linux
chmod a+x index-macos
cp -r ../../linux-x64/ node_modules/node-pty/prebuilds/
cd ../..

## Package toolbox
cp LICENSE.txt integratedterminal
pandoc README.md -o integratedterminal/README.pdf --pdf-engine weasyprint
matlab -batch "matlab.addons.toolbox.packageToolbox('integratedterminal.prj')"
