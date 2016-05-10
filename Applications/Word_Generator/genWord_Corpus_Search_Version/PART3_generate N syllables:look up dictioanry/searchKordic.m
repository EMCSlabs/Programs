function [realW, nonW] = searchKordic(wordlist)
%%
% This function look up a list of words in Sejong Dictionary
% to tell if each word is a real word or a nonword
% 
% SJ_dict.mat needs to be in your current folder
%
% Input
%       wordlist: a list of words (data type: table)
% Output
%       realW: a list of real words among the wordlist (data type: table)
%       nonW: a list of nonwords among the wordlist (data type: table)
%
% written by: YG (12/18/2015) 

%%

    nonW = table(); realW = table();
    load('SJ_dict.mat')
    
    for i = 1:height(wordlist)
    string = wordlist.str_graph{i};
    tf = strcmp(SJ_dict.word,string);
    
    if sum(tf) == 0
        nonW = [nonW; wordlist(i,:)];
    else 
        realW = [realW; wordlist(i,:)];
    end
    end
    
    
