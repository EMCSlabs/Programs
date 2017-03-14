function Estimator_v7()
% Realtime sound visualization (waveform, FFT, spectrogram)
%
% ** Description **
% This is a realtime sound visualization GUI for waveform, FFT and
% spectrogram.
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
% 2017-02-18 created by EMCS Labs
% --feel free to edit and leave comments--
%
S.fh = figure('units','pixels',...  % figure shape
    'position',[100 55 1100 800],...
    'numbertitle','off',...
    'menubar','none',...
    'name','Real-time Estimator',...
    'renderer', 'painters',...
    'resize','off');
S.ax_wave = axes('units','pixels',...    % plotting axes
    'position',[100 450 500 280]); 
S.ax_fft = axes('units','pixels',...    % plotting axes
    'position',[660 450 400 280]); 
S.ax_sgram = axes('units','pixels',...    % plotting axes
    'position',[100 120 500 280]); 
S.ax_art = axes('units','pixels',...    % plotting axes
    'position',[660,120,400,280]);
S.tx = uicontrol('style','text',... % text box
    'units','pixels',...
    'position',[10,750,200,20],...
    'string','numFrame = 0',...
    'HorizontalAlignment','center',...
    'fontsize',15);
S.pulldown = uicontrol('style','popupmenu',... % drop-down menu
    'position',[150 30 150 50],...
    'string',{'ANN','LSTM','MATLAB_ANN'},...
    'value',1,...
    'callback',{@load_model});
S.tx_pulldown = uicontrol('style','text',...
    'units','pixels',...
    'position',[150,5,150,50],...
    'string','Model not loaded',...
    'HorizontalAlignment','center',...
    'fontsize',15); % text box
S.pb_start = uicontrol('style','push',... % start button
    'units','pixels',...
    'position',[350 30 100 50],...
    'string','Start',...
    'value',0,...
    'fontsize',15);
S.pb_stop = uicontrol('style','push',...  % stop button
    'units','pixels',...
    'position',[500 30 100 50],...
    'string','Stop',...
    'value',0,...
    'enable','off',...
    'fontsize',15);
