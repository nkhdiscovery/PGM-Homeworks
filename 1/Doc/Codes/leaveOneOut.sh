DB=$1
varsDefine="$2"
varsDIR="$3"
BN="$4"

rm -rf ./tmp-data/ 
mkdir ./tmp-data/ 2> /dev/null
count=0;
for i in `seq $(wc -l $DB | cut -d' ' -f1)`
do
    echo ------------------------ leaving $i\'th out --------------
    line=`sed -n "${i}p" "$DB"`
    cat "$DB" | sed '3d' > ./tmp-data/one.out
    echo $line
    ./train.sh "$varsDefine"  ./tmp-data/one.out "$BN" "$varsDIR"
    
    tmpline=`./fullObserveQuery.sh $i "$DB" "$varsDefine" "$varsDIR" 1`

    p1=`echo $tmpline | cut -d' ' -f1`
    orig=`echo $tmpline | cut -d':' -f2`
    p2=`./fullObserveQuery.sh $i "$DB" "$varsDefine" "$varsDIR" 2`
    argMax=`echo $p1 $p2 | awk '{printf "%d\n", $1 < $2 ? 2 : 1}'`
    if [[ "$argMax" -eq "$orig" ]]
    then
        ((++count))
    fi 
    echo max:$argMax orig:$orig $count - p1:$p1 p2:$p2
done

echo $count > ./count.log





