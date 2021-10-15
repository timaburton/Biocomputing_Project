#Shell Script for Biocomputing Bash Project Fall 2021

#Usage: bash BioCompProject.sh
#the code will ask users for the path's of where each folder is located. However to make it 
#easier on users, we suggest organizing the project's files based on the structure below:
##### /bioinformaticsProject : /muscle, /ref_sequences, /BioCompProject.sh, /proteomes, 
#     /hmmer/bin/: hmmbuild hmmsearch 


# The following code is getting the path of McRa gene, HSP70 gene and Proteomes from the user.
printf  "Hi, I hope you are doing great.\nCould you please give me the path of McRA_Genes?\n"
printf  "Example: ref_sequences directory is in Biocomp-Project, which is current working directory, enter './ref_sequences'\n"
printf  "If any path is your current path, please enter only a '.'\n"

read Path1
printf "Awesome, and also share the path of HSP70 genes?\n"
read Path2
printf "Great! Now kindly enter the path where proteomes are stored\n"
read Path3
printf "Thank you. Almost there...I promise. Please tell us the path where your Muscle program is stored.\n"
read Path4
printf "Finally, could you list the path for your hmmbuild and hmmsearch?\n"
read Path5

printf "The paths you have entered are: "
echo $Path1 $Path2 $Path3 $Path4 $Path5

#following commands concatenates all the McrA gene files and all of the HSP70 gene files
#results in one file for McrA genes and anothe for HSP70 genes
cat $Path1/mcrAgene*.fasta  > $Path1/mcrAlist.fasta
cat $Path2/hsp70gene*.fasta > $Path2/hsp70list.fasta

#next set of commands runs the Muscle program to create alignment files 
#for both types of reference sequences. Then a profile is built for each to perform a search

$Path4/muscle -in $Path1/mcrAlist.fasta -out $Path1/mcrAlignment.fasta

$Path4/muscle -in $Path2/hsp70list.fasta -out $Path2/hsp70Alignment.fasta

$Path5/hmmbuild $Path1/mcrAbuild.fasta $Path1/mcrAlignment.fasta 

$Path5/hmmbuild $Path2/hsp70build.fasta $Path2/hsp70Alignment.fasta

#removes any file with this naming convention 
rm genehitlist.csv

#print a header row for your CSV file
echo -e 'Proteome\tMcrA Hits\tHSP70 Hits'  >> genehitlist.csv

#begin for loop to generate a search image that will be then referenced to all 50 proteomes
#to find any proteome that has the most McrA and HSP70 hits/matches
for i in {01..50}

do 

$Path5/hmmsearch --tblout mcrAsearch.fasta $Path1/mcrAbuild.fasta $Path3/proteome_$i*

mcrAhit=$(cat mcrAsearch.fasta | grep -v "^#" | wc -l)

$Path5/hmmsearch --tblout hsp70search.fasta $Path2/hsp70build.fasta $Path3/proteome_$i* 

hsp70hit=$(cat hsp70search.fasta | grep -v "^#" | wc -l)

echo -e Proteome_$i'\t'$mcrAhit'\t'$hsp70hit >> genehitlist.csv 

done	


# The following pipeline  travereses genehitlist.csv to find the best 5 candidates that are  
#methanogens with pH resistance qualities. First, we check to see if there are any McrA hits, and
#discard any that return with 0 hits. Following this we sort the reminaing proteomes based on their 
#the number of hsp70 gene hits/matches. Finally, this list is stored in a new .txt file and is displayed for the user to see

cat genehitlist.csv |awk -F '\t' '$2>0'|sort -k 3 -nr | head -n 5 | cut -d "\t" -f 1 > UltimateHitList.txt 

echo "This is the ultimate list of Proteomes to use for your experiment...Good luck!"
cat UltimateHitList.txt

