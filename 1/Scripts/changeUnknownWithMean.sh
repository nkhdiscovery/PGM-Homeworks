export FILE_NAME="$1"
rm -rf ./tmp_file
rm -rf ./*.col

#change delimeter character to seperate with what you want
char_delim=","
char_unknown="?"

for i in `seq $(head -1 "$FILE_NAME" | tr $char_delim ' ' | wc -w | cut -d' ' -f1)`
do 
    echo "Processing column $i ... "
    cat "$FILE_NAME" | cut -d$char_delim -f$i | grep -iv "$char_unknown" > ./tmp_file
    mean=$(printf "%.4f\n" "$(echo "(`cat ./tmp_file | tr '\n' '+0' && echo "0"`)/$(wc -l ./tmp_file | cut -d' ' -f1)" | bc -l )")
    echo "Mean for column $i is $mean ...."
    cat "$FILE_NAME" | cut -d$char_delim -f$i | sed "s/"$char_unknown"/$mean/g" >> "./tmp_$i.col"
done
paste -d $char_delim `ls *.col  | sort -V` > "$FILE_NAME".result

rm -rf ./tmp_file
rm -rf ./*.col
