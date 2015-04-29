declare -A columnMap

export DB="$2"
varsDefine="$3"
varsDIR="$4"

mkdir joints temp 2>/dev/null

querySorted="$(echo $1| tr ',' '\n' | while read a ; do col=`grep $a "$varsDefine" | cut -d':' -f2` ; echo $a $col ; done | sort -g -t' ' -k2 | cut -d' ' -f1 | tr '\n' ',' | sed 's/,$//g')"

if [[ -e ./joints/"$querySorted.joint" ]]
then
    echo "Joint table for $querySorted exists , skipping ..."
    exit 0
fi


echo "Making joint probability of $querySorted ..." 

rm -rf ./joints/"$querySorted.joint"
rm -rf ./temp/*

# see which columns are queried to find their joint
while read a
do 
    columnMap[$a]=$(grep "$a" "$varsDefine" | cut -d':' -f2)
    cols="$cols,${columnMap[$a]}"
done < <(echo $querySorted | tr ',' '\n' ) 
cols=`echo $cols | sed 's/^,//g'`

cat $DB | cut -d, -f$cols > ./temp/"$querySorted.cut"

total=`wc -l "$DB" | cut -d' ' -f1`

while read jointEvent
do
    count=`grep "$jointEvent" ./temp/"$querySorted.cut" | wc -l| cut -d' ' -f1`
    echo $count is count for $jointEvent
    echo -n "$jointEvent" >> ./joints/"$querySorted.joint"
    printf " %.9f\n" "$(echo "$count/$total" | bc -l)" >>  ./joints/"$querySorted.joint"
done < <(./combineVars.sh $querySorted $varsDIR $varsDefine | tr ' ' '\n' )
