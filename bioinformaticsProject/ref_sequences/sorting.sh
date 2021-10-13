cat mcrAgene_*.fasta >> allmcrAgene.fasta

	./muscle -in allmcrAgene.fasta -out muscleallmcrAgene.fasta
	./hmmbuild buildallmrcA.fasta muscleallmcrAgene.fasta

for j in proteome_*.fasta
do

	./hmmsearch --tblout mrcA$j buildallmrcA.fasta $j
	
done	

cat mrcAproteome_*.fasta
for k in mrcAproteome_*.fasta
do 	
cat $k | grep "WP" | sed -e s/'\s'/,/g 
#echo $k " " $number >> t.txt
done	
#done 
#for z in hsp70gene_*.fasta
#do
#	./muscle -in $z -out muscle$z
#	./hmmbuild build$z muslce$z
#for l in hasmrcA*.fasta
#do

#done
#done
