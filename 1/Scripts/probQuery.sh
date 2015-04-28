##
##   BE CAREFULL! I have considered the query to this function is sorted, because it was not worth it to 
##  pair-sort query and value
##

p=`grep "$2" ./joints/"$1.joint" | cut -d' ' -f2 `
if [[ -z "$p" ]]
then 
    >&2 echo "Warning, no entry for $2 in $1.joint ... considering epsilon = 0.000000001"
    echo 0.000000001
else
    echo $p | awk '{printf"%.9f\n" , $0 ==0 ? 0.000000001 : $0}'
    # I did below with the line above and I don't warn, as the performance goes up with awk rather than if on bc
#    if [[ `echo $p'=='0.0 | bc -l` -eq 1 ]] 
#    then
#        >&2 echo "Warning, entry for $2 in $1.joint is zero ... considering epsilon = 0.000000001"
#        echo 0.000000001
#    else
#        echo "$p"
#    fi

fi

