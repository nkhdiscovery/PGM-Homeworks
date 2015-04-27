##
##   BE CAREFULL! I have considered the query to this function is sorted, because it was not worth it to 
##  pair-sort query and value
##

p=`grep "$2" ./joints/"$1.joint" | cut -d' ' -f2 `
if [[ -z "$p" ]]
then 
    >&2 echo "Warning, no entry for $2 in $1.joint ... considering zero"
    echo 0.0
else
    echo "$p"
fi

