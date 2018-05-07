#!/bin/bash
#DESCRIPTION:clean the output of hmmsearch
#USAGE:./modify_hmmsearch.sh [positive_output_hmmsearch] [negative_output_hmmsearch]
#like >>>./modify_hmmsearch.sh ./output/1000_POS_FINAL_RW_hmmsearch.txt ./output/1000_NEG_hmmsearch.txt

#ASSIGN the input to variables
pos_hmmsearch=$1
neg_hmmsearch=$2

#now we need to clean these two file
#POSITIVE
echo -e "I'm cleaning the positive output file coming from the run of hmmsearch \n"
s_p=`grep -n "full sequence" $pos_hmmsearch|grep -o -e "^[1-9]*" `
S_p=`expr $s_p + 3`
e_p=`tail -n +$S_p $pos_hmmsearch|grep -n "Domain annotation" | grep -o -e "^[1-9]*"`
E_p=`expr $e_p - 3`
tail -n +$S_p $pos_hmmsearch | head -n +$E_p > ./output/CLEAN_1000_POS_FINAL_RW_hmmsearch.txt
#NEGATIVE
s_n=`grep -n "inclusion thre" $neg_hmmsearch|grep -o -e "^[1-9]*"`
S_n=`expr $s_n + 1`
e_n=`tail -n +$S_n $neg_hmmsearch|grep -n "Domain annotation" | grep -o -e "^[1-9]*"`
E_n=`expr $e_n - 3`
tail -n +$S_n $neg_hmmsearch | head -n +$E_n > ./output/CLEAN_1000_NEG_hmmsearch.txt


#some times can be occur that some sequences do not respect some threshold, therefore we decided to consider them
#we just delete the line that contain the "inclusion threshold" and considered all the sequences
#then we do some consideration about these
echo -e "We don't care about the presence of sequences that do not respect the threshold chosen for the hmmsearch, we leave them into the cleaned file \n"
sed -i '/inclusion threshold/d' ./output/CLEAN_1000_POS_FINAL_RW_hmmsearch.txt
