function [allW2, realW2, nonW2] = gen2syll(ov, vc, co,r_ov1,r_vc1,r_co1,r_ov2,r_vc2)
% This function generates Korean disyllabic words of the given probability 
% calculated based on Sejong written corpus
%
% created by: YG (2015-12-10)
% modified: 2015-12-14
% modified: 2015-12-18
%
%
% Input
%     ov: table of onset-vowel sequence/frequency/probability
%     vc: table of vowel-coda sequence/frequency/probability
%     co: table of coda-onset(of the following syllable) sequence/frequency/probability
%     r_ov1: range of onset-vowel frequency(%) in the 1st syll e.g.[10 20] from 10% to 20% from the top 
%     r_vc1: range of vowel-coda frequency(%) in the 1st syll 
%     r_co1: range of coda-onset frequency(%) in the 1st syll
%     r_ov2: range of onset-vowel frequency(%) in the 2nd syll
%     r_vc2: range of vowel-coda frequency(%) in the 2nd syll
%
% Output
%     allW2: table of all disyllabic words generated of the given range of probability
%     realW2: table of real disyllabic words generated of the given range of probability
%     nonW2: table of disyllabic nonwords generated of the given range of probability

%% Create biphoone lists of the 1st syll of desired probability (%)
% onset-vowel list
uq = unique(ov.freq_ov, 'stable'); % get unique frequency of ov list
uqlen = length(uq); % unique length
init_idx = ceil(uqlen*r_ov1(1)/100); % probability index calculated in the unique list
if init_idx == 0
    init_idx = 1; % if ov_init = 0%, init_idx is 0. So, convert it into 1 so that the 1st element of the column is referred
end
end_idx = ceil(uqlen*r_ov1(2)/100); 
if end_idx == 0
    end_idx = 1;
end

init_per = uq(init_idx); % frequency info of the given index
end_per = uq(end_idx);

if ~isequal(init_per, end_per)
    rows = ov.freq_ov >= end_per & ov.freq_ov <= init_per;
    ov1 = ov(rows,:);
else 
    rows = ov.freq_ov == init_per;
    ov1 = ov(rows,:);
end

% vowel-coda list
uq = unique(vc.freq_vc, 'stable'); % get unique frequency of vc list
uqlen = length(uq); % unique length
init_idx = ceil(uqlen*r_vc1(1)/100); % init probability index calculated in the unique list
if init_idx == 0
    init_idx = 1; 
end
end_idx = ceil(uqlen*r_vc1(2)/100);
if end_idx == 0
    end_idx = 1;
end

init_per = uq(init_idx); % frequency info of the given index
end_per = uq(end_idx);

if ~isequal(init_per, end_per)
    rows = vc.freq_vc >= end_per & vc.freq_vc <= init_per;
    vc1 = vc(rows,:);
else 
    rows = vc.freq_vc == init_per;
    vc1 = vc(rows,:);
end

% coda-onset list
uq = unique(co.freq_co, 'stable'); % get unique frequency of co list
uqlen = length(uq); % unique length
init_idx = ceil(uqlen*r_co1(1)/100); % init probability index calculated in the unique list
if init_idx == 0
    init_idx = 1; 
end
end_idx = ceil(uqlen*r_co1(2)/100);
if end_idx == 0
    end_idx = 1;
end

init_per = uq(init_idx); % frequency info of the given index
end_per = uq(end_idx);

if ~isequal(init_per, end_per)
    rows = co.freq_co >= end_per & co.freq_co <= init_per;
    co1 = co(rows,:);
else 
    rows = co.freq_co == init_per;
    co1 = co(rows,:);
end

%% Create biphone lists of the 2nd syll of desired probability (%)
% onset-vowel list
uq = unique(ov.freq_ov, 'stable'); % get unique frequency of ov list
uqlen = length(uq); % unique length
init_idx = ceil(uqlen*r_ov2(1)/100); % probability index calculated in the unique list
if init_idx == 0
    init_idx = 1; 
