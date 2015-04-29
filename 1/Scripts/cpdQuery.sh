cpd="$1"
grep "$2" "$cpd" | cut -d' ' -f2
