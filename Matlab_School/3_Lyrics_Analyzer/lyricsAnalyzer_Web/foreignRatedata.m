function [ foreignRatio ] = foreignRatedata(data)
% [ input  ] data : full data cell (size: n by 4)
%            inputType : type of input ('artist' or 'year')
%            artistORyear : name of artist or year (in quotations)
% [ output ] foreignRatio : proportion (%) of alphabetical words to total word count (by Year)
%% ver 1.0. (Last updated: 2016.01.28. 06:45AM)
%% (1) Concatenate lyrics of certain year or artist

lyrics = [];
lyrics = num2str(lyrics);

for i = 1:size(data,1);
    lyric = data(i,4);
    lyrics = [lyrics lyric{1,1} ' ']; % Add a white-space after one lyric
end

%% (2) Calculate Foreign word ratio 
foreignRatio = 100*length(regexp(lyrics,'[A-Za-z]+','match'))/length(regexp(lyrics,'\<\S+\>','match'));

end