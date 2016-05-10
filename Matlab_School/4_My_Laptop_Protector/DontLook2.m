function varargout = DontLook2(varargin)
% DONTLOOK2 MATLAB code for DontLook2.fig
%      DONTLOOK2, by itself, creates a new DONTLOOK2 or raises the existing
%      singleton*.
%
%      H = DONTLOOK2 returns the handle to a new DONTLOOK2 or the handle to
%      the existing singleton*.
%
%      DONTLOOK2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DONTLOOK2.M with the given input arguments.
%
%      DONTLOOK2('Property','Value',...) creates a new DONTLOOK2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DontLook2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DontLook2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DontLook2

% Last Modified by GUIDE v2.5 19-Jan-2016 21:49:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @DontLook2_OpeningFcn, ...
    'gui_OutputFcn',  @DontLook2_OutputFcn, ...
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


% --- Executes just before DontLook2 is made visible.
function DontLook2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DontLook2 (see VARARGIN)

% Choose default command line output for DontLook2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DontLook2 wait for user response (see UIRESUME)
% uiwait(handles.fig);


% --- Outputs from this function are returned to the command line.
function varargout = DontLook2_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
S.cnt = 0;
S.result = [];
S.runState = 1;
set(handles.fig,'UserData',S)


% --- Executes on button press in tg_start.
function tg_start_Callback(hObject, eventdata, handles)
% hObject    handle to tg_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Whenever button is pressed or unpressed, 
% this callback is called regardless of the Value property (1 or 0)

% Retrieve S
S = get(handles.fig,'UserData');
result = S.result;
runState = S.runState;

% Check button press
buttonPress = get(handles.tg_start,'value');
if buttonPress == 1
    clc
    set(handles.tx_status,'String','Initializing...')
    set(handles.tx_status,'Enable','inactive')
    pause(1)
    
    % Change button string
    set(handles.tg_start,'String','Stop')
    set(handles.tg_start,'ForegroundColor',[1 0 0])
    timeinfo = get(handles.ed_time,'string');
    
    % Get endtime from handles.ed_time
    endTime = str2num(timeinfo);
    
    % Initialize video
    try 
        % try this, if fails, go to catch 
        vid = videoinput('winvideo',1);    % Windows OS
    catch
        vid = videoinput('macvideo',1);    % Mac OS
    end
    % Preparation
    triggerconfig(vid,'manual');         % Manually start trigger
    set(vid,'ReturnedColorSpace','rgb'); % Set color space as rgb
    set(vid,'FramesPerTrigger',1);       % Capture one frame per trigger
    set(vid,'TriggerRepeat', Inf);       % Set trigger repeat as inf
    start(vid); % start video
    result = struct('img',[],'rectangle',[]); % structure to capture image & rectangle info
    
    % Get maximum area
    sizes = vid.VideoResolution;
    row = sizes(1);
    col = sizes(2);
    maxArea = row*col;
    
    % Load alarm sound
    [y,fs] = audioread('alarm1.mp3');
    player = audioplayer(y,fs);
    
    set(handles.tx_status,'String','Camera prepared...')
    set(handles.tx_status,'Enable','on')
    
    frameNum = 1;   % Set frame number
    S.runState = 1;   % Set state for main loop
    tic;         % Set timer

    set(handles.fig,'UserData',S)
end

% Main loop
try
    while runState == 1
        S = get(handles.fig,'UserData');
        runState = S.runState;
        
        % Check button press to escape
        buttonPress = get(handles.tg_start,'value');
        if buttonPress == 0
            set(handles.tg_start,'String','Saving...')
            set(handles.tg_start,'ForegroundColor',[0 1 0])
            set(handles.tg_start,'enable','inactive')
            set(handles.tx_status,'String','Saving result...')
            pause(1)
            
            % Due to the speed of while loop,
            % additional if statement is needed
            if exist('vid','var')
                % Save result
                dt = datestr(datetime('now')); % get current time
                dt = regexprep(dt,':','.');
                dt = regexprep(dt,'\s','_');
                save(['result_' dt '.mat'],'result')
                
                % Clear video
                stop(vid);
                delete(vid);
                set(handles.tx_status,'String','Finished')
                set(handles.tg_start,'String','Start')
                set(handles.tg_start,'ForegroundColor',[0 0 0])
                set(handles.tg_start,'enable','on')
                pause(1)
            end
            break
        end
        
        trigger(vid);  % trigger vid
        rawImg = getdata(vid,1);  % get image
        result(frameNum).img = rawImg; % save image
        
        minFrame = 5;
        if frameNum >= minFrame  % when at least two frames are acquired
            prev = result(frameNum).img;
            next = result(frameNum-1).img;
            rect = trackMotionLive(prev,next);
            result(frameNum).rectangle = rect;
            rectArea = result(frameNum).rectangle.rectArea;

            set(handles.tx_status,'String',sprintf('%d, area=%d',frameNum,rectArea))
            
            % Check area
            if rectArea < maxArea*0.8
                set(handles.tx_status,'ForegroundColor',[1 1 1])
                stop(player)
            elseif rectArea > maxArea*0.8
                set(handles.tx_status,'ForegroundColor',[1 0 0])
                if ~isplaying(player)
                    play(player)
                end
                % Send email!
                dt = datestr(datetime('now')); % get current time
                recipient = get(handles.ed_email,'string');
                contents = {'Somebody just touched your laptop';...
                    sprintf('Date: %s',dt);...
                    'Snapshot is attached'};
                title = sprintf('[ALERT] Someone just touched your laptop: %s',dt);
                sender = 'matlabgroup4@gmail.com';
                pwd = '4whghkdlxld';
                imwrite(rawImg,'snapshot.png')
                attach = './snapshot.png';
                try
                    matlabmail(recipient,contents,title,sender,pwd,attach)
                catch
                    set(handles.tx_status,'String','Email error')
                end
            end
        end
        
        frameNum = frameNum + 1;
        t = toc;           % get ending time of frame after frame
        if t > endTime*60  % if designated time has passed (minute)
            set(handles.tx_status,'String','Finished')
            set(handles.tg_start,'String','Start')
            pause(1)
            
            % Save result
            set(handles.tx_status,'String','Saving result...')
            dt = datestr(datetime('now')); % get current time
            dt = regexprep(dt,':','.');
            dt = regexprep(dt,'\s','_');
            save(['result_' dt '.mat'],'result')
            
            % Clear video
            stop(vid);
            delete(vid);
            break
        end
        
        % Update S
        S.runState = runState;
        S.result = result;
        set(handles.fig,'UserData',S)
    end
