function [allW3,realW3, nonW3] = gen3syll_pos(initov,initvc,initco,medov,medvc,medco,finov,finvc,r_ov1,r_vc1,r_co1,r_ov2,r_vc2,r_co2,r_ov3,r_vc3)
% This function generates Korean trisyllables of the given probability
% calculated based on Sejong written corpus
%
% created by: YG (2015-12-10)
% modified: 2015-12-14
% modified: 2015-12-18
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
%     r_co2: range of coda-onset frequency(%) in the 2nd syll
%     r_ov3: range of onset-vowel frequency(%) in the 3rd syll
%     r_vc3: range of vowel-coda frequency(%) in the 3rd syll
%
% Output
%     allW3: table of all trisyllables generated of the given range of probability
%     realW3: table of real trisyllabic words generated of the given range of probability
%     nonW3: table of trisyllabic nonwords generated of the given range of probability

%% Create biphone lists of the 1st syll of desired probability (%)
% onset-vowel list
uq = unique(initov.freq_ov, 'stable'); % get unique frequency of ov list
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
    rows = initov.freq_ov >= end_per & initov.freq_ov <= init_per;
    ov1 = initov(rows,:);
else 
    rows = initov.freq_ov == init_per;
    ov1 = initov(rows,:);
end

% vowel-coda list
uq = unique(initvc.freq_vc, 'stable'); % get unique frequency of vc list
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
    rows = initvc.freq_vc >= end_per & initvc.freq_vc <= init_per;
    vc1 = initvc(rows,:);
else 
    rows = initvc.freq_vc == init_per;
    vc1 = initvc(rows,:);
end

% coda-onset list
uq = unique(initco.freq_co, 'stable'); % get unique frequency of co list
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
    rows = initco.freq_co >= end_per & initco.freq_co <= init_per;
    co1 = initco(rows,:);
else 
    rows = initco.freq_co == init_per;
    co1 = initco(rows,:);
end
%% Create biphone lists of the 2nd syll of desired probability (%)
% onset-vowel list
uq = unique(medov.freq_ov, 'stable'); % get unique frequency of ov list
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
    rows = medov.freq_ov >= end_per & medov.freq_ov <= init_per;
    ov2 = medov(rows,:);
else 
    rows = medov.freq_ov == init_per;
    ov2 = medov(rows,:);
end

% vowel-coda list
uq = unique(medov.freq_ov, 'stable'); % get unique frequency of vc list
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
    rows = medvc.freq_vc >= end_per & medvc.freq_vc <= init_per;
    vc2 = medvc(rows,:);
else 
    rows = medvc.freq_vc == init_per;
    vc2 = medvc(rows,:);
end

% coda-onset list
uq = unique(medco.freq_co, 'stable'); % get unique frequency of co list
uqlen = length(uq); % unique length
init_idx = ceil(uqlen*r_co2(1)/100); % init probability index calculated in the unique list
if init_idx == 0
    init_idx = 1; 
end
end_idx = ceil(uqlen*r_co2(2)/100);
if end_idx == 0
    end_idx = 1;
end

init_per = uq(init_idx); % frequency info of the given index
end_per = uq(end_idx);

if ~isequal(init_per, end_per)
    rows = medco.freq_co >= end_per & medco.freq_co <= init_per;
    co2 = medco(rows,:);
else 
    rows = medco.freq_co == init_per;
    co2 = medco(rows,:);
end

%% Create biphone lists of the 3rd syll of desired probability (%)
% onset-vowel list
uq = unique(finov.freq_ov, 'stable'); % get unique frequency of ov list
uqlen = length(uq); % unique length
init_idx = ceil(uqlen*r_ov3(1)/100); % probability index calculated in the unique list
if init_idx == 0
    init_idx = 1; 
end
end_idx = ceil(uqlen*r_ov3(2)/100);
if end_idx == 0
    end_idx = 1;
end

init_per = uq(init_idx); % frequency info of the given index
end_per = uq(end_idx);

