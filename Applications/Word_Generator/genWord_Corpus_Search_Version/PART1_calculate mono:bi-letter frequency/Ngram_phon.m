function [tmp]=Ngram_phon(txtfile)
%%
% This function calculates monogram and bigram frequency (phone unit) of a given
% textfile, which is a list of Korean words. 
% The results are organized in a structure format as an output.
%
% Input
%   txtfile: string variable (the name of the text file)

% Output
%   tmp: the organized structure consisting of mono/bigram frequency

% e.g. [Sejong_Noun]=Ngram_phon('sejong_noun.txt')
%
%
% Written by EMCS Youth Group (2015-Oct-22)
% 
% See also: GRAPH2PHONE, BIfREQ, MONOfREQ


%% load word list
tic
fid = fopen(txtfile,'rt','n','UTF-8'); % 'UTF-8' encoding for Hangul;
text = textscan(fid,'%s %d','delimiter',',');
fclose(fid);
txt(:,1) = text{1,1}; % the 1st column for nouns
txt(:,2) = num2cell(double(text{1,2})); % the 2nd column for noun length

%% preprocess the word list
%  graph2phone function converts Korean orthography(grapheme) to alphabetized version
%  and seperate onset/vowel/coda in a word 
for i = 1:length(txt)
    [phones,~,~,~,ortho_sep] = graph2phone(txt{i,1}); % e.g.input: korean word for 'horse'
    txt{i,3} = phones; % 'mmaall'
    txt{i,4} = ortho_sep;  % ['mm' 'aa' 'll'] 
end
%% convert to table and filter

txt = cell2table(txt);
% change variable names
txt.Properties.VariableNames{1} = 'words';
txt.Properties.VariableNames{2} = 'length';
txt.Properties.VariableNames{3} = 'ortho_eng';
txt.Properties.VariableNames{4} = 'ortho_sep';

% filter out undefined rows (=>single phones, words including numbers)
txt.ortho_eng = categorical(txt.ortho_eng);
filtxt= txt(~any(isundefined(txt.ortho_eng),2),:);

%% Get monogram list

% Get phone list by its syllable position
mono = []; mono_init = []; mono_med = []; mono_fin = [];

for k = 1:height(filtxt)
    % all the syllables
    mono = [mono; filtxt.ortho_sep{k}];
    % syllables in the initial position only
    mono_init = [mono_init; filtxt.ortho_sep{k}(1,:)];
    % syllables in the medial position (From the 2nd To the 2nd to the last)
    mono_med = [mono_med; filtxt.ortho_sep{k}(2:end-1,:)];
    % syllables in the final position only
    mono_fin = [mono_fin; filtxt.ortho_sep{k}(end,:)];   
end

%% Get monogram frequency

% monogram frequency(position non-specific)
[freq_o_nonspec,freq_v_nonspec,freq_c_nonspec] = monoFreq(mono);

% monogram frequency (position specific)
[freq_o_init,freq_v_init,freq_c_init] = monoFreq(mono_init);
[freq_o_med,freq_v_med,freq_c_med] = monoFreq(mono_med);
[freq_o_fin,freq_v_fin,freq_c_fin] = monoFreq(mono_fin);

fprintf('monogram frequency calculated...\n')

%% NOW MONOGRAM FREQUNCY CALCULATION IS FINISHED & MOVE ON TO BIGRAM FREQUENCY
%
% 
%
%% Get onset-vowel, vowel-coda, coda-onset sequence list

% initialization
ovlist = []; ov_init = []; ov_med = []; ov_fin = [];
vclist = []; vc_init = []; vc_med = []; vc_fin = [];
colist = []; co_init = []; co_med = []; co_fin = [];

