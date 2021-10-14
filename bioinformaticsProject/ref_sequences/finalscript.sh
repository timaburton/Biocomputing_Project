#This script is for the final project of Biocomputing
#Usage: bash finalscript.sh

#STEP 1a: combine all hsp files in ref_sequences into a total file called HSP_file.fasta
cat hsp*.fasta >> HSP_file.fasta
#STEP 1b: combine all mcrA files in ref_sequences into a total file called mcrA_file.fasta
cat mcrA*.fasta >> mcrA_file.fasta

#STEP 2a: Search for HSP in each proteome
./muscle -in HSP_file.fasta -out HSP_Muscle.afasta
#STEP 2b: Search for mcrA in each proteome
./muscle -in mcrA_file.fasta -out MCRA_Muscle.afasta

#STEP 3a: Build hmm profile
~/Private/bin/bin/hmmbuild HSP_hmm.txt HSP_Muscle.afasta
#STEP 3b: Build mcrA profile
~/Private/bin/bin/hmmbuild MCRA_hmm.txt MCRA_Muscle.afasta

#STEP 4: Count matches for HSP and MCRA (against  each proteome)
for number in proteome*.fasta
do
name=$(echo $number | cut -d_ -f 2| cut -d. -f 1)
~/Private/bin/bin/hmmsearch --tblout match${name}resultsHSP.search HSP_hmm.txt $number
~/Private/bin/bin/hmmsearch --tblout match${name}resultsMCRA.search MCRA_hmm.txt $number
done

#STEP 5: Make table with proteome number in first column, number of HSP matches in second column, and number of MCRA matches in third column
for i in {01..50}
do
coltwo=$(cat match"$i"resultsHSP.search | grep -v "#" | wc -l)
colthree=$(cat match"$i"resultsMCRA.search | grep -v "#" | wc -l)
echo "Proteome $i   $coltwo"   "$colthree"
done

