cpd="$1" 
cat $cpd |  awk -F' ' '{ if ($1 == "'"$2"'") print $0 }' | cut -d' ' -f2 
