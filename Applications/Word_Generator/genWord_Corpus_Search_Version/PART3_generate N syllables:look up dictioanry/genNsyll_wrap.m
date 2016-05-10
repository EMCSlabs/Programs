% This script is a wrapper for all kinds of genNsyll functions
%
% 2015-12-12

%%
clear all;clc;
load('sejong_lit.mat')

%% Number of syllable = 1
%
%
%% 1syll_get range
r_ov1 = [98 100];
r_vc1 = [98 100];

%% 1syll_ position non-specific
% import sections needed, as table

ov = sortrows(sejong_lit.Noun.Bigram.Position_Nonspecific.onset_vowel,'prob_ov', 'descend');
vc = sortrows(sejong_lit.Noun.Bigram.Position_Nonspecific.vowel_coda, 'prob_vc', 'descend');
tic
% run function gen1syll
list = genNsyll(ov,vc,r_ov1,r_vc1);
toc

% Use function 'searchKordic' to get nonword & real word lists
if ~isempty(list)
  [realW, nonW] = searchKordic(list);
    % Tag word type information ('real' or 'non')
    if ~isempty(realW);
        realW(:,'type') = {'real'}; % if realW1 is empty, realW1.type becomes a struct!
        % Get real frequency info and add it in the table (for nonwords, 'N/A')
        load('noun_syll1.mat')
        real_freq = cell(height(realW),1);
        for i = 1:height(realW)
            check = cell2mat(strfind(nouns1.noun,realW.str_graph{i}));
            idx = strcmp(realW.str_graph{i},nouns1.noun);
            if ~isempty(check)
                real_freq{i} = nouns1{idx,'freq'};
            else
                real_freq{i} = {0};
            end
        end
        realW(:,'real_freq') = real_freq;
    end    
    if ~isempty(nonW);
        nonW(:,'type') = {'non'};
        nonW(:,'real_freq') = {'N/A'}; % nonwords do not have real frequency!
    end
    % concatenate the real/non table
    allW1 = [realW; nonW];
else
    allW1 = table(); realW = table(); nonW = table();
end
%% Number of syllable = 2
%
%
%% 2syll_ get range
r_ov1 = [0 10];
r_vc1 = [0 10];
r_co1 = [0 10];

r_ov2 = [0 10];
r_vc2 = [0 10];

%% 2syll _ position specific
% import sections needed, as table
initov = sortrows(sejong_lit.Noun.Bigram.Position_Specific.initial.onset_vowel,'freq_ov','descend');
initvc = sortrows(sejong_lit.Noun.Bigram.Position_Specific.initial.vowel_coda,'freq_vc','descend');
initco = sortrows(sejong_lit.Noun.Bigram.Position_Specific.initial.coda_onset,'freq_co','descend');
finov = sortrows(sejong_lit.Noun.Bigram.Position_Specific.final.onset_vowel,'freq_ov','descend');
finvc = sortrows(sejong_lit.Noun.Bigram.Position_Specific.final.vowel_coda,'freq_vc','descend');
tic
% run function gen2syll_pos
list = genNsyll(initov, initvc, initco, finov, finvc,r_ov1,r_vc1,r_co1,r_ov2,r_vc2);
toc
% Use function 'searchKordic' to get nonword & real word lists
if ~isempty(list)
  [realW, nonW] = searchKordic(list);
    % Tag word type information ('real' or 'non')
    if ~isempty(realW);
        realW(:,'type') = {'real'}; % if realW1 is empty, realW1.type becomes a struct!
        % Get real frequency info and add it in the table (for nonwords, 'N/A')
        load('noun_syll2.mat')
        real_freq = cell(height(realW),1);
        for i = 1:height(realW)
            check = cell2mat(strfind(nouns2.noun,realW.str_graph{i}));
            idx = strcmp(realW.str_graph{i},nouns2.noun);
            if ~isempty(check)
                real_freq{i} = nouns2{idx,'freq'};
            else
                real_freq{i} = {0};
            end
        end
        realW(:,'real_freq') = real_freq;
    end    
    if ~isempty(nonW);
        nonW(:,'type') = {'non'};
        nonW(:,'real_freq') = {'N/A'}; % nonwords do not have real frequency!
    end
    % concatenate the real/non table
    allW2 = [realW; nonW];
else
    allW2 = table(); realW = table(); nonW = table();
end
%% 2syll_position non-specific
% import sections needed, as table
ov = sortrows(sejong_lit.Noun.Bigram.Position_Nonspecific.onset_vowel,'freq_ov','descend');
vc = sortrows(sejong_lit.Noun.Bigram.Position_Nonspecific.vowel_coda,'freq_vc','descend');
co = sortrows(sejong_lit.Noun.Bigram.Position_Nonspecific.coda_onset,'freq_co','descend');
tic
% run function gen2syll
list = genNsyll(ov, vc, co,r_ov1,r_vc1,r_co1,r_ov2,r_vc2);
toc
% Use function 'searchKordic' to get nonword & real word lists

