#!/bin/zsh

# init script
BASEDIR=$(dirname "$0")
cd $BASEDIR

# DO NOT PUT FINAL "/" FOR FOLDERS         
leaderboards_dir="data/leaderboards"
leaderboards_md="md/leaderboards"
pilots_dir="data/pilots"
pilots_md="md/pilots"
ranking_dir="data/ranking"
collections_dir="collections"

# MD2 AND DATA2 : work from another folder.

#mkdir -p "$pilots_dir"
#mkdir -p "$pilots_md"
#mkdir -p "$leaderboards_md"
#mkdir -p "$ranking_dir"

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
         sed 's/|//g'  |
         sed 's/\\//g' )
pilots=$(cut -d , -f2 <<< $pilots)
pilots=$(sed '/\n/d' <<< $pilots | sed '/^[[:space:]]*$/d')
pilotslist=$(echo -e "$pilots" | sort -u)
finalpilot=""

while read pilot ; do
    n=$(grep "^$pilot$" <<< $pilots | wc -l)
    finalpilot=$(echo -e "$finalpilot\n$pilot,$n")
    done <<< $pilotslist
    
finalpilot=$(sort -Vr --field-separator="," --key="2" <<< $finalpilot)
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
        pilotdat=$(grep "^$track_name,$scenery_name" < "$pilots_dir/$pilot.csv")
        besttime=$(head -n 1 "$leaderboards_dir/$track_name - $scenery_name.csv" | cut -d, -f1)
        pilottime=$(cut -d, -f4 <<< $pilotdat)
        
        # nhead = top 5%
        nhead=$(wc -l < "$leaderboards_dir/$track_name - $scenery_name.csv")
        nhead=$(bc <<< "$nhead * 5 / 100 ")
        bestindex=$(head -n $nhead "$leaderboards_dir/$track_name - $scenery_name.csv" | cut -d, -f1 | sed '/^[[:space:]]*$/d' | sed -z "s/\n/ + /g" | sed "s/ + $//g")
        bestindex=$(bc <<< "scale=3 ; ( $bestindex ) / $nhead ")
        
        pilottopindex=$(bc <<< "scale=3 ; ( $pilottime / $bestindex ) * 100 ")
        #pilottbestindex=$(bc <<< "scale=3 ; ( $pilottime / $besttime ) * 100 ")
        
        echo "$pilotdat,$pilottopindex"
        
        done <<< $cleancollection)
        
    pilot_data=$(grep -v ",NO_DATA," <<< $pilot_data)
    n=$(echo -e "$pilot_data" | wc -l)
    spec=$(grep ",TBSSpec," <<< $pilot_data | wc -l)
    sumpilot=$(cut -d , -f4 <<< $pilot_data | sed '/^[[:space:]]*$/d' | sed -z "s/\n/ + /g" | sed "s/ + $//g")
    sumpilot=$(bc <<< "scale=3 ; $sumpilot")
    #pilotbestindex=$(cut -d , -f9 <<< $pilot_data | sed '/^[[:space:]]*$/d' | sed -z "s/\n/ + /g" | sed "s/ + $//g")
    #pilotbestindex=$(bc <<< "scale=3 ; ($pilotbestindex) / $n")
    pilottopindex=$(cut -d , -f9 <<< $pilot_data | sed '/^[[:space:]]*$/d' | sed -z "s/\n/ + /g" | sed "s/ + $//g")
    pilottopindex=$(bc <<< "scale=3 ; ($pilottopindex) / $n")
    list=$(echo -e "$list\n$pilot,$n,$sumpilot,$pilottopindex,$spec")
    
  done <<< $pilots

  sortby=$(grep "\[sortby=" "$collections_dir/$collection.csv"| sed -e "s/^\# \[sortby=//g"  -e "s/\]$//g")
  
  if [ "$sortby" = "time" ]  ; then nsort=3 ; calcdelta="sum"
elif [ "$sortby" = "index" ] ; then nsort=4 ; calcdelta="index"
  else nsort=3 ; calcdelta="sum"
  fi
  
  list=$(sort --field-separator="," -k2,2rn -k${nsort},${nsort}n <<< $list)     # Sort by N Track completed, then by sum_time
  #list=$(sort --field-separator="," -k2,2rn -k4,4n <<< $list)    # Sort by N Track completed, then by indextime
  
  if [ "$sortby" = "time" ]  ; then nsort=3 ; calcdelta="sum"
      summaxrank=$(sort --field-separator="," -k2,2rV -k${nsort},${nsort}n <<< $list | head -n 1 | cut -d , -f${nsort})
elif [ "$sortby" = "index" ] ; then nsort=4 ; calcdelta="index"
      summaxrank=$(sort --field-separator="," -k${nsort},${nsort}V <<< $list | head -n 1 | cut -d , -f${nsort})
  else nsort=3 ; calcdelta="sum"
      summaxrank=$(sort --field-separator="," -k2,2rV -k${nsort},${nsort}n <<< $list | head -n 1 | cut -d , -f${nsort})
  fi
  
  
i=1
n=$(head -n 1 <<< $list | cut -d , -f2)
n=$(($n))
previousn=$(bc <<< "$n + 1")



while IFS="," read -r pilot n sum index spec ; do
  
  samerank=$(((($n))-(($previousn))))  
  
   
   
if [ "$sortby" = "index" ] ; then
      calcudelta=$index
      delta=$(bc <<< "scale=3 ; $calcudelta - $summaxrank")
      if [ $(bc <<< "$delta == 0") -eq 1 ] ; then delta=""
      else delta=+$delta ; fi
      newlist=$(echo -e "$newlist\n|$i|$pilot|$index|$spec / $n|$sum s|$delta|")
      datanewlist=$(echo -e "$datanewlist\n$pilot,$n,$sum")
    
    
    
  else # = time or not said
    if [ "$samerank" -eq 0 ] ; then
      calcudelta=$sum
      delta=$(bc <<< "scale=3 ; $calcudelta - $summaxrank")
      if [ $(bc <<< "$delta == 0") -eq 1 ] ; then delta=""
      else delta=+$delta ; fi
      newlist=$(echo -e "$newlist\n|$i|$pilot|$index|$spec / $n|$sum s|$delta|")
      datanewlist=$(echo -e "$datanewlist\n$pilot,$n,$sum")
    else
      newlist=$(echo -e "$newlist\n|$i|$pilot|$index|$spec / $n|$sum s||")
      datanewlist=$(echo -e "$datanewlist\n$pilot,$n,$sum")
      summaxrank=$(grep ",$n," <<< $list | head -n 1 | cut -d , -f${nsort})
    fi    
  fi
  
  
  ((i++))
  previousn="$(($n))"
done <<< $list


  outputfile="$leaderboards_md/$collection.md"
  echo -e "### $collection RANKING" > "$outputfile"
  echo -e "*$(wc -l <<< $cleancollection) tracks included from [$collections_dir/$collection.csv](/$collections_dir/$(sed "s/ /%20/g" <<< $collection).csv)*" >> "$outputfile"
  echo -e "|RANK|PILOT|INDEX|TBSSPEC|TIME|DELTA|" >> "$outputfile"
  echo -e "|:---:|:---|:---:|:---:|:---:|---:|" >> "$outputfile"
  echo "$newlist" | sed '/^[[:space:]]*$/d' >> "$outputfile"
  
  
  dataoutputfile="$ranking_dir/$collection.csv"
  echo "$datanewlist" | sed '/^[[:space:]]*$/d' | sort --field-separator="," -k2,2rV -k3,3V > "$dataoutputfile"
