#!/bin/bash
# Copyright 2016  Korea University & EMCS Labs  (Author: Hyungwon Yang)
# Apache 2.0

if [ $# -ne 3 ]; then
   echo "Input arguments are incorrectly provided. Three arguments should be assigned." 
   echo "1. dictionary directory."
   echo "2. language directory."
   echo "3. oov_word" 
   echo "*** USAGE ***"
   echo "Ex. sh prepare_new_lang.sh $dir $lang $oov_word " && exit 1
fi

# dictionary directory.
dict_dir=$1
# language directory.
lang_dir=$2
# oov word.
oov_word=$3

### dict directory ###
# lexcionp.
perl -ape 's/(\S+\s+)(.+)/${1}1.0\t$2/;' < $dict_dir/lexicon.txt > $dict_dir/lexiconp.txt

# silence.
echo -e "<SIL>\n<UNK>" >  $dict_dir/silence_phones.txt
echo "silence.txt file was generated."

# nonsilence.
awk '{$1=""; print $0}' $dict_dir/lexicon.txt | tr -s ' ' '\n' | sort -u | sed '/^$/d' > $dict_dir/nonsilence_phones.txt
echo "nonsilence.txt file was generated."

# optional_silence.
echo '<SIL>' >  $dict_dir/optional_silence.txt
echo "optional_silence.txt file was generated."

# extra_questions.
cat $dict_dir/silence_phones.txt| awk '{printf("%s ", $1);} END{printf "\n";}' > $dict_dir/extra_questions.txt || exit 1;
cat $dict_dir/nonsilence_phones.txt | perl -e 'while(<>){ foreach $p (split(" ", $_)) {  $p =~ m:^([^\d]+)(\d*)$: || die "Bad phone $_"; $q{$2} .= "$p "; } } foreach $l (values %q) {print "$l\n";}' >> $dict_dir/extra_questions.txt || exit 1;
echo "extra_questions.txt file was generated."

# Insert <UNK> in the lexicon.txt and lexiconp.txt.
sed -i '1 i\<UNK> <UNK>' $dict_dir/lexicon.txt 
sed -i '1 i\<UNK> 1.0 <UNK>' $dict_dir/lexiconp.txt

### lang directory ###
main/local/core/prepare_lang.sh $dict_dir $oov_word main/data/local/lang $lang_dir >/dev/null

	

