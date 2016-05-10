function [ FreqCell ] = FreqAnal(data, datatype, ngram)
% [input]  data : output of stopword & getPosfunction n by 1 cell array
%          datatype: 'raw' or 'tagged'
%          ngram: 'unigram' or 'bigram'
% [output] FreqCell: n by 2 cell array (word - frequency)
%% Last updated: 2016.01.28 3:57 PM
%%
FreqCell = [];
FreqCell_prep = [];
if isequal(datatype, 'raw')
    switch ngram
        case 'unigram'
            for i = 1 : size(data,1);
                % Words = cell array of Words Of one song
                Words = regexp(data{i,1},'\S+','match');
                uqword = unique(Words);
                uqword = uqword';
                FreqCell_prep = [FreqCell_prep; uqword];
            end
            
        case 'bigram'
            % (1) For loop by Song number
            for i = 1:size(data,1)
                list = [];
                % Separate by '#' delimiter
                sharpTxt = textscan(data{i,1}, '%s', 'delimiter','#');
                sharpTxt = sharpTxt{1,1};
                list = [list; sharpTxt];
                bigram = [];
                
                % (2) For loop by 'list' size (Sharp separated units)
                for k = 1:size(list,1)
                    
                    % Extract Single words
                    byWord = regexp(list{k,1}, '\S+','match');
                    
                    % Combine into Bigram unit
                    for m = 1:size(byWord,2)-1
                        bi = [byWord{1,m} ' ' byWord{1,m+1}];
                        bi = cellstr(bi);
                        
                        % Accumulate all bigram cases in 'bigram'
                        bigram = [bigram; bi];
                    end
                end
                
                bigram = unique(bigram);
                FreqCell_prep = [FreqCell_prep ; bigram];
            end
            
    end
    
    uqList = unique(FreqCell_prep);
    FreqCell = [uqList num2cell(countcats(categorical(FreqCell_prep)))];
    
    
elseif isequal(datatype, 'tagged')
    FreqCell_prep = data;
    
    uqList = unique(FreqCell_prep);
    FreqCell = [uqList num2cell(countcats(categorical(FreqCell_prep)))];
    
end

% Sort FreqCell by frequency (for ALL cases)
Freq = cell2table(FreqCell);
Freq.Properties.VariableNames{1} = 'uqlist';
Freq.Properties.VariableNames{2} = 'uqCNT';
FreqTable = sortrows(Freq,{'uqCNT','uqlist'},{'descend','ascend'});
FreqCell = table2cell(FreqTable);

end