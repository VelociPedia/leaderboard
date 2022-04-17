#!/bin/zsh

# USAGE : getpilots.zsh [collection] [pilot1 (pilot2 pilots 3 ...)]
# Name "collection" without root directory name nor .csv extension.

# init script
BASEDIR=$(dirname "$0")
cd $BASEDIR

pilot="$2"
pilot=$(sed 's/[[:space:]]//g' <<< $pilot)
pilot=$(sed 's/\///g' <<< $pilot |
         sed 's/\.//g' |
         sed 's/\[//g' |
         sed 's/\]//g' |
         sed 's/\*//g' |
         sed 's/-//g'  |
         sed 's/\\//g' )

# DO NOT PUT FINAL "/" FOR FOLDERS         
leaderboards_dir="data/leaderboards"
pilots_dir="data/pilots"
pilots_md="md/pilots"
collections_dir="collections"

mkdir -p "$pilots_dir"
mkdir -p "$pilots_md"

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


while IFS=, read -r track_name scenery_name ; do
    pilot_data=$(grep -e ",${pilot}," "$leaderboards_dir/$track_name - $scenery_name.csv")
    if [ ! -z "$pilot_data" ] ; then
        pilot_rank=$(grep -n ",${pilot}," "$leaderboards_dir/$track_name - $scenery_name.csv" | cut -d: -f1)
        echo -e "+ RANK $pilot_rank\t$track_name ($scenery_name)"
        d=$(sed "/^$track_name,$scenery_name,/d" < "$pilots_dir/${pilot}.csv")  # ---
        echo $d
        echo -e "$d" > "$pilots_dir/${pilot}.csv"                               # Delete the previous record
        echo -e "$track_name,$scenery_name,$pilot_rank,$pilot_data" >> "$pilots_dir/${pilot}.csv"
        
        else
        echo -e "- NO DATA\t$track_name ($scenery_name)"
        d=$(sed "/^$track_name,$scenery_name,/d" < "$pilots_dir/${pilot}.csv")  # ---
        echo $d
        echo -e "$d" > "$pilots_dir/${pilot}.csv"                               # Delete the previous record
        echo -e "$track_name,$scenery_name,999,999.999,$pilot,NO_DATA" >> "$pilots_dir/${pilot}.csv"
        fi
    done <<< $cleancollection

if [ "$makecollectionpilots" = "1" ]   ; then
    echo -e "\t  --> Building CheatSheet for pilot"
    mkdir -p "$pilots_md/"
    pilot_data=""
        while IFS=, read -r track_name scenery_name ; do
            next_pilot_data=$(grep "$track_name,$scenery_name" "$pilots_dir/$pilot.csv")
            pilot_data=$(echo "$pilot_data\n$next_pilot_data")
            done <<< $cleancollection


        pilot_data=$(sed '/^[[:space:]]*$/d' <<< $pilot_data)
        outputfile="$pilots_md/$pilot-$collection.md"
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

        a=$(grep ",TBSSpec," <<< $pilot_data | sort --field-separator="," -V --key="1")
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
        
        a=$(grep "NO_DATA$" <<< $pilot_data)
        n=$(wc -l <<< $a)
        echo -e "---\n### $n tracks without data (200+ or not in leaderboard)" >> "$outputfile"
        echo -e "|TRACK|SCENE|" >> "$outputfile"
        echo -e "|:---|:---|" >> "$outputfile"
        while IFS=, read -r track scene rank no_data ; do
            echo -e "|$track|$scene|" >> "$outputfile"
            done <<< $a
        fi