# Determine which isloated colonies of methanogens are the best candidates for growth experiments based on the presence of the McrA gene and multiple copies of the HSP70 gene.
# Usage: bash computingproject.sh
# Enter remote crc terminal
# Be sure to have hmmsearch, hmmbuild, and muscle in the same working directory

# Combine all hsp.fasta and mcrA.fasta into two separate files
cat hsp*.fasta >> hspref.fasta
cat mcrA*.fasta >> mcrAref.fasta

# Use muscle to align reference sequences into two files, one for hsp70 and one for mcrA. This will generate .afasta files.
./muscle -in hspref.fasta -out hspref.afasta
./muscle -in mcrAref.fasta -out mcrAref.afasta

# Input .afasta files into hmmbuild to generate two profile hmm's, one for hsp70 and one for mcrA.
./hmmbuild hsphmm.txt hspref.afasta
./hmmbuild mcrAhmm.txt mcrAref.afasta

# Use hmmsearch to search for patterns in aligned sequences. Repeat for both hsp70 and mcrA. Match.txt files will contain result output tables.
for file in proteome*.fasta
do
./hmmsearch --tblout hspmatch$file.txt hsphmm.txt $file
done

for file in proteome*.fasta
do
./hmmsearch --tblout mcrAmatch$file.txt mcrAhmm.txt $file
done

# Interpret results:

# Generate a text file with the names of candidate pH-resistant methanogens based on tabular hmmsearch results.
# hsp:
for file in hspmatchproteome*.txt
do
echo $file | tr '\n' ' ' >> hspresults.txt
grep "WP_" $file | wc -l >> hspresults.txt
done

grep -E "[23456789]$" hspresults.txt > results.txt

# mrcA:
for file in mcrAmatchproteome*.txt
do
echo $file | tr '\n' ' ' >> mcrAresults.txt
grep "WP_" $file | wc -l >> mcrAresults.txt
done

grep -E "[123456789]$" mcrAresults.txt >> results.txt

#Generate final answer
cut -d _ -f 2 results.txt | cut -d . -f 1 | sort | uniq -c | sort | grep -E "2 " | tr -s ' ' | cut -d " " -f 3 > finalresults.txt

# Rationale: The final results file lists the best 8 isolated candidate colonies because of the presence of the McrA gene to produce methane and the presence of two or greater HSP70 genes to confer pH resistance.  

# Generate a summary table of best candidate results with proteome_number, number_of_mcrA_genes, number_of_HSP70_genes
