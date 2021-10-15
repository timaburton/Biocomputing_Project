#this is the rough draft of our Bash project script
#usage: TBD but something around bash biocomp_project.sh <ref sequence file> <location of muscle tool>

#access ref file 

cd $1

#to combine the raw hsp70 files into one fasta that we will hmm

cat hsp70* | grep -v fasta > hsp70.fasta

#to combine the raw mcrAgene files into one fasta that we will hmm

cat mcrAgene* | grep -v fasta > mrcAgene.fasta

#muscling the compiled hsp70

$2 -in hsp70.fasta -out hsp70.hmm

#muscling the compiled mcrA
$2 -in hsp70.fasta -out hsp70.hmm

