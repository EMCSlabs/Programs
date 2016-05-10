function [realW, nonW] = searchKordic_web(wordlist)
%%
% This function look up a list of words
% in the web-based <Standard Korean Dictionary>
% to tell if each word is a real word or a nonword
%
% Input
%       wordlist: a list of words (data type: table)
% Output
%       realW: a list of real words among the wordlist (data type: table)
%       nonW: a list of nonwords among the wordlist (data type: table)
%
% written by: YG (12/10/2015) 

    nonW = table();
    realW = table();
    
    for i = 1:height(wordlist)
    word = wordlist.str_graph{i};
    url = ['http://stdweb2.korean.go.kr/search/List_dic.jsp'];
    options = weboptions('Timeout',60,'RequestMethod','post');
    page = webread(url, 'PageRow', '10', 'Table', 'words|word', 'Gubun', '0', 'SearchPart', 'Simple', 'SearchText', word, options);
%     disp(i);
    
    % delete if the word search doesn't return a null report
    index = strfind(page,'.(0');
    if length(index) ~= 0 % if the dictionary says there's no real word like this
        nonW = [nonW ; wordlist(i,:)];
%         disp('CONFIRMED as a REAL NON-WORD');
    else % if it is a real word
        realW = [realW; wordlist(i,:)];
    end
    end
