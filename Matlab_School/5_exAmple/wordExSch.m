function [exa,source,time] = wordExSch(word,inst)
%% search  for word instance
% max inst is 20
% make query url
url = ['https://scholar.google.co.kr/scholar?q=' word '&hl=en&scisbd=1&num=20&as_sdt=0,5']; % full url

% get web page
a = webread(url);

% process the results

% split by result delimiter
ex = regexp(a,'<div class="gs_a">','split')';
inst_new = inst +1;
exa = ex(2:inst_new);

% clean up (tags, change ASCII to character) & highlight the query word
exa = regexprep(exa,word,['[[*' word '*]]'], 'preservecase'); % hightlight query word
exa = regexprep(exa,'<a href="/c.*=sra">',''); % delete
exa = regexprep(exa,'.*ago - </span>',''); % delete
exa = regexprep(exa,'</div><div class="gs_fl">.*',''); % delete
exa = regexprep(exa,'<b>',''); % delete
exa = regexprep(exa,'<br>',' '); % delete
exa = regexprep(exa,'\n',' '); % delete
exa = regexprep(exa,'</b>',''); % delete
exa = regexprep(exa,'&#39;',''''); % apostrophe
exa = regexprep(exa,'&quot;',''''); % single quotation
exa = regexprep(exa,'&#8211;','-'); % dash
exa = regexprep(exa,'&#8212;','-'); % emdash
exa = regexprep(exa,'&#8220;','"'); % double quotation (open)
exa = regexprep(exa,'&#8221;','"'); % double quotation (close)
exa = regexprep(exa,'&#8226;',''); % bullet

exa = cellfun(@(v) ['<Html>' v], exa, 'Uniform', 0);
exa = regexprep(exa,word,['<Font color = "red" face = "Comic Sans Ms">' word '</Font>'], 'preservecase'); % hightlight query word


% source
source = ex(2:inst_new);
source = regexp(source,'.*</div><div class="gs_rs">','match');
for i = 1:length(source);
    source{i} = char(source{i});
end
source = regexprep(source,'<.*?>',''); % delete
source = regexprep(source,'&#\d\d\d\d\d;',''); % delete


% time
time = ex(2:inst_new);
time = regexp(time,'>\d+.+ago','match');
for i = 1:length(time);
    time{i} = char(time{i});
end
time = regexprep(time,'>','');

end
