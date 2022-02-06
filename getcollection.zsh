#!/bin/zsh

# USAGE : getpilots.zsh [collection] [pilot1 (pilot2 pilots 3 ...)]
# Name "collection" without root directory name nor .csv extension.

# init script
BASEDIR=$(dirname "$0")
cd $BASEDIR
mkdir -p pilots/data


pilot="$2"
pilot=$(sed 's/[[:space:]]//g' <<< $pilot)

leaderboards_dir="leaderboards/data"
collections_dir="collections"

collection="$1"
collection=$(sed -E 's@collections/@@' <<< $collection)
collection=$(sed -E 's@\.csv$@@' <<< $collection)

cleancollection=$(sed '/^[[:space:]]*$/d' "$collections_dir/$collection.csv")
cleancollection=$(sed '/^#.*$/d' <<< $cleancollection)

makecollectionrank=0
makecollectionpilots=0

mcollectionrank=$(grep "seriesleaderboard=1" "$collections_dir/$collection.csv")
mcollectionpilots=$(grep "pilotleaderboard=1" "$collections_dir/$collection.csv")

if [ ! -z "$mcollectionrank" ]   ; then makecollectionrank="1"   ; fi
if [ ! -z "$mcollectionpilots" ] ; then makecollectionpilots="1" ; fi


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
    y=0 ; z=0
    while IFS=, read -r track_name scenery_name ; do
        pilot_data=$(grep -e ",${pilot}," "$leaderboards_dir/$track_name - $scenery_name.csv")
        touch "pilots/data/${pilot}.csv"
        if [ ! -z "$pilot_data" ] ; then
            pilot_rank=$(grep -n ",${pilot}," "$leaderboards_dir/$track_name - $scenery_name.csv" | cut -d: -f1)
            #echo -e "+ RANK $pilot_rank\t$track_name ($scenery_name)"
            d=$(sed "/^$track_name,$scenery_name,/d" < "pilots/data/${pilot}.csv")  # ---
            echo -e "$d" > "pilots/data/${pilot}.csv"                               # Delete the previous record
            echo -e "$track_name,$scenery_name,$pilot_rank,$pilot_data" >> "pilots/data/${pilot}.csv"
            ((y++))
        else
            #echo -e "- NO DATA\t$track_name ($scenery_name)"
            d=$(sed "/^$track_name,$scenery_name,/d" < "pilots/data/${pilot}.csv")  # ---
            echo -e "$d" > "pilots/data/${pilot}.csv"                               # Delete the previous record
            #here it would be awesome to move it to some "archive.file", those are the end of leaderboard that is being kicking out if the data existed before
            #same for the other one, to keep record of past PB
            echo -e "$track_name,$scenery_name,999,999.999,$pilot,NO_DATA" >> "pilots/data/${pilot}.csv"
            ((z++))
        fi
        done <<< $cleancollection
    newpilotdata=$(sort -u < "pilots/data/${pilot}.csv")
    echo -e "\t  --> $y tracks with data"
    echo -e "\t  --> $z tracks without data"
    echo -e "$newpilotdata" > "pilots/data/${pilot}.csv"
    
    
    if [ "$makecollectionpilots" = "1" ]   ; then
        echo -e "\t  --> Building CheatSheet for pilot"
        mkdir -p "pilots/collection/"
        pilot_data=""
            while IFS=, read -r track_name scenery_name ; do
                next_pilot_data=$(grep "$track_name,$scenery_name" "pilots/data/$pilot.csv")
                pilot_data=$(echo "$pilot_data\n$next_pilot_data")
                done <<< $cleancollection

        pilot_data=$(sed '/^[[:space:]]*$/d' <<< $pilot_data)
        outputfile="pilots/collection/$pilot-$collection.md"
        ntrack=$(sed '/NO_DATA$/d' <<< $pilot_data | wc -l)
        besttracks=$(($ntrack/6))
        worsetracks=$(($ntrack/4))
        oldesttracks=$(($ntrack/6))
        
        a=$(sed '/NO_DATA$/d' <<< $pilot_data | sort --field-separator="," -n --key="3" | head -n $besttracks)
        echo -e "### Best $besttracks $1 TRACKS ranks" > "$outputfile"
        echo -e "|RANK|TRACK|SCENE|QUAD|DATE|" >> "$outputfile"
        echo -e "|:---:|:---|:---|:---:|:---:|" >> "$outputfile"
        while IFS=, read -r track scene rank time name country quad date ; do
            echo -e "|$rank|$track|$scene|$quad|$date|" >> "$outputfile"
            done <<< $a

        a=$(sed '/NO_DATA$/d' <<< $pilot_data | sort --field-separator="," -rn --key="3" | head -n $worsetracks)
        echo -e "---\n### Worse $worsetracks $1 TRACKS ranks" >> "$outputfile"
        echo -e "|RANK|TRACK|SCENE|QUAD|DATE|" >> "$outputfile"
        echo -e "|:---:|:---|:---|:---:|:---:|" >> "$outputfile"
        while IFS=, read -r track scene rank time name country quad date ; do
            echo -e "|$rank|$track|$scene|$quad|$date|" >> "$outputfile"
            done <<< $a

        a=$(grep ",TBSSpec," <<< $pilot_data | sort --field-separator="," --key="1")
        n=$(wc -l <<< $a)
        echo -e "---\n### $n tracks where TBS SPEC quad was used" >> "$outputfile"
        echo -e "|RANK|TRACK|SCENE|QUAD|DATE|" >> "$outputfile"
        echo -e "|:---:|:---|:---|:---:|:---:|" >> "$outputfile"
        while IFS=, read -r track scene rank time name country quad date ; do
            echo -e "|$rank|$track|$scene|$quad|$date|" >> "$outputfile"
            done <<< $a
            
        a=$(sed '/NO_DATA$/d' <<< $pilot_data | sort --field-separator="," --key="8" | head -n $oldesttracks)
        echo -e "---\n### Oldest $oldesttracks personal best" >> "$outputfile"
        echo -e "|RANK|TRACK|SCENE|QUAD|DATE|" >> "$outputfile"
        echo -e "|:---:|:---|:---|:---:|:---:|" >> "$outputfile"
        while IFS=, read -r track scene rank time name country quad date ; do
            echo -e "|$rank|$track|$scene|$quad|$date|" >> "$outputfile"
            done <<< $a
        
        a=$(grep "NO_DATA$" "pilots/data/$pilot.csv")
        n=$(wc -l <<< $a)
        echo -e "---\n### $n tracks without data (200+ or not in leaderboard)" >> "$outputfile"
        echo -e "|TRACK|SCENE|" >> "$outputfile"
        echo -e "|:---|:---|" >> "$outputfile"
        while IFS=, read -r track scene rank no_data ; do
            echo -e "|$track|$scene|" >> "$outputfile"
            done <<< $a
        fi
    done <<< $pilots
#pitot_pos pilot_time pilot_name pilot_country pilot_quad pilot_date