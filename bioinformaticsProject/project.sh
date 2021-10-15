#Input:the name of two reference proteome sequence
#Output:the file named "candidate_pH-resistant_methanogens.csv" which containing the isolates that meet the requiments of two genes
#Usage: bash project.sh ./ref_sequences hsp mcr

#Empty files
echo -e '\c'> ref-hsp.fasta
echo -e '\c'> ref-mcr.fasta
#Combining all reference protein sequences together 
cat $1/$2*.fasta >> ref-hsp.fasta
cat $1/$3*.fasta >> ref-mcr.fasta

#Generate alignments for reference protein sequences 
./muscle -quiet -in ref-hsp.fasta  -out Ali-hsp
./muscle -quiet -in ref-mcr.fasta  -out Ali-mcr

#Creat profile hidden markov models for alignments 
./hmmer/bin/hmmbuild -o log build-hsp Ali-hsp
./hmmer/bin/hmmbuild -o log build-mcr Ali-mcr

#Empty file 
echo -e '\c'> proteome.csv
#Search proteomes of all isolates, and save the sequence top hits list 
for proteome in proteomes/proteome_*
do 
./hmmer/bin/hmmsearch -o log --tblout result-hsp build-hsp $proteome
./hmmer/bin/hmmsearch -o log --tblout result-mcr build-mcr $proteome

#Counting the lines of hmmsearch result
line_hsp=$(cat result-hsp | wc -l | cut -d , -f 1)
line_mcr=$(cat result-mcr | wc -l | cut -d , -f 1)

#Calculating the number of mached sequences   
count_hsp=$(echo "$line_hsp-13" | bc)  
count_mcr=$(echo "$line_mcr-13" | bc)

# Saving the results into a table
echo "$proteome,hsp copy $count_hsp,$count_mcr" >> proteome.csv
done

#Deleting unmatched proteome, ranking matched proteome
cat proteome.csv | grep -v -w "0" | grep -v -w "hsp copy 1" | sed 's/hsp copy//' | sort -t , -k 2 -k 3 -n -r  > candidate_pH-resistant_methanogens.csv
#name each column
sed -i "1 i proteome_name,count_$2,count_$3" candidate_pH-resistant_methanogens.csv

