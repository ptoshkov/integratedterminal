#!/usr/bin/env bash
set -xe

## Check dependencies
command -V matlab
command -V node
command -V npm
command -V pkg

## Set up frontend
cd frontend
npm install
cd ..

## Set up backend
cd backend
npm install
npm run build
cd ..

## Package toolbox
matlab -batch "matlab.addons.toolbox.packageToolbox('integratedterminal.prj')"
