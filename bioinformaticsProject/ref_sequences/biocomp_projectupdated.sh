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

$2 -in mcrAgene.fasta -out mcrAgene.hmm

#Build a profile HMM from muscle output for hsp70

$3  hsp70results hsp70.hmm 

#Build a profile HMM from muscle output for mcrA

$3  mcrAresults mcrAgene.hmm 

#Compile proteomes to use as file to search using hmmsearch

#Leaving ref_sequence 

cd ..

#Enter Proteome

cd $4

#Compile proteomes to use as file to search using hmmsearch

cat proteome* | grep -v fasta > proteome.fasta

#Do we need code here that moved proteomes.fasta into ref sequence? If so, 

#searching sequence database hsp70 

$5 --tblout hsp70searchofficial hsp70results proteome.fasta

#searching sequence database mcrA

$5 --tblout mcrAsearchofficial mcrAresults proteome.fasta

#Converting to a text file with proteome names
