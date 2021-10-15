# This script will search for HSP and mcrA genes in the isolated pryoteome sequence files and identify the number of matches for each gene. It will also create a file that contains the names of the
# proteomes that are candidates for further experiments. Written to be run from ~/Private/Biocomputing_Project/bioinformaticsProject/ where hmmer and muscle are located in ~/Private

# usage: bash candidatesearch.sh

# Combine all hsp sequence files into one file 
cat ./ref_sequences/hsp* > ./ref_sequences/hsp.fasta

# Combine all mcrA sequence files into one file
cat ./ref_sequences/mcrA* > ./ref_sequences/mcrA.fasta

# Align sequences in hsp.fasta file
../../muscle -in ./ref_sequences/hsp.fasta -out hsp.aligned

# Build HMM profile (hsp.hmm) from hsp.aligned file
../../hmmer/bin/hmmbuild --amino hsp.hmm hsp.aligned

# Align sequences in mcrA.fasta file
../../muscle -in ./ref_sequences/mcrA.fasta -out mcrA.aligned

# Build HMM profile (mcrA.hmm) from mcrA.aligned file
../../hmmer/bin/hmmbuild --amino mcrA.hmm mcrA.aligned

# Search all proteome sequence files (01 through 50) with HSP and mcrA models
declare -i count=1 
for file in ./proteomes/*.fasta 
do
filename="proteome_0$count" 
if (( $count > 9 )) 
then filename="proteome_$count" 
fi 
../../hmmer/bin/hmmsearch --tblout $filename.hsp hsp.hmm $file
../../hmmer/bin/hmmsearch --tblout $filename.mcrA mcrA.hmm $file
count+=1 
done

# Count matches for HSP and mcrA and generate a summary table
printf "|%10s|%10s|%10s|\n" "name" "hsp" "mcrA"
printf "===============================================\n"
for i in {01..50}
do
hsp=$(grep -v "#" proteome_$i.hsp | wc -l)
mcrA=$(grep -v "#" proteome_$i.mcrA | wc -l)
printf "|%10s|%10s|%10s|\n" "proteome_$i" $hsp $mcrA
done

# Exclude all proteomes that do not have any HSP or mcrA genes, then exclude all proteomes that have fewer than three HSP genes.
for i in {01..50}
do
hsp=$(grep -v "#" proteome_$i.hsp | wc -l)
mcrA=$(grep -v "#" proteome_$i.mcrA | wc -l)
if ! (($hsp<1 || $mcrA<1))
then
if (($hsp>2))

# Create a file that contains the names of the proteomes that meet the requirements listed above (at least one mcrA gene and more than three HSP genes)
then printf "proteome_$i\n" >> candidates.txt
fi
fi
done

# Make directories and move output files to organize script outputs
mkdir hmmbuildoutput
mkdir muscleoutput
mkdir hmmsearchfiles
mv *.aligned ./muscleoutput
mv *.hmm ./hmmbuildoutput
mv *.mcrA *.hsp ./hmmsearchfiles
