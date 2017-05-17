function varargout = Estimator_v5(varargin)
% ESTIMATOR_V5 MATLAB code for Estimator_v5.fig
%      ESTIMATOR_V5, by itself, creates a new ESTIMATOR_V5 or raises the existing
%      singleton*.
%
%      H = ESTIMATOR_V5 returns the handle to a new ESTIMATOR_V5 or the handle to
%      the existing singleton*.
%
%      ESTIMATOR_V5('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ESTIMATOR_V5.M with the given input arguments.
%
%      ESTIMATOR_V5('Property','Value',...) creates a new ESTIMATOR_V5 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Estimator_v5_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Estimator_v5_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Estimator_v5

% Last Modified by GUIDE v2.5 21-Nov-2015 00:01:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Estimator_v5_OpeningFcn, ...
    'gui_OutputFcn',  @Estimator_v5_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT
end

% --- Executes just before Estimator_v5 is made visible.
function Estimator_v5_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Estimator_v5 (see VARARGIN)

% Choose default command line output for Estimator_v5
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%handles
delete(timerfindall);
initializeDisplay(handles);
myGUIdata = guidata(handles.SgramGUI);

%myGUIdata
timerEventInterval = 0.1; % in second
timer50ms = timer('TimerFcn',@synchDrawGUI, 'Period', ...
    timerEventInterval,'ExecutionMode','fixedRate', ...
    'UserData',handles.SgramGUI);
myGUIdata.timer50ms = timer50ms;
myGUIdata.smallviewerWidth = 30; % 30 ms is default
myGUIdata.recordObj1 = audiorecorder(myGUIdata.samplingFrequency,24,1);
set(myGUIdata.recordObj1,'TimerPeriod',0.1);
record(myGUIdata.recordObj1)
myGUIdata.maxAudioRecorderCount = 200;
myGUIdata.maxLevel = -100;
myGUIdata.audioRecorderCount = myGUIdata.maxAudioRecorderCount;
% for ax2
myGUIdata.number=1;
myGUIdata.t3yValue=zeros(1, 100);
guidata(handles.SgramGUI,myGUIdata);
start_button_Callback(hObject, eventdata, handles)
end
% UIWAIT makes Estimator_v5 wait for user response (see UIRESUME)
% uiwait(handles.SgramGUI);

function initializeDisplay(handles)
myGUIdata = guidata(handles.SgramGUI);
myGUIdata.samplingFrequency = 21739;
axes(handles.ax1);

myGUIdata = settingForNarrowband(myGUIdata);
fxx = myGUIdata.visibleFrequencyAxis;
tx = myGUIdata.timeAxis;
myGUIdata.SgramHandle = image([tx(1) tx(end)]-tx(end),[fxx(1) fxx(end)],myGUIdata.initialSgramData);
axis('xy');
myGUIdata.titleText = title('Narrowband Spectrogram','FontSize',17);
xlabel('Time (s)', 'FontSize', 14);
ylabel('Frequency (Hz)', 'FontSize', 14);
myGUIdata.linearTicLocationList = get(handles.ax1,'ytick');
myGUIdata.linearTickLabelList = get(handles.ax1,'ytickLabel');

% set(myGUIdata.SgramHandle,'erasemode','none');
% erasemode fcn is unsupported
drawnow expose;

guidata(handles.SgramGUI,myGUIdata);
end

function myGUIdata = settingForNarrowband(myGUIdata)
myGUIdata.windowLengthInMs = 80; % 80
myGUIdata.higherFrequencyLimit = 3600;
fs = myGUIdata.samplingFrequency;
fftl = 2^ceil(log2(myGUIdata.windowLengthInMs*fs/1000));
%fftl = 1024;
fx = (0:fftl/2)/fftl*fs;
fxx = fx(fx<myGUIdata.higherFrequencyLimit);
frameShift = 0.007;
tx = 0:frameShift:4;
myGUIdata.initialSgramData = rand(length(fxx),length(tx))*62+1;
myGUIdata.frameShift = frameShift;
myGUIdata.visibleFrequencyAxis = fxx;
myGUIdata.timeAxis = tx;
myGUIdata.fftl = fftl;
myGUIdata.fftBuffer = zeros(fftl,length(tx));
myGUIdata.lastPosition = 1;
myGUIdata.frameShiftInSample = round(myGUIdata.frameShift*fs);
% myGUIdata.windowFunction = blackman(round(myGUIdata.windowLengthInMs*fs/1000));
myGUIdata.windowFunction = nuttallwin(round(myGUIdata.windowLengthInMs*fs/1000));
myGUIdata.windowLengthInSample = length(myGUIdata.windowFunction);
myGUIdata.dynamicRange = 80;
myGUIdata.maxLevel = -100;
end


function synchDrawGUI(obj, event, string_arg)
handleForTimer = get(obj,'UserData');
myGUIdata = guidata(handleForTimer);
numberOfSamples = myGUIdata.windowLengthInSample;
dynamicRange = myGUIdata.dynamicRange;
fftl = myGUIdata.fftl;
w = myGUIdata.windowFunction;
fxx = myGUIdata.visibleFrequencyAxis;
fs = myGUIdata.samplingFrequency;
if get(myGUIdata.recordObj1,'TotalSamples') > fftl*4
    tmpAudio = getaudiodata(myGUIdata.recordObj1);
    currentPoint = length(tmpAudio);
    if length(currentPoint-numberOfSamples+1:currentPoint) > 10
        myGUIdata.audioRecorderCount = myGUIdata.audioRecorderCount-1;
        spectrogramBuffer = get(myGUIdata.SgramHandle,'cdata');
        ii = 0;
        while myGUIdata.lastPosition+myGUIdata.frameShiftInSample+numberOfSamples < currentPoint
            ii = ii+1;
            currentIndex = myGUIdata.lastPosition+myGUIdata.frameShiftInSample;
            x = tmpAudio(currentIndex+(0:numberOfSamples-1));
            tmpSpectrum = 20*log10(abs(fft(x.*w,fftl)));
            myGUIdata.fftBuffer(:,ii) = tmpSpectrum;
            myGUIdata.lastPosition = currentIndex;
        end;
        nFrames = ii;
        if nFrames > 0
            tmpSgram = myGUIdata.fftBuffer(:,1:nFrames);
            if myGUIdata.maxLevel < max(tmpSgram(:))
                myGUIdata.maxLevel = max(tmpSgram(:));
            else
                myGUIdata.maxLevel = max(-100,myGUIdata.maxLevel*0.998);
            end;
            tmpSgram = 62*max(0,(tmpSgram-myGUIdata.maxLevel)+dynamicRange)/dynamicRange+1;
            spectrogramBuffer(:,1:end-nFrames) = spectrogramBuffer(:,nFrames+1:end);
            spectrogramBuffer(:,end-nFrames+1:end) = tmpSgram(1:length(fxx),:);
            set(myGUIdata.SgramHandle,'cdata',spectrogramBuffer);
        else
            disp('no data read!');
        end;
    else
        disp('overrun!')
    end;
    
    if myGUIdata.audioRecorderCount < 0
        switch get(myGUIdata.timer50ms,'running')
            case 'on'
                stop(myGUIdata.timer50ms);
        end
        disp('Initializing audio buffer');
        stop(myGUIdata.recordObj1);
        record(myGUIdata.recordObj1);
        myGUIdata.audioRecorderCount = myGUIdata.maxAudioRecorderCount;
        myGUIdata.lastPosition = 1;
        switch get(myGUIdata.timer50ms,'running')
            case 'off'
                start(myGUIdata.timer50ms);
        end
    end;
    guidata(handleForTimer,myGUIdata);
    
  
    
    % ax3
    load JW13palpha;
    hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));
    [ MFCCs ] = ...
        mfcc_rev( x, 21739, 50, 50, 0.97, hamming, [300 3700], 20, 13, 22);
    xy = myNeuralNetworkFunction(MFCCs);
    plot(myGUIdata.ax3, xy(1:2:size(xy,1),1), xy(2:2:size(xy,1),1), 'or', ...
        'LineWidth', 2, ...
        'MarkerSize', 8, ...
        'MarkerFaceColor', 'k')
    xlim(myGUIdata.ax3,[-100 40]); ylim(myGUIdata.ax3,[-40 40]);
    set(myGUIdata.ax3,'ytick',[]); set(myGUIdata.ax3,'yticklabel',[])
    set(myGUIdata.ax3,'xtick',[]); set(myGUIdata.ax3,'xticklabel',[])
    title(myGUIdata.ax3, 'Estimated Articulator Trajectory','FontSize',15);
    hold(myGUIdata.ax3, 'on')
    plot(myGUIdata.ax3, pal(:,1), pal(:,2), 'k', 'LineWidth', 1.5)
    plot(myGUIdata.ax3, pha(:,1), pha(:,2), 'k', 'LineWidth', 1.5)
    hold(myGUIdata.ax3, 'off')        
    
    % ax2
    set(myGUIdata.ax2,'XDir','reverse');
    title(myGUIdata.ax2, 'Signal', 'FontSize', 15);
    if myGUIdata.number<=100
        if myGUIdata.number==1
            hold(myGUIdata.ax2,'off')
        end
        myGUIdata.t3yValue(1, myGUIdata.number)=xy(8,1);
    plot(myGUIdata.ax2,1:myGUIdata.number,myGUIdata.t3yValue(1:myGUIdata.number),'b', 'LineWidth', 1.2)
    hold(myGUIdata.ax2,'on')
    xlim(myGUIdata.ax2,[0 100]), ylim(myGUIdata.ax2,[-10 20])
    myGUIdata.number=myGUIdata.number+1;
    drawnow
    else
        hold(myGUIdata.ax2,'off')
        for map=2:length(myGUIdata.t3yValue)
        myGUIdata.t3yValue(1, map-1)=myGUIdata.t3yValue(1, map);
        end
        myGUIdata.t3yValue(1, end)=xy(8,1);
        plot(myGUIdata.ax2,1:100,myGUIdata.t3yValue,'b')
        xlim(myGUIdata.ax2,[0 100]), ylim(myGUIdata.ax2,[-10 20])
    end
    guidata(handleForTimer,myGUIdata);
    
    % ax4
    N = 500;
    [Y,freq] = spectrum_rev(x, 21739);
    plot(myGUIdata.ax4,freq(1:(N/2)+1),log2(abs(Y(1:(N/2)+1))),'b');
    grid(myGUIdata.ax4,'on');
    xlim(myGUIdata.ax4,[0 3600]); ylim(myGUIdata.ax4,[-15 15]);
    xlabel(myGUIdata.ax4,'Frequency in Hz');
    ylabel(myGUIdata.ax4,'Log-base-2 of Amplitude');
    title(myGUIdata.ax4,'Spectrum','FontSize',15);
    
