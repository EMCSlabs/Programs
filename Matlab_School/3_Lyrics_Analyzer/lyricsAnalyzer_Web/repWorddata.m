function [AvgNrepWord, AvgNrep] = repWorddata(data)
% [ input  ] data : full data cell (size: n by 4)
%            inputType : type of input ('artist' or 'year')
%            artistORyear : name of artist or year (in quotations)
% [ output ] NrepWord : Average number of repeated words per song (of a specific Artist)
%            Nrep : Average number of repetitions per song (of a specific Artist)
%% ver 1.0. (Last updated: 2016.01.28. 06:45PM)
%%
% Pre-allocation
NrepWord = [];
Nrep = [];
lyrsArtist = [];

% (1) Extract lyrics which correspond to input 'artist'
lyrsArtist = data(:,4);

% (2) Count repeated words(and repeated times) of each lyrics extracted in step(1)
% For each songs ('i'th song among all songs)
for i = 1:size(lyrsArtist,1);
    lyric = lyrsArtist(i,1);
    words = regexp(lyric,'[^\s]+','match'); words = words{1,1}';
    uqwords = unique(words);
    uqwords(:,2) = num2cell(zeros(length(uqwords),1));
    for k = 1:length(uqwords);
        for q = 1:length(words);
            if strcmp(uqwords{k,1},words{q,1});
                uqwords{k,2} = uqwords{k,2} + 1;
            end
        end
    end
    
    % Pre-allocation (reset as 0 in every for loop)
    repNum = 0;
    repNumList = [];
    repSum = 0;
    repSumList = [];
    
    for k = 1:length(uqwords);
        if 1 < uqwords{k,2};
            repNum = repNum + 1;
            repSum = repSum + uqwords{k,2} - 1;
            % cf. 'uqWords{k,2}': how many times a word appeared
            %  -> 'ONE repetition' when appeared TWICE!
            %  -> 'NO repetition' when appeared only once!
        end
        repNumList = [repNumList; repNum];
        repSumList = [repSumList; repSum];
    end
    
    NrepWord(i,1) = mean(repNumList);
    Nrep(i,1) = mean(repSumList);
    
    
% (3) Finally compute the Average of each variable
AvgNrepWord = mean(NrepWord);
AvgNrep = mean(Nrep);
end


