#for i in mcrAgene_*.fasta
#do
#	./muscle -in $i -out muscle$i
#	./hmmbuild build$i muscle$i
#m=1
for j in proteome_*.fasta
do

	./hmmsearch --tblout mrcA$j buildmcrAgene_01.fasta $j
done	
#for k in mrcAproteome_*.fasta
#do 	
#cat $k | grep "WP" | sed -e s/'\s'/,/g | cut -d "," -f 40 >> t.txt
#done	
#done 
