#!/bin/bash

BASE_PATH=$1
OUTPUT=`pwd`/2013output.csv

echo $OUTPUT

rm -rf $OUTPUT
cd $BASE_PATH

if [ -z "$BASE_PATH" ]
then
	echo "Fail: no base path!"
	exit 1;
fi

for file in `ls`
do
	if [[  "$file" =~ "SFIF" ]]
	then
		echo "file:$file"
		awk -F, '
		BEGIN {day_lines=1;exchange="";contract_no="";date="";open_price="";close_price="";high_price="";low_price="";volumn="";money="";}
		{
		  if ( day_lines == 1 ) 
		  {
		    date=$3;
		  } else {
		    if ( $3 !~ date ) 
		    {
		      print exchange,contract_no,date,open_price,high_price,low_price,close_price,volumn,money;
		      if ( day_lines != 2)
		      {
		        print exchange","contract_no","date","open_price","high_price","low_price","close_price","volumn","money >> "'$OUTPUT'";
		      }

		      exchange=$1;
		      contract_no=$2;
		      split($3,time," ");
		      date=time[1];
		      print "====date===="date;
		      open_price=$4;
		      low_price=0;
		      high_price=0;
		      volumn=0;
		      money=0;
	    	    }
		    if ( high_price < $4) high_price=$4;
		    if ( low_price == 0 ) low_price = $4; else if ( low_price > $4 ) low_price = $4;
		    close_price = $4;
		    volumn+=$7;
		    money+=$8;
	          }
		  day_lines++;
		} 
		END {print "done in file '$file'"}
		' $file;
	
	fi
done

echo "Done!"
