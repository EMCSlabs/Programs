function [estArtistList] = estArtist(data,songdata)
%% 
ratio = length(regexp(songdata,'[A-Za-z]+','match'))/length(regexp(songdata,'\<\S+\>','match'));
songdatawords = regexp(songdata,'\<\S+\>','match');
NTokens = length(songdatawords);
uqWords = unique(songdatawords);
uqWords(2,:) = num2cell(zeros(1,length(uqWords)));
for k = 1:size(uqWords,2)
    for q = 1:size(songdatawords,2)
        if strcmp(uqWords{1,k},songdatawords{1,q})
            uqWords{2,k} = uqWords{2,k} + 1;
        end
    end
end
repNum = 0;

for k = 1:size(uqWords,2)
    if 1 < uqWords{2,k}
        repNum = repNum + 1;
    end
end

%% 


y2x = mean(cell2mat(data(:,6)))/mean(cell2mat(data(:,5)));
y2z = mean(cell2mat(data(:,6)))/mean(cell2mat(data(:,7)));
for p = 1:size(data,1)
    y = sqrt((NTokens - data{p,6})^2);
    x = sqrt((ratio - data{p,5})^2)*y2x; %1347;
    z = sqrt((repNum - data{p,7})^2)*y2z; %6;
    data{p,8} = sqrt(x^2+y^2+z^2);
end

%%
FreqTable = sortrows(data,8);
estArtistList = FreqTable(1:15,3);
f = size(estArtistList,1);
for m = 1:f
    for n = size(estArtistList,1):-1:m+1
    if strcmp(estArtistList{m,1},estArtistList{n,1})
        estArtistList(n,:) = [];
        f = f-1;
    end
    end
end
estArtistList = estArtistList(1:3,1);
end