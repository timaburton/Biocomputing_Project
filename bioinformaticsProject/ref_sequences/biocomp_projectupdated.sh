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

#hmmsearch hsp70

for file in proteome*
do
echo | ~/Private/bin/hmmsearch --tblout hsp70search$file  hsp70results  $file
done

#hmmsearch mcrA

for file in proteome*
do
echo | ~/Private/bin/hmmsearch --tblout mcrAsearch$file  mcrAresults  $file
done

#Compiling all hsp70searches

echo | cat hsp70searchproteome_* > compositesearch1

#Compiling all mcrAsearches

echo | catmcrAsearchproteome_* > compositesearch2