% iteration for each phone-separated cell
for k = 1:height(filtxt)
    
    %% create onset-vowel, vowel-coda bigram list
    ov = cellstr(cell2mat(filtxt.ortho_sep{k}(:,1:2)));
    vc = cellstr(cell2mat(filtxt.ortho_sep{k}(:,2:3)));
    
    % vertcat the list (position-nonspecific)
    ovlist = [ovlist; ov];
    vclist = [vclist; vc];
    
    % vertcat the list (position-specific)
    
    % monosyllabic words
    if size(filtxt.ortho_sep{k},1) == 1 
        % initial position only 
        ov_init = [ov_init; ov(1,:)];
        vc_init = [vc_init; vc(1,:)];    
        
    % disyllabic words
    elseif size(filtxt.ortho_sep{k},1) == 2 
        % initial & final position only 
        ov_init = [ov_init; ov(1,:)];
        vc_init = [vc_init; vc(1,:)];
        
        ov_fin = [ov_fin; ov(end,:)];   
        vc_fin = [vc_fin; vc(end,:)];
        
    % trisyllabic words or more  
    else
        % initial & medial & final position
        ov_init = [ov_init; ov(1,:)];
        vc_init = [vc_init; vc(1,:)];
        
        ov_med = [ov_med; ov(2:end-1,:)];
        vc_med = [vc_med; vc(2:end-1,:)];
        
        ov_fin = [ov_fin; ov(end,:)];        
        vc_fin = [vc_fin; vc(end,:)];          
    end
        
    %% data prep for coda-onset bigram list
    % concatenate horizontally coda column and onset column
    co = [filtxt.ortho_sep{k}(:,3) filtxt.ortho_sep{k}(:,1)]; 
    
    % Remove the first row in onset column b/c the onset is preceding, not
    % following, the coda in the same syllable.
    % Then, add '##' at the end row of the same column to mark the word-final position
    co(:,2) = [co(2:end,2); '##'];
    
    % concatenate coda-onset sequence string
    co = cellstr(cell2mat(co));
    
    % vertcat the list (position-nonspecific)
    colist = [colist; co];
    
    % vertcat the list (position-specific)
    % monosyllables
    if size(filtxt.ortho_sep{k},1) == 1
        % initial position only
        co_init = [co_init; co(1,:)];
        
    % disyllabic words  
    elseif size(filtxt.ortho_sep{k},1) ==2
        % initial & final position only
        co_init = [co_init; co(1,:)];        
        co_fin = [co_fin; co(end,:)];
    
    % trisyllables or more    
    else
        % initial & medial & final position
        co_init = [co_init; co(1,:)];
        co_med = [co_med; co(2:end-1,:)];
        co_fin = [co_fin; co(end,:)];
    end
end

%% get bigram frequency
% bigram frequency (position nonspecific)
[freq_ov_nonspec,freq_vc_nonspec,freq_co_nonspec] = biFreq(ovlist,vclist,colist);

% bigram frequency (position specific)
[freq_ov_init,freq_vc_init,freq_co_init] = biFreq(ov_init,vc_init,co_init);
[freq_ov_med,freq_vc_med,freq_co_med] = biFreq(ov_med,vc_med,co_med);
[freq_ov_fin,freq_vc_fin,freq_co_fin] = biFreq(ov_fin,vc_fin,co_fin);

fprintf('bigram frequency calculated...\n')
%% Create a structure

% 2 fields : 1) monogram 2) bigram
% 2 subfields : 1) position_nonspecific 2) position_specific
% (3 subfields under position_specific: 1) initial 2) medial 3) final)
% 3 subfields: 1) onset 2) vowel 3) coda

% monogram
tmp.Monogram.Position_Nonspecific = struct('onset',freq_o_nonspec,...
    'vowel',freq_v_nonspec,...
    'coda',freq_c_nonspec);
tmp.Monogram.Position_Specific.initial = struct('onset',freq_o_init,...
    'vowel',freq_v_init,...
    'coda',freq_c_init);
tmp.Monogram.Position_Specific.medial = struct('onset',freq_o_med,...
    'vowel',freq_v_med,...
    'coda',freq_c_med);
tmp.Monogram.Position_Specific.final = struct('onset',freq_o_fin,...
    'vowel',freq_v_fin,...
    'coda',freq_c_fin);

% bigram
tmp.Bigram.Position_Nonspecific = struct('onset_vowel',freq_ov_nonspec,...
    'vowel_coda',freq_vc_nonspec,...
    'coda_onset',freq_co_nonspec);
tmp.Bigram.Position_Specific.initial = struct('onset_vowel',freq_ov_init,...
    'vowel_coda',freq_vc_init,...
    'coda_onset',freq_co_init);
tmp.Bigram.Position_Specific.medial = struct('onset_vowel',freq_ov_med,...
    'vowel_coda',freq_vc_med,...
    'coda_onset',freq_co_med);
tmp.Bigram.Position_Specific.final = struct('onset_vowel',freq_ov_fin,...
    'vowel_coda',freq_vc_fin,...
    'coda_onset',freq_co_fin);

% filtered word list 
tmp = setfield(tmp,'Word_List',filtxt);

fprintf('structure created! finished!\n')
toc


