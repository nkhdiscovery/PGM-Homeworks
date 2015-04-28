##################################################################################################
##
## first argument: vars.define , second: Database.csv , third: BN.bn
##

vars=`cat $1 | cut -d':' -f1`
DB=$2
BN=$3

rm -rf ./temp/ ./CPD/ ./joints/ 
isPrior()
{
    local ans=`cat $BN | cut -d' ' -f2 | grep $1`
    echo $ans
}

for var in $vars
do
    if [[ -z $(isPrior $var) ]]   
    then
       ./makeJointTable.sh $var  
    fi
done

while read edge
do
    child=`echo $edge | cut -d' ' -f2`
    parent=`echo $edge | cut -d' ' -f1`
    ./createCPD.sh "$child|$parent"
done < $BN
