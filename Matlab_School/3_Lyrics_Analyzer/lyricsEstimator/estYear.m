function [estYear] = estYear(data,songdata)
% This funciton estimates the year when lyric is written
% [ input  ] data : full data table
%                  (cf. load allsong.mat BEFORE using this function)
%            songdata : string type lyrics (in quotations)
% [ output ] estYear : estimated year
%%
minyear = 1933;
currentYear = 2016;

y = str2double(data(:,1));

x1 = cell2mat(data(:,5));
x2 = cell2mat(data(:,6));
x3 = cell2mat(data(:,7));

X1 = [ones(size(x1)) x1];
X2 = [ones(size(x2)) x2];
X3 = [ones(size(x3)) x3];

%%

[beta1,~,~,~,stats1] = regress(y,X1);
[beta2,~,~,~,stats2] = regress(y,X2);
[beta3,~,~,~,stats3] = regress(y,X3);

%%

McvForeign = std(x1)/mean(x1);
McvtokenYear = std(x2)/mean(x2);
McvrepWordYear = std(x3)/mean(x3);

%%
ratio = length(regexp(songdata,'[A-Za-z]+','match'))/length(regexp(songdata,'\<\S+\>','match'));
songdatawords = regexp(songdata,'\<\S+\>','match');
NTokens = length(songdatawords);
if NTokens < 8
    dlg = dialog('Position',[300 300 500 200],'Name','Worning');
    txt = uicontrol('Parent',dlg,...
        'Style','text',...
        'Position',[90 70 300 100],...
        'FontSize',20,...
        'String','입력인수가 너무 짧습니다 검색 버튼을 사용하세요');
    btn = uicontrol('Parent',dlg,...
        'Position',[180 30 70 25],...
        'String','Close',...
        'Callback','delete(gcf)');
    return;
end
if NTokens < 30
    NTokens = mean(x2)
end


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

estRatio = beta1(1) + beta1(2)*ratio;
estNTokens = beta2(1) + beta2(2)*NTokens;
estrepNum = beta3(1) + beta3(2)*repNum; 

if estRatio > currentYear
    estRatio = currentYear;
elseif estRatio < minyear
    estRatio = minyear;
end

if estNTokens > currentYear
    estNTokens = currentYear;
elseif estNTokens < minyear
    estNTokens = minyear;
end

if estrepNum > currentYear
    estrepNum = currentYear;
elseif estrepNum < minyear
    estrepNum = minyear;
end

allMcv = 3 - McvForeign - McvtokenYear - McvrepWordYear ;
allP = (1-stats1(3)) + (1-stats2(3)) + (1-stats3(3));
allCoef = stats1(1) + stats2(1) + stats3(1);
estYear_1 = stats1(1)/allCoef*estRatio + stats2(1)/allCoef*estRatio + stats3(1)/allCoef*estrepNum;
estYear_2 = ((1 - McvForeign)/allMcv)*estRatio + ((1 - McvtokenYear)/allMcv)*estRatio + ((1 - McvrepWordYear)/allMcv)*estrepNum;
estYear_3 = (1-stats1(3))/allP*estRatio + (1-stats2(3))/allP*estNTokens + (1-stats3(3))/allP*estrepNum;

estYear = (estYear_1 + estYear_2 + estYear_3)/3;

%%
estYear = round(estYear,0);

if estYear > currentYear
    estYear = currentYear;
    return;
    
elseif estYear < minyear
    estYear = minyear;
    return;
end

end
