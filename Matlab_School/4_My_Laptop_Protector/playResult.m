function playResult(result)

% Get size of movie
sizes = size(result(1).img);
vidWidth = sizes(2);
vidHeight = sizes(1);

% Create movie structure
M = struct('cdata',[],'colormap',[]);
for i = 1:length(result)
   M(i).cdata = result(i).img;
end

% Play
h = figure;
set(h,'position',[200 200 vidWidth vidHeight]);
frameRate = 5;
movie(h,M,1,frameRate);