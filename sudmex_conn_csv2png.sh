#!/bin/bash


csv=$1
png=$2

pgm=${png%.png}.pgm
geom="600x600"

maxvalue=$(sed 's/,/\n/g' $csv | sed 's/\.[0-9]*//' | uniq | sort -n | tail -n 1)
meanvalue=$(sed 's/,/\n/g' $csv | uniq | sort -n | awk '{a+=$1} END{print a/NR}' | sed 's/\.[0-9]*//' )
echo meanvalue is $meanvalue

echo P2 > $pgm
echo "116 116" >> $pgm
echo $meanvalue >> $pgm
cat $csv >> $pgm
sed -i  's/,/ /g' $pgm
convert $pgm -resize 800x800. $png