#!/bin/bash
#DESCRIPTION:create the unique file to pass to MUSCLE
#USAGE:./scripts/seq_align.sh [table_downloaded_from_PDB]
#like >>>./scripts/seq_align.sh tabularResults_wild.csv

#NOTABENE:THIS SCCRIPT WORK WITH CUSTOMIZE TABLE HAVING  the PDB ID, the chain ID, the Entity ID, the Sequence and Resolution

#ASSIGN the input to variables
tabl_search=$1
input="$HOME/Desktop/LAB1_part2/real_project/resolution_wildtype/github_script/input"
output="$HOME/Desktop/LAB1_part2/real_project/resolution_wildtype/github_script/output"
script="$HOME/Desktop/LAB1_part2/real_project/resolution_wildtype/github_script/scripts"
cp "$1" "$input"

#TRASFORM in a FASTA unique file adding the resolution information to the Header
echo -e "I'm making the unique FASTA file adding to the Hedear the resolution information...\n"
tail -n +2 $input/$1 | head -n -2 | sed s/\"//g | awk -F"," '{print ">"$1":"$2":"$3; print ($NF)}'> $output/tabular_resolution_wild.fasta

#make the CLUSTER
echo -e "I'm doing the clustering of the sequences belonging to training set...\n"
blastclust -i $output/tabular_resolution_wild.fasta -S 95 -o $output/clean_resol_wild_95.clust #&> $output/clust.txt 

#take for each cluster tha one that have the BEST RESOLUTION
echo -e "I'm selecting the protein with best reolution from each cluster...\n"
for i in `seq 1 16`; do tail -n +$i $output/clean_resol_wild_95.clust | head -1 | tr " " "\n" | sed -e "s/:/ /g" | sort -nk 3 | head -n 2 | tail -n 1; done >$output/repr_resolution_wild_95.txt

echo -e "I'm making a file containing the FASTA sequences belonging to those selcted before...\n"
awk -F " " '{print $1":"$2":"$3}' $output/repr_resolution_wild_95.txt > $output/format_repr_res_wild_95.txt
python $script/clust_fasta.py $output/format_repr_res_wild_95.txt $output/tabular_resolution_wild.fasta > $output/format_repr_res_wild_95.fasta
