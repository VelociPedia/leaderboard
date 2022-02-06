#!/bin/zsh

# init script

BASEDIR=$(dirname "$0")
cd $BASEDIR
mkdir -p "leaderboards"

collections_dir="collections/"

collection="beginner.csv
DEP.csv
TBSEU.csv
QuadRivals.csv"

query=$(tail -n 30 update.list | sed "s/\t/,/g")
toupdate=$(while IFS=, read f1 f2 f3 ; do echo "$f2,$f3" | sed "/^[[:space:]]*$/d" | sed "/^,$/d" ; done <<< $query)


while read -r c ; do
  ccat=$(cat "$collections_dir/$c")
  toupdate=$(echo -e "$toupdate\n$ccat")
done <<< $collection

# Cleaning
toupdate=$(echo $toupdate | sed '/^#.*$/d' | sed '/^[[:space:]]*$/d' | sort -u)
echo $toupdate > "$collections_dir/collection.csv"