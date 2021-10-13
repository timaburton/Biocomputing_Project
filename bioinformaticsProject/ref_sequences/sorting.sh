for i in mcrAgene_*.fasta
do
#	./muscle -in $i -out muscle$i
#	./hmmbuild build$i muscle$i
	for j in ../proteomes/proteome_*.fasta
	do
		./hmmsearch --tblout mrcA$i build$i $j
	done
done
 
