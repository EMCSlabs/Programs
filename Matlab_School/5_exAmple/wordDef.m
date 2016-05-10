function [ s ] = wordDef(word)
%% search dictionary.com for word definition

% make query url
u1 = 'http://dictionary.reference.com/browse/';
u2 = '?s=t';
url = [u1 word u2];

% get web page
a = webread(url);

%% process the results

% match, highlight the query word
s = regexp(a,'<div class="def-content">.*?<div', 'match')';

% clean up (tags, change ASCII to character)
s = regexprep(s, '<.*?>', '');
s = regexprep(s, '<div', '');

end