S.pb_quit = uicontrol('style','push',...  % quit button
    'units','pixels',...
    'position',[650 30 100 50],...
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

% load model
load_model(S)

% recording object
S.recordObj = audiorecorder(S.srate,24,1); % nbit=24, channel=1 (mono)
set(S.recordObj, 'TimerPeriod', 0.1); % time interval for each TimerFcn

% timer object (should be the last one to define)
S.timerObj = timer('TimerFcn',{@drawGUI},...
    'Period',S.timeInterval,...
    'ExecutionMode','fixedRate');
set(S.fh,'UserData',S) % save timerObj in UserData

% must update callback functions at this point
% if not, S will not contain timerObj, recordObj and parameters
set(S.pb_start,'callback',{@pb_start}) 
set(S.pb_stop,'callback',{@pb_stop})
set(S.pulldown,'callback',{@load_model})

%------------------------------------------------------------------------%
%-- parameter setting
    function set_parameters(varargin)
        % this function set basic parameters
        S.timeInterval = 0.1; % timer interval in sec
        S.srate = 44100; % sampling rate
        S.windowLengthMS = 80; % in ms
        S.higherFreqLimit = 5000; % max limit for drawing frequencies
        S.fftLength = 2^ceil(log2(S.windowLengthMS*S.srate/1000)); % fft input length e.g. 4096
        S.frameShift_sgram = 1/S.srate*300; % in sec
        S.frameShift_fft = 1/S.srate*300; % in sec
        S.frameShift_wave = 1/S.srate; % in sec
        S.frameShiftInSample_sgram = round(S.frameShift_sgram*S.srate); % e.g. 0.007*44100=>309
        S.frameShiftInSample_fft = round(S.frameShift_fft*S.srate); % e.g. 0.007*44100=>309
        S.windowFunction = nuttallwin(round(S.windowLengthMS*S.srate/1000)); % window function
        S.windowLengthInSample = length(S.windowFunction); % samples in a window e.g. 3528
        S.dynamicRange = 80;
        S.lastPosition = 1;
        S.frameCount = 0; % counting every frame
        S.recEndPoint = 0; % recording end point for tmpAudio in drawGUIsgram function
        S.maxLevel = -100;
        S.sigmoid = @(a,x) 1./(1 + exp(a*x));
        S.relu = @(x)(x<=0).*0 + (x>0).*x;
    end

%-- axes setting
    function set_axes(varargin)
        % this function set axes before plotting
        tmpfreqAxis = (0:S.fftLength/2)/S.fftLength*S.srate;
        S.plotTimeAxisSize = 4;   % e.g. 4 second x-axis in plot
        S.freqAxis_sgram = tmpfreqAxis(tmpfreqAxis<S.higherFreqLimit); % y-axis frequency range
        S.freqAxis_fft = linspace(0,floor(S.srate/2),S.fftLength/2); % x-axis frequency range in Hz
        
        % spectrogram
        S.timeAxis_sgram = 0:S.frameShift_sgram:S.plotTimeAxisSize; % x-axis time range in sec
        S.timeAxis_sgram = S.timeAxis_sgram(1:end-1);
        S.timeAxisInSample_sgram = length(S.timeAxis_sgram); % number of x-axis frequencies
        S.initialSgramData = rand(length(S.freqAxis_sgram),length(S.timeAxis_sgram))*62 + 1;
        S.fftBuffer = zeros(S.fftLength,length(S.timeAxis_sgram));
        S.sgramHandle = image(S.ax_sgram,[S.timeAxis_sgram(1),S.timeAxis_sgram(end)]-S.timeAxis_sgram(end),...
            [S.freqAxis_sgram(1),S.freqAxis_sgram(end)],S.initialSgramData); % initial data with each corner
        axis(S.ax_sgram,'xy') % make y axis increasing from bottom to top
        xlabel(S.ax_sgram,'Time (sec)')
        ylabel(S.ax_sgram,'Frequency (Hz)')
        title(S.ax_sgram,'Spectrogram')
        grid(S.ax_sgram,'minor')
        S.linearTicLocationListWide = get(S.ax_sgram,'ytick');
        S.linearTickLabelListWide = get(S.ax_sgram,'ytickLabel');
        
        % waveform
        S.timeAxis_wave = 0:S.frameShift_wave:S.plotTimeAxisSize; % x-axis time range in sec
        S.timeAxis_wave = S.timeAxis_wave(1:end-1);
        S.timeAxisInSample_wave = length(S.timeAxis_wave); % number of x-axis frequencies
        S.initialWaveData = zeros(1,length(S.timeAxis_wave)); % initial data
        S.waveHandle = plot(S.ax_wave,-S.timeAxis_wave,S.initialWaveData);
        ylim(S.ax_wave,[-1 1])
        xlabel(S.ax_wave,'Time (sec)')
        ylabel(S.ax_wave,'Amplitude (-1 to +1)')
        title(S.ax_wave,'Waveform')
        grid(S.ax_wave,'minor')
        S.linearTicLocationListWide = get(S.ax_wave,'ytick');
        S.linearTickLabelListWide = get(S.ax_wave,'ytickLabel');
        
        % fft
        S.initialFFTydata = zeros(1,length(S.freqAxis_fft)); % number of x-axis time samples
        S.initialFFTxdata = S.freqAxis_fft/max(S.freqAxis_fft)*round(S.srate/2);
        S.fftHandle = plot(S.ax_fft,S.initialFFTxdata,S.initialFFTydata); % initial data
        xlim(S.ax_fft,[0 S.higherFreqLimit])
        ylim(S.ax_fft,[-100 100])
        xlabel(S.ax_fft,'Frequency (Hz)')
        ylabel(S.ax_fft,'DB')
        title(S.ax_fft,'FFT')
        grid(S.ax_fft,'minor')
        S.linearTicLocationListWide = get(S.ax_fft,'ytick');
        S.linearTickLabelListWide = get(S.ax_fft,'ytickLabel');
        
        % articulation
        try load('meanPalates.mat'), load('meanPharynx.mat');
        catch error('meanPalates.mat or meanPharynx is not in the path');end
        S.pal = plot(S.ax_art,meanPalates(:,1),meanPalates(:,2),'k-');
        hold(S.ax_art,'on')
        S.pha = plot(S.ax_art,meanPharynx(:,1),meanPharynx(:,2),'k-');
        xlim(S.ax_art,[-90 20])
        ylim(S.ax_art,[-25 25])
%         xlim(S.ax_art,[-80 0])
%         ylim(S.ax_art,[0 22])
        title(S.ax_art,'Articulation')
        xlabel(S.ax_art,'back <--> front (mm)')
        ylabel(S.ax_art,'low <--> high (mm)')
        grid(S.ax_art,'minor')
        hold(S.ax_art,'off')
        S.meanPalates = meanPalates;
        S.meanPharynx = meanPharynx;
    end

%-- popupmenu: load model
    function load_model(varargin)
        sels = get(S.pulldown,'string');
        idx = get(S.pulldown,'value');
        selected = sels{idx}; % get pull-down menu selection
        switch selected
            case 'ANN'
                S.model_dir = './models/ANN';
                S.frameCount = 0;
            case 'LSTM'
                S.model_dir = './models/LSTM';
                S.frameCount = 0;
                addpath(S.model_dir)
            case 'MATLAB_ANN'
                S.model_dir = './models/MATLAB_ANN';
                S.frameCount = 0;
                addpath(S.model_dir)
        end
        try 
            if strcmp(selected,'ANN') || strcmp(selected,'LSTM')
                L = load(fullfile(S.model_dir,'models.mat'));
                S.model = getfield(L, 'models');
                set(S.tx_pulldown,'string','Model loaded')
                set(S.pb_start,'enable','on')
            elseif strcmp(selected,'LSTM')
                if ~exist('forward_LSTM.m')
                    error('forward_LSTM.m does not exist')
                end
            elseif strcmp(selected, 'MATLAB_ANN')
                if ~exist('forward_ANN.m')
                    error('forward_ANN.m does not exist')
                else
                    set(S.pb_start,'enable','on')
                end
            end
        catch
            set(S.tx_pulldown,'string','Model Not loaded')
            warning('Check your model directory\nError at %s',S.model_dir)
            set(S.pb_start,'enable','off')
        end
        set(S.fh,'UserData',S) % update S in UserData!
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
        S.frameCount = 0;
        
        stop(S.timerObj)
        stop(S.recordObj)
        set(S.fh,'UserData',S) % update S
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
    function drawGUI(varargin)
        % This function calls drawGUIsgram, drawGUIwave
        S = get(S.fh,'UserData'); % retrieve S from UserData
        S.tmpAudio = getaudiodata(S.recordObj); % tmpAudio is adding up previous data
        S.spectrogramBuffer = get(S.sgramHandle,'cdata'); % get initial spectrogram data
        S.recCurrentPoint = S.recEndPoint + 1; % recording start point
        S.recEndPoint = length(S.tmpAudio); % recording end point
        S.frameEndPoint = S.recCurrentPoint + S.windowLengthInSample; % end point for each frame
        set(S.tx,'string',sprintf('numFrame = %d',S.frameCount))
        
        % draw spectrogram
        drawGUIsgram(varargin);
        
        % draw waveform
        drawGUIwave(varargin);
        
        % draw fft
        drawGUIfft(varargin);
        
        S.frameCount = S.frameCount+1;
        
        set(S.fh,'UserData',S) % update S in UserData!
    end

%-- spectrogram & articulation
    function drawGUIsgram(varargin)
        nFrames = 0;
        while S.lastPosition+S.frameShiftInSample_sgram+S.windowLengthInSample < S.recEndPoint
            % Whenever recordObj is called, samples will be obtained such
            % that for that samples, it should be windowed as much as
            % possible to maximize the use of information. 
            nFrames = nFrames + 1;
            currentIndex = S.lastPosition + S.frameShiftInSample_sgram;
            x = S.tmpAudio(currentIndex + (0:S.windowLengthInSample-1));
            tmpSpectrum = 20*log10(abs(fft(x.*S.windowFunction,S.fftLength)));
            S.fftBuffer(:,nFrames) = tmpSpectrum; % S.fftBuffer will be overwritten
            S.lastPosition = currentIndex;
        end
        mfcc = get_mfcc(x, S.srate);
        pred = forward(mfcc); % (example x feature)
        
        tmpSgram = S.fftBuffer(:,1:nFrames);
        if S.maxLevel < max(tmpSgram(:))
            S.maxLevel = max(tmpSgram(:));
        else
            S.maxLevel = max(-100,S.maxLevel*0.998);
        end
        tmpSgram = 62*max(0,(tmpSgram-S.maxLevel)+S.dynamicRange)/S.dynamicRange+1;
        
        S.spectrogramBuffer(:,1:end-nFrames) = S.spectrogramBuffer(:,nFrames+1:end); % back portion to front
        S.spectrogramBuffer(:,end-nFrames+1:end) = tmpSgram(1:length(S.freqAxis_sgram),:); % update back portion
        set(S.sgramHandle,'cdata',S.spectrogramBuffer)
        
        % draw articulation
        plot(S.ax_art,pred(end,[1,3,5,7,9,11,13]),pred(end,[2,4,6,8,10,12,14]),...
            'ko','MarkerSize',8,...
            'MarkerFaceColor','k') % (example x feature)
        line(S.ax_art,pred(end,[11,9]),pred(end,[12,10]),'color',[0 0 1],'linewidth',2)
        line(S.ax_art,pred(end,[9,7]),pred(end,[10,8]),'color',[0 0 1],'linewidth',2)
        line(S.ax_art,pred(end,[7,5]),pred(end,[8,6]),'color',[0 0 1],'linewidth',2)
        
        hold(S.ax_art,'on')
        S.pal = plot(S.ax_art,S.meanPalates(:,1),S.meanPalates(:,2),'k-');
        S.pha = plot(S.ax_art,S.meanPharynx(:,1),S.meanPharynx(:,2),'k-');
        xlim(S.ax_art,[-90 20])
        ylim(S.ax_art,[-25 25])
        hold(S.ax_art,'off')
        set(S.fh,'UserData',S) % update S in UserData!
    end

%-- waveform
    function drawGUIwave(varargin)
        sampleDiff = S.plotTimeAxisSize*S.srate - S.recEndPoint;
        if sampleDiff >= 0  % if number of samples is less than or equal to plotTimeAxisSize (e.g. 4 sec)
            ydata = [zeros(1,sampleDiff), S.tmpAudio']; % zero padding at the front
        else                % if number of samples is more than plotTimeAxisSize (e.g. 4 sec)
            ydata = S.tmpAudio(end-S.timeAxisInSample_wave+1:end)';
        end
        set(S.waveHandle,'ydata',fliplr(ydata)) % ydata should be left-right switched 
    end

%-- FFT
    function drawGUIfft(varargin)
        try
            tmpFrameSamples = S.tmpAudio(S.recCurrentPoint:S.frameEndPoint-1); % samples in a frame
        catch
            % In case, length(tmpFrameSamples) < lenght(S.frameEndpoint-1)
            % Error occurs possibly due to short of memory
            tmpFrameSamples = S.tmpAudio(S.recCurrentPoint:size(S.tmpAudio,1));
        end
            tmpSpectrum = 20*log10(abs(fft(tmpFrameSamples,S.fftLength))); % spectrum given a frame (from Kawahara's code)
            yData = tmpSpectrum(1:floor(length(tmpSpectrum)/2)); % only half of the spectrum (symmetry)
            set(S.fftHandle,'ydata',yData)
    end

%-- MFCC
    function mfcc = get_mfcc(sig, srate)
        Tw = 25;           % analysis frame duration (ms)
        Ts = 10;           % analysis frame shift (ms)
        alpha = 0.97;      % preemphasis coefficient
        R = [ 300 3700 ];  % frequency range to consider
        M = 20;            % number of filterbank channels
        C = 13;            % number of cepstral coefficients
        L = 22;            % cepstral sine lifter parameter
        [mfcc_tmp,~,~,~] = ...
            mfcc_rev( sig, srate, Tw, Ts, alpha, @hamming, R, M, C, L );
        % get 1st and 2nd derivatives
        deriv_1 = [zeros(size(mfcc_tmp,1),1), diff(mfcc_tmp,1,2)];
        deriv_2 = [zeros(size(mfcc_tmp,1),2), diff(mfcc_tmp,2,2)];
        mfcc = [mfcc_tmp;deriv_1;deriv_2]; 
    end

%-- Forward calculation
    function pred = forward(xdata)
        % xdata: (feature x examples)
        sels = get(S.pulldown,'string');
        idx = get(S.pulldown,'value');
        selected = sels{idx}; % get pull-down menu selection
        sigmoid = @(a,x) 1./(1 + exp(a*x));
        switch selected
            case 'ANN'
                biasMatrix_H = S.model.biasMatrix_H;
                biasMatrix_O = S.model.biasMatrix_O;
                weightMatrix_IH = S.model.weightMatrix_IH;
                weightMatrix_HO = S.model.weightMatrix_HO;
                in_coeff = -0.25;
                out_coeff = -0.1;
                input_mani = sigmoid(in_coeff,xdata);
                hidden_Activation = sigmoid(-1,input_mani'*weightMatrix_IH + repmat(biasMatrix_H,size(xdata,2),1));
                output_Activation = sigmoid(-1,hidden_Activation*weightMatrix_HO + repmat(biasMatrix_O,size(hidden_Activation,1),1));
                output_reverse = log(1./output_Activation - 1)/out_coeff;
                pred = output_reverse;  % (example x feature)
            case 'LSTM'
                if S.frameCount < 1
                   S.hidden_Cell_Memory_List = {''}; 
                   S.hidden_Activation_List = {''};
                end
                pred = zeros(size(xdata,2), 14);
                for i = 1:size(xdata, 2)
                    input_Activation = xdata(:,i)'; % 1x39 vector
                    [pred(i,:), new_Hidden_Cell_Memory, new_Hidden_Activation, ~] =...
                        forward_LSTM(S.model, S.frameCount,'acoustics', input_Activation, ...
                        S.hidden_Cell_Memory_List, S.hidden_Activation_List);
                    S.hidden_Cell_Memory_List = new_Hidden_Cell_Memory;
                    S.hidden_Activation_List = new_Hidden_Activation;
                end
                set(S.fh,'UserData',S) % update S in UserData because of LSTM!
            case 'MATLAB_ANN'
                pred = forward_ANN(xdata)'; % (example x feature)
        end
        
    end
end



