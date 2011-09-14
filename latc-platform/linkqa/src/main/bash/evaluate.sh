#!/bin/bash
#Compute precision and recall between a reference set and a link set
#Technically, the set intersection of equivalent lines is used

# Depends on rapper, Ubuntu: sudo apt-get install raptor2-utils

# TODO Clean up /tmp afterwards...

ls=$1
rs=$2

# Check if a positive.nt file exists
if [ -f "$ls" -a -f "$rs" ]; then

	startDate=`date`

	refsetTmp=`tempfile`
	linksetTmp=`tempfile`

	refsetErrorsTmp="$refsetTmp"".errors"
        linksetErrorsTmp="$linksetTmp"".errors"


	#echo "$refsetTmp"
	#echo "$linksetTmp"

	#sed '/^\s*$/d' "$rs" | sed 's|\s+|\s' | awk 1 > "$refsetTmp"
	#sed '/^\s*$/d' "$ls" | sed 's|\s+|\s' | awk 1 > "$linksetTmp"


	# Not sure if the awk 1 can be skipped - it should add newlines at the end of the stream
	rapper -q -i ntriples -o ntriples "$rs" 1> "$refsetTmp"  2> "$refsetErrorsTmp"
	rapper -q -i ntriples -o ntriples "$ls" 1> "$linksetTmp" 2> "$linksetErrorsTmp"


	linksetErrorCount=`cat "$linksetErrorsTmp" | wc -l` 
        refsetErrorCount=`cat "$refsetErrorsTmp" | wc -l`


        rawRefsetSize=`cat "$refsetTmp" | wc -l`
        rawLinksetSize=`cat "$linksetTmp" | wc -l`


	refset=`tempfile`
	linkset=`tempfile`
	intersection="$refset""_""intersection"

	#echo "aoeu $refsetTmp $refset"

	sort -u "$refsetTmp" > "$refset"
	sort -u "$linksetTmp" > "$linkset"

	sort -m "$refset" "$linkset" | uniq -d > "$intersection"

	refsetSize=`cat "$refset" | wc -l`
	linksetSize=`cat "$linkset" | wc -l`
	intersectionSize=`cat "$intersection" | wc -l`

	#echo "rs=$refsetSize ls=$linksetSize is=$intersectionSize"

	precision="0"
	if [[ "$refsetSize" -ne "0" ]]; then
		precision=`echo "$intersectionSize/$refsetSize" | bc -l`
	fi

	recall="0"
        if [[ "$linksetSize" -ne "0" ]]; then
	        recall=`echo "$intersectionSize/$linksetSize" | bc -l`       
	fi

	refsetDuplicateSize=$(($rawRefsetSize-$refsetSize))
	linksetDuplicateSize=$(($rawLinksetSize-$linksetSize))

	endDate=`date`

	#echo "val= $precision --- $recall"
	
	echo -e "formatVersion=0.1\nrawRefsetSize=$rawRefsetSize\nrawLinksetSize=$rawLinksetSize\nrefsetSize=$refsetSize\nlinksetSize=$linksetSize\nintersectionSize=$intersectionSize\nprecision=$precision\nrecall=$recall\nrefsetDuplicateSize=$refsetDuplicateSize\nlinksetDuplicateSize=$linksetDuplicateSize\nstartDate=$startDate\nendDate=$endDate\nlinksetErrorCount=$linksetErrorCount\nrefsetErrorCount=$refsetErrorCount"


fi
