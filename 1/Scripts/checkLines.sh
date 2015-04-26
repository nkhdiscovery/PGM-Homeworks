char_delim=","

for i in $*
do 
    echo "Checking file $i ..."
    cat "$i" | tr ',' ' ' | while read -r a ; do echo "$a" | wc -w ; done | sort| uniq
    echo "Your lines are not contain same much data if you see more than one number above!"
done
