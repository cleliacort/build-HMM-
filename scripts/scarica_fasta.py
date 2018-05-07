#USAGE python programma_file lista_id fasta_single_line

import sys
l_341=sys.argv[1]
l_single=sys.argv[2]



lista_341=[]
f_list=open(l_341)
for line in f_list:
        lista_341.append(line.rstrip())


sid=""
c=0
f_swiss=open(l_single)
for line in f_swiss:
    if line[0] == ">":
        sid= line.split('|')[1] #ci ritorna la lista ma a noi serve solo il secondo elemento della lista_341

        if sid in lista_341:
        #c=1
            print line.rstrip()
            c=1
        else:
            c=0
    else:
        if c==1: print line.rstrip()
