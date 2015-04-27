declare -A columnMap

export DB=test.db

mkdir joints temp 2>/dev/null
querySorted=$(echo $1 | tr ',' '\n' | sort -g | tr '\n' ',' | sed 's/,$//g' )

rm -rf ./joints/"$1.joint"
rm -rf ./joints/"$querySorted.joint"

# see which columns are queried to find their joint
while read a
do 
    columnMap[$a]="`grep $a ./vars.define | cut -d':' -f2`" ;
    cols="$cols,${columnMap[$a]}"
done < <(echo $querySorted | tr ',' '\n' | sort -g) 
cols=`echo $cols | sed 's/^,//g'`

cat $DB | cut -d, -f$cols > ./temp/"$querySorted.cut"

total=`wc -l "$DB" | cut -d' ' -f1`

while read jointEvent
do
    count=`grep "$jointEvent" ./temp/"$querySorted.cut" | wc -l| cut -d' ' -f1`
    echo -n "$jointEvent" >> ./joints/"$querySorted.joint"
    printf " %.9f\n" "$(echo "$count/$total" | bc -l)" >>  ./joints/"$querySorted.joint"
done < <(./combineVars.sh $querySorted | tr ' ' '\n' )