else
    disp(['Recorded data is not enough! Skipping this interruption... at ' datestr(now,'mmmm dd, yyyy HH:MM:SS.FFF AM')]);
end;
end



% --- Outputs from this function are returned to the command line.
function varargout = Estimator_v5_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end


% --- Executes on button press in start_button.
function start_button_Callback(hObject, eventdata, handles)
% hObject    handle to start_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myGUIdata = guidata(handles.SgramGUI);
set(myGUIdata.start_button,'enable','off');
set(myGUIdata.stop_button,'enable','on');
set(myGUIdata.play_button,'enable','off');
switch get(myGUIdata.timer50ms,'running')
    case 'on'
        stop(myGUIdata.timer50ms);
end
myGUIdata.audioRecorderCount = myGUIdata.maxAudioRecorderCount;
myGUIdata.lastPosition = 1;
record(myGUIdata.recordObj1);
switch get(myGUIdata.timer50ms,'running')
    case 'off'
        start(myGUIdata.timer50ms);
    case 'on'
    otherwise
        disp('Timer is broken!');
end
guidata(handles.SgramGUI,myGUIdata);
end


% --- Executes on button press in stop_button.
function stop_button_Callback(hObject, eventdata, handles)
% hObject    handle to stop_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myGUIdata = guidata(handles.SgramGUI);

