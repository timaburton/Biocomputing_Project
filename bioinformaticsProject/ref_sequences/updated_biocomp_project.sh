$2 muscle  -in hsp70.fasta -out hsp70.hmm

#muscling the compiled mcrA

$2 muscle -in mcrAgene.fasta -out mcrAgene.hmm

#Build a profile HMM from muscle output for hsp70

./hmmbuild hsp70results hsp70.hmm

#Build a profile HMM from muscle output for mcrA

./hmmbuild mcrAresults mcrAgene.hmm

#Compile proteomes to use as file to search using hmmsearch

cat proteome* | grep -v fasta > proteome.fasta

#Do we need code here that moved proteomes.fasta into ref sequence? If so,

#searching sequence database hsp70

./hmmsearch --tblout hsp70searchofficial hsp70results proteome.fasta

#searching sequence database mcrA

./hmmsearch --tblout mcrAsearchofficial mcrAresults proteome.fasta
