#USAGE: python  clust_fasta.py   name_of_IDs_list   database_file_containing_fasta_sequence

import sys
ids=sys.argv[1]
tab_f=sys.argv[2]

IDs=[]
ids_list=open(ids)
for line in ids_list:
        IDs.append(line.rstrip())


tab=open (tab_f)
for line in tab:
    if line[0] == ">":
        sid= (line.split('>')[1]).rstrip() #ci ritorna la lista ma a noi serve solo il secondo elemento della lista_341

        if sid in IDs:
        #c=1
            print line.rstrip()
            c=1
        else:
            c=0
    else:
        if c==1: print line.rstrip()