set(myGUIdata.start_button,'enable','on');
set(myGUIdata.stop_button,'enable','off');
set(myGUIdata.record_button,'enable','on');

switch get(myGUIdata.timer50ms,'running')
    case 'on'
        stop(myGUIdata.timer50ms)
    case 'off'
       
    otherwise
        disp('Timer is broken!');
end;
myGUIdata.audioData = getaudiodata(myGUIdata.recordObj1);
stop(myGUIdata.recordObj1);
guidata(handles.SgramGUI,myGUIdata);
end


% --- Executes on button press in record_button.
function record_button_Callback(hObject, eventdata, handles)
% hObject    handle to record_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

myGUIdata = guidata(handles.SgramGUI);
set(myGUIdata.start_button,'enable','off');
set(myGUIdata.stop_button,'enable','on');
set(myGUIdata.play_button,'enable','off');

switch get(myGUIdata.timer50ms,'running')
    case 'on'
        stop(myGUIdata.timer50ms);
    case 'off'
    otherwise
        disp('Timer is broken!');
end;

myGUIdata.recordObj2 = audiorecorder(myGUIdata.samplingFrequency,24,1);
recordblocking(myGUIdata.recordObj2,str2double(get(handles.record_second,'String')));
myGUIdata.audioData2 = getaudiodata(myGUIdata.recordObj2);

load JW13palpha;
myGUIdata.pal= pal;
myGUIdata.pha = pha;

hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));
[ MFCCs, ~, ~ ] = ...
    mfcc_rev( myGUIdata.audioData2, 21739, 50, 50, 0.97, hamming, [300 3700], 20, 13, 22);
