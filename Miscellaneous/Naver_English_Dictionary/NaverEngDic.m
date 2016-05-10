function [definition, POS] = NaverEngDic(wordlist)
% NaverEngDic Ver 2.0.
% Bug updated
% Pre-assign zero vectors to definition (output)
bin = zeros(length(wordlist),1);
definition = num2cell(bin);
POS = num2cell(bin);

% (1) URL Manipulation
% Search words in wordlist by manipulating url
for i = 1:length(wordlist)
    %disp(i)
    word = wordlist{i};
    url = ['http://endic.naver.com/search.nhn?sLn=kr&searchOption=all&query=' word];
    
    % (2) Read Source by webread
    page = webread(url);
    
    % (3) Find the pattern in the source
    % Oh I notice that my desired info tends to appear between "fnt_k05"> and <
    
    % (4) Get data automatically with for loop & regexp
    % Extract desired information (definition of word) in the source code
    
    if regexp(page,'에 대한 검색결과가 없습니다.')
        def = 'CAUTION: NOT FOUND';
        POStag = 'CAUTION: NOT FOUND';
        
    else
        % (i) POS
        POStag = regexp(page,'k09">[^<]+</','match');
        POStag = regexprep(POStag,'k09">','');
        POStag = regexprep(POStag,'</','');
        if isempty(POStag)
            POStag = '';
        elseif regexp(POStag{1,1},'^\(.*\)$') == 1; % If the first k09 is '(미)'
            POStag =  POStag{1,2}; % Take the second k09
        else
            POStag =  POStag{1,1}; % Default
        end
        
        % (ii) Definition
        def = regexp(page,'k05">[^<]+</','match');
        if ~isempty(def)
            def = def{1,1}; % cf. First match is what we want
            def = regexprep(def,'k05">','');
            def = regexprep(def,'</','');
        end
        
        if isempty(def) % If def doesn't appear after k05
            def = regexp(page,'k09">[^<]+</','match'); % Check k09
            if regexp(def{1,2},'^\[.+\]$') == 1; % If k09 is '[POS]' again
                def = def{1,2};
                def = regexprep(def,'k09">','');
                def = regexprep(def,'</','');
                
            elseif length(def) > 1
                % If k09 is not '[POS]', Check second k05
                def = regexp(page,'k05">[^<]+</','match');
                if isempty(def)
                    def = 'CAUTION: NOT FOUND';
                    POStag = 'CAUTION: NOT FOUND';
                else
                    def = def{1,2};
                    def = regexprep(def,'k05">','');
                    def = regexprep(def,'</','');
                end
            end
        end
    end
    
    % Save into a cell array named 'definition'
    POS{i} = POStag;
    definition{i} = def;
end
end

