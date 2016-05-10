function [ foreignRatio ] = foreignRate(data, inputType, artistORyear)
% [ input  ] data : full data cell (size: n by 4)
%            inputType : type of input ('artist' or 'year')
%            artistORyear : name of artist or year (in quotations)
% [ output ] foreignRatio : proportion (%) of alphabetical words to total word count (by Year)
%% ver 2.0. (Last updated: 2016.01.26. 7:30AM)
%% (1) Concatenate lyrics of certain year or artist

lyrics = [];
lyrics = num2str(lyrics);

for i = 1:size(data,1);
    if strcmp(inputType, 'year');
        if strcmp(data{i,1}, artistORyear);
            lyric = data(i,4);
            lyrics = [lyrics lyric{1,1} ' ']; % Add a white-space after one lyric
        end
    else strcmp(inputType, 'artist');
        lyric = data(:,4);
        for i = 1:size(lyric,1)
            lyrics = [lyrics lyric{i,1} ' ']; % Add a white-space after one lyric
        end
    end
end

%% (2) Calculate Foreign word ratio 
foreignRatio = 100*length(regexp(lyrics,'[A-Za-z]+','match'))/length(regexp(lyrics,'\<\S+\>','match'));

end