myGUIdata.xy = myNeuralNetworkFunction(MFCCs);

set(myGUIdata.play_button,'enable','on');

guidata(handles.SgramGUI,myGUIdata);
end


% --- Executes on button press in play_button.
function play_button_Callback(hObject, eventdata, handles)
% hObject    handle to play_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myGUIdata = guidata(handles.SgramGUI);

% soundsc(myGUIdata.audioData2,21739);

durT = length(myGUIdata.audioData2)/21739;
t = 0:1/21739:floor(durT);
y = [0; myGUIdata.audioData2];
set(myGUIdata.ax2,'XDir','normal');
plot(handles.ax2, t, y(1:length(t)))
minY = min(y); maxY = max(y);
xlim(handles.ax2, [0 round(durT)]);
ylim(handles.ax2, [minY-.0001 maxY+.0001]);
xlabel(handles.ax2,'Time (s)');

frameRate = 25; % fps
frameT = 1/frameRate;

playHeadLoc = 0;
hold(myGUIdata.ax2, 'on');

player = audioplayer(y, 21739);
player.Userdata.x = t;
player.Userdata.y = y;

set(player, 'TimerFcn', @c_bar);
set(player, 'TimerPeriod', .01);
play(player);


set(myGUIdata.ax3,'ytick',[]); set(myGUIdata.ax3,'yticklabel',[])
set(myGUIdata.ax3,'xtick',[]); set(myGUIdata.ax3,'xticklabel',[])

for k = 1:size(myGUIdata.xy,2)
    plot(myGUIdata.ax3, myGUIdata.pal(:,1), myGUIdata.pal(:,2), 'k', 'LineWidth', 1.5)
    xlim(myGUIdata.ax3,[-85 35]); ylim(myGUIdata.ax3,[-35 35]);
    hold(myGUIdata.ax3, 'on')
    plot(myGUIdata.ax3, myGUIdata.pha(:,1), myGUIdata.pha(:,2), 'k', 'LineWidth', 1.5)
    plot(myGUIdata.ax3, myGUIdata.xy(1:2:size(myGUIdata.xy,1),k), myGUIdata.xy(2:2:size(myGUIdata.xy,1),k), 'or', ...
        'LineWidth', 2, 'MarkerSize', 8, 'MarkerFaceColor', 'k')
    hold(myGUIdata.ax3, 'off')
    pause(1/21739*660)
end

hold(myGUIdata.ax2, 'off');

end


function src = c_bar(src,eventdata)
myGUIdata = guidata(handles.SgramGUI);

c_sample = get(src, 'Currentsample');
sig = get(src, 'UserData');

plot(myGUIdata.ax2, sig.x, sig.y); axis tight; shg
hold on
plot([c_sample c_sample], [-1 1], 'color', 'r', 'linewidth', 2);
hold off
end


% --- Executes during object creation, after setting all properties.
function record_second_CreateFcn(hObject, eventdata, handles)
% hObject    handle to record_second (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function record_second_Callback(hObject, eventdata, handles)
% hObject    handle to record_second (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of record_second as text
%        str2double(get(hObject,'String')) returns contents of record_second as a double
end


% --- Executes on button press in load_button.
function load_button_Callback(hObject, eventdata, handles)
% hObject    handle to load_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

myGUIdata = guidata(handles.SgramGUI);
set(myGUIdata.start_button,'enable','off');
set(myGUIdata.stop_button,'enable','on');
set(myGUIdata.play_button,'enable','off');

switch get(myGUIdata.timer50ms,'running')
    case 'on'
        stop(myGUIdata.timer50ms);
    case 'off'
    otherwise
        disp('Timer is broken!');
end;

fname = uigetfile({'*.wav'; '*.*'},'File Selector');
myGUIdata.recordObj2 = [];
[myGUIdata.recordObj2, fs] = audioread(fname);

if strcmp( num2str(fs), '21739') == 0;
    [P,Q] = rat(21739/fs);
    myGUIdata.myGUIdata.audioData2 = resample(myGUIdata.recordObj2,P,Q);
end

myGUIdata.audioData2 = myGUIdata.recordObj2;

load JW13palpha;
myGUIdata.pal= pal;
myGUIdata.pha = pha;

hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));
[ MFCCs, ~, ~ ] = ...
    mfcc_rev( myGUIdata.audioData2, 21739, 50, 50, 0.97, hamming, [300 3700], 20, 13, 22);
myGUIdata.xy = myNeuralNetworkFunction(MFCCs);

set(myGUIdata.play_button,'enable','on');

guidata(handles.SgramGUI,myGUIdata);
end
