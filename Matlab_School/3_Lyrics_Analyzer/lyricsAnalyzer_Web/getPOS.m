function [ POS ] = getPOS(data, type)
% [ input  ] data : tagged lyrics (n by 1 cell array)
%              ex. load('sample_tagged.mat');  data = tagged(:,4)
%            type : N for Nouns (NNG;일반명사 / NNP;고유명사 / NP;대명사)
%                   V for Verbs
%                   Adj for Adjectives
%              ex. (data, 'NNG')
% [ output ] POS : all morphemes  (n by 1 cell array)
%% Last updated: 2016.01.28. 2:42 PM
%%
NNGs=[]; NNPs=[]; NPs=[];
VAs = [];
VVs = [];

if strcmp(type, 'N');
    for i = 1:size(data)
        NNG = regexp(data{i},'\w+(?==NNG)','match');
        NNP = regexp(data{i},'\w+(?==NNP)','match');
        NP = regexp(data{i},'\w+(?==NP)','match');
        
        NNGs = [NNGs unique(NNG)];
        NNPs = [NNPs unique(NNP)];
        NPs = [NPs unique(NP)];
        
    end
    NNG=NNGs';
    NNP=NNPs';
    NP=NPs';
    
    NN = [NNG;NNP;NP];
    POS = NN;
    
elseif strcmp(type, 'V');
    for i = 1:size(data)
        VV = regexp(data{i},'\w+=VV','match');
        VV = regexprep(VV, '(?<=\w+)=VV', '다');
        VV = VV';
        VVs = [VVs ; unique(VV)];
    end
    POS = VVs;
    
elseif strcmp(type, 'Adj');
    for i = 1:size(data)
        VA = regexp(data{i},'\w+=VA','match');
        VA = regexprep(VA, '(?<=\w+)=VA', '다');
        VA = VA';
        VAs = [VAs ; unique(VA)];
    end
    POS = VAs;
    
end
