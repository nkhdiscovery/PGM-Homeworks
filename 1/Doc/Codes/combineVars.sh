##
## This gives the combination of input variables like A,B,C (with no space, seperated with comma and variables should 
## exist in the predefined file format. 
##
varsDIR="$2"
varsDefine="$3"
### sort vars due to column number in db
vars="$(echo $1| tr ',' '\n' | while read a ; do col=`grep $a "$varsDefine" | cut -d':' -f2` ; echo $a $col ; done | sort -g -t' ' -k2 | cut -d' ' -f1 | tr '\n' ',' | sed 's/,$//g')"

nkhCom="$(export command="" && echo $vars | tr ',' '\n' | while read a ; do export command="$command,{\`cat "$varsDIR/$a".var\`}" ; echo $command ; done | sed 's/^,//g' | tail -1)"
nkhCom="eval echo $nkhCom"
eval $nkhCom
