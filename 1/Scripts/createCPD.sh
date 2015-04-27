export queryVar=`echo $1 | cut -d'|' -f1`
export conditions=`echo "$1" | cut -d'|' -f2 | tr ',' '\n' | sort -g | tr '\n' ',' | sed 's/,$//g'`

./makeJointTable.sh "$conditions"
./makeJointTable.sh "$queryVar,$conditions" #sorting will be handled there
sortedAll=`echo $queryVar,$conditions | tr ',' '\n' | sort -g | tr '\n' ',' | sed 's/,$//g' `
echo $sortedAll

queryValues="`cat $queryVar.var | tr ',' '\n' `"
for i in `./combineVars.sh "$sortedAll"`
do
    echo $i
done

