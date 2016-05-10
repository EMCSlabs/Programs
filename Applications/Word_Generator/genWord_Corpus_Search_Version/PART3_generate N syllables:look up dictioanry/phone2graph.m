function [ortho_sep,word] = phone2graph(kor_pr)
%% 
% This function converts alphabetized phoneme into Korean grapheme
%
% INPUT:
%           kor_pr    :  alphabetized pronunciation of korean 
%                               (e.g.) 'ohaanfnnyvohhhaa**s0ii**'
%
% OUTPUT:
%           ortho_sep :  n x 4 cell containing syllable-wise alphabetized pronuncations & hangul conversions
%           word   :  n x 1 table containing word-level conversion of the input
%
% written by: YG (12/10/2015)

%% set dictionary
ONS = {'k0', 'kk', 'nn', 't0', 'tt', 'rr', 'mm', 'p0', 'pp', 's0', 'ss', 'oh', 'c0', 'cc', 'ch', 'kh', 'th', 'ph', 'hh'};
NUC = {'aa', 'qq', 'ya', 'yq', 'vv', 'ee', 'yv', 'ye', 'oo', 'wa', 'wq', 'wo', 'yo', 'uu', 'wv', 'we', 'wi', 'yu', 'xx', 'xi', 'ii'};
COD = {'**', 'kf', 'kk', 'ks', 'nf', 'nc', 'nh', 'tf', 'll', 'lk', 'lm', 'lb', 'ls', 'lt', 'lp', 'lh', 'mf', 'pf', 'ps', 's0', 'ss', 'oh', 'c0', 'ch', 'kh', 'th', 'ph', 'hh'};

%% separate input into syllables (row: syllable col: onset/nucleus/coda)

ortho_sep = [];
for i = 1:length(kor_pr)/2

    if mod(i,3) == 1
       ortho_sep{end+1,1} = kor_pr(2*i-1:2*i);  
    elseif mod(i,3) ==2
       ortho_sep{end,2} = kor_pr(2*i-1:2*i); 
    else 
       ortho_sep{end,3} = kor_pr(2*i-1:2*i); 
    end

end
%% get indices of onset, nucleus and coda from the dictionary above

idx=[];
for i = 1:size(ortho_sep,1)
    idx{end+1,1} = regexpcell(ONS,ortho_sep{i,1});
    idx{end,2} = regexpcell(NUC,ortho_sep{i,2});
    idx{end,3} = regexpcell(COD,ortho_sep{i,3});
end

%% get syllable-wise uint16 values

for i = 1:size(ortho_sep,1)
    iONS = regexpcell(ONS,ortho_sep{i,1});
    iNUC = regexpcell(NUC,ortho_sep{i,2});
    iCOD = regexpcell(COD,ortho_sep{i,3});
    
    sum = 44032 + 588*(iONS-1)+28*(iNUC-1)+(iCOD-1); % this is how uint16 coding works!
    
    ortho_sep{i,4} = char(sum);
    
end

%% combine all the syllables in a cell

word = [];
for i = 1:size(ortho_sep,1)
    word = [word ortho_sep{i,4}];
end


