#this is the rough draft of our Bash project script
#usage: TBD but something around bash biocomp_project.sh <ref sequence file> <location of muscle tool>

#access ref files 

#cd ref_sequences 

#to combine the raw hsp70 files into one fasta that we will hmm

cat hsp70g* | grep -v fasta > hsp70.fasta

#to combine the raw mcrAgene files into one fasta that we will hmm

cat mcrAgene_* | grep -v fasta > mcrA.fasta

#muscling the compiled hsp70

~/Private/bin/muscle -in hsp70.fasta -out hsp70.hmm

#muscling the compiled mcrA

~/Private/bin/muscle -in mcrA.fasta -out mcrAgene.hmm

#Build a profile HMM from muscle output for hsp70

~/Private/bin/hmmbuild  hsp70results hsp70.hmm 

#Build a profile HMM from muscle output for mcrA

~/Private/bin/hmmbuild  mcrAresults mcrAgene.hmm 

#Compile proteomes to use as file to search using hmmsearch

mv ./mcrAresults ../proteomes 

mv ./hsp70results ../proteomes
#cd ..

#Enter Proteome

#cd $4

#Compile proteomes to use as file to search using hmmsearch

#cat proteome* | grep -v fasta > proteome.fasta

#Do we need code here that moved proteomes.fasta into ref sequence? If so, 

#searching sequence database hsp70 

# --tblout hsp70searchofficial hsp70results proteome.fasta

#searching sequence database mcrA

# --tblout mcrAsearchofficial mcrAresults proteome.fasta

#Converting to a text file with proteome names
