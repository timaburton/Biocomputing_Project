## Identifying candidate pH-resistant methanogenic Archaea

# The aim of this project is to 

# USAGE: bash Project1.sh reference_sequence_path proteome_sequence_path

# 1. concatenating the reference sequences:

#cat $1 > geneA.fasta
#cat $2 > geneB.fasta
cat $1/mcrAgene_*.fasta > mcrAgene.fasta
cat $1/hsp70gene_*.fasta > hsp70gene.fasta

# 2. aligning the concatenated ref sequence files using muscle
../muscle3.8.31_i86linux64 -in mcrAgene.fasta -out mcrAgene_aligned.fasta
../muscle3.8.31_i86linux64 -in hsp70gene.fasta -out hsp70gene_aligned.fasta

# 3. build HMM profile
../hmmer/bin/hmmbuild mcrA_profile.hmm mcrAgene_aligned.fasta
../hmmer/bin/hmmbuild hsp70_profile.hmm hsp70gene_aligned.fasta

# 4. search for gene in each proteome
for proteome in $2/proteome_*.fasta
do
../hmmer/bin/hmmsearch --tblout mcrA_search.txt mcrA_profile.hmm $proteome
../hmmer/bin/hmmsearch --tblout hsp70_search.txt hsp70_profile.hmm $proteome
mcrA_match=$(cat mcrA_search.txt | grep -v "#" | wc -l)
hsp70_match=$(cat hsp70_search.txt | grep -v "#" | wc -l)
# make a table with 3 columns (proteome name, mcrA match count, hsp70 match count)

done
