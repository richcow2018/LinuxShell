#!/bin/bash
now=$(date)
filepath="dffddfsdf/adfsadf/adfsdf"
srvfolder0="$filepath/Ethan"
tgtfolder0="$filepath/tempfolder" 

echo $srvfolder0 >> duplicatedfile0.txt

echo "Start: $now" >> duplicatedfile0.txt

find $srvfolder0 -type f -printf "%s %f\n" | \
while read SIZE FILE ; do
    echo "$FILE" "$SIZE" 
    find $tgtfolder0 -iname "$FILE" -size "${SIZE}" | \
    while read DUPLICATE; do
        # whatever you want to do with the duplicate file
      echo "$DUPLICATE" >> duplicatedfile0.txt
      rm "$DUPLICATE"
    done
done

echo "End: $now" >> duplicatedfile0.txt
