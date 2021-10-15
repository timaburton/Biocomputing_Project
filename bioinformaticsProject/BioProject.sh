# Script searches genomes for genes of interest and produces a summary table with the results of the searches. 
# Determines which of the 50 isolated proteomes are the best candidates for continued growth experiments by searching for matches to the mcrA gene and the hsp70 gene. 
# Usage: bash BioProject.sh
# Script was written to be used from the bioinformaticsProject directory based on relative paths but could be used from anywhere with adjusted paths to necessary files.  
# Path to bioinformatics folder: ~/Private/bashproject/Biocomputing_Project/bioinformaticsProject

# Combine reference sequence files for mcrAgene
cat ./ref_sequences/mcrAgene_*.fasta >> mcrAgene_combined_file.fasta 

# Align mcrA reference sequences using muscle and build an hmm profile using hmmbuild
~/Private/bashproject/muscle3.8.31_i86linux64 -in mcrAgene_combined_file.fasta -out mcrA_muscle_results
~/Private/bin/bin/hmmbuild mcrA_hmmbuild_results mcrA_muscle_results

# Combine reference sequence files for hsp70gene
cat ./ref_sequences/hsp70gene_*.fasta >> hsp70gene_combined_file.fasta

# Align hsp70 reference sequences using muscle and build an hmm profile using hmmbuild
~/Private/bashproject/muscle3.8.31_i86linux64 -in hsp70gene_combined_file.fasta -out hsp70_muscle_results
~/Private/bin/bin/hmmbuild hsp70_hmmbuild_results hsp70_muscle_results

# Create output table with titles for each column
echo "Proteome_number, mcrA_matches, hsp70_matches" > summary_table.csv

# Search proteomes using hmm profile for mcrA gene and hsp70 gene, isolate match results for each gene and append to summary table
for number in {01..50}
do
~/Private/bin/bin/hmmsearch --tblout mcrA_hmmsearch_results_proteome$number mcrA_hmmbuild_results ./proteomes/proteome_$number.fasta
mcrAmatches=$(cat mcrA_hmmsearch_results_proteome$number | grep -E -v "#" | wc -l)
~/Private/bin/bin/hmmsearch --tblout hsp70_hmmsearch_results_proteome$number hsp70_hmmbuild_results ./proteomes/proteome_$number.fasta 
hsp70matches=$(cat hsp70_hmmsearch_results_proteome$number | grep -E -v "#" | wc -l)
proteome_name=proteome$number
echo $proteome_name, $mcrAmatches, $hsp70matches >> summary_table.csv
done

# Summary table with results from all searches 
cat summary_table.csv  

# Text file with candidate pH-resistant methanogens   
echo "These are the proteomes that we have identified as being the best candidates for continued growth experiments. We selected these proteomes because they all have the mcrA gene present, indicating that they are methanogens, and because these four proteomes all have three matches for the hsp70 gene, which is the most of all the methanogens present. This means that they are the most pH resistant proteomes of the methanogens, and will have the best chance at growth. The next best proteome candidates had only two hsp70 gene matches, so we used this as our decision point." > Proteome_Results.txt
cat summary_table.csv | grep -E -v P | sort -t "," -k2 -n | tail -n -16 | sort -t "," -k3 -n | tail -n -4 | cut -d "," -f1 >> Proteome_Results.txt
cat Proteome_Results.txt 


