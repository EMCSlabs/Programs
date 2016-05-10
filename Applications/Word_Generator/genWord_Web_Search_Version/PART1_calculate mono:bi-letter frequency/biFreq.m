function [freq_OV,freq_VC,freq_CO] = biFreq(ov,vc,co)
%%
% This function calculates bigram frequency (by phoneme)of Korean words
% 
% Input:
%       ov: a cell array of onset-vowel list 
%       vc: a cell array of vowel-coda list
%       co: a cell array of coda-onset list
% Output:
%       freq_OV: a table for frequency of ov sequence 
%       freq_VC: a table for frequency of vc sequence
%       freq_CO: a table for frequency of co sequence
%
% written by: YG 2015-9-25
% modified by: YG 2015-10-22


% generate unique list 
uq_ov = unique(ov);
uq_vc = unique(vc);
uq_co = unique(co);

% calculate frequency of each unique bigram 
freq_ov = countcats(categorical(ov));
freq_vc = countcats(categorical(vc));
freq_co = countcats(categorical(co));

% calculate probability of each unique bigram
prob_ov = freq_ov/sum(freq_ov);
prob_vc = freq_vc/sum(freq_vc);
prob_co = freq_co/sum(freq_co);

% combine the result as a table
freq_OV = table(uq_ov,freq_ov,prob_ov);
freq_VC = table(uq_vc,freq_vc,prob_vc);
freq_CO = table(uq_co,freq_co,prob_co);


% as a cell array
%
% freqTable = [uq,cellstr(num2str(freq)),prob];

return