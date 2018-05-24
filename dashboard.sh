#!/usr/bin/env bash

rm -rf reports/
tar -xJf <(curl https://raw.githubusercontent.com/kantord/pricedb/master/price.2010.db.tar.xz)
mv price.2010.db price.db
make ledgerfile=$1 currency=$2 -j -B
./node_modules/just-dashboard-desktop/dist/linux-unpacked/just-dashboard-desktop ./.dashboard.yml