catch
    % send email!!
    stop(vid);
    delete(vid);
    disp('Error occurred or terminated illegally...')
    % Send email!
    dt = datestr(datetime('now')); % get current time
    recipient = get(handles.ed_email,'string');
    contents = {'Somebody just touched your laptop';...
        sprintf('Date: %s',dt);...
        'Snapshot is attached'};
    title = sprintf('[ALERT] Someone just touched your laptop: %s',dt);
    sender = 'matlabgroup4@gmail.com';
    pwd = '4whghkdlxld';
    imwrite(rawImg,'snapshot.png')
    attach = './snapshot.png';
    try
        matlabmail(recipient,contents,title,sender,pwd,attach)
    catch
        set(handles.tx_status,'String','Email error')
    end
end


function ed_time_Callback(hObject, eventdata, handles)
% hObject    handle to ed_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_time as text
%        str2double(get(hObject,'String')) returns contents of ed_time as a double


% --- Executes during object creation, after setting all properties.
function ed_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cb_record.
function cb_record_Callback(hObject, eventdata, handles)
% hObject    handle to cb_record (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_record



function ed_email_Callback(hObject, eventdata, handles)
% hObject    handle to ed_email (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ed_email as text
%        str2double(get(hObject,'String')) returns contents of ed_email as a double


% --- Executes during object creation, after setting all properties.
function ed_email_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ed_email (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_play.
function pb_play_Callback(hObject, eventdata, handles)
% hObject    handle to pb_play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Retrieve S
S = get(handles.fig,'UserData',S);
set(handles.tx_status,'String','Loading...')
[fname,fpath,fext] = uigetfile('*.mat','Choose .mat file');
fullName = fullfile(fpath,fname,fext);
load(fullName)
playResult(result)
set(handles.tx_status,'String','Playing...')

% --- Executes during object creation, after setting all properties.
function tx_status_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tx_status (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Img = trackMotionLive(framePREV,frameNEXT)
% This function tracks motion from adjascent two input frames
% 2016-01-18

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
diffImg = abs(grayNEXT - grayPREV); % get difference
threshold = 0.5;                % set threshold
img_binary = im2bw(diffImg, threshold);   % image(frame) to binary image(frame)
% imshow(img_binary)

rowvec = sum(img_binary,2); % sum up row wise
rowidx = find(rowvec);          % find indices

%% Motion detection 
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
    Img.left = left;
    Img.head = head;
    Img.width = width;
    Img.height = height;
    Img.rectArea = rectArea;
else
    Img.left = 0;
    Img.head = 0;
    Img.width = 0;
    Img.height = 0;
    Img.rectArea = 0;
end


function matlabmail(recipient, message, subject, sender, psswd, attachments)
% Modified for gmail
% For group 4 only
% smtp and account information should be checked first
%
% usage: MATLABMAIL('EMAIL@korea.ac.kr',{'Hi','Nice to meet you'},'Hello','matlabgroup4@gmail.com','PASSWORD',[])
% usage: MATLABMAIL('EMAIL@korea.ac.kr',{'Hi','Nice to meet you'},'Hello','matlabgroup4@gmail.com','PASSWORD','file.txt')
%
% For more detail:
% http://kr.mathworks.com/help/matlab/ref/sendmail.html
% https://dgleich.wordpress.com/2014/02/27/get-matlab-to-email-you-when-its-done-running/

if nargin < 5
    help matlabmail
    return
end

setpref('Internet','E_mail',sender);
setpref('Internet','SMTP_Server','smtp.gmail.com'); % change here
setpref('Internet','SMTP_Username',sender);
setpref('Internet','SMTP_Password',psswd);

props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', ...
                  'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');
% encoding = slCharacterEncoding()
encoding = 'UTF-8';
setpref('Internet','E_mail_Charset',encoding)

disp('sending email...')
if isempty(attachments)
    sendmail(recipient, subject, message);
    fprintf('email sent to %s\n',recipient)
else
    sendmail(recipient, subject, message, attachments);
    fprintf('email sent to %s with attachment\n',recipient)
end

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
