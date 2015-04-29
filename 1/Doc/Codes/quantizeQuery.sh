query=`echo $1 | sed "s/\.[0]*,/,/g" | sed "s/\.[0]*$//g"`

col1=`echo $query | cut -d, -f1 | while read a ; do echo -n "$a : " ; if [[ "$a" -le 19 ]] ; then echo 1 ; elif [[ "$a" -le 29  ]] ; then echo 2 ; elif [[ "$a" -le 39 ]] ; then echo 3 ; elif [[ "$a" -le 49 ]] ; then echo 4 ;elif [[ "$a" -le 59 ]] ; then echo 5  ; elif [[ "$a" -le 69 ]] ; then echo 6 ; else echo 7 ; fi ; done  | cut -d' ' -f3 `

col4=`echo $query | cut -d, -f4 | while read a ; do echo -n "$a : " ; if [[ "$a" -le 119 ]] ; then echo 1 ; elif [[ "$a" -le 139  ]] ; then echo 2 ; elif [[ "$a" -le 159 ]] ; then echo 3 ; elif [[ "$a" -le 179 ]] ; then echo 4 ;elif [[ "$a" -le 250 ]] ; then echo 5  ; fi ; done  | cut -d' ' -f3`

col5=`echo $query | cut -d, -f5 | while read a ; do echo -n "$a : " ; if [[ "$a" -le 199 ]] ; then echo 1 ; elif [[ "$a" -le 239  ]] ; then echo 2 ; else echo 3 ; fi ; done | cut -d' ' -f3`

a=`echo $query | cut -d, -f10`
col10="$a"
found="false"
ans=`echo $a'<='1.0 | bc -l`
if [[ "$ans" -eq 1 ]] ; 
then 
    col10=1 
    found="true"
fi
if [[ "$found" = "false" ]] 
then
    ans=`echo $a'<='2.0 | bc -l` ; 
    if [[ "$ans" -eq 1 ]] ; 
    then 
        col10=2 
        found=true
    fi
fi 
if [[ "$found" = "false" ]] 
then
    ans=`echo $a'<='3.0 | bc -l` ; 
    if [[ "$ans" -eq 1 ]] ; 
    then 
        col10=3
        found=true
    fi
fi 
if [[ "$found" = "false" ]] 
then
    ans=`echo $a'<='5.0 | bc -l` ; 
    if [[ "$ans" -eq 1 ]] ; 
    then 
        col10=4
        found=true
    fi
fi 
if [[ "$found" = "false" ]] 
then
    ans=`echo $a'<='7.0 | bc -l` ; 
    if [[ "$ans" -eq 1 ]] ; 
    then 
        col10=5
        found=true
    else
        col10=6
    fi 
fi
col8=`echo $query | cut -d, -f8 | while read a ; do echo -n "$a : " ; if [[ "$a" -le 159 ]] ; then echo 1 ; elif [[ "$a" -le 166  ]] ; then echo 2 ; elif [[ "$a" -le 173 ]] ; then echo 3 ; elif [[ "$a" -le 180 ]] ; then echo 4 ;elif [[ "$a" -le 187 ]] ; then echo 5  ; elif [[ "$a" -le 194 ]] ; then echo 6 ; else echo 7 ; fi ; done  | cut -d' ' -f3`

p1=$col1
p2=`echo $query | cut -d, -f2-3`
p3=`echo $query | cut -d, -f6-7`
p4=`echo $query | cut -d, -f9`
p5=`echo $query | cut -d, -f11-14`

echo "$p1,$p2,$col4,$col5,$p3,$col8,$p4,$col10,$p5"

