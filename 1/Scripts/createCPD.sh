export queryVar=`echo $1 | cut -d'|' -f1`
export conditions=`echo "$1" | cut -d'|' -f2`

DB="$2"
varsDefine="$3"
varsDIR="$4"

sortedCon="$(echo "$conditions" | tr ',' '\n' | while read a ; do  col=`grep $a $varsDefine | cut -d':' -f2` ; echo $a $col ; done | sort -g -t' ' -k2 | cut -d' ' -f1 | tr '\n' ',' | sed 's/,$//g')"

sortedAll="$(echo $queryVar,$sortedCon | tr ',' '\n' | while read a ; do col=`grep $a "$varsDefine" | cut -d':' -f2` ; echo $a $col ; done | sort -g -t' ' -k2 | cut -d' ' -f1 | tr '\n' ',' | sed 's/,$//g')"

qIndex=`echo $sortedAll | tr ',' ' ' | grep -o ".*$queryVar" | wc -w`

if [[ -e ./CPD/"$queryVar-$sortedCon"-$qIndex.cpd ]]
then
    echo "CPD for ($queryVar|$sortedCon) exists ... skipping"
    exit 0
fi

echo "Making CPD for ($queryVar|$sortedCon) "

mkdir ./CPD/ 2> /dev/null
rm -rf ./CPD/"$queryVar-$sortedCon"-$qIndex.cpd

./makeJointTable.sh "$sortedCon" "$DB" "$varsDefine" "$varsDIR"

#sorting will be handled there
./makeJointTable.sh "$queryVar,$sortedCon" "$DB" "$varsDefine" "$varsDIR"

queryValues="`cat $varsDIR/$queryVar.var | tr ',' '\n' `"

for i in `./combineVars.sh $sortedAll $varsDIR $varsDefine`
do
    pJointAll=`grep "$i" ./joints/"$sortedAll.joint" | cut -d' ' -f2 `
    conDitionValue=`echo $i | cut -d, -f$qIndex --complement`
    pCondition=`./probQuery.sh "$sortedCon" "$conDitionValue"`
    echo "pjointAll: $pJointAll - conVal: $conDitionValue - pcon: $pCondition"

    # I removed this due to performance, I hope it never happens ! :D I handled enough in probQuery.sh
#    if [[ `echo $pCondition'=='0.0 | bc -l` -eq 1 ]] 
#    then
#        >&2 echo "OOooooPs! P($conDitionValue) is zero!! This should never happen because P($i) should be epsilon!\n Exiting ... Check the program or your run sequences." 
#        exit 0 ;
#    fi
    echo -n "$i " >> ./CPD/"$queryVar-$sortedCon"-$qIndex.cpd
    echo $pJointAll $pCondition | awk '{printf "%.9f\n", $1/$2 == 0 ? 0.000000001 : $1/$2}' >> ./CPD/"$queryVar-$sortedCon"-$qIndex.cpd
done

./visualizeCPD.sh ./CPD/"$queryVar-$sortedCon"-$qIndex.cpd "$varsDIR" 
