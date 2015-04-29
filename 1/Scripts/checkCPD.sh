cat $1 | cut -f2- | sed 's/\t/+/g'  | while read a ; do echo $a | bc -l ; done 
