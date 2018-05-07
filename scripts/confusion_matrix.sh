#!/bin/bash
#DESCRIPTION: It take the as input the rescaled files and give as the MCC and the ACCURANCY
#USAGE: ./confusion_matrix.sh [rescaled_POSITIVE.txt] [rescaled_NEGATIVE.txt]
#like >>>./confusion_matrix.sh ../POS/LEAVE/rescaled_POS.txt ../POS/LEAVE/rescaled_NEG.txt

#NO OUTPUT = the next two line are necessary because i don't want to print the result of each command on the shell
# logfile="file.log"
# exec > $logfile 2>&1

input="$HOME/Desktop/LAB1_part2/real_project/resolution_wildtype/github_script/input"
output="$HOME/Desktop/LAB1_part2/real_project/resolution_wildtype/github_script/output"
script="$HOME/Desktop/LAB1_part2/real_project/resolution_wildtype/github_script/scripts"
database="$HOME/Desktop/LAB1_part2/real_project/resolution_wildtype/github_script/output/database"
model="$HOME/Desktop/LAB1_part2/real_project/resolution_wildtype/github_script/model"

#ASSIGN the input to the variables
pos=$1
neg=$2

#POSITIVE
#take as input the rescaled positive file with "id  E-value_full_sequence  E-value_domain" and
#retrive the true positive for ten threshold (from 10e-1 to 10e-10)
echo -e "I'm computing the TRUE POSITIVE...\n"
for i in `seq 1 10` ; do  awk -v a=$i '{if ($2<(10^(-a))) print $0}'  $pos |wc -l; done > $output/f1_pos

#NEGATIVE
echo -e "I'm computing the FALSE POSITIVE..\n"
#take as input the rescaled negative file with "id  E-value_full_sequence  E-value_domain" and
#retrive the true negative for ten threshold (from 10e-1 to 10e-10)
for i in `seq 1 10` ; do  awk -v a=$i '{if ($2<(10^(-a))) print $0}'  $neg |wc -l; done > $output/f2_neg

#put the two file together and compute the remaining values for the confusion matrix (FP=false positive & FN=false negative)
echo -e "I'm computing the FALSE NEGATIVE and the TRUE NEGATIVE...\n"
paste $output/f1_pos $output/f2_neg |awk '{print $1,335-$1,$2,43697-$2}'>$output/tab_res.txt

echo -e "Down here you can find a nice table reporting the values of consfusion matrix for 10 different E-value threshold...\n"
awk 'BEGIN {print "e- TP FN FP TN"; n=0} {n=n+1} {print n,$0}' $output/tab_res.txt > $output/nice_tab.txt
cat $output/nice_tab.txt
echo ""
echo ""
echo ""



#MATTHEW CORRELATION COEFFICIENT
#ACCURANCY COEFFICIENT
echo -e "I'm computing the ACC and MCC for the confusion matrix of different E-value"
fin_r=$(python ./scripts/matthew_acc.py $output/tab_res.txt)
echo "$fin_r"

#tell to the bash script "YOU FINISHED"
exit 0


# per rendere eseguibile
# chmod u+x file_name.sh
