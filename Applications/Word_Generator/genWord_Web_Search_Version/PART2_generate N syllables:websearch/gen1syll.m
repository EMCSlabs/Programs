function [allW1, realW1, nonW1] = gen1syll(ov,vc,r_ov1,r_vc1)
% This function generates Korean monosyllables of the given probability 
% calculated based on Sejong written corpus
%
% created by: YG (2015-12-10)
% modified: 2015-12-14
% modified: 2015-12-18
%
% Input
%     ov: table of onset-vowel sequence/frequency/probability
%     vc: table of vowel-coda sequence/frequency/probability
%     r_ov1: range of onset-vowel frequency(%) e.g.[10 20] from 10% to 20% from the top 
%     r_vc1: range of vowel-coda frequency(%) 
%
% Output
%     allW1: table of monosyllables generated of the given range of probability
%     realW1: table of real words generated of the given range of probability
%     nonW1: table of nonwords generated of the given range of probability

%% Extract the onset-vowel sequences of desired probability (%)

uq = unique(ov.freq_ov, 'stable'); % get unique frequency of ov list
uqlen = length(uq); % unique length
init_idx = ceil(uqlen*r_ov1(1)/100); % init probability index calculated in the unique list
if init_idx == 0
    init_idx = 1; % if r_ov1(1) = 0%, init_idx is 0. So, convert it into 1 so that the 1st element of the column is referred
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

%% Extract the vowel-coda sequences of desired probability (%)
uq = unique(vc.freq_vc, 'stable'); % get unique frequency of ov list
uqlen = length(uq); % unique length
init_idx = ceil(uqlen*r_vc1(1)/100); % init probability index calculated in the unique list
if init_idx == 0
    init_idx = 1; % if r_ov1(1) = 0%, init_idx is 0. So, convert it into 1 so that the 1st element of the column is referred
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

%% ovc (syll1)

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
        rep= cellstr(repmat(ov1.uq_ov{i},length(idx),1)); 
        % get probability multiplied
        prob= arrayfun(@(x) ov1.prob_ov(i) * x,vc1.prob_vc(idx)); 
        % concatenate cell arrays of string as (n x 2) cell array
        str_total =[str_total; horzcat(rep, c_vc{idx,1})]; 
        % concatenate probability
        prob_total = [prob_total; prob]; 
    end       
end
% from (n x 2) to (n x 1) array
str_total = strcat(str_total(:,1), str_total(:,2)); 

%% Convert alphabetized strings into Korean graphemes

% alphabetized strings into Korean graphemes
[~,str_graph] = cellfun(@phone2graph, str_total, 'UniformOutput',false); 

list = table(str_graph,prob_total,str_total); % create a table

%% Use function 'searchKordic' to get Nonword & Realword lists

if ~isempty(list)
% Generate realW1 & nonW1 by using 'searchKordic' function
[realW1, nonW1] = searchKordic(list);

% Tag word type information ('real')
if ~isempty(realW1);
    realW1(:,'type') = {'real'};% if realW1 is empty, realW1.type becomes a struct!
    
    % Get real frequency info and add it in the table (for nonwords, 'N/A')
    load('noun_syll1.mat')    
    real_freq = cell(height(realW1),1);
    for i = 1:height(realW1)
        check = cell2mat(strfind(nouns1.noun,realW1.str_graph{i}));
        idx = strcmp(realW1.str_graph{i},nouns1.noun);
        if ~isempty(check)
            real_freq{i} = nouns1{idx,'freq'};
        else
            real_freq{i} = {0};
        end
    end
    realW1(:,'real_freq') = real_freq;
end

% Tag word type information ('non')
if ~isempty(nonW1);
    nonW1(:,'type') = {'non'};
    nonW1(:,'real_freq') = {'N/A'}; % nonwords do not have real frequency!
end

% concatenate the two tables
allW1 = [realW1; nonW1];
else
    allW1 = table(); realW1 = table(); nonW1= table();
end
