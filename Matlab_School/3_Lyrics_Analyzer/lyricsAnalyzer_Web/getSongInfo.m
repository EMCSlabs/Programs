function [singleData] = getSongInfo(songNumber)
%% Last updated: 2016.01.27. 4:34 PM
%% Preallocation
singleData = [];
%% Get song info in a for loop
% Complete songUrl automatically
songUrl =['http://www.genie.co.kr/detail/songInfo?xgnm=' songNumber];

% Get songHtml
optionsGet = weboptions('Timeout',5);
songHtml= webread(songUrl,optionsGet);

% Get Album Number
albumNumber = regexp(songHtml,'(?<=albumInfo'','')\d+','match'); 
albumNumber = albumNumber{1,1};

% Get AlbumHtml
albumUrl =['http://www.genie.co.kr/detail/albumInfo?axnm=' albumNumber];
albumHtml = webread(albumUrl, optionsGet);

% Get Year
yearInfo = regexp(albumHtml, '(?<=alt="¹ß¸ÅÀÏ" /></span> <span class="value">)[^>]*(?=</span></li>)','match');
yearInfo = yearInfo{1,1};
year = yearInfo(1:4);

% Get Lyrics
songHtml = regexprep(songHtml,'<br>',' '); % Remove all <br> first
lyr = regexp(songHtml,'(?<=pLyrics">)[^<]+','match');
if ~isempty(lyr)
    lyrics = lyr{1,1};
elseif isempty(lyr)
    lyrics = 'Not for under 19';
end

% Get Title / Artist
info = regexp(songHtml, '(?<="og:title" content=")[^"]*(?= - genie)','match');
info = regexprep(info, '\([^\)]+\) ',''); % Remove all strings in ( ) parentheses
info = regexprep(info, ' \([^\)]+\)',''); % Remove all strings in ( ) parentheses
info = regexprep(info, '\[[^\]]+\] ',''); % Remove all strings in [ ] brackets
info = regexprep(info, ' \[[^\]]+\]',''); % Remove all strings in [ ] brackets
delimiterIndex = regexp(info,' / '); % Get start index of ' /' in 'info' string
delimiterIndex = delimiterIndex{1}; % Cell to double
title{1,1} = info{1,1}(1:delimiterIndex-1);    % Save as 'i'th cell in title variable
artist{1,1} = info{1,1}(delimiterIndex+3:end); % Save as 'i'th cell in artist variable

% Combine all three pieces of info together
singleData = [year title artist lyrics];

end