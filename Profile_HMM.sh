#!/bin/bash
#DESCRIPTION: This script compute automatycally an Profile_HMM and compute the confusion matrix, ACC and MCC for 10 different E_value
#At starting poitn you have to pass only your customize table of your training set.
#Then is enough to following step by step the interactive guide

#USAGE: ./Profile_HMM.sh [customize_table_of_your training_set]
#like this >>> ./Profile_HMM.sh tabularResults_wild.csv

#ATTENTION1: to run it you need to download all the file with the same repository organization
#ATTENTION2: for now you need to replace your working directory in all of the shell scripts that you can find
#            into the scripts directory.

#ASSIGN the input to variables
# mkdir input
# mkdir output
# echo -e "PLEASE tell me what is your working directory"
# echo -e "IT MUST BE IN THE CURRENT FORM: $HOME/folder_1/folder_2/etc.."
# echo -e "(without the last slash)"
# read folder
# input="$folder/input"
# output="$folder/output"
# script="$folder/scripts"
#database="$folder/format_db"

input="$HOME/Desktop/LAB1_part2/real_project/resolution_wildtype/github_script/input"
output="$HOME/Desktop/LAB1_part2/real_project/resolution_wildtype/github_script/output"
script="$HOME/Desktop/LAB1_part2/real_project/resolution_wildtype/github_script/scripts"

training_set=$1
mkdir input
mkdir output

#modified the training set to retrieve a single unique fasta file
./scripts/seq_align.sh $training_set

#create a list of ids for the structural alignment
echo -e "I'm creating a list of ids that you can use to make the structural alignment..\n"
#awk -F " " '{print $1":"$2"}' $output/repr_resolution_wild_95.txt
awk -F " " '{print $1":"$2}' $output/repr_resolution_wild_95.txt > $output/efold_repr_res_wild_95.txt

echo -e "Pass the previous output file called EFOLD_REPR_WILD_95.TXT to the online MUSCLE to retrieve the multiple structural alignment..\n"
echo -e "I waiting for you...\n"
echo -e "Put the alignment into the input folder and write down its name...THANK YOU..\n"
read str_ali

#build the Profile-HMM
echo -e "I'm building the Profile-HMM..\n"
mkdir model
model="$HOME/Desktop/LAB1_part2/real_project/resolution_wildtype/github_script/model"
hmmbuild $model/kunizt.hmm $input/$str_ali
echo ""
#cheack it
echo -e "I'm quickly check the model, running a profile search aginst the training set...\n"
hmmsearch -o $output/hmmsearch_prova.txt $model/kunizt.hmm $output/format_repr_res_wild_95.fasta

#modified the two positive and negative testing set
#running the hmmsearch against both sets
#create a file that contain all the values for the confusion matrix
echo -e "Choose two testing set:one with proteins having the Kunitz domain (read the correlated paper to understand how do it) and the
the other with proteins that do not have it...\n"
echo -e "Put the testing into the input folder...\n"
echo -e "Write down the name of the positive set (proteins with Kunitz domain)...\n"
read test_pos
echo ""
echo -e "Write down the name of the negative set (proteins without Kunitz domain)"
read test_neg
echo ""
./scripts/pos_neg.sh $test_pos $test_neg $folder

#computed all the values for the confusion matrix
echo -e "I'm computing all the values to bufor ten different E-value threshold "
./scripts/confusion_matrix.sh $output/rescaled_POS_FRW.txt $output/rescaled_NEG.txt


echo "ALMOST WELL DONE"
