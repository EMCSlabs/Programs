function [ noStops ] = stopWords(data, datatype, ngram)
% [ input ]  data     : n by 1 cell array
%            datatype : 'raw' or 'tagged'
%            ngram    : 'unigram' or 'bigram'
% [ output ] noStops  : n by 1 cell array
% cf. If datatype is tagged, 'ngram' is always UNIGRAM
%% Last updated: 2016.01.28. 1:53 PM
%% 3 Stopword lists (.mat) required
load stopwords_bigram.mat    % raw - bigram
load stopwords_unigram.mat   % raw - unigram
load stopwords_tagged.mat    % tagged - unigram
%%
uniRaws = [];
biRaws = [];
uniTags=[];

if isequal(datatype, 'raw')
    switch ngram
        case 'unigram'
            for i = 1:size(data,1)
                uniRaw = data(i,1);
                for k = 1:length(stpWd_uni);
                    stop = sprintf('\\<%s\\>', stpWd_uni{k,1});
                    uniRaw = regexprep(uniRaw, stop, '');
                end
                uniRaws = [uniRaws ; uniRaw];
            end
            noStops = uniRaws;
            
        case 'bigram'
            for i = 1:size(data,1)
                biRaw = data(i,1);
                for k = 1:length(stpWd_bi);
                    stop = sprintf('\\<%s\\>', stpWd_bi{k,1});
                    biRaw = regexprep(biRaw, stop, '#');
                end
                biRaws = [biRaws ; biRaw];
            end
            noStops = biRaws;
    end
    
elseif isequal(datatype, 'tagged')
    data(:,1) = regexprep(data(:,1),',',' ');
    for i = 1:size(data,1)
        uniTag = data(i,1);
        for k = 1:length(stpWd_uniTag);
            stop = sprintf('\\<%s\\>', stpWd_uniTag{k,1});
            uniTag = regexprep(uniTag,stop,'');
        end
        uniTags = [uniTags ; uniTag];
    end
    noStops = uniTags;
end
end
