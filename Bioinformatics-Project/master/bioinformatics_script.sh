# This script identifies candidate pH-resistant methanogens to move forward with for study.
# Usage: bash bioinformatics_script.sh relative-path-of-reference-sequences directory-containing-results number-of-proteome-files
# Note: You must have muscle, hmmbuild, and hmmsearch in the same directory that this script is executed in. Additionally, they must be named as so.

# Combine reference sequences files of hsp70 gene and mcrA gene into one 

cat $1/hsp70gene_*.fasta >> hsp70.fasta ## can make directory an input
cat $1/mcrAgene_*.fasta >> mcrA.fasta

# Run muscle alignment on combined hsp70 and mcrA reference sequences

./muscle -in hsp70.fasta -out hsp70_muscle.fasta
./muscle -in mcrA.fasta -out mcrA_muscle.fasta 

# Run hmmbuild on aligned hsp70 and mcrA
 
./hmmbuild hsp70_hmmbuild.fasta hsp70_muscle.fasta
./hmmbuild mcrA_hmmbuild.fasta mcrA_muscle.fasta

# Combine hmmbuild results for mcrA and hsp70 into one file for use in search

cat hsp70_hmmbuild.fasta mcrA_hmmbuild.fasta >> hmmbuild-ALL.fasta

# Search the number of mcrA and hsp70 gene copies in each proteome, and identify candidates to be further studied

for i in $(seq -w 01 "$3") # make number of files more general. Can specify with a $2
do
./hmmsearch --tblout $2/proteome_"$i"_result.fasta hmmbuild-ALL.fasta proteome_"$i".fasta # determines what genes are present in each proteome
done

for i in $(seq -w 01 "$3")
do
var1=$(cat $2/proteome_"$i"_result.fasta | grep -c "mcrA") # identifies number of mcrA gene copies in specified proteome
var2=$(cat $2/proteome_"$i"_result.fasta | grep -c "hsp70") # identifies number of hsp70 gene copies in specified proteome
echo "Proteome_$i  mcrA Copies: $var1  hsp70 Copies: $var2" 
echo "Proteome_$i  mcrA Copies: $var1  hsp70 Copies: $var2" | grep -v " 0" | grep -v "hsp70 Copies: 1"  >> Candidate_Proteomes.txt # generates text file proposing the candidate proteomes to study.
done
