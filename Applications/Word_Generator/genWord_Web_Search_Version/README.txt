genWord .v4 (2015-Dec-15)
Yejin Cho & Yeonjung Hong & Youngsun Cho
 
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

		     	

## part2: Create a list of Korean syllables(length N) by setting a range of frequency ratio

SCRIPT TO RUN       : genAll.m

>>Input required    : sejong_lit.mat, noun_syll1.mat, noun_syll2.mat, noun_syll3.mat
>>Output            : allW#, realW#, nonW# for each condition

>>Functions required: gen1syll.m
                      gen2syll.m
		       gen2syll_pos.m
		       gen3syll.m
                      gen3syll_pos.m
		       regexpcell.m
		       phone2graph.m
		       searchKordic.m	


## Run GUI

GUI filename: genWord

>>Input required            : syllable number, probability type, probability rankings
>>Output                    : allW#, realW#, nonW#, sortable by word-wise probability/ hangul ordering, savable to specified dir.

>>Functions & files required: gen1syll.m
                              gen2syll.m
                              gen2syll_pos.m
                              gen3syll.m
                              gen3syll_pos.m
                              regexpcell.m
                              phone2graph.m
                              searchKordic_web.m	
                              sejong_lit.mat


