#!/bin/bash
## run as: 
## 
## ./conversion_efficiency.sh <CX output file>
## 
## approximate the bisulfite conversion of your bs-seq libs with the output of 
## bismark 'CX report'
## ( ChrPt should not be methylated )
## :::::: obvi this is for plants only ::::::

#sum total unconverted cytosines
methylC=`perl -wnl -e '/ChrPt/ and print;' $1 | awk '{sum+=$4} END {print sum}'`

#sum total converted cytosines
unmethylC=`perl -wnl -e '/ChrPt/ and print;' $1 | awk '{sum+=$5} END {print sum}'`

#under 1% is usable for me, prefer under 0.5%
#output such that 1.0 is 100%
conversion_efficieny=`echo $methylC/\($methylC+$unmethylC\)|bc -l`
echo
echo $methylC/\($methylC+$unmethylC\)|bc -l
echo
echo
