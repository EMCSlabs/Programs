% This script is a wrapper for all kinds of genNsyll functions
%
% 2015-12-12

%%
clear all;clc;
load('sejong_lit.mat')

%% Number of syllable = 1
%
%
%% 1syll_get range
r_ov1 = [98 100];
r_vc1 = [98 100];

%% 1syll_ position non-specific
% import sections needed, as table

ov = sortrows(sejong_lit.Noun.Bigram.Position_Nonspecific.onset_vowel,'prob_ov', 'descend');
vc = sortrows(sejong_lit.Noun.Bigram.Position_Nonspecific.vowel_coda, 'prob_vc', 'descend');

% run function gen1syll
[allW1, realW1, nonW1] = gen1syll(ov,vc,r_ov1,r_vc1);

%% Number of syllable = 2
%
%
%% 2syll_ get range
r_ov1 = [0 5];
r_vc1 = [0 5];
r_co1 = [0 5];

r_ov2 = [0 5];
r_vc2 = [0 5];

%% 2syll _ position specific
% import sections needed, as table
initov = sortrows(sejong_lit.Noun.Bigram.Position_Specific.initial.onset_vowel,'freq_ov','descend');
initvc = sortrows(sejong_lit.Noun.Bigram.Position_Specific.initial.vowel_coda,'freq_vc','descend');
initco = sortrows(sejong_lit.Noun.Bigram.Position_Specific.initial.coda_onset,'freq_co','descend');
finov = sortrows(sejong_lit.Noun.Bigram.Position_Specific.final.onset_vowel,'freq_ov','descend');
finvc = sortrows(sejong_lit.Noun.Bigram.Position_Specific.final.vowel_coda,'freq_vc','descend');

% run function gen2syll_pos
[allW2, realW2, nonW2] = gen2syll_pos(initov, initvc, initco, finov, finvc,r_ov1,r_vc1,r_co1,r_ov2,r_vc2);
%% 2syll_position non-specific
% import sections needed, as table
ov = sortrows(sejong_lit.Noun.Bigram.Position_Nonspecific.onset_vowel,'freq_ov','descend');
vc = sortrows(sejong_lit.Noun.Bigram.Position_Nonspecific.vowel_coda,'freq_vc','descend');
co = sortrows(sejong_lit.Noun.Bigram.Position_Nonspecific.coda_onset,'freq_co','descend');

% run function gen2syll
[allW2, realW2, nonW2] = gen2syll(ov, vc, co,r_ov1,r_vc1,r_co1,r_ov2,r_vc2);
%% Number of syllable = 3
%
%
%% 3syll_get range
r_ov1 = [0 3]; r_vc1 = [0 5]; r_co1 = [0 5];
r_ov2 = [0 3]; r_vc2 = [0 5]; r_co2 = [0 5];
r_ov3 = [0 3]; r_vc3 = [0 5];

%% 3syll_ position specific
% import sections needed, as table
initov = sortrows(sejong_lit.Noun.Bigram.Position_Specific.initial.onset_vowel,'prob_ov','descend');
initvc = sortrows(sejong_lit.Noun.Bigram.Position_Specific.initial.vowel_coda,'prob_vc','descend');
initco = sortrows(sejong_lit.Noun.Bigram.Position_Specific.initial.coda_onset,'prob_co','descend');

medov = sortrows(sejong_lit.Noun.Bigram.Position_Specific.medial.onset_vowel,'prob_ov','descend');
medvc = sortrows(sejong_lit.Noun.Bigram.Position_Specific.medial.vowel_coda,'prob_vc','descend');
medco = sortrows(sejong_lit.Noun.Bigram.Position_Specific.medial.coda_onset,'prob_co','descend');

finov = sortrows(sejong_lit.Noun.Bigram.Position_Specific.final.onset_vowel,'prob_ov','descend');
finvc = sortrows(sejong_lit.Noun.Bigram.Position_Specific.final.vowel_coda,'prob_vc','descend');

% run function gen3syll_pos
[allW3,realW3, nonW3] = gen3syll_pos(initov,initvc,initco,medov,medvc,medco,finov,finvc,r_ov1,r_vc1,r_co1,r_ov2,r_vc2,r_co2,r_ov3,r_vc3);

%% 3syll_ position non-specific
% import sections needed, as table
ov = sortrows(sejong_lit.Noun.Bigram.Position_Nonspecific.onset_vowel,'prob_ov','descend');
vc = sortrows(sejong_lit.Noun.Bigram.Position_Nonspecific.vowel_coda,'prob_vc','descend');
co = sortrows(sejong_lit.Noun.Bigram.Position_Nonspecific.coda_onset,'prob_co','descend');

% run function gen3syll
[allW3,realW3,nonW3] = gen3syll(ov,vc,co,r_ov1,r_vc1,r_co1,r_ov2,r_vc2,r_co2,r_ov3,r_vc3);
