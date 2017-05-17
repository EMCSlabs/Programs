function [Fail, fullData] = addSong(singleData, fullData)
%% Last updated: 2016.01.26. 8:52AM
%% Pre-allocation
Fail = 0;
%% Decide Success or Fail
criteria = singleData{1,4};
for i = 1:size(fullData,1)
    singleData_noSpace = singleData{1,2}(~isspace(singleData{1,2}));
    fullData_noSpace = fullData{i,2}(~isspace(fullData{i,2}));
    if strcmp(singleData_noSpace,fullData_noSpace)
        Fail = 1;
        return
    end
    
    singleData_upper = upper(singleData_noSpace);
    fullData_upper = upper(fullData_noSpace);
    if strcmp(singleData_upper, fullData_upper)
        Fail = 1;
        return
    end   
end

if ~isempty(regexp(criteria,'가사 정보가 없습니다'))
    Fail = 1;
    return
elseif ~isempty(regexp(criteria,'연주곡'))
    Fail = 1;
    return
elseif ~isempty(regexp(criteria,'[Ii]nstrumental'))
    Fail = 1;
    return
elseif ~isempty(regexp(criteria,'Not for under 19'))
    Fail = 1;
    return
elseif isempty(criteria)
    Fail = 1;
    return
elseif isempty(singleData{1,2})
    Fail = 1;
    return
elseif isempty(singleData{1,3})
    Fail = 1;
    return
end

fullData = [fullData ; strtrim(singleData)];
Fail = 0;

end
