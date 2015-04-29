lineNum="$1"
DB="$2"
varsDefine="$3"
varsDIR="$4"
ourObserve="$5"
fullQ=`./makeNthQuery.sh $DB $lineNum $varsDefine`
evidence=`echo $fullQ | cut -d'|' -f1`

tempcond=`echo $fullQ | cut -d'|' -f2`
cond="`echo ${tempcond%=*}`"
originalCondVal="`echo ${tempcond#*=}`"
condVal="$5"
#echo "original $cond:$originalCondVal"
sigma=0
nominator=0

for i in `cat $varsDIR/$cond.var | tr ',' '\n' `
do
    py=1 #this is Pai in roman, multiples ... 

    for j in `echo "$evidence" | tr ',' '\n'`
    do
       pj=`./cpdQuery.sh ./CPD/"${j%=*}"-"$cond"-1.cpd "${j#*=}","$i"`
       py=`echo $py*$pj | bc -l `
    done

    pi=`./probQuery.sh $cond $i`
    
    py=`echo $py*$pi | bc -l`
    if [[ "$i" -eq "$condVal" ]] 
    then
        nominator="$py"
        #echo $i is noinator: $py
    fi
    sigma=`echo $sigma+$py | bc -l`
    #echo Pi: $py
    #echo sigma: $sigma
done
printf "%.9f " "$(echo "$nominator/$sigma" | bc -l )"
echo "original:$originalCondVal"



