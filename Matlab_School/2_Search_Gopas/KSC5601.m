function [URLencoded] = KSC5601(Kor)
load ksc5601_noQuote.mat
encodedKor = [];
for i = 1:length(Kor)
    if regexp(Kor(i),'[A-Za-z0-9]')
        encodedKor{i} = Kor(i);
    elseif ~isequal(Kor(i),' ')
        searchSyll = strcmp(ksc5601(:,2), Kor(i));
        encodedKor{i} = ksc5601(find(searchSyll==1),1);
    elseif isequal(Kor(i),' ')
        encodedKor{i} = {'+'};
    end
end

for i = 1:size(encodedKor,2)
    if iscell(encodedKor{i})
        encodedKor{i} = char(encodedKor{i});
    end
end

URLencoded = [];
for i = 1:size(encodedKor,2)
    URLencoded = [URLencoded encodedKor{i}];
end

URLencoded = regexprep(URLencoded,'0x','%');
URLencoded = regexprep(URLencoded,'%\w\w','$0%');
end
