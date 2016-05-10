function [phones,s1,s2,s3,ortho_sep] = graph2phone(graphemes)
    %%
    % This function converts Korean graphemes into alphabetized phoneme
    % format.
    %
    % Input:
    %       graphems: a string of Korean syllables 
    %
    % Output:
    %       phones: a string of alphabets representing onset/vowel/coda of
    %               the given grapheme
    %       s1: a string of alphabets representing the onset of the final syllable
    %       s2: a string of alphabets representing the vowel of the final syllable 
    %       s3: a string of alphabets representing the coda of the final syllable
    %       ortho_sep: N x 3 cell array of strings of alphabets representing onset/vowel/coda in each of N syllables
    %
    %
    % created 2015-5-10
    % edited 2015-7-1
    % edited 2015-7-10
    % edited 2015-7-14 space is included
    % edited coda consonants (kf, pf, tf, nf, mf)
    %
    % phone list updated
    % NUC: EE - >e2 -> zz -> qq
    %      YE -> y2 -> yz -> yq
    %      wE -> w2 -> wo
    %      WE -> W3 -> wz -> wq
    %
    % edited 2015-10-20 nonsyllable case is included
    
    
    phones = '';
    
    ONS = {'k0', 'kk', 'nn', 't0', 'tt', 'rr', 'mm', 'p0', 'pp', 's0', 'ss', 'oh', 'c0', 'cc', 'ch', 'kh', 'th', 'ph', 'hh'};
    NUC = {'aa', 'qq', 'ya', 'yq', 'vv', 'ee', 'yv', 'ye', 'oo', 'wa', 'wq', 'wo', 'yo', 'uu', 'wv', 'we', 'wi', 'yu', 'xx', 'xi', 'ii'};
    COD = {'' 'kf', 'kk', 'ks', 'nf', 'nc', 'nh', 'tf', 'll', 'lk', 'lm', 'lb', 'ls', 'lt', 'lp', 'lh', 'mf', 'pf', 'ps', 's0', 'ss', 'oh', 'c0', 'ch', 'kh', 'th', 'ph', 'hh'};
    
    n = double(uint16(graphemes));
    
    if n >= 44032
        
        idx = n~=32;
        k = 1;
        ONSET = [];
        VOWEL = [];
        CODA = [];
        
        while k <= length(n)
            if idx(k) == 1
                base = 44032;
                df = n(k) - base;
                iONS = floor(df/588)+1;
                iNUC = floor(mod(df, 588)/28)+1;
                iCOD = mod(mod(df, 588), 28)+1;
                s1 = [ONS{iONS}]; s2 = [NUC{iNUC}];
                if ~isempty(COD{iCOD})
                    s3 = [COD{iCOD}];
                else
                    s3 = '**';
                end
                
                tmp = [s1 s2 s3];
                phones = [phones tmp];
                ONSET{k} = s1;
                VOWEL{k} = s2;
                CODA{k} = s3;
            elseif idx(k) == 0
                tmp = ' ';
                phones = [phones tmp];
            end
            %     phones = regexprep(phones,'-(oh)','-');
            k = k + 1;
            tmp = [];
        end
        
        % for i = 1:length(n)
        %     base = 44032;
        %     df = n(i) - base;
        %     iONS = floor(df/588)+1;
        %     iNUC = floor(mod(df, 588)/28)+1;
        %     iCOD = mod(mod(df, 588), 28)+1;
        %
        %     s1 = ['-' ONS{iONS}]; s2 = [NUC{iNUC}];
        %     if ~isempty(COD{iCOD})
        %         s3 = [COD{iCOD}];
        %     else
        %         s3 = '';
        %     end
        %     phones = [phones  s1 s2 s3];
        % end
        
        ONSET = ONSET';
        VOWEL = VOWEL';
        CODA = CODA';
        
        ortho_sep = [ONSET VOWEL CODA];
%         if length(phones) > 1
%             phones = phones(1:end);
%         end
%         
        
    % if the entered characters don't constitute syllable(s)    
    else
        s1 = 'N/A';
        s2 = 'N/A';
        s3 = 'N/A';
        ortho_sep = [{'N/A'} {'N/A'} {'N/A'}];
    end
    
    
    % phones = regexprep(phones,'\s\-',' ');
    % phones = regexprep(phones,'^oh','');
    % phones = regexprep(phones,'-(oh)','-');
    % phones = regexprep(phones,'oh(-)','ng-');
    % phones = regexprep(phones,'oh$','ng');
    % phones = regexprep(phones,'oh ','ng ');
    
