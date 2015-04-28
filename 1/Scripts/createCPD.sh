export queryVar=`echo $1 | cut -d'|' -f1`
export conditions=`echo "$1" | cut -d'|' -f2 | tr ',' '\n' | sort -g | tr '\n' ',' | sed 's/,$//g'`

if [[ -e ./CPD/"$queryVar-$conditions".cpd ]]
then
    echo "CPD for ($queryVar|$conditions) exists ... skipping"
    exit 0
fi

mkdir ./CPD/ 2> /dev/null
rm -rf ./CPD/"$queryVar-$conditions".cpd

./makeJointTable.sh "$conditions"
./makeJointTable.sh "$queryVar,$conditions" #sorting will be handled there
echo "Making CPD for ($queryVar|$conditions) "
sortedAll=`echo $queryVar,$conditions | tr ',' '\n' | sort -g | tr '\n' ',' | sed 's/,$//g' `

qIndex=`echo $sortedAll | tr ',' ' ' | grep -o ".*$queryVar" | wc -w`


queryValues="`cat $queryVar.var | tr ',' '\n' `"

for i in `./combineVars.sh $sortedAll`
do
    pJointAll=`./probQuery.sh "$sortedAll" "$i"`
    conDitionValue=`echo $i | cut -d, -f$qIndex --complement`
    pCondition=`./probQuery.sh "$conditions" "$conDitionValue"`

    # I removed this due to performance, I hope it never happens ! :D I handled enough in probQuery.sh
#    if [[ `echo $pCondition'=='0.0 | bc -l` -eq 1 ]] 
#    then
#        >&2 echo "OOooooPs! P($conDitionValue) is zero!! This should never happen because P($i) should be epsilon!\n Exiting ... Check the program or your run sequences." 
#        exit 0 ;
#    fi
    echo -n "$i " >> ./CPD/"$queryVar-$conditions".cpd
    echo $pJointAll $pCondition | awk '{printf "%.9f\n", $1/$2 == 0 ? 0.000000001 : $1/$2}' >> ./CPD/"$queryVar-$conditions".cpd
done

