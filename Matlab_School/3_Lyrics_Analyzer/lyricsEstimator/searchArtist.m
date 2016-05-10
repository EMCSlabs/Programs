function [searchedArtist] = searchArtist(data,songdata)

searchedArtist = [];
semiexp1 = songdata;
semiexp2 = regexp(semiexp1,'\<\S+\>','match');
exp =[];
for e = 1:length(semiexp2)
    exp = [exp semiexp2{1,e} '.*'];
end
%exp = cell2mat(exp);
for i = 1:size(data,1)
    exist = regexp(data{i,4},exp);
    if ~isempty(exist)
        searchedArtist = [searchedArtist; data(i,3)];
    end
end

end