## Identifying candidate pH-resistant methanogenic Archaea
# Project by Johanna Olesk and Nihat Aliyev

# The aim of this project is to identify which of the 50 isolated microbe proteomes belong to pH-resistant methanogens. This can be done by looking at the presence of the methyl-coenzyme M reductase (mcrA) gene catalyzing the last step of the methanogenesis, and the number of copies of HSP70 gene which is involved in protein biogenesis and refolding for stress resistance.

# The inputs of the code are the reference sequences together with the proteome sequences.
# The outputs of the code are a table showing a match count for mcrA gene and hsp70 gene for each proteome, and a text file with the names of the candidate pH-resistant methanogens based on the results.

# USAGE: bash Project1.sh reference_sequence_path proteome_sequence_path

mkdir Results

# 1. concatenating the reference sequences:
cat $1/mcrAgene_*.fasta > mcrAgene.fasta
cat $1/hsp70gene_*.fasta > hsp70gene.fasta

# 2. aligning the concatenated ref sequence files using muscle
../muscle3.8.31_i86linux64 -in mcrAgene.fasta -out mcrAgene_aligned.fasta
../muscle3.8.31_i86linux64 -in hsp70gene.fasta -out hsp70gene_aligned.fasta

# 3. build HMM profile
../hmmer/bin/hmmbuild mcrA_profile.hmm mcrAgene_aligned.fasta
../hmmer/bin/hmmbuild hsp70_profile.hmm hsp70gene_aligned.fasta

echo "proteome_ID,mcrA_gene,hsp70_gene" > Results/match_count_table.csv

# 4. search for gene in each proteome
for proteome in $2/proteome_*.fasta
do
../hmmer/bin/hmmsearch --tblout mcrA_search.txt mcrA_profile.hmm $proteome
../hmmer/bin/hmmsearch --tblout hsp70_search.txt hsp70_profile.hmm $proteome
mcrA_match=$(cat mcrA_search.txt | grep -v "#" | wc -l)
hsp70_match=$(cat hsp70_search.txt | grep -v "#" | wc -l)
# make a table with 3 columns (proteome name, mcrA match count, hsp70 match count)
proteomeID=$(echo $proteome | sed 's/.*\/\(.*\)\..*/\1/')
echo "$proteomeID,$mcrA_match,$hsp70_match" >> Results/match_count_table.csv
done

echo "These are the pH-resistant methanogens chosen according to the presence of the mcrA gene and the number of copies of hsp70 gene (we chose the copy number 2 or more)." > Results/pHresistant_methanogens.txt

# 5. choose the pH-resistant methanogens
cat Results/match_count_table.csv | sort -t , -k 2 | awk -F , '$3>"1"' | awk -F , '$2=="1"' > chosen_methanogens.txt
cut -d , -f 1 chosen_methanogens.txt >> Results/pHresistant_methanogens.txt

rm mcrAgene.fasta
rm hsp70gene.fasta
rm mcrAgene_aligned.fasta
rm hsp70gene_aligned.fasta
rm mcrA_profile.hmm
rm hsp70_profile.hmm
rm mcrA_search.txt
rm hsp70_search.txt
rm chosen_methanogens.txt
