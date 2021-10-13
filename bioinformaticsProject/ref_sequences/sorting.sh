cat mcrAgene_*.fasta >> allmcrAgene.fasta

	./muscle -in allmcrAgene.fasta -out muscleallmcrAgene.fasta
	./hmmbuild buildallmrcA.fasta muscleallmcrAgene.fasta

for j in proteome_*.fasta
do

	./hmmsearch --tblout mrcA$j buildallmrcA.fasta $j
	
done	


for k in mrcAproteome_*.fasta
do 	
	number=$(cat $k | grep "WP" | xargs | cut -d " " -f 6) 
	echo $k " " $number >> t.txt
done	
cat t.txt | sort -r -k 2 | grep -E '[0-9]{3,}' > hasmcrAgene.txt 
 
cat hsp70gene_*.fasta >> allhsp.fasta
	./muscle -in allhsp.fasta -out muscleallhsp.fasta
	./hmmbuild buildallhsp.fasta muscleallhsp.fasta
for l in proteome_*.fasta
do
 	./hmmsearch --tblout hsp$l buildallhsp.fasta $l
done
for b in hspproteome_*.fasta
do
amount=$(cat $b | grep -c "WP" )
echo $b " " $amount >> s.txt
done
cat s.txt | sort -r -k 2 > hashspgene.txt

