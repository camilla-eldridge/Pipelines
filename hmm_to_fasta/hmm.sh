#!/bin/bash
query="$1"
target="$2"
model="$3"
id="$4"

if [ "$1" == "-h" ]; then
  echo "Usage: ./hmm.sh  query.fasta  target.fasta  P/N  id"
  exit 0
fi


if [ "$model" == "N" ];then
	muscle -in "$query" -out "$id"_muscle.fasta
	hmmbuild --dna "$id".hmm "$id"_muscle.fasta
	nhmmer --dna "$id".hmm "$target" > "$id".nhmmer
	hmm_to_fasta.py "$id".nhmmer  "$target"  "$model" > "$id"_nhmmout.fa
else
	clustalo --in "$query" -o "$id"_clustalo.fasta
	hmmbuild --amino "$id".hmm "$id"_clustalo.fasta
	hmmsearch "$id".hmm "$target" > "$id".hmmsearch
	hmm_to_fasta.py "$id".hmmsearch "$target" "$model"  > "$id"_hmmsearch.fa
fi



#phmmer == search with single sequence input
#phmmer
#(protein sequence vs protein database),
#hmmsearch
#(protein HMM query
#vs protein database), or
#hmmscan
#(protein query vs protein HMM database)
