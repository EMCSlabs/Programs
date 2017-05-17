function [ taggedStr ] = KorPOStag(strArray)
% This function tags POS information to a Korean cell string array
% via Komoran POS tagger.
% [ input  ]  strArray  :  a cell array of strings (KOR) 
% [ output ]  taggedStr :  a cell array of tagged strings (KOR)
% [ *** NOTE: JAVA 1.7 required (cf. please do NOT use ver 1.8)]
% Written by: Yejin Cho and Jungwook Kim
% Date: 2016.01.25
%% Last updated: 2016.01.29. 05:12 AM
taggedStr = [];
fulldirec1 = fullfile(cd,'komoranWrapper.jar');
fulldirec2 = fullfile(cd,'models-full');

javaaddpath(fulldirec1);
me = com.scarlet.wrapper.Main();

for i = 1:size(strArray,1)
    returnval = me.DoConvert(strArray{i,1}, fulldirec2);
    taggedStr{i,1} = cell(returnval);
    taggedStr{i,1} = taggedStr{i,1}{1,1};
    fprintf('%dth lyrics tagging completed\n',i);
end
end