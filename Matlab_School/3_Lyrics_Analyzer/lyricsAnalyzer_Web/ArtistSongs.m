function [ fullData ] = ArtistSongs(artistName, nSongs)
% This function retrieves Year-Title-Artist-Lyrics information
% of a requested number of songs of a specific artist.
% [ input  ]  artistName :  name of a specific artist (char; in quotations)
%             nSongs     :  number of songs to be collected (double)
% [ output ]  fullData   :  n by 4 cell array of year-title-artist-lyrics

% Written by: Yejin Cho
% Date: 2016.01.25
%% Last updated: 2016.01.28. 2:57 AM
%% Pre-allocation
% tic
songCnt = 0;
fullData = [];

for nPage = 1:inf

    % Finish for loop
    % if songCnt exceeds nSongs(= requested number of songs)
    if songCnt >= nSongs
    break
    end
    
    % Get songlist by 30 (= songs in 1 page)
    [songNumber, nRead, maxPage] = getSongList(artistName, nPage);
    if ~isempty(songNumber) && ~isempty(nRead)
        disp(nPage)
        
        % If no more songs read in 'nPage'
        if nRead == 0
            break
        end
        
        for i = 1:nRead
            % Get detail song info (title-artist-lyrics)
            singleData = getSongInfo(songNumber{i,1});
            
            % Add the song to fullData, if no fail found
            [Fail, fullData] = addSong(singleData, fullData);
            
            % Count number of successfully added songs
            if Fail == 0
                songCnt = songCnt + 1;
            end
            
            % Finish for loop
            % if songCnt exceeds nSongs(= requested number of songs)
            if songCnt >= nSongs
                break
            end
            
        end
        
        
    elseif isempty(songNumber) && isempty(nRead)
        fullData = [];
        break
    end
    
    % For loop should stop when reached the last page (maxPage)
    if nPage >= maxPage
        break
    end
    
end

% Pre-process result data
fullData = lyricsPrep(fullData);

% Save fullData as 'artistName.mat'
% eval(sprintf('save(''%s.mat'',''fullData'')',artistName))
% toc
end