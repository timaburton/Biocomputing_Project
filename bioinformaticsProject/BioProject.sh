# Usage: bash BioProject.sh
# must be used in bioinformatics folder for relative paths to work, should we change this so that it can be used from anywhere? 
# Path to bioinformatics folder: /afs/crc.nd.edu/user/c/cnovak/Private/bashproject/Biocomputing_Project/bioinformaticsProject

# Combine reference sequence files for mcrAgene
cat ./ref_sequences/mcrAgene_*.fasta >> mcrAgene_combined_file1.fasta 

# Align mcrA reference sequences using muscle and build an hmm profile using hmm build
~/Private/bashproject/muscle3.8.31_i86linux64 -in mcrAgene_combined_file1.fasta -out mcrA_muscle_results1
~/Private/bin/bin/hmmbuild mcrA_hmmbuild_results1 mcrA_muscle_results1

# Combine reference sequence files for hsp70gene
cat ./ref_sequences/hsp70gene_*.fasta >> hsp70gene_combined_file1.fasta

# Align hsp70 reference sequences using muscle and build an hmm profile using hmm build
~/Private/bashproject/muscle3.8.31_i86linux64 -in hsp70gene_combined_file1.fasta -out hsp70_muscle_results1
~/Private/bin/bin/hmmbuild hsp70_hmmbuild_results1 hsp70_muscle_results1

# Create output file with titles for each column
echo "Proteome_number, mcrA_matches, hsp70_matches" > summary_table.csv

# Search proteomes using hmm profile for hsp70 gene and mcrA gene, isolate match results for each gene and send to summary table
for proteome in {01..50}
do
~/Private/bin/bin/hmmsearch --tblout hsp70_hmmsearch_results_proteome$proteome hsp70_hmmbuild_results1 ./proteomes/proteome_$proteome.fasta 
hsp70matches=$(cat hsp70_hmmsearch_results_proteome$proteome | grep -E -v "#" | wc -l)
proteome_name=proteome$proteome
~/Private/bin/bin/hmmsearch --tblout mcrA_hmmsearch_results_proteome$proteome mcrA_hmmbuild_results1 ./proteomes/proteome_$proteome.fasta
mcrAmatches=$(cat mcrA_hmmsearch_results_proteome$proteome | grep -E -v "#" | wc -l)
echo $proteome_name, $mcrAmatches, $hsp70matches >> summary_table.csv
done

# Sorted summary table with results from all searches 
cat summary_table.csv 

# Text file with candidate pH-resistant methanogens   
echo "These are the proteomes that we have identified to have the best possible chance of working. We selected these four because they all have the mcrA gene present, indicating that they are methanogenic organisms, and because these four have the greatest amount of matches for the hsp70 gene, meaning that they are the most pH resistant proteomes of the 50 that we were given. The next best proteomes only had two matches of the hsp70 gene instead of 3, so we used this as our decision point." > Proteome_Results.txt
cat summary_table.csv | grep -E -v P | sort -t "," -k2 -n | tail -n -16 | sort -t "," -k3 -n | tail -n -4 | cut -d "," -f1 >> Proteome_Results.txt
cat Proteome_Results.txt 



