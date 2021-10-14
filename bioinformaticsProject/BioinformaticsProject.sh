#Searches set of proteomes for the mcrA and hsp70 genes, and outputs results into a table, in a file titled "Summary.csv". Produces a file "Candidates.txt" that contains a list of proteomes that are candidates for the growth experiments.
#Note: The code is dependent on where tools and files are located in a system, so could vary for users. 
#Usage: bash BioinformaticsProject.sh

#Align reference sequences
cd ref_sequences
cat mcrAgene_**.fasta > mcrAgene.fasta
cat hsp70gene_**.fasta > hsp70gene.fasta
../muscle -in mcrAgene.fasta -out mcrAgene_muscle.fasta
../muscle -in hsp70gene.fasta -out hsp70gene_muscle.fasta

#Build a profile for the mcrA and hsp70 genes
../bin/hmmbuild --amino mcrAgene_hmm.txt mcrAgene_muscle.fasta
../bin/hmmbuild --amino hsp70gene_hmm.txt hsp70gene_muscle.fasta

#Search the proteomes for mcrA gene, identifies methanogens
cd ../proteomes
for number in proteome_**.fasta
do
name=$(echo $number | cut -d_ -f 2 | cut -d. -f 1)
../bin/hmmsearch --tblout ${name}resultsmcrAgene_match ../ref_sequences/mcrAgene_hmm.txt $number
../bin/hmmsearch --tblout ${name}resultshsp70gene_match ../ref_sequences/hsp70gene_hmm.txt $number
done

#Produce a table with proteome number, mcrA match, number of hsp70 matches
for n in {01..50}
do
column2=$(cat "$n"resultsmcrAgene_match | grep -v '#' | wc -l)
column3=$(cat "$n"resultshsp70gene_match | grep -v '#' | wc -l)
echo "Proteome $n" "$column2" "$column3" >> ../Summary.csv
done

#Provide a list of candidate pH-resistant methanogens
#Based on the results, the cutoff for sufficient pH resistance was 1 copy of hsp70. While the average number of copies was 2.62 across the proteomes, only 14/50 were methanogens. Considering pH resistance to be just one copy of hsp70 allows you to proceed with a larger sample for the growht experiments.
#Note: Average was calculated by awk '{ total += $3; count++ } END { print total/count }' Summary.csv
cd ..
grep -e '1 [1-9]' Summary.csv > Candidates.txt

