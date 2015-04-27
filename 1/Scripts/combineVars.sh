##
## This gives the combination of input variables like A,B,C (with no space, seperated with comma and variables should 
## exist in the predefined file format. 
##
nkhCom="$(export command="" && echo $1 | tr ',' '\n' | while read a ; do export command="$command,{\`cat "$a".var\`}" ; echo $command ; done | sed 's/^,//g' | tail -1)"
nkhCom="eval echo $nkhCom"
eval $nkhCom
