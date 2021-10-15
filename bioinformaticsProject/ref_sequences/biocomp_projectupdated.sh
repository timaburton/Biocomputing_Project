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

#Move to proteome directory from ref_sequences

cd  ~/Private/Biocomputing_Project/bioinformaticsProject/proteomes/

#hmmsearch hsp70

for file in proteome*
do
echo | ~/Private/bin/hmmsearch --tblout hsp70search$file  hsp70results  $file
done

#Sorting hsp based on proteome

for file in hsp70searchproteome_*
do
grep "# Target\|WP" $file > newcomposite2$file
done

#Finding amount of hsp in each proteome

for file in newcompositehsp70searchproteome_*
do
echo
wc -l $file >> CompiledWChsp70
done


#hmmsearch mcrA

for file in proteome*
do
echo | ~/Private/bin/hmmsearch --tblout mcrAsearch$file  mcrAresults  $file
done

#Sorting mcrA  based on proteome

for file in mcrAsearchproteome_*
do
grep "# Target\|WP" $file > newcomposite1$file
done

#Finding amount of mcrA in each proteome 
do
echo
wc -l $file >> CompiledWCmcrA
done

