% This script detects motion from real-time video
% 1) Run the entire script (not by section)
% 2) Type how long you want to turn on the camera e.g. endTime = 0.5
clear all; close all; clc

endTime = 0.5; % minute (0.5 min == 30 sec)

%% Create videoinput object
% vid = videoinput('winvideo',1);    % Windows OS
vid = videoinput('macvideo',1);   % Mac OS

triggerconfig(vid,'manual');         % Manually start trigger
set(vid,'ReturnedColorSpace','rgb'); % Set color space as rgb
set(vid,'FramesPerTrigger',1);       % Capture one frame per trigger
set(vid,'TriggerRepeat', Inf);       % Set trigger repeat as inf
start(vid); % start video
IMG = struct('img',[],'rectangle',[]); % structure to capture image & rectangle info

%% Infinite while loop
state = 1;
tic;         % set timer
figure;
while 1
    trigger(vid);                    % trigger vid
    IMG(state).img = getdata(vid,1); % get Image
    sizes = size(IMG(state).img);
    % subplot for realtime video
    subplot(211)
    imshow(IMG(state).img)           % show image
    hold on
    
    if state ~= 1
        prev = IMG(state).img;
        next = IMG(state-1).img;
        rect = trackMotionLive(prev,next);
        IMG(state).rectangle = rect;
        % Draw rectangle
        left = IMG(state).rectangle.left;
        head = IMG(state).rectangle.head;
        width = IMG(state).rectangle.width;
        height = IMG(state).rectangle.height;
        rectArea = IMG(state).rectangle.rectArea;
        rectangle('Position',[left head width height],'EdgeColor','r');
        fprintf('%d, area=%d\n',state,rectArea)
        
        % subplot for changes of area
        subplot(212)
        if state == 2
            handlesPlot = plot(rectArea);
            ylim([0 sizes(1)*sizes(2)])
        else
            oldRectArea=get(handlesPlot,'YData');
            set(handlesPlot,'YData',[oldRectArea rectArea]);
        end
    end
    
    state = state + 1;
    t = toc;           % get ending time of one frame
    if t > endTime*60  % if designated time has passed
        disp('Finished')
        stop(vid);
        break          % finish recording
    end
end
hold off

% Clear video
stop(vid);
% delete(vid);
