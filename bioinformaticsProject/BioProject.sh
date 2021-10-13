#combine reference sequence files for mcrAgene and  hsp70gene

cat hsp70gene_*.fasta >> hsp70gene_combined_file.fasta
cat mcrAgene_*.fasta >> mcrAgene_combined_file.fasta 

# Align mcrA reference sequences using muscle and build an hmm profile using hmm build

../../../muscle3.8.31_i86linux64 -in mcrAgene_combined_file.fasta -out mcrA_muscle_results
~/Private/bin/bin/hmmbuild mcrA_hmmbuild_results mcrA_muscle_results

# Search proteomes using hmm profile for mcrA gene

for proteome in proteomes; do ~/Private/bin/bin/hmmsearch --tblout mcrA_search_results ./ref_sequences/ mcrA_hmmbuild_results ./proteomes/proteome_*.fasta >> proteome_mcrA_results; done

#Worked for one file, need to turn into loop

~/Private/bin/bin/hmmsearch --tblout mcrA_hmmsearch_results_proteome01 ./ref_sequences/mcrA_hmmbuild_results ./proteomes/proteome_01.fasta



# ALigns hsp70 reference sequences using muscle and build an hmm profile using hmm build

../../../muscle3.8.31_i86linux64 -in hsp70gene_combined_file.fasta -out hsp70_muscle_results
~/Private/bin/bin/hmmbuild hsp70_hmmbuild_results hsp70_muscle_results
