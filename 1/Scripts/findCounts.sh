declare -A columnMap

export DB=test.db

mkdir joints temp 2>/dev/null
rm -rf ./joints/"$1.joint"

# see which columns are queried to find their joint
while read a
do 
    columnMap[$a]="`grep $a ./vars.define | cut -d':' -f2`" ;
    cols="$cols,${columnMap[$a]}"
done < <(echo $1 | tr ',' '\n') 
cols=`echo $cols | sed 's/^,//g'`

cat $DB | cut -d, -f$cols > ./temp/"$1.cut"

total=`wc -l "$DB" | cut -d' ' -f1`

while read jointEvent
do
    count=`grep "$jointEvent" ./temp/"$1.cut" | wc -l| cut -d' ' -f1`
    echo -n "$jointEvent" >> ./joints/"$1.joint"
    printf " %.9f\n" "$(echo "$count/$total" | bc -l)" >>  ./joints/"$1.joint"
done < <(./combineVars.sh $1 | tr ' ' '\n' )
