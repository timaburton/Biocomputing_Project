#this is the rough draft of our Bash project script
#usage: TBD but something around bash biocomp_project.sh <rawfiledir> <proteomsdir>



#to combine the raw hsp70 files into one fasta that we will hmm

cat hsp70* | grep -v fasta > hsp70.fasta

#to combine the raw mcrAgene files into one fasta that we will hmm

cat mcrAgene* | grep -v fasta > mrcAgene.fasta
