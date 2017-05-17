function [songNumber, nRead, maxPage] = getSongList(artistName, nPage)
%% Last updated: 2016.01.27. 4:34 PM
%% Get artistNumber
artistName = urlencode(artistName);

% Complete URL automatically
artUrl =['http://www.genie.co.kr/search/searchArtist?query=' artistName '&Coll='];

optionsGet = weboptions('Timeout',5);

% Get HTML Source
artHtml = webread(artUrl,optionsGet);

% Find artistNum according to the observed pattern
artNum = regexp(artHtml,'(?<=<span class="artist"><a href="#" onclick="fnViewArtist\('')\d+','match');
if ~isempty(artNum)
    artistNumber = artNum{1};
    
    % Get songList page
    listUrl = 'http://www.genie.co.kr/detail/bArtistSongList';
    options = weboptions('RequestMethod','post','Timeout',5);
    listHtml = webread(listUrl, 'xxnm', artistNumber, 'pg', nPage, 'pgsize', '30',...
        'otype', 'pop0', 'stype', '', options);
    
    % Get songNumber (from listHtml)
    songNum = regexp(listHtml,'(?<=<div class="list" songid=")\d+','match');
    songNumber = songNum'; clear songNum;
    nRead = length(songNumber);
    
    % Get max page number (from listHtml)
    maxPage = regexp(listHtml,'(?<=fnGoPage_ArtistSong\('')\d+','match');
    if ~isempty(maxPage)
        maxPage = maxPage{1,end-1};
    else isempty(maxPage)
        maxPage = 1;
    end
    
elseif isempty(artNum)
    songNumber = [];
    nRead = [];
    
end
