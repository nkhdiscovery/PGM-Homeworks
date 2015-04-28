## first argument is input dataBase, second is vars.define, third is output directory
DB="$1"
varsDefine="$2"
varsDIR="$3"

mkdir "$varsDIR" 2> /dev/null

while read line
do
    var=`echo $line | cut -d':' -f1`
    col=`echo $line | cut -d':' -f2`
    echo "$(cat "$DB" | cut -d, -f$col | sort | uniq | tr '\n' ',' | sed 's/,$//g')" > "$varsDIR"/"$var".var
done < "$varsDefine"

