function [] = summarizeData(data)
%% Last updated: 2016.01.28. 8:16 PM
% Pre-allocation
data(:,5) = num2cell(zeros(size(data,1),1));
data(:,6) = num2cell(zeros(size(data,1),1));
data(:,7) = num2cell(zeros(size(data,1),1));
data(:,8) = num2cell(zeros(size(data,1),1));

%%
for i = 1:size(data,1)
    fprintf('%dth data summarized\n',i)
    % (1) Foreign word ratio
    data(i,5) = num2cell(length(regexp(data{i,4},'[A-Za-z]+','match'))/length(regexp(data{i,4},'\<\S+\>','match')));
    
    % (2) Number of Tokens
    songdata1 = regexp(data{i,4},'\<\S+\>','match');
    data(i,6) = num2cell(length(songdata1));
    uqWords1 = unique(songdata1);
    uqWords1(2,:) = num2cell(zeros(1,length(uqWords1)));
    for k = 1:length(uqWords1)
        for q = 1:length(songdata1)
            if strcmp(uqWords1{1,k},songdata1{1,q})
                uqWords1{2,k} = uqWords1{2,k} + 1;
            end
        end
    end
    
    % (3) Number of Repetitions
    repNum = 0;
    for k = 1:length(uqWords1)
        if 1 < uqWords1{2,k}
            repNum = repNum + 1;
        end
    end
    data(i,7) = num2cell(repNum);
end

save('Summary.mat','data');

end
