function varargout = DontTouch(varargin)
% ???????????? ?????????=== ????????? statictext --hello
%              ??????????? statictext--password
%              ???????????? ed_email//pu_email
%              start button --- pb_start
% DONTTOUCH MATLAB code for DontTouch.fig
%      DONTTOUCH, by itself, creates a new DONTTOUCH or raises the existing
%      singleton*.
%
%      H = DONTTOUCH returns the handle to a new DONTTOUCH or the handle to
%      the existing singleton*.
%
%      DONTTOUCH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DONTTOUCH.M with the given input arguments.
%
%      DONTTOUCH('Property','Value',...) creates a new DONTTOUCH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DontTouch_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DontTouch_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DontTouch

% Last Modified by GUIDE v2.5 29-Jan-2016 15:35:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DontTouch_OpeningFcn, ...
                   'gui_OutputFcn',  @DontTouch_OutputFcn, ...
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


% --- Executes just before DontTouch is made visible.
function DontTouch_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DontTouch (see VARARGIN)

% Choose default command line output for DontTouch
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
S.pw=[];
S.mypw='abc';
[y,fs]=audioread('alarm3.wav');
S.player = audioplayer([y;y;y;y;y],fs);
S.key=[];
S.show=[];
S.cam = webcam;

set(handles.figure1,'userdata',S);

% UIWAIT makes DontTouch wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DontTouch_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pb_start.
function pb_start_Callback(hObject, eventdata, handles)
% hObject    handle to pb_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
S=get(handles.figure1,'userdata')
player=S.player;
dt = datestr(datetime('now')); % get current time
id = get(handles.ed_email,'string');  %???????????
site=get(handles.pu_email,'string');   %????????????????????
value=get(handles.pu_email,'value');
recipient=[id,site{value}];
subject='warning';  %?????????????????????
sender='matlabgroup4@gmail.com';  %????????????????????????????
psswd='4whghkdlxld';   %???????????????????????????
attachments='snapshot.png';   %??????????????????????????
contents = {'Somebody just touched your laptop';...
    sprintf('Date: %s',dt)};
string=get(handles.pb_start,'string');
if strcmp(string,'Start')
    set(handles.pb_start,'string','Stop')
    set(handles.pb_start,'enable','off')
elseif strcmp(string,'Stop')
    set(handles.pb_start,'string','Start')
    set(handles.pb_start,'enable','on')
end

set(handles.figure1,'userdata',S);



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


% --- Executes on selection change in pu_email.
function pu_email_Callback(hObject, eventdata, handles)
% hObject    handle to pu_email (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pu_email contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pu_email


% --- Executes during object creation, after setting all properties.
function pu_email_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pu_email (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
S=get(handles.figure1,'userdata');
string=get(handles.pb_start,'string');
player=S.player;
dt = datestr(datetime('now')); % get current time
id = get(handles.ed_email,'string');  %???????????
site=get(handles.pu_email,'string');   %????????????????????
value=get(handles.pu_email,'value');
recipient=[id,site{value}];
subject='warning';  %?????????????????????
sender='matlabgroup4@gmail.com';  %????????????????????????????
psswd='4whghkdlxld';   %???????????????????????????
contents = {'Somebody just touched your laptop';...
    sprintf('Date: %s',dt)};

if strcmp(string,'Stop')
    current=eventdata.Key;
    S.key=[S.key,current];
    pass=get(handles.password,'string')
    pass=[S.key];
    set(handles.password,'string',pass);
    if ~strcmp(current,'a')&&~isempty(current)
        if~isplaying(player)
            a = snapshot(S.cam);
            imshow(a)
            imwrite(a,'snapshot.png');
            attachments = 'snapshot.png';   %??????????????????????????
            play(player)
            set(handles.hello,'string','Do not Touch!!','FontSize',20)
            matlabmail(recipient, contents, subject, sender, psswd, attachments)
            current=[];
        end
    end
    if strcmp(current,'backspace')
        S.pw = S.pw(1:end-1);
        S.show=S.show(1:end-1);
        
    else
        S.pw = [S.pw,current];
        S.show=[S.show,'*'];
        str = S.pw;
        str=num2str(str);
        if  ~isempty(regexp(str,'^abc$','match'));
            set(handles.hello,'string','Right!');
            pause(player)
        elseif strcmp(S.key,S.mypw)
            pause(player)
            set(handles.hello,'string','Hello')
        elseif ~strcmp(S.key,S.mypw)
            play(player)
        end
    end
end


set(handles.password,'string',S.show)
set(handles.figure1,'userdata',S);

function matlabmail(recipient, message, subject, sender, psswd, attachments)
% modified for Gmail
% it only works when the sender uses Gmail
% smtp and account information should be checked first
%
% usage: MATLABMAIL('EMAIL@korea.ac.kr',{'Hi','Nice to meet you'},'Hello','YOUR_EMAIL@korea.ac.kr','YOUR_PASSWORD',[])
% usage: MATLABMAIL('EMAIL@korea.ac.kr',{'Hi','Nice to meet you'},'Hello','YOUR_EMAIL@korea.ac.kr','YOUR_PASSWORD','file.txt')
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
