genWord .v5 (2015-Dec-15)
Yejin Cho &Yeonjung Hong & Youngsun Cho
 
## part1: Calculate monogram & bigram frequencies of Korean nouns in Sejong written corpus

SCRIPT TO RUN: corpusNgram.m

>>Input required     : sejong_noun.txt
>>Output             : sejong_lit (AND saved in a current folder as sejong_lit.mat)
		     
>>Functions required: Ngram_phon.m
                      graph2phone.m
                      monoFreq.m
                      biFreq.m
		     	
## (subpart1) : Create mat files having syllable noun length information

>>Input required    : sj_noun_syllnum.xlsx
>>Output	     : nouns.mat/noun_syll1.mat/noun_syll2.mat/noun_syll3.mat

>>Script required   : genNounList.m


## part2: Prepare and preprocess Korean dictionary 

>>Input required    : SJ_dict.xlsx
>>Output            : SJ_dict.mat

>>Script required   : revSJ_dict.m


## part3: Create a list of Korean syllables(length N) by setting a range of frequency ratio

SCRIPT TO RUN       : genNsyll_wrap.m

>>Input required    : sejong_lit.mat, noun_syll1.mat, noun_syll2.mat, noun_syll3.mat
>>Output            : allW#, realW#, nonW# for each condition

>>Functions required: genNsyll.m
		       regexpcell.m
		       phone2graph.m
		       searchKordic.m	


## Run GUI

GUI filename: genWord

>>Input required            : syllable number, probability type, probability rankings
>>Output                    : allW#, realW#, nonW#, sortable by word-wise probability/ hangul ordering, savable to specified dir.

>>Functions & files required: genNsyll
                              regexpcell.m
                              phone2graph.m
                              searchKordic.m	
                              sejong_lit.mat
				noun_syll1.mat
				noun_syll2.mat
				noun_syll3.mat
				SJ_dict.mat


