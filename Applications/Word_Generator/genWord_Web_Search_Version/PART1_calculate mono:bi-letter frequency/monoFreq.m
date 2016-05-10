function [freq_onset,freq_vowel,freq_coda] = monoFreq(monolist)
%%
% This function calculates monogram frequency (by phoneme) of Korean words
% 
% Input:
%       monolist: a N x 3 cell array where each column represents onset/vowel/coda
%
% Output:
%       freq_onset: a table for frequency of onset
%       freq_vowel: a table for frequency of vowel
%       freq_coda: a table for frequency of coda
%
% written by: YG 2015-9-25
% modified by: YG 2015-10-22


% generate unique list by position (onset,vowel,coda)
uq1 = unique(monolist(:,1));
uq2 = unique(monolist(:,2));
uq3 = unique(monolist(:,3));

% calculate frequency of each unique monogram 
freq1 = countcats(categorical(monolist(:,1)));
freq2 = countcats(categorical(monolist(:,2)));
freq3 = countcats(categorical(monolist(:,3)));

% calculate probability of each unique monogram
prob1 = freq1/sum(freq1);
prob2 = freq2/sum(freq2);
prob3 = freq3/sum(freq3);

% combine the result as a table
freq_onset = table(uq1,freq1,prob1);
freq_vowel = table(uq2,freq2,prob2);
freq_coda = table(uq3,freq3,prob3);

% as a cell array
%
% freqTable = [uq,cellstr(num2str(freq)),prob];
return