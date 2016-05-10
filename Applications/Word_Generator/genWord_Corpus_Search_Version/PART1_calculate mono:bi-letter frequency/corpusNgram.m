% This script creates a struct containing the mono & biphone probability of a corpus data

% created 2015-10-22
% modified 2015-12-12

clear;clc;
%% get ngram list
% 'sejong_noun.txt' is a text file of noun list from Sejong written corpus
% It takes around 10-12 minutes to run this function since the text file includes 34955 words.

[Noun]=Ngram_phon('sejong_noun.txt');

%% initialization
sejong_lit = [];

%% create a struct
% Hopefully, we'd like to add fields such as 'Verb', 'Adjective', etc.
% For this time, we only used nouns as our basic data
sejong_lit = setfield(sejong_lit,'Noun',Noun);

%% save the struct
save('sejong_lit.mat','sejong_lit')