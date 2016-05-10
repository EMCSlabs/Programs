% This script detects motion from real-time video
% 2016-01-18

% 1) Run the entire script (not by section)
% 2) Type how long you want to turn on the camera e.g. endTime = 0.5
clear all; close all; clc

endTime = 2; % minute (0.5 min == 30 sec)

%% Create videoinput object
imaqhwinfo  % Check valid video 
% vid = videoinput('winvideo',1);    % Windows OS, install adaptor: OS generic
vid = videoinput('macvideo',1);    % Mac OS

triggerconfig(vid,'manual');         % Manually start trigger
set(vid,'ReturnedColorSpace','rgb'); % Set color space as rgb
set(vid,'FramesPerTrigger',1);       % Capture one frame per trigger
set(vid,'TriggerRepeat', Inf);       % Set trigger repeat as inf
start(vid); % start video
IMG = struct('img',[],'rectangle',[]); % structure to capture image & rectangle info

% Get maximum area
sizes = vid.VideoResolution;
row = sizes(1);
col = sizes(2);
maxArea = row*col;

% Load alarm sound
[y fs] = audioread('alarm1.mp3');
player = audioplayer(y,fs);

%% Infinite while loop
state = 1;
tic;         % set timer
figure;
while 1
    trigger(vid);                    % trigger vid
    IMG(state).img = getdata(vid,1); % get Image

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
        
        % Check area
        if rectArea > maxArea*0.5 && rectArea < maxArea*0.9
            disp('You Thief!!!!')
            stop(player)
        elseif rectArea > maxArea*0.9
            if ~isplaying(player)
                play(player)
            end
        end
        
        
        % subplot for changes of area
        subplot(212)
        if state == 2
            handlesPlot = plot(rectArea);
            ylim([0 maxArea])
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
delete(vid);
