#!/usr/bin/env bash

npm install
cd ./node_modules/just-dashboard-desktop/
npm install
npm run dist:dir
cd -
