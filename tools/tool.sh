#!/bin/bash

BASE_PATH=$1
OUTPUT=`pwd`/output.csv

echo $OUTPUT

#rm -rf $OUTPUT
cd $BASE_PATH

if [ -z "$BASE_PATH" ]
then
	echo "Fail: no base path!"
	exit 1;
fi

for folder in `ls`
do
	cd $folder
	for file in `ls`
	do
		if [[ ! "$file" =~ "IFMi" ]]
		then
			#echo "file:$file"
			EXCHANGE="";
			CONTRACT_NO="";
			DATE="";
			OPEN_PRICE="";
			HIGH_PRICE="";
			LOW_PRICE="";
			CLOSE_PRICE="";
			VOLUMN="";
			MONEY="";
			EXCHANGE=`sed -n '2p' $file | awk -F, '{print $1}'`;
			CONTRACT_NO=`sed -n '2p' $file | awk -F, '{print $2}'`;
			DATE=`sed -n '2p' $file | awk -F, '{print $3}' | awk '{print $1}'`;
			OPEN_PRICE=`sed -n '2p' $file | awk -F, '{print $4}'`;
			CLOSE_PRICE=`sed -n '$p' $file | awk -F, '{print $4}'`;
			HIGH_PRICE=`awk -F, 'BEGIN {high=0;} NR>1 { if ($4>high) high=$4;} END { print high;}' $file`
			LOW_PRICE=`awk -F, 'BEGIN {low=0;} NR>1 { if (low==0) {low=$4;} else if ($4<low) { low=$4; }} END { print low;}' $file`
			VOLUMN=`awk -F, 'BEGIN {money=0} NR>1 { money+=$8 } END {print money}' $file`;
			MONEY=`awk -F, 'BEGIN {volumn=0} NR>1 { volumn+=$7 } END {print volumn}' $file`;
			echo "$EXCHANGE,$CONTRACT_NO,$DATE,$OPEN_PRICE,$HIGH_PRICE,$LOW_PRICE,$CLOSE_PRICE,$VOLUMN,$MONEY">>$OUTPUT;
		fi
	done
	cd ../
done

echo "Done!"