if ~isequal(init_per, end_per)
    rows = finov.freq_ov >= end_per & finov.freq_ov <= init_per;
    ov3 = finov(rows,:);
else 
    rows = finov.freq_ov == init_per;
    ov3 = finov(rows,:);
end

% vowel-coda list
uq = unique(finvc.freq_vc, 'stable'); % get unique frequency of vc list
uqlen = length(uq); % unique length
init_idx = ceil(uqlen*r_vc3(1)/100); %  probability index calculated in the unique list
if init_idx == 0
    init_idx = 1; 
end
end_idx = ceil(uqlen*r_vc3(2)/100);
if end_idx == 0
    end_idx = 1;
end

init_per = uq(init_idx); % frequency info of the given index
end_per = uq(end_idx);

if ~isequal(init_per, end_per)
    rows = finvc.freq_vc >= end_per & finvc.freq_vc <= init_per;
    vc3 = finvc(rows,:);
else 
    rows = finvc.freq_vc == init_per;
    vc3 = finvc(rows,:);
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
        % concatenate probability
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
% create a table with the two variables
list = table(str_total, prob_total);

%% ovcovco(syll3)

% divide co into c_co(coda) & o_co(onset)
c_co = cellfun(@(x) x(1:2), co2{:,1},'UniformOutput', false);
% converting cell into table is to use index info easily later 
o_co = cell2table(cellfun(@(x) x(end-1:end), co2{:,1},'UniformOutput', false)); 

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
        prob  = arrayfun(@(x) list.prob_total(i) * x, co2.prob_co(idx));
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

%% ovcovcov(syll3)

% divide ov into o_ov(onset) & v_ov(vowel)
o_ov = cellfun(@(x) x(1:2), ov3{:,1},'UniformOutput', false);
% converting cell into table is to use index info easily later 
v_ov = cell2table(cellfun(@(x) x(end-1:end), ov3{:,1},'UniformOutput', false)); 

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
        prob = arrayfun(@(x) list.prob_total(i) * x, ov3.prob_ov(idx));
        % concatenate cell arrays of string (n x 2) cell array
        str_total =[str_total; horzcat(rep, v_ov{idx,1})]; 
        % concatenate probability
        prob_total = [prob_total; prob]; 
    end       
end
% from (n x 2) to (n x 1) array
str_total = strcat(str_total(:,1), str_total(:,2)); 

% create a table with the two variables
list = table(str_total, prob_total);

%% ovcovcovc(syll3)

% divide vc into v_vc(vowel) & c_vc(coda)
v_vc = cellfun(@(x) x(1:2), vc3{:,1},'UniformOutput', false);
% converting cell into table is to use index info easily later 
c_vc = cell2table(cellfun(@(x) x(end-1:end), vc3{:,1},'UniformOutput', false)); 

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
        prob = arrayfun(@(x) list.prob_total(i) * x,vc3.prob_vc(idx));
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
  [realW3, nonW3] = searchKordic(list);
    
% Tag word type information ('real' or 'non')
if ~isempty(realW3);
    realW3(:,'type') = {'real'}; % if realW1 is empty, realW1.type becomes a struct!
    
    % Get real frequency info and add it in the table (for nonwords, 'N/A')
    load('noun_syll3.mat')
    real_freq = cell(height(realW3),1);
    for i = 1:height(realW3)
        check = cell2mat(strfind(nouns3.noun,realW3.str_graph{i}));
        idx = strcmp(realW3.str_graph{i},nouns3.noun);
        if ~isempty(check)
            real_freq{i} = nouns3{idx,'freq'};
        else
            real_freq{i} = {0};
        end
    end
    realW3(:,'real_freq') = real_freq;
end
if ~isempty(nonW3);
nonW3(:,'type') = {'non'};
nonW3(:,'real_freq') = {'N/A'}; % nonwords do not have real frequency!
end
    
    % concatenate the real/non table
    allW3 = [realW3; nonW3];
    
else
    allW3 = table(); realW3 = table(); nonW3 = table();
end

