DB="$1"
lineNum="$2" 
varsDefine="$3"
vNum=`wc -l $varsDefine | cut -d' ' -f1`
vars=`cat $varsDefine | cut -d':' -f1 | tr '\n' ',' | sed 's/,$//g'`
dbCols=`cat $varsDefine | cut -d':' -f2 | tr '\n' ',' | sed 's/,$//g'`
line=`sed -n "${lineNum}p" "$DB" | cut -d',' -f$dbCols `
cond="`echo $vars | cut -d, -f$vNum`=`echo $line | cut -d, -f$vNum `"
evidence="`echo $vars | cut -d, -f$vNum --complement`"
line=`echo $line | cut -d, -f$vNum --complement | tr ',' '\n' `
#echo "$evidence $line $cond"
first=`paste -d'=' <(echo "$evidence" | tr ',' '\n')  <(echo "$line") | tr '\n' ',' |  sed 's/,$//g' ` 
echo "$first|$cond"
