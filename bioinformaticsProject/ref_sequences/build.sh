#
for i in *.fasta
do
	./muscle -in $i -out muscle$i
	./hmmbuild build$i muscle$i
	for j in ../proteomes/proteome_**.fasta
	do
		./hmmsearch --tblout mrca$i $j build$i
	done
	cat mrca$i | grep "aligned" > hasmrcA$i
	
	#t=1
	#for p in ../ref_sequences/hsp70gene_**.fasta
	#do 
	#	./hmmsearch --tblout $thsp$i hasmrcA$i $p
		t=t+1	
	#done 
	#	cat $thsp$i | grep "aligned" > $thas$i
	##make file with all the names of the proteome that have hsp70 and mrc
	#for m in $thas$i
	#do
	#	echo m > table.csv
	#done
done
#cat table.csv | sed 's/_/ /' | sort -k 2
