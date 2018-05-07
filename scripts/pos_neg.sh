#!/bin/bash
#DESCRIPTION:It takes the fasta output of the research on uniprot and give us the rescaled files
#USAGE: ./scripts/pos_neg.sh [unique_fasta_POSITIVE] [unique_fasta_NEGATIVE]

#ASSIGN the input to variables
# input="$folder/input"
# output="$folder/output"
# script="$folder/scripts"
# database="$folder/format_db"
# model="$folder/model"
input="$HOME/Desktop/LAB1_part2/real_project/resolution_wildtype/github_script/input"
output="$HOME/Desktop/LAB1_part2/real_project/resolution_wildtype/github_script/output"
script="$HOME/Desktop/LAB1_part2/real_project/resolution_wildtype/github_script/scripts"
database="$HOME/Desktop/LAB1_part2/real_project/resolution_wildtype/github_script/output/database"
model="$HOME/Desktop/LAB1_part2/real_project/resolution_wildtype/github_script/model"

pos_unip=$1
neg_unip=$2
#folder=$3

#create a directory in which put all the OUTPUT
#mkdir output
mkdir $output/database

#trasform the fasta unique file containing all the positive sequences into a DATABASE format
echo -e "I'm trasforming the FASTA file containing the positive sequences into a DATABASE...\n"
formatdb -i $pos_unip
echo -e "###TAKE CAREFUL: I moved all the default output files procuted from the command formatdb to a specific directory"
echo -e "###if you add more options and retrieve other output files modify the line 18 of pos_neg.sh scripts to include them\n"
cp $pos_unip $database
mv P*[rnq] $database
mv formatdb.log $database

#we run blastall to understand which are the proteins very similar to those chose as training set
echo -e "I'm running the BLASTALL using as input the proteins belonging to the training set against the database created before...\n"
blastall -p blastp -i $output/format_repr_res_wild_95.fasta -d $database/$pos_unip -m 8 -o $output/REPR_RES_W_95.blast

#after manual check of the previous output file, we extract those sequences that do not have
#the level of identity lovel then the one chose that is equale to 95%
echo -e "... PLEASE check the previous output...\n"
sleep 5
echo -e "Insert the THRESHOLD that I need to use to select the final set:"
read thr
awk -v t=$thr -F "\t" '$3>t { print $2}' $output/REPR_RES_W_95.blast | sort -u | awk -F "|" '{print $2}'> $output/IDS_above_$thr.list #22
echo

#extract all the ids from the fasta unique file containing all the postive sequences
echo -e "From the fasta unique file containing the positive sequences, I'm extracting their IDS \n"
grep ">" $pos_unip | cut -d "|" -f 2| sort -u > $output/ALL_POS_IDS.list #359

#delete those that we consider very similar to the sequences chosen for the training set (that are those into IDS_above_95.list)
echo -e "From the ids list of all positive sequences, I'm removing the sequences selected before because they are very similar to those belonging to the training set \n"
comm -2 -3 $output/ALL_POS_IDS.list $output/IDS_above_95.list > $output/POS_FINAL_IDS.list #359-22=337


#create a unique file that contain the fasta sequences containing in this last file
echo -e "I'm creating a new file with the fasta sequences corresponding to ids containing into the last output \n"
python ./scripts/scarica_fasta.py ./output/POS_FINAL_IDS.list $pos_unip > $output/POS_FINAL_IDS.fasta


#pass the clean positive and negative unique fasta file to the hmmsearch
echo -e "I'm running two time the hmmsearch using as input the first time the fasta file with the positive sequences and the second time the one containing the those negative \n"
#POSITIVE
hmmsearch --noali -E 1000 --max -o $output/1000_POS_FINAL_RW_hmmsearch.txt $model/kunizt.hmm $output/POS_FINAL_IDS.fasta
#NEGATIVE
hmmsearch --noali -E 1000 --max -o $output/1000_NEG_hmmsearch.txt $model/kunizt.hmm $neg_unip

#modify the hmmsearch output
echo "###If you don't want to modify as default the hmmsearch output files, change in the pos_neg.sh script the name of the cleaned file at line 55 and 57"
sleep 5
./scripts/modify_hmmsearch.sh ./output/1000_POS_FINAL_RW_hmmsearch.txt ./output/1000_NEG_hmmsearch.txt

#we need to rescaled both file to make them comparable
echo -e "I'm doing the rescaling on positive and negative clean files...\n"
all_pos=`grep ">" ./output/POS_FINAL_IDS.fasta | wc -l`
all_neg=`grep ">" $neg_unip | wc -l`
#POSITIVE
awk -v p=$all_pos '{print $9,$1/p,$4/p}' $output/CLEAN_1000_POS_FINAL_RW_hmmsearch.txt > $output/rescaled_POS_FRW.txt
#NEGATIVE
awk -v n=$all_neg '{print $9,$1/n,$4/n}' $output/CLEAN_1000_NEG_hmmsearch.txt > $output/rescaled_NEG.txt
