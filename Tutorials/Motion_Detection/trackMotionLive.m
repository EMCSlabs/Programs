function img = trackMotionLive(framePREV,frameNEXT)
% This function tracks motion from adjascent two input frames

warning off

%% Get size of input frames
sizePREV = size(framePREV);
sizeNEXT = size(frameNEXT);

%% Check input frames
if length(sizePREV) < 3 || length(sizeNEXT) < 3
    error(sprintf('Input frames are incorrect\nCheck your input frames'))
end

%% Check frame sizes
if sizePREV(1) ~= sizeNEXT(1) || sizePREV(2) ~= sizeNEXT(2)
    error(sprintf('Input frames do not match with size\nCheck your input frames'))
end

%% Change int8 to double for use
pixelsPREV = double(cat(4,framePREV))/255;
pixelsNEXT = double(cat(4,frameNEXT))/255;

%% Get gray scale frame
grayPREV = rgb2gray(pixelsPREV);
grayNEXT = rgb2gray(pixelsNEXT);

%% Get thresholded frame
img = abs(grayNEXT - grayPREV); % get difference
threshold = 0.5;                % set threshold
img_binary = im2bw(img, threshold);   % image(frame) to binary image(frame)
% imshow(img_binary)

rowvec = sum(img_binary,2); % sum up row wise
rowidx = find(rowvec);          % find indices

%% Motion detection (main loop)
if rowidx ~= 0 % in case of no movement
    head = rowidx(1);
    toe = rowidx(end);
    
    %% column wise search (finding left and right)
    colvec = sum(img_binary,1); % sum up column wise
    colidx = find(colvec);
    left = colidx(1);
    right = colidx(end);
    
    %% Get center point
    center = [left + (right-left)/2, head + (toe-head)/2];
    %     plot(center(1),center(2),'y*') % draw center point
    
    %% Draw rectangle on moving object
    width = right-left;
    height = toe-head;
    rectArea = width*height;
    
    %% Drawing or not
    %     rectangle('Position',[left head width height],'EdgeColor','r');
    %     drawnow
    %     hold off
    
    %% save data into R
    img.left = left;
    img.head = head;
    img.width = width;
    img.height = height;
    img.rectArea = rectArea;
else
    img.left = 0;
    img.head = 0;
    img.width = 0;
    img.height = 0;
    img.rectArea = 0;
end


