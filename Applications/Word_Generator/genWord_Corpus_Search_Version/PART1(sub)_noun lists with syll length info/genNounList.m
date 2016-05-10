%% load word list
[~, ~, raw] = xlsread('/Users/HYJ/Documents/fMRI/Data/Wordgen_byFreq/wordgen_byFreq/sj_noun_syllnum.xlsx','Sheet1');
raw = raw(2:end,:);
raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};
cellVectors = raw(:,[2,3]);
raw = raw(:,[1,4]);

%% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
raw(R) = {NaN}; % Replace non-numeric cells

%% Create output variable
data = reshape([raw{:}],size(raw));

%% Create table
nouns = table;

%% Allocate imported array to column variable names
nouns.freq = data(:,1);
nouns.noun = cellVectors(:,1);
nouns.pos = cellVectors(:,2);
nouns.syllnum = data(:,2);

%% Clear temporary variables
clearvars data raw cellVectors R;

%% 

save('nouns.mat','nouns')

rows = nouns.syllnum == 1;
nouns1 = nouns(rows,:);
save('noun_syll1.mat','nouns1')

rows = nouns.syllnum == 2;
nouns2 = nouns(rows,:);
save('noun_syll2.mat','nouns2')

rows = nouns.syllnum == 3;
nouns3 = nouns(rows,:);
save('noun_syll3.mat','nouns3')