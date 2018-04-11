#!/usr/bin/env bash
ledger -f $1 reg $2 -n -M -X $4 --no-rounding $3
