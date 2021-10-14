# Practice_BioComp2.sh

# This should return the best sample options from the given set, being those that are positive for mcrA gene and have
# pH resistance via multiple HSP70 genes.

#first, identify the samples that are methanogenic. Of those, find the ones with the most HSP70 genes.
# need to return a table with all search results ???
# also return txt file listing candidate colonies (would be good to put in order of number of hsp70 hits.

#DO ALL OF THIS IN THE BIOCOMP-PROJECT DIRECTORY
# make mcrA profile
cat ./ref_sequences/mcrAgene* >> ./ref_sequences/mcrAgene_all.fasta  # combine all mcrA$

muscle -in ./ref_sequences/mcrAgene_all.fasta -out ./ref_sequences/alligned_mcrAgene_all.fasta  # align all sequences

hmmbuild ./ref_sequences/alligned_mcrAgene_all.hmm ./ref_sequences/alligned_mcrAgene_all.fasta # makes a profile of all$

# make hsp70 profile
cat ./ref_sequences/hsp70gene* >> ./ref_sequences/hsp70gene_all.fasta  # combine all hs$

muscle -in ./ref_sequences/hsp70gene_all.fasta -out ./ref_sequences/alligned_hsp70gene_all.fasta  # align all sequences

hmmbuild ./ref_sequences/alligned_hsp70gene_all.hmm ./ref_sequences/alligned_hsp70gene_all.fasta # makes a profile of a$

# now to make a list of mcrA-positive colonies:

for colony in ./proteomes/*
do
matches=$(hmmsearch ./ref_sequences/alligned_hsp70gene_all.hmm $colony | grep ">>" | wc -l) # each hitis reported with $
if [ $matches -gt 0 ]
then
echo $colony >> mcrA_positive.txt # mcrA -positive colonies listed here
fi
done

mcrA_pos=$(cat mcrA_positive.txt)

for colony in $mcrA_pos
do
matches=$(hmmsearch ./ref_sequences/alligned_hsp70gene_all.hmm $colony | grep ">>" | wc -l) # stores the number of hits
echo "$colony","$matches" >> candidates.txt # adds line to a csv where 1st col is proteome name, 2nd col is # of hsp co$
done

# so, now we have a file candidates.txt which contains the candidates and how many hsp copies they have
cat candidates.txt | sort -nr -t, -k2 >> candidates_sorted.txt

