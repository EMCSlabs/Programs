function [ tokensPerSong ] = Tokendata(data, tokenType)
% [ input  ] data : full data cell (size: n by 4)   
%            type : type of tokens ('word' or 'syllable') 
% [ output ] tokensPerSong : Average number of words/syllables (token) per song (of a specific Artist)
%% ver 1.0. (Last updated: 2016.01.28. 06:45PM)
%% (1) Extract songs according to input condition
% Pre-allocation
lyrics = data(:,4)
%% (2) Count number of Words or Syllbles in each song
% Pre-allocation
wordsPerSong = [];
syllsPerSong = [];

if strcmp(tokenType, 'word');
    % (i) If tokenType is 'word', count the number of all word tokens
    for k = 1 : size(lyrics,1);
        wordToken = regexp(lyrics(k),'\<\S+\>','match');
        wordToken = wordToken{1,1};
        wordsPerSong(k) = size(wordToken,2);
    end
    
    % Get average N of words per song
    tokensPerSong = mean(wordsPerSong);
    
    
else strcmp(tokenType, 'syllable');
    % (ii) If tokenType is 'syllable', count the number of all syllable tokens
    for k = 1 : size(lyrics,1);
        syllToken = regexp(lyrics(k),'\S','match');
        syllToken = syllToken{1,1};
        syllsPerSong(k) = size(syllToken,2);
    end
    
    % Get average N of syllables per song
    tokensPerSong = mean(syllsPerSong);
    
end
