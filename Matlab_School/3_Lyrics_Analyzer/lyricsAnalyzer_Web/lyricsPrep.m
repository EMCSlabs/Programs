function [newData] = lyricsPrep(data)
% [ input  ] data    :  n by 4 cell (output of ArtistSongs function)
% [ output ] newData :  Year-Title-Artist-Lyrics (n by 4 cell, refined)
%% Last updated: 2016.01.28. 3:48 PM
%% (1) Convert all cells into char in Lyrics column
for i = size(data,1):-1:1
    if iscell(data{i,4})
        data{i,4} = char(data{i,4});
    end
end
%% (2) Refine data strings
for i = 1:size(data,1);
    if isempty(regexp(data{i,2},'\(.+\)','once'))
        data{i,2} = regexprep(data{i,2},'\)','');
        data{i,2} = regexprep(data{i,2},'\(','');
    end
    
    % All types of non-alphanumerics into ''
    data{i,4} = regexprep(data{i,4},'(?=[\W])[\S]','');
    
    % Remove specific expressions
    data{i,4} = regexprep(data{i,4},'intro',' ','ignorecase');
    data{i,4} = regexprep(data{i,4},'outro',' ','ignorecase');
    data{i,4} = regexprep(data{i,4},'repeat',' ','ignorecase');
    data{i,4} = regexprep(data{i,4},'chorus',' ','ignorecase');
    data{i,4} = regexprep(data{i,4},'verse',' ','ignorecase');
    data{i,4} = regexprep(data{i,4},'narration',' ','ignorecase');
    data{i,4} = regexprep(data{i,4},'rap',' ','ignorecase');
    data{i,4} = regexprep(data{i,4},'skit',' ','ignorecase');
    data{i,4} = regexprep(data{i,4},'song',' ','ignorecase');
    data{i,4} = regexprep(data{i,4},'hook',' ','ignorecase');
    data{i,4} = regexprep(data{i,4},'(작사|작곡|편곡)',' ');
    data{i,4} = regexprep(data{i,4},'반복',' ');
    data{i,4} = regexprep(data{i,4},'간주( 중|중)','');
    data{i,4} = regexprep(data{i,4},'x\s*\d',' ');
    data{i,4} = regexprep(data{i,4},'nbsp',' ','ignorecase');
    data{i,4} = regexprep(data{i,4},'sabi',' ','ignorecase');
    data{i,4} = regexprep(data{i,4},'featuring',' ','ignorecase');
    
    % All types of non-alphanumerics into ''
    data{i,4} = regexprep(data{i,4},'(?=[\W])[\S]','');
    
    % All types of white-spaces([\f\n\r\t\v]) into ' '
    data{i,4} = regexprep(data{i,4},'[\f\n\r\t\v]',' ');
    
    % All number + dot (‘1.’, ‘2.’,..)
    data{i,4} = regexprep(data{i,4},'[\d][\.]','');
    
    % All Numbers at the beginning
    data{i,4} = regexprep(data{i,4},'^[\d]','');
    
    % All single Capital alphabets at the beginning
    data{i,4} = regexprep(data{i,4},'^[A-HJ-Z] ','');
    
    % All whitespace left at the beginning
    data{i,4} = regexprep(data{i,4},'^ *','');
    
    % More than 1 whitespace in the middle
    data{i,4} = regexprep(data{i,4},' *',' ');
    
    %% Re-process (to make sure)
    % All Numbers at the beginning
    data{i,4} = regexprep(data{i,4},'^[\d]','');
    
    % All whitespace left at the beginning
    data{i,4} = regexprep(data{i,4},'^ *','');
    
    % More than 1 whitespace in the middle
    data{i,4} = regexprep(data{i,4},' *',' ');
    
% % 가수 멤버 이름 제거 (가능할 지 모르겠지만) 
end
newData =  data;
end
