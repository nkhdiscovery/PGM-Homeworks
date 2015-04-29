cpd="$1"
varsDIR="$2"
mkdir ./temp 2>/dev/null

var=`echo ${cpd##*/} | cut -d'-' -f1`
col=`echo $cpd | cut -d'-' -f3 | cut -d'.' -f1`

for val in `cat $varsDIR/$var.var | tr ',' '\n'`
do
    awk -F, '{ if ( $"'"$col"'" == "'"$val"'" ) print $0 }' "$cpd" | cut -d' ' -f2 > ./temp/vis-"$var-$val".table
done

awk -F, '{ if ( $"'"$col"'" == "'"$val"'" ) print $0 }' "$cpd" |cut -d' ' -f1  | cut -d, -f$col --complement > ./temp/vis-"$var"-first.table
paste ./temp/vis-"$var"-first.table ` find . | grep -i "temp/vis-$var-" | grep -v first | sort -g` > "$cpd".visualized


