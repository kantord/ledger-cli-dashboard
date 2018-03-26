#!/usr/bin/env bash
ledgerfile=$1
categoriesfile=$2
expenses_account=$3
currency=$4
output_file=$5

for category in $(cat $categoriesfile)
do
    make reports/monthly/change/$expenses_account/$category.txt ledgerfile=$ledgerfile currency=$currency
done

# I know this is crazy
# This generates code to join N files
command_to_run=$(cat expense_categories.conf  | sed "s/$/.txt/;s/^/join - reports\/monthly\/change\/$expenses_account\//" | tr "\n" "|" | sed 's/|$//;s/^join -/cat/')

header=$(cat expense_categories.conf | tr "\n" " ")

./jsonify.sh <(eval $command_to_run) "Month" "$header" > $output_file
