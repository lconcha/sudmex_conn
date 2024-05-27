#!/bin/bash


csv=$1
png=$2

pgm=${png%.png}.pgm
geom="600x600"
n=$(wc -l $csv | awk '{print $1}')

maxvalue=$(sed 's/,/\n/g' $csv | sed 's/\.[0-9]*//g' | uniq | sort -n | tail -n 1)
meanvalue=$(sed 's/,/\n/g' $csv | uniq | sort -n | awk '{a+=$1} END{print a/NR}' | sed 's/\.[0-9]*//' )
echo "  mean value: $meanvalue ($csv)"

echo P2 > $pgm
echo "$n $n" >> $pgm
echo $meanvalue >> $pgm
sed 's/\.[0-9]*//g' $csv >> $pgm
sed -i  's/,/ /g' $pgm
convert $pgm -resize $geom label:"$csv"  -gravity Center -append $png