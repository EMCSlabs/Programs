function [ tokensPerSong ] = Token(data, inputType, tokenType, varargin)
% [ input  ] data : full data cell (size: n by 4)
%            inputType : type of input ('artist' or 'year' or 'all')
%            tokenType : type of tokens ('word' or 'syllable')
%            artistORyear (varargin) : name of artist or year (in quotations)
% [ output ] tokensPerSong : Average number of words/syllables (token) per song (of a specific Artist)
%% ver 2.0. (Last updated: 2016.01.29. 11:44 AM)
%% (1) Extract songs according to input condition
% Pre-allocation
lyrics = [];

if strcmp(inputType, 'artist');
    % (i) If inputType is 'artist', get all lyrics (4th column) from data
    for i = 1:size(data,1);
        lyric = data(i,4);
        lyrics = [lyrics ; lyric]; % Concatenate as a string-cell array
    end
    
elseif strcmp(inputType, 'year');
    % (ii) If inputType is 'year', check year info to get lyrics (4th column) from data
    for i = 1:size(data,1);
        if strcmp(data{i,1}, varargin);
            lyric = data(i,4);
            lyrics = [lyrics ; lyric]; % Concatenate as a string-cell array
        end
    end
elseif strcmp(inputType, 'all');
    lyrics = data(:,4);
end

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
