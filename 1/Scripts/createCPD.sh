export queryVar=`echo $1 | cut -d'|' -f1`
export conditions=`echo "$1" | cut -d'|' -f2 | tr ',' '\n' | sort -g | tr '\n' ',' | sed 's/,$//g'`

./makeJointTable.sh "$conditions"
./makeJointTable.sh "$queryVar,$conditions" #sorting will be handled there
sortedAll=`echo $queryVar,$conditions | tr ',' '\n' | sort -g | tr '\n' ',' | sed 's/,$//g' `

qIndex=`echo $sortedAll | tr ',' ' ' | grep -o ".*$queryVar" | wc -w`


queryValues="`cat $queryVar.var | tr ',' '\n' `"

for i in `./combineVars.sh $sortedAll`
do
    pJointAll=`./probQuery.sh "$sortedAll" "$i"`
    conDitionValue=`echo $i | cut -d, -f$qIndex --complement`
    pCondition=`./probQuery.sh "$conditions" "$conDitionValue"`
    if [[ `echo $pCondition'=='0.0 | bc -l` -eq 1 ]] 
    then
        >&2 echo "OOooooPs! P($conDitionValue) is zero!! This should never happen because P($i) should be epsilon!\n Exiting ... Check the program or your run sequences." 
        exit 0 ;
    fi
    echo "$pCondition : $pJointAll"
done