end
end_idx = ceil(uqlen*r_ov2(2)/100);
if end_idx == 0
    end_idx = 1;
end

init_per = uq(init_idx); % frequency info of the given index
end_per = uq(end_idx);

if ~isequal(init_per, end_per)
    rows = ov.freq_ov >= end_per & ov.freq_ov <= init_per;
    ov2 = ov(rows,:);
else 
    rows = ov.freq_ov == init_per;
    ov2 = ov(rows,:);
end

% vowel-coda list
uq = unique(vc.freq_vc, 'stable'); % get unique frequency of vc list
uqlen = length(uq); % unique length
init_idx = ceil(uqlen*r_vc2(1)/100); %  probability index calculated in the unique list
if init_idx == 0
    init_idx = 1; 
end
end_idx = ceil(uqlen*r_vc2(2)/100);
if end_idx == 0
    end_idx = 1;
end

init_per = uq(init_idx); % frequency info of the given index
end_per = uq(end_idx);

if ~isequal(init_per, end_per)
    rows = vc.freq_vc >= end_per & vc.freq_vc <= init_per;
    vc2 = vc(rows,:);
else 
    rows = vc.freq_vc == init_per;
    vc2 = vc(rows,:);
end
%% ovc(syll1)

% divide vc into v_vc(vowel) & c_vc(coda)
v_vc = cellfun(@(x) x(1:2), vc1{:,1},'UniformOutput', false);
% converting cell into table is to use index info easily later 
c_vc = cell2table(cellfun(@(x) x(end-1:end), vc1{:,1},'UniformOutput', false)); 

% more efficient way for preallocating should be considered
str_total = []; 
prob_total = [];
for i = 1:height(ov1)
    % get index of matching list
    idx = regexpcell(v_vc, ov1.uq_ov{i}(end-1:end));   
    % if there is any matching pair
    if ~isempty(idx) 
        % preallocate a cell array replicating as many as the number of indices
        rep = cellstr(repmat(ov1.uq_ov{i},length(idx),1)); 
        % get probability multiplied
        prob = arrayfun(@(x) ov1.prob_ov(i) * x,vc1.prob_vc(idx));
        % concatenate cell arrays of string as (n x 2) cell array
        str_total =[str_total; horzcat(rep, c_vc{idx,1})]; 
        % concatenate probability
        prob_total = [prob_total; prob]; 
    end       
end
% from (n x 2) to (n x 1) array
str_total = strcat(str_total(:,1), str_total(:,2)); 

% create a table with the two variables
list = table(str_total, prob_total);


%% ovco(syll2)

% divide co into c_co(coda) & o_co(onset)
c_co = cellfun(@(x) x(1:2), co1{:,1},'UniformOutput', false);
% converting cell into table is to use index info easily later 
o_co = cell2table(cellfun(@(x) x(end-1:end), co1{:,1},'UniformOutput', false)); 

% more efficient way for preallocating should be considered
str_total = []; 
prob_total = [];
for i = 1:height(list)
    % get index of matching list
    idx = regexpcell(c_co, list.str_total{i}(end-1:end));   
    % if there is any matching list 
    if ~isempty(idx) 
        % preallocate a cell array replicating as many as the number of indices
        rep = cellstr(repmat(list.str_total{i},length(idx),1)); 
        % get probability multiplied
        prob  = arrayfun(@(x) list.prob_total(i) * x, co1.prob_co(idx));
        % concatenate cell arrays of strings as (n x 2) cell array
        str_total =[str_total; horzcat(rep, o_co{idx,1})]; 
        % concatenate probability
        prob_total = [prob_total; prob]; 
    end       
end
% from (n x 2) to (n x 1) array
str_total = strcat(str_total(:,1), str_total(:,2)); 

% create a table with the two variables
list = table(str_total, prob_total);

