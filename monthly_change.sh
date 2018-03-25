#!/usr/bin/env bash
ledger -f $1 reg $2 -n -M -X EUR --no-rounding -j | sed 's/ -/ /'
