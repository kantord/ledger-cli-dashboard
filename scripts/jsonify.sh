#!/usr/bin/env bash

input_file=$1
x_column=$2
columns=`echo $3 | sed 's/_vs_/ /g'`

function input_ {
    echo "$x_column $columns"
    cat $input_file
}

input_ | \
jq -R '. | split(" ")' | \
jq --slurp "{\"x\": \"$x_column\", \"xFormat\": \"%Y-%m-%d\", \"rows\": .}"