if ~isempty(list)
  [realW, nonW] = searchKordic(list);
    % Tag word type information ('real' or 'non')
    if ~isempty(realW);
        realW(:,'type') = {'real'}; % if realW1 is empty, realW1.type becomes a struct!
        % Get real frequency info and add it in the table (for nonwords, 'N/A')
        load('noun_syll2.mat')
        real_freq = cell(height(realW),1);
        for i = 1:height(realW)
            check = cell2mat(strfind(nouns2.noun,realW.str_graph{i}));
            idx = strcmp(realW.str_graph{i},nouns2.noun);
            if ~isempty(check)
                real_freq{i} = nouns2{idx,'freq'};
            else
                real_freq{i} = {0};
            end
        end
        realW(:,'real_freq') = real_freq;
    end    
    if ~isempty(nonW);
        nonW(:,'type') = {'non'};
        nonW(:,'real_freq') = {'N/A'}; % nonwords do not have real frequency!
    end
    % concatenate the real/non table
    allW2 = [realW; nonW];
else
    allW2 = table(); realW = table(); nonW = table();
end
%% Number of syllable = 3
%
%
%% 3syll_get range
r_ov1 = [0 4]; r_vc1 = [0 4]; r_co1 = [0 4];
r_ov2 = [0 4]; r_vc2 = [0 4]; r_co2 = [0 4];
r_ov3 = [0 4]; r_vc3 = [0 4];

%% 3syll_ position specific
% import sections needed, as table
initov = sortrows(sejong_lit.Noun.Bigram.Position_Specific.initial.onset_vowel,'prob_ov','descend');
initvc = sortrows(sejong_lit.Noun.Bigram.Position_Specific.initial.vowel_coda,'prob_vc','descend');
initco = sortrows(sejong_lit.Noun.Bigram.Position_Specific.initial.coda_onset,'prob_co','descend');

medov = sortrows(sejong_lit.Noun.Bigram.Position_Specific.medial.onset_vowel,'prob_ov','descend');
medvc = sortrows(sejong_lit.Noun.Bigram.Position_Specific.medial.vowel_coda,'prob_vc','descend');
medco = sortrows(sejong_lit.Noun.Bigram.Position_Specific.medial.coda_onset,'prob_co','descend');

finov = sortrows(sejong_lit.Noun.Bigram.Position_Specific.final.onset_vowel,'prob_ov','descend');
finvc = sortrows(sejong_lit.Noun.Bigram.Position_Specific.final.vowel_coda,'prob_vc','descend');
tic
% run function genNsyll
list = genNsyll(initov,initvc,initco,medov,medvc,medco,finov,finvc,r_ov1,r_vc1,r_co1,r_ov2,r_vc2,r_co2,r_ov3,r_vc3);
toc

% Use function 'searchKordic' to get nonword & real word lists

if ~isempty(list)
  [realW, nonW] = searchKordic(list);
    % Tag word type information ('real' or 'non')
    if ~isempty(realW);
        realW(:,'type') = {'real'}; % if realW1 is empty, realW1.type becomes a struct!
        % Get real frequency info and add it in the table (for nonwords, 'N/A')
        load('noun_syll3.mat')
        real_freq = cell(height(realW),1);
        for i = 1:height(realW)
            check = cell2mat(strfind(nouns3.noun,realW.str_graph{i}));
            idx = strcmp(realW.str_graph{i},nouns3.noun);
            if ~isempty(check)
                real_freq{i} = nouns3{idx,'freq'};
            else
                real_freq{i} = {0};
            end
        end
        realW(:,'real_freq') = real_freq;
    end    
    if ~isempty(nonW);
        nonW(:,'type') = {'non'};
        nonW(:,'real_freq') = {'N/A'}; % nonwords do not have real frequency!
    end
    % concatenate the real/non table
    allW3 = [realW; nonW];
else
    allW3 = table(); realW = table(); nonW = table();
end
%% 3syll_ position non-specific
% import sections needed, as table
ov = sortrows(sejong_lit.Noun.Bigram.Position_Nonspecific.onset_vowel,'prob_ov','descend');
vc = sortrows(sejong_lit.Noun.Bigram.Position_Nonspecific.vowel_coda,'prob_vc','descend');
co = sortrows(sejong_lit.Noun.Bigram.Position_Nonspecific.coda_onset,'prob_co','descend');
tic
% run function genNsyll
list= genNsyll(ov,vc,co,r_ov1,r_vc1,r_co1,r_ov2,r_vc2,r_co2,r_ov3,r_vc3);
toc

% Use function 'searchKordic' to get nonword & real word lists
if ~isempty(list)
  [realW, nonW] = searchKordic(list);
    % Tag word type information ('real' or 'non')
    if ~isempty(realW);
        realW(:,'type') = {'real'}; % if realW1 is empty, realW1.type becomes a struct!
        % Get real frequency info and add it in the table (for nonwords, 'N/A')
        load('noun_syll3.mat')
        real_freq = cell(height(realW),1);
        for i = 1:height(realW)
            check = cell2mat(strfind(nouns3.noun,realW.str_graph{i}));
            idx = strcmp(realW.str_graph{i},nouns3.noun);
            if ~isempty(check)
                real_freq{i} = nouns3{idx,'freq'};
            else
                real_freq{i} = {0};
            end
        end
        realW(:,'real_freq') = real_freq;
    end    
    if ~isempty(nonW);
        nonW(:,'type') = {'non'};
        nonW(:,'real_freq') = {'N/A'}; % nonwords do not have real frequency!
    end
    % concatenate the real/non table
    allW3 = [realW; nonW];
else
    allW3 = table(); realW = table(); nonW = table();
end