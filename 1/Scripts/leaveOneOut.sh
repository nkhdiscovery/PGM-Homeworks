DB=$1
varsDefine="$2"
varsDIR="$3"
BN="$4"

rm -rf ./tmp-data/ 
mkdir ./tmp-data/ 2> /dev/null
count=0;
for i in `seq $(wc -l $DB | cut -d' ' -f1)`
do
    line=`sed -n "${i}p" "$DB"`
    cat "$DB" | sed '3d' > ./tmp-data/one.out
    echo $line
    ./train.sh "$varsDefine"  ./tmp-data/one.out "$BN" "$varsDIR"
    tmpline=`./fullObserveQuery.sh $i "$DB" "$varsDefine" "$varsDIR" 1`
    p1=`echo $tmpline | cut -d' ' -f1`
    orig=`echo $tmpline | cut -d':' -f2`
    p2=`./fullObserveQuery.sh $i "$DB" "$varsDefine" "$varsDIR" 2`
    argMax=`echo $p1 $p2 | awk '{printf "%d\n", $1 > $2 ? 1 : 2}'`
    count=`echo $argMax $orig $count | awk '{printf "%d\n" , $argMax == $orig ? $3+1 : $3 }'`
done

echo $count