%% ovcov(syll2)

% divide ov into o_ov(onset) & v_ov(vowel)
o_ov = cellfun(@(x) x(1:2), ov2{:,1},'UniformOutput', false);
% converting cell into table is to use index info easily later 
v_ov = cell2table(cellfun(@(x) x(end-1:end), ov2{:,1},'UniformOutput', false)); 

% more efficient way for preallocating should be considered
str_total = []; 
prob_total = [];
for i = 1:height(list)
    % get index of matching list
    idx = regexpcell(o_ov, list.str_total{i}(end-1:end));   
    % if there is any matching pair
    if ~isempty(idx) 
        % preallocate a cell array replicating as many as the number of indices
        rep = cellstr(repmat(list.str_total{i},length(idx),1)); 
        % get probability multiplied
        prob = arrayfun(@(x) list.prob_total(i) * x, ov2.prob_ov(idx));
        % concatenate cell arrays of string (n x 2) cell array
        str_total =[str_total; horzcat(rep, v_ov{idx,1})]; 
        % concatenate prob_ovcov
        prob_total = [prob_total; prob]; 
    end       
end
% from (n x 2) to (n x 1) array
str_total = strcat(str_total(:,1), str_total(:,2)); 

% create a table with the two variables
list = table(str_total, prob_total);

%% ovcovc(syll2)

% divide vc into v_vc(vowel) & c_vc(coda)
v_vc = cellfun(@(x) x(1:2), vc2{:,1},'UniformOutput', false);
% converting cell into table is to use index info easily later 
c_vc = cell2table(cellfun(@(x) x(end-1:end), vc2{:,1},'UniformOutput', false)); 

% more efficient way for preallocating should be considered
str_total = []; 
prob_total = [];
for i = 1:height(list)
    % get index of matchingi list
    idx = regexpcell(v_vc, list.str_total{i}(end-1:end));   
    % if there is any matching pair
    if ~isempty(idx) 
        % preallocate a cell array replicating as many as the number of indices
        rep = cellstr(repmat(list.str_total{i},length(idx),1)); 
        % get probability multiplied
        prob = arrayfun(@(x) list.prob_total(i) * x,vc2.prob_vc(idx));
        % concatenate cell arrays of string as (n x 2) cell array
        str_total =[str_total; horzcat(rep, c_vc{idx,1})]; 
        % concatenate probability
        prob_total = [prob_total; prob]; 
    end       
end
% from (n x 2) to (n x 1) array
str_total = strcat(str_total(:,1), str_total(:,2)); 

%% Convert alphabetized strings into Korean graphemes

[~,str_graph] = cellfun(@phone2graph, str_total, 'UniformOutput',false);

list = table(str_graph,prob_total,str_total);

%% Use function 'searchKordic' to get nonword & real word lists

if ~isempty(list)
[realW2, nonW2] = searchKordic(list);

% Tag word type information ('real' or 'non')
if ~isempty(realW2);
    realW2(:,'type') = {'real'};% if realW1 is empty, realW1.type becomes a struct!
    
    % Get real frequency info and add it in the table (for nonwords, 'N/A')
    load('noun_syll2.mat')
    real_freq = cell(height(realW2),1);
    for i = 1:height(realW2)
        check = cell2mat(strfind(nouns2.noun,realW2.str_graph{i}));
        idx = strcmp(realW2.str_graph{i},nouns2.noun);
        if ~isempty(check)
            real_freq{i} = nouns2{idx,'freq'};
        else
            real_freq{i} = {0};
        end
    end
    realW2(:,'real_freq') = real_freq;
end
if ~isempty(nonW2);
nonW2(:,'type') = {'non'};
nonW2(:,'real_freq') = {'N/A'}; % nonwords do not have real frequency!
end

% concatenate the real/non table 
allW2 = [realW2; nonW2];

else
    allW2 = table(); realW2 = table(); nonW2= table();
end


