
#USAGE: python [name_of_program.py] [file_values_confusion_matrix.txt]
#like >>>python matthew_acc.py no_H_tab.txt
#INPUT is a file containing for each line the value for confusion matrix (TP,FN,FP,TN)

import sys
from math import sqrt

def get_MCC(file_name):
    f=open (file_name)
    res=[]
    for line in f:
        v=map(float,line.split())
        res.append(((v[0]*v[3])-(v[2]*v[1]))/sqrt((v[0]+v[2])*(v[0]+v[1])*(v[3]+v[2])*(v[3]+v[1])))
    return res

def get_ACC(file_name):
    f=open (file_name)
    res=[]
    for line in f:
        v=map(float,line.split())
        res.append((v[0]+v[3])/(v[0]+v[1]+v[3]+v[2]))
    return res

if __name__=='__main__':
    file_name=sys.argv[1]
    MCC=get_MCC(file_name)
    ACC=get_ACC(file_name)

    for i in range(1,len(MCC)+1):
        print "MCC e-", i,":",MCC[i-1]
        print "ACC e-", i,":",ACC[i-1]
        print "\n"
