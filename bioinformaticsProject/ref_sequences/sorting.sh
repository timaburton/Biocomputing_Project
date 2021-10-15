#Compares proteome sequences to check if they contain first McrA gene and then finds the 
#number of hsp 70 genes those proteomes that contain McrA have to identify the best candidates 
#for a pH-resistatnt methanogenic Archaea
#makes all the mrcAgene files into one file
cat mcrAgene_*.fasta >> allmcrAgene.fasta

#aligns the single mrcA gene file
./muscle -in allmcrAgene.fasta -out muscleallmcrAgene.fasta
#builds the newly aligned file
./hmmbuild buildallmrcA.fasta muscleallmcrAgene.fasta

#could make this an absolute path by ../proteomes/proteome_*.fasta instead
#compares the newly built file to each proteome sequence for matches
for j in proteome_*.fasta
do

	./hmmsearch --tblout mrcA$j buildallmrcA.fasta $j
	
done	

#looks through each search results file for matches
for k in mrcAproteome_*.fasta
do 	
	number=$(cat $k | grep "WP" | xargs | cut -d " " -f 6) 
	echo $number >> t.txt
done	 

#makes all the hsp70 gene files into one file 
cat hsp70gene_*.fasta >> allhsp.fasta
#aligns single hsp 70 gene file
./muscle -in allhsp.fasta -out muscleallhsp.fasta
#builds the newly aligned file
./hmmbuild buildallhsp.fasta muscleallhsp.fasta
#searchs through each search results file for matches
for l in proteome_*.fasta
do
 	./hmmsearch --tblout hsp$l buildallhsp.fasta $l
done
#looks through each search result file for the number of matches of hsp to the proteome files
for b in hspproteome_*.fasta
do
	amount=$(cat $b | grep -c "WP" )
	echo $b " " $amount >> s.txt
done

cat s.txt > hashspgene.txt
#creates a table with the proteome that have mcrA gene and hsp matches
paste hashspgene.txt t.txt > table.txt
echo "Top 10 candidates for Study" > results.txt
echo "Proteome	hsp gene matches" >> results.txt
#sorts the table by has an mrcA match and then by the number of hsp 70 gene matches
cat table.txt | sed 's/hsp//g' | sed -r 's/[0-9]{3,}.[0-9]{0,}/has mcrAgene/g' | grep "has" |  sort -r -k 2 | head -n 10 >> results.txt

