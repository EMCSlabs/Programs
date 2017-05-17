function [exa,source,time] = wordEx(word,inst)
%% search google news for word instance

% make query url
u1 = 'https://www.google.com/search?hl=en&gl=us&tbm=nws&authuser=0&q=';
u2 = '&gs_l=news-cc.3..43j0l9j43i53.3701.4354.0.4442.7.6.0.1.1.1.141.465.3j3.6.0...0.0...1ac.1.9EWAKZO8k_A';
url = [u1 word '&oq=' word '&num=' num2str(inst) u2]; % full url

% get web page
a = webread(url);

%% process the results

% split by result delimiter
ex = regexp(a,'<div class="slp">','split')';
exa = ex(2:end);

% clean up (tags, change ASCII to character) & highlight the query word
exa = regexprep(exa,'.*<div class="st">','');
exa = regexprep(exa,'<.*?>',''); % delete tags
exa = regexprep(exa,'&nbsp;',' '); % non-breaking space
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
source = ex(2:end);
source = regexp(source,'<span class="_tQb _IId">','split');

for i = 1:length(source);
    source{i} = char(source{i});
end
source = regexp(source,'<span class="f">.*(ago|\d\s\w\w\w\s\d\d\d\d)','match');
for i = 1:length(source);
    source{i} = char(source{i});
end
source = regexprep(source,'<span class="f">','');
time = source;
source = regexprep(source,'\s-\s.*','');


% time

time = regexprep(time,'.*\s-\s','');



end
