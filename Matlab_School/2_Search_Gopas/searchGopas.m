function [totalN, list_title, list_link] = searchGopas(keyword, category)
% INPUT
% keyword: character array
% category: numerical
%                   1 for the category "recommended"
%                   2 for the category "not recommended"
% OUTPUT
% totalN: numerical
%               total number of the results
% titles: cell array
%             a list of the titles containing my keyword

%% change you character encoding to KSC5601
feature('defaultcharacterset', 'EUC-KR')
%% encode my keyword 
encodedKey = KSC5601(keyword);
%% set url for the chosen category
if category == 1
     front = 'http://www.koreapas.com/bbs/zboard.php?id=kfc&select_arrange=headnum&desc=asc&page_num=50&selected=&exec=&sn=off&ss=on&sc=on&su=&category=5&keyword=';
     back = '&x=0&y=0';
elseif category ==2
    front = 'http://www.koreapas.com/bbs/zboard.php?id=kfc&select_arrange=headnum&desc=asc&page_num=50&selected=&exec=&sn=off&ss=on&sc=on&su=&category=6&keyword=';
    back = '&x=0&y=0';
end     
url = [front encodedKey back];
%% read the source page 
options = weboptions('Timeout', 100);
source = webread(url, options);
%% extract the list of titles and their links
list_link= regexp(source, '(?<=<a href=")view\.php\?id=kfc[^"]*', 'match')';
list_title = regexp(source, '(?<="   >)[^\n]*','match')';

if ~isempty(list_link)
    % complete the link
    link_front = 'http://www.koreapas.com/bbs/';
    for i = 1:length(list_link)
        list_link{i} = [link_front list_link{i}];
    end
    % remove html taggers from the list_title
    list_title = regexprep(list_title, '</?.*?>','');
    % count the number of the result
    totalN = length(list_link);
else
    list_title = {'N/A'};
    list_link = {[front back]};
    totalN = 0;
end
