#!/usr/bin/env bash

rm -rf reports/
make ledgerfile=$1 currency=$2 -j
./node_modules/just-dashboard-desktop/dist/linux-unpacked/just-dashboard-desktop ./dashboard.yml
