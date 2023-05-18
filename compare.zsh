#!/bin/zsh

# init script
BASEDIR=$(dirname "$0")
cd $BASEDIR

# DO NOT PUT FINAL "/" FOR FOLDERS         
leaderboards_dir="data/leaderboards"
leaderboards_md="md/leaderboards"
pilots_dir="data/pilots"
pilots_md="md/pilots"
collections_dir="collections"

mkdir -p "$pilots_dir"
mkdir -p "$pilots_md"
mkdir -p "$leaderboards_md"


pilotyou="$1"
pilotthey="$2"

pilotyou=$(sed 's/\///g' <<< $1 |
sed 's/\.//g' |
sed 's/\[//g' |
sed 's/\]//g' |
sed 's/\*//g' |
sed 's/-//g'  |
sed 's/\\//g' )

pilotthey=$(sed 's/\///g' <<< $2 |
sed 's/\.//g' |
sed 's/\[//g' |
sed 's/\]//g' |
sed 's/\*//g' |
sed 's/-//g'  |
sed 's/\\//g' )



echo -e "[*] Building data for pilots"

for trackcsv in "$leaderboards_dir"/*.csv ; do
    pilotyou_line=$(grep ",$pilotyou,"  "$trackcsv")
    pilotthey_line=$(grep ",$pilotthey," "$trackcsv")

    pilotyou_data="$pilotyou_data\n$trackcsv,$pilotyou_line"
    pilotthey_data="$pilotthey_data\n$trackcsv,$pilotthey_line"
    done

pilotyou_data=$(sed '/^[[:space:]]*$/d' <<< $pilotyou_data)
pilotthey_data=$(sed '/^[[:space:]]*$/d' <<< $pilotthey_data)

alltracks=$(echo $pilotyou_data $pilotthey_data )

echo $alltracks
exit
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
        grep "^$track_name,$scenery_name" < "$pilots_dir/$pilot.csv"
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


  outputfile="$leaderboards_md/$collection.md"
  echo -e "### $collection RANKING" > "$outputfile"
  echo -e "*$(wc -l <<< $cleancollection) tracks included from [$collections_dir/$collection.csv]($collections_dir/$(sed "s/ /%20/g" <<< $collection).csv)*" >> "$outputfile"
  echo -e "|RANK|PILOT|COMPLETED|TIME|DELTA|" >> "$outputfile"
  echo -e "|:---:|:---|:---:|:---|---:|" >> "$outputfile"
  echo "$newlist" | sed '/^[[:space:]]*$/d' >> "$outputfile"