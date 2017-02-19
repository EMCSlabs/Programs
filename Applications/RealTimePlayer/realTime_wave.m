function realTime_wave()
% Realtime plotting of waveform
%
% ** Description **
% This is a simple real-time plotting of a waveform.
% You can manipulate this GUI to implement for your own purposes.
% Since Hideki(2013)'s realtimeSpectrogramV3 is much complicated, this GUI
% was made simpler and easier to manipulate although you may not feel simpler or easier ;)
%
% ** Tips **
% 1) while vs. timer
% Building real-time player requires precise timing control. For a simple
% GUI, using while-end will do the job. However, for a better timing
% control in much complicated works, using timer function might do the
% better job than using while-end loop.
%
% 2) variable control
% As Matt Fig (2009) mentioned in his GUI practice codes, creating one
% structural variable is a one way of handling variables without much
% conflict. You may choose to use global variable or UserData in figure.
% This GUI uses Matt's method of creating one variable (e.g. S) for accessing
% across the function space
%
% 3) parameters you may want to manipulate
% In this GUI, you may manipulate several parameters as follows:
%         S.timeInterval       % timer interval in sec
%         S.srate              % sampling rate in hz
%         S.windowLengthMS     % window length in ms
%         S.higherFreqLimit    % higher frequency limit in hz
%         S.frameShift         % frame shift in ms
%         S.windowFunction     % type of window functions e.g. hamming
%
% ** References **
% - Hideki Kawahara's real-time plotting codes
%   : http://www.wakayama-u.ac.jp/~kawahara/MatlabRealtimeSpeechTools
% - Matt Fig's GUI codes
%   : https://www.mathworks.com/matlabcentral/fileexchange/24861-41-complete-gui-examples
%
% ** History **
% 2017-01-01 created by Jaekoo Kang, Sunghah Hwang, Hosung Nam (EMCS Labs)
% --feel free to edit and leave comments--
%
S.fh = figure('units','pixels',...  % figure shape
    'position',[400 300 700 500],...
    'numbertitle','off',...
    'menubar','none',...
    'name','Real-time Waveform',...
    'renderer', 'painters',...
    'resize','off');
S.ax = axes('units','pixels',...    % plotting axes
    'position',[100 150 500 280]); 
S.tx = uicontrol('style','text',... % text box
    'units','pixels',...
    'position',[10,450,200,20],...
    'string','numFrame = 0',...
    'HorizontalAlignment','center',...
    'fontsize',15);
S.pb_start = uicontrol('style','push',... % start button
    'units','pixels',...
    'position',[150 50 100 50],...
    'string','Start',...
    'value',0,...
    'fontsize',15);
S.pb_stop = uicontrol('style','push',...  % stop button
    'units','pixels',...
    'position',[300 50 100 50],...
    'string','Stop',...
    'value',0,...
    'enable','off',...
    'fontsize',15);
S.pb_quit = uicontrol('style','push',...  % quit button
    'units','pixels',...
    'position',[450 50 100 50],...
    'string','Quit',...
    'value',0,...
    'fontsize',15,...
    'callback',{@pb_quit});
%------------------------------------------------------------------------%
% Reminder: variable 'S' will hold all the uicontrols, variables/parameters
% during the entire process

% basic settings
set_parameters(S);

% axes setting
set_axes(S);

% recording object
S.recordObj = audiorecorder(S.srate,24,1); % nbit=24, channel=1 (mono)
set(S.recordObj, 'TimerPeriod', 0.1); % time interval for each TimerFcn

% timer object (should be the last one to define)
S.timerObj = timer('TimerFcn',{@drawGUIwave},...
    'Period',S.timeInterval,...
    'ExecutionMode','fixedRate');
set(S.fh,'UserData',S) % save timerObj in UserData

% must update callback functions at this point
% if not, S will not contain timerObj, recordObj and parameters
set(S.pb_start,'callback',{@pb_start}) 
set(S.pb_stop,'callback',{@pb_stop})
%------------------------------------------------------------------------%
%-- parameter setting
    function set_parameters(varargin)
        % this function set basic parameters
        S.timeInterval = 0.1; % timer interval in sec
        S.srate = 44100; % sampling rate
        S.higherFreqLimit = 3600;
        S.frameShift = 1/S.srate; % around 0.00002 sec
        S.lastPosition = 1;
        S.frameCount = 0;
    end

%-- axes setting
    function set_axes(varargin)
        % this function set axes before plotting
        S.plotTimeAxisSize = 4;   % e.g. 4 second x-axis in plot
        S.timeAxis = 0:S.frameShift:S.plotTimeAxisSize; % x-axis time range in sec
        S.timeAxis = S.timeAxis(1:end-1);
        S.timeAxisInSample = length(S.timeAxis); % number of x-axis time samples
        S.initialWaveData = zeros(1,length(S.timeAxis)); % initial data
        S.waveHandle = plot(S.ax,-S.timeAxis,S.initialWaveData);
        ylim(S.ax,[-1 1])
        xlabel(S.ax,'Time (sec)')
        ylabel(S.ax,'Amplitude (-1 to +1)')
        grid(S.ax,'minor')
        S.linearTicLocationListWide = get(S.ax,'ytick');
        S.linearTickLabelListWide = get(S.ax,'ytickLabel');
    end

%-- pushbotton: start plotting
    function pb_start(varargin)
        set(S.pb_start,'enable','off')
        set(S.pb_stop,'enable','on')
        set(S.pb_quit,'enable','on')
        
        record(S.recordObj); % start recording
        pause(.5) % quick pause for recording object to initiate
        start(S.timerObj); % start timer object
    end

%-- pushbotton: stop plotting
    function pb_stop(varargin)
        set(S.pb_stop,'enable','off')
        set(S.pb_start,'enable','on')
        set(S.pb_quit,'enable','on')
        
        stop(S.timerObj)
        stop(S.recordObj)
    end

%-- pushbotton: quit GUI
    function pb_quit(varargin)
        pause(.5) % give litte time for computer to process
        if strcmp(get(S.timerObj,'running'),'on')
            stop(S.timerObj)
        end
        stop(S.recordObj)
        delete(timerfind) % delete all timers (just in case)
        delete(S.recordObj)
        close(S.fh)
    end

%-- drawing samples on the axes
    function drawGUIwave(varargin)
        % This function is called every time inverval for timer object. So,
        % handles and variables should be properly updated by storing them
        % in UserData. Otherwise, whenever timer is executed, variables
        % would not be updated as expected.
        S = get(S.fh,'UserData'); % retrieve S from UserData
        tmpAudio = getaudiodata(S.recordObj)'; % tmpAudio is adding up previous data
        S.recEndPoint = length(tmpAudio);
        
        sampleDiff = S.plotTimeAxisSize*S.srate - S.recEndPoint;
        if sampleDiff >= 0  % if number of samples is less than or equal to plotTimeAxisSize (e.g. 4 sec)
            ydata = [zeros(1,sampleDiff), tmpAudio]; % zero padding at the front
        else                % if number of samples is more than plotTimeAxisSize (e.g. 4 sec)
            ydata = tmpAudio(end-S.timeAxisInSample+1:end);
        end
        set(S.waveHandle,'ydata',fliplr(ydata)) % ydata should be left-right switched 
        
        S.frameCount = S.frameCount+1;
        set(S.tx,'string',sprintf('Frame rate = %d',S.frameCount))
        set(S.fh,'UserData',S) % update S in UserData!
    end
end



