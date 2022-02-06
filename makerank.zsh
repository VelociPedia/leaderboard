#!/bin/zsh

# USAGE : getpilots.zsh [collection] [pilot1 (pilot2 pilots 3 ...)]
# Name "collection" without root directory name nor .csv extension.

# init script
BASEDIR=$(dirname "$0")
cd $BASEDIR
mkdir -p "leaderboards/collection"

leaderboards_dir="leaderboards/data"
collections_dir="collections"

collection="$1"
collection=$(sed -E 's@collections/@@' <<< $collection)
collection=$(sed -E 's@\.csv$@@' <<< $collection)

cleancollection=$(sed '/^[[:space:]]*$/d' "$collections_dir/$collection.csv")
cleancollection=$(sed '/^#.*$/d' <<< $cleancollection)


echo -e "[*] Building list of pilots from collection..."

pilots=""
while IFS=, read -r track_name scenery_name ; do
    nextpilots=$(cat "$leaderboards_dir/$track_name - $scenery_name.csv")
    pilots=$(echo -e "$pilots\n$nextpilots")
    done <<< $cleancollection


pilots=$(sed 's/\///g' <<< $pilots |
         sed 's/\.//g' |
         sed 's/\[//g' |
         sed 's/\]//g' |
         sed 's/\*//g' |
         sed 's/-//g'  |
         sed 's/\\//g' )
pilots=$(cut -d , -f2 <<< $pilots)
pilots=$(sed '/\n/d' <<< $pilots | sed '/^[[:space:]]*$/d')
pilotslist=$(echo -e "$pilots" | sort -u)
finalpilot=""

while read pilot ; do
    n=$(grep "^$pilot$" <<< $pilots | wc -l)
    finalpilot=$(echo -e "$finalpilot\n$pilot,$n")
    done <<< $pilotslist
    
finalpilot=$(sort -nr --field-separator="," --key="2" <<< $finalpilot)
finalpilots=$(sed '/\n/d' <<< $finalpilot | sed '/^[[:space:]]*$/d')


### Here, we'll try to gather ONLY people having leaderboard in at least half of the tracks to keep data as usefull as possible
### We have use HALF of the tracks tracked
i=$(wc -l <<< $cleancollection)
j=$(($i/2))
finallistpilots=$(while [ $i -gt $j ] ; do
          grep ",$i" <<< $finalpilots
          ((i--))
          done)


## Now we'll gather data for all of them

pilots=$(cut -d, -f1 <<< $finallistpilots) # All pilots satisfying requirement
#pilots=$(head -n 20 <<< $finallistpilots | cut -d, -f1) #Testing purpose, small work : only 20 CSV to build
pilots=$(sed '/^[[:space:]]*$/d' <<< $pilots)

echo -e "  --> Done ! $(wc -l <<< $pilots) pilots kept."


i=1
while read pilot ; do
    echo -e "[$i]\tPilot $pilot"
    ((i++))
    
    pilot_data=$(while IFS=, read -r track_name scenery_name ; do
        grep "^$track_name,$scenery_name" < "pilots/data/$pilot.csv"
        done <<< $cleancollection)
    
    pilot_data=$(grep -v "NO_DATA$" <<< $pilot_data)
    n=$(echo -e "$pilot_data" | wc -l)
    sumpilot=$(cut -d , -f4 <<< $pilot_data | numsum)
    list=$(echo -e "$list\n$pilot,$n,$sumpilot")
    
  done <<< $pilots

  list=$(sort --field-separator="," -k2,2rn -k3,3n <<< $list)

  
  
i=1
previoussum=$(head -n 1 <<< $list | cut -d , -f3)
previoussum=$(($previoussum))
previousn=$(head -n 1 <<< $list | cut -d , -f3)
previousn=$(($previoussum))

while IFS="," read -r pilot n sum ; do
  
  samerank=$(((($n))-(($previousn))))
  
  if [ "$samerank" = "0" ] ; then
    delta=$(($(($sum))-$(($summaxrank))))
    delta=$(printf "%.3f\n" $delta)
    newlist=$(echo -e "$newlist\n|$i|$pilot|$n tracks|$sum s|+$delta|")
  else
    newlist=$(echo -e "$newlist\n|$i|$pilot|$n tracks|$sum s||")
    summaxrank=$(grep ",$n," <<< $list | head -n 1 | cut -d , -f3)
  fi
  
  ((i++))
  previousn="$(($n))"
  previoussum="$(($sum))"
done <<< $list


  outputfile="leaderboards/collection/$collection.md"
  echo -e "### $collection RANKING" > "$outputfile"
  echo -e "*$(wc -l <<< $cleancollection) tracks included from [$collections_dir/$collection.csv]($collections_dir/$collection.csv)*" >> "$outputfile"
  echo -e "|RANK|PILOT|COMPLETED|TIME|DELTA|" >> "$outputfile"
  echo -e "|:---:|:---|:---:|:---|---:|" >> "$outputfile"
  echo "$newlist" | sed '/^[[:space:]]*$/d' >> "$outputfile"