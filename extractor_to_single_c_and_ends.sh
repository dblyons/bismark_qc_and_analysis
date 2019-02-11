#!/bin/bash

# assumes dzlab_tools ends_analysis.pl is in your path

echo
echo " 1 extractor; 2 dir_name_and_base_gff_out; 3 anchor_file(hetero tes is /data2/dk9_jacobsen/q45...gff); 4 bin_size(for ends); 5 dist_size(for ends); 6 stopflag(0 or 6) ; 7 suffix_to_add_to_ends(e.g. q45) - currently set to run both 5 and 3"
echo 

#make gff for standard ends_analysis
#awk '($4+$5)>0 {print}' $1 |  awk ' a=$4/($4+$5)  {print $0"\t"a}' |  awk '{print $1"\t"$7"\t"$6"\t"$2"\t"$2"\t"$8"\t"$3"\t"".""\t""ID="NR}' > $2

mkdir $2
echo
echo 'making dir from 2'
echo
#make the 9th col total coverage
awk '($4+$5)>0 {print}' $1 | awk 'a=($4+$5) {print $0"\t"a}' |  perl -wnla -e '$meth=$F[3]/$F[7]; print "$F[0]\t$F[6]\t$F[5]\t$F[1]\t$F[1]\t$meth\t$F[2]\t.\t$F[7]";' > ./$2/$2

echo 
echo 'changing dir to 2' 
echo
cd ./$2

#split into contexts
#awk '{print >> $2; close($2)}' $2
awk  '$3~/CG/ {print}' $2 > $2.cg.gff
awk  '$3~/CHG/ {print}' $2 > $2.chg.gff
awk  '$3~/CHH/ {print}' $2 > $2.chh.gff
#perl -wnla -e '$F[2]~/CHG/ and print;' $2 > $2.chg.gff
#perl -wnla -e '$F[2]~/CHH/ and print;' $2 > $2.chh.gff

#awk '{print >> $3; close($3)}' $2

echo
echo 'completed splitting into contexts'
echo

# optional commands to parse CHH subcontexts
#remove ambiguous contexts
#rm *N* *Y* *R* *K* *M* *W*

echo
echo 'and remove garbage removal'
echo

# more optional commands to parse CHH subcontexts 
#fully CMT2 sites
#cat CAA  CTA > CWA
#fully CMT3 sites
#cat CAG CTG > CWG

#cat CAG CCG CTG > CHG

echo
echo 'begin ends_analysis.pl'
echo

#do ends_analysis on file of your choice
mkdir ./5ends

for i in ./*gff; do ends_analysis.pl -g $3 -b $4 -d $5 -s $6 -5 -x ID -o ./5ends/$i.$7.5ends  $i; done

mkdir ./3ends

for i in ./*gff; do ends_analysis.pl -g $3 -b $4 -d $5 -s $6 -3 -x ID -o ./3ends/$i.$7.3ends $i; done

echo
echo 'clean and remove backed up files'
echo
#fix ends for R
naNA.pl ./*ends/*

rm ./*ends/*bak

ls -lth
