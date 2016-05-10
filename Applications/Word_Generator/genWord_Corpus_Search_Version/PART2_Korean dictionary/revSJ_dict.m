% This scripts clears out problematic items in original SJ_dict
% SJ_dict.mat which currently exists in the folder is the revised one

numidx = ~cellfun(@isempty, regexp(SJ_dict.word, '\D\d$'));
findidx = find(numidx ==1);
dict = cell2table(SJ_dict.word);
prob = dict(findidx,1);

SJ_dict.word{findidx(1)} ='??';
SJ_dict(findidx(2),:)= [];
SJ_dict.word{findidx(3)} = '??';
SJ_dict(findidx(4),:)= [];
SJ_dict.word{findidx(5)} = '??';
SJ_dict(findidx(6),:)= [];
SJ_dict.word{findidx(8)} = '??';
SJ_dict(findidx(9),:) = [];
SJ_dict(findidx(10),:) = [];

