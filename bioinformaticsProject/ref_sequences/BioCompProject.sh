## The following code is getting the path of McRa gene, HSP70 gene and Proteomes from the user.
printf  "Hi, I hope you are doing great.\nCould you please give me the path of McRA_Genes?\n"
read Path1
printf "Awesome, And also share the path of HSP70 genes?\n"
read Path2
printf "Great!, And lastly, kindly share the path of proteomes too?\n"
read Path3
echo "Here are the paths you have entered:\n" $Path1 $Path2 $Path3

cat $Path1/hsp70gene*.fasta > hsp70genelist.fasta
cat $Path2/mcrAgene*.fasta  > mcrAlist.fasta

./muscle -in ./hsp70list.fasta -out hsp70Alignment.fasta

./muscle -in ./mcrAlist.fasta -out mcrAlignment.fasta

./hmmer/bin/hmmbuild mcrAbuild.fasta mcrAlignment.fasta

./hmmer/bin/hmmbuild hsp70build.fasta hsp70Alignment.fasta

for i in {01..50}

do 

./hmmer/bin/hmmsearch --tblout mcrAsearch.fasta mcrAbuild.fasta ./proteomes/proteome_$i* 

mcrAhit=$(cat mcrAsearch.fasta | grep -v "^#" | wc -l)

./hmmer/bin/hmmsearch --tblout hsp70search.fasta hsp70build.fasta ./proteomes/proteome_$i* 

hsp70hit=$(cat hsp70search.fasta | grep -v "^#" | wc -l)

echo "Proteome $i" $mcrAhit $hsp70hit >> genehitlist.csv 

done

cat genehitlist.csv | 
