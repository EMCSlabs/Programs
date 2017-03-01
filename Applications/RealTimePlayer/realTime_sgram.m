function realTime_sgram()
% Realtime plotting of spectrogram
%
% ** Description **
% This is a simple real-time plotting of spectrogram.
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
    'name','Real-time Spectrogram',...
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
S.timerObj = timer('TimerFcn',{@drawGUIsgram},...
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
        S.windowLengthMS = 80; % in ms
        S.higherFreqLimit = 3600; % max limit for drawing frequencies
        S.fftLength = 2^ceil(log2(S.windowLengthMS*S.srate/1000)); % fft input length e.g. 4096
        S.frameShift = 0.007; % in sec
        S.frameShiftInSample = round(S.frameShift*S.srate); % e.g. 0.007*44100=>309
        S.windowFunction = nuttallwin(round(S.windowLengthMS*S.srate/1000)); % window function
        S.windowLengthInSample = length(S.windowFunction); % samples in a window e.g. 3528
        S.dynamicRange = 80;
        S.lastPosition = 1;
        S.frameCount = 0; % counting every frame
        S.recEndPoint = 0; % recording end point for tmpAudio in drawGUIsgram function
        S.maxLevel = -100;
    end

%-- axes setting
    function set_axes(varargin)
        % this function set axes before plotting
        tmpfreqAxis = (0:S.fftLength/2)/S.fftLength*S.srate;
        S.freqAxis = tmpfreqAxis(tmpfreqAxis<S.higherFreqLimit); % y-axis frequency range
        S.timeAxis = 0:S.frameShift:4; % x-axis time range e.g. 4 seconds window
        S.timeAxisInSample = length(S.timeAxis); % number of x-axis frequencies
        S.initialSgramData = rand(length(S.freqAxis),length(S.timeAxis))*62 + 1;
        S.fftBuffer = zeros(S.fftLength,length(S.timeAxis));
        S.sgramHandle = image([S.timeAxis(1),S.timeAxis(end)]-S.timeAxis(end),...
            [S.freqAxis(1),S.freqAxis(end)],S.initialSgramData); % initial data with each corner
        axis('xy') % make y axis increasing from bottom to top
        xlabel(S.ax,'Time')
        ylabel(S.ax,'Frequency (Hz)')
        grid(S.ax,'minor')
        S.linearTicLocationListWide = get(S.ax,'ytick');
        S.linearTickLabelListWide = get(S.ax,'ytickLabel');
    end

%-- pushbotton: start plotting
    function pb_start(varargin)
        set(S.pb_start,'enable','off')
        set(S.pb_stop,'enable','on')
        set(S.pb_quit,'enable','on')
        S.recEndPoint = 0; % once stop button is pressed, tmpAudio is flushed. That's why!
        S.lastPosition = 1; % lastPosition should be back to 1 if resumed after a pause
        set(S.fh,'UserData',S) % update S; if not, S.recEndPoint won't be 0

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
    function drawGUIsgram(varargin)
        % This function is called for every time inverval for timer object. So,
        % handles and variables should be properly updated by storing them
        % in UserData. Otherwise, whenever timer is executed, variables
        % would not be updated as expected.
        S = get(S.fh,'UserData'); % retrieve S from UserData
        tmpAudio = getaudiodata(S.recordObj); % tmpAudio is adding up previous data
        spectrogramBuffer = get(S.sgramHandle,'cdata'); % get initial spectrogram data
        S.recCurrentPoint = S.recEndPoint + 1; % recording start point
        S.recEndPoint = length(tmpAudio); % recording end point
        S.frameEndPoint = S.recCurrentPoint + S.windowLengthInSample; % end point for each frame
        
        nFrames = 0;
        while S.lastPosition+S.frameShiftInSample+S.windowLengthInSample < S.recEndPoint
            % Whenever recordObj is called, samples will be obtained such
            % that for that samples, it should be windowed as much as
            % possible to maximize the use of information. 
            nFrames = nFrames + 1;
            currentIndex = S.lastPosition + S.frameShiftInSample;
            x = tmpAudio(currentIndex + (0:S.windowLengthInSample-1));
            tmpSpectrum = 20*log10(abs(fft(x.*S.windowFunction,S.fftLength)));
            S.fftBuffer(:,nFrames) = tmpSpectrum; % S.fftBuffer will be overwritten
            S.lastPosition = currentIndex;
        end
        
        tmpSgram = S.fftBuffer(:,1:nFrames);
        if S.maxLevel < max(tmpSgram(:))
            S.maxLevel = max(tmpSgram(:));
        else
            S.maxLevel = max(-100,S.maxLevel*0.998);
        end
        tmpSgram = 62*max(0,(tmpSgram-S.maxLevel)+S.dynamicRange)/S.dynamicRange+1;
        
        spectrogramBuffer(:,1:end-nFrames) = spectrogramBuffer(:,nFrames+1:end); % back portion to front
        spectrogramBuffer(:,end-nFrames+1:end) = tmpSgram(1:length(S.freqAxis),:); % update back portion
        set(S.sgramHandle,'cdata',spectrogramBuffer)
        
        S.frameCount = S.frameCount+1;
        set(S.tx,'string',sprintf('numFrame = %d',S.frameCount))
        set(S.fh,'UserData',S) % update S in UserData!
    end
end



