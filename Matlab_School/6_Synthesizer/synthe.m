function varargout = synthe(varargin)

% Last Modified by GUIDE v2.5 29-Jan-2016 14:26:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name', mfilename, ...
    'gui_Singleton', gui_Singleton, ...
    'gui_OpeningFcn', @synthe_OpeningFcn, ...
    'gui_OutputFcn', @synthe_OutputFcn, ...
    'gui_LayoutFcn', [] , ...
    'gui_Callback',  []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before synthe is made visible.
function synthe_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;

set(handles.ax_main, 'XLim', [0 768], 'YLim', [0 500], 'XTick', 0:48:768, ...
    'XMinorTick', 'on', 'YTick', 0:20:500, 'YTickLabel', [], ...
     'XTickLabel', {1; ''; ''; '';  2; ''; ''; '';  3; ''; ''; '';  4;  ''; ''; ''; ''});

tabGroup = uitabgroup(handles.fig, 'unit', 'pixel', 'position', [975 460 200 200]);
t1 = uitab(tabGroup, 'backgroundcolor', [.9 .9 .9], ...
    'title', '<html><b><i><font size="3" color="blue">Waveform</font>');
handles.ax_wave = axes('parent', t1, 'unit', 'pixel', 'Position', [15 5 150 150]);
t2 = uitab(tabGroup, 'backgroundcolor', [.9 .9 .9], ...
    'title', '<html><b><i><font size="3" color="green">ADSR</font>');

adsr.f = [1 2 3 4 5];
adsr.v = [0 0; .2 1; .5 .5; .8 .5; 1 0];
adsr.c = [1 0 0; 0 0 1; 1 0 1; 0 1 0; 1 1 0];
adsr.ah = axes('parent', t2, 'unit', 'pix', 'position', [25 5 150 150], ...
    'box', 'on', 'xlim', [0 1], 'ylim', [0 1.5], 'xtick', [0 .2 .4 .6 .8 1], ...
    'ytick', [0 .25 .50 .75 1 1.25 1.5], 'yticklabel', [0 25 50 75 100 125 150]);
adsr.p = patch('faces', adsr.f, 'vertices', adsr.v, 'facevertexcdata', adsr.c, ...
    'edgecolor', 'interp', 'facecolor', 'none', 'linewidth', 2, ...
    'marker', 'o', 'markersize', 10, 'parent', adsr.ah);

% Change the ax_main's backgruond color by making line function (to make distinct boundary line between white and black keys)
X= [0 768];
Y= [30 30; 70 70; 130 130; 170 170; 210 210; 270 270; 310 310; 370 370; 410 410; 450 450];
for i = 1:length(Y)
    line(X,Y(i,:), 'Parent', handles.ax_main, 'linewidth', 16, ...
        'color', [0.1 0.1 0.1 .3]);
end

% Version check
if strcmp(version('-release'), '2015b')
    handles.ax_main.XRuler.MinorTickValues = 0:12:768;
else
    handles.ax_main.XRuler.MinorTick = 0:12:768;
end

% Color the piano keys
black = zeros(20,108,3);
white1 = ones(30,140,3);
white2 = ones(40,140,3);
white3 = ones(20,140,3);

set([handles.pb_Ab4, handles.pb_Db3, handles.pb_Eb3, handles.pb_Gb3, ...
    handles.pb_Ab3, handles.pb_Bb3, handles.pb_Db4, handles.pb_Eb4, ...
    handles.pb_Gb4, handles.pb_Bb4], 'Cdata', black);
set([handles.pb_C3, handles.pb_E3, handles.pb_F3, handles.pb_B3, ...
    handles.pb_C4, handles.pb_E4, handles.pb_F4, handles.pb_B4], 'Cdata', white1);
set([handles.pb_D3, handles.pb_G3, handles.pb_A3, handles.pb_D4, ...
    handles.pb_G4, handles.pb_A4], 'Cdata', white2);
set(handles.pb_C5, 'Cdata', white3);

% Make the structure for later elements
S = struct('notelength', 47, 'patchdata', zeros(128, 25));
S.freq = [130.81; 138.59; 146.83; 155.56; 164.81; 174.61; 185; 196; ...
    207.65; 220; 233.08; 246.94; 261.625; 277.18; 293.66; 311.13; ...
    329.63; 349.23; 369.99; 392; 415.3; 440; 466.16; 493.88; 523.25];

set(handles.fig, 'WindowButtonMotionFcn', '');

W = struct('pop_osc1', 1, 'pop_osc2', 1, ...
    'osc1', sin(2*pi*220*(0:1/20000:1)), ...
    'osc2', zeros(1, 20001), 'ratio', 0.5, ...
    'att', 0.1, 'dec', 0.2, 'sus', 0.7, 'rel', 0.1, 'dep', 1, ...
    'filter', designfilt('highpassfir', 'StopbandFrequency', 0.001, ...
    'PassbandFrequency', 0.101, 'PassbandRipple', 0.5, ...
    'StopbandAttenuation',65), 'cut', 0.101, 'res', 0, 'userwave', []);

for i = 1:25            % put sine wave sound when press the play button not pressing the apply button
    S.waves(i,1) = W;
end

set(handles.ax_main, 'userdata', S);
exe(handles, W, 220, 1, handles.ax_wave);
set(handles.ax_wave, 'UserData', W);
set(handles.sl_osc, 'Enable', 'inactive');
Si = W;
Si.rec = zeros(25,1);

R = struct('rec', []);
set(handles.pb_rec, 'userdata', R);
set(handles.pb_C3, 'userdata', Si);
set(handles.sl_cut, 'value', 0.101);

unitbeat = 60/str2double(get(handles.ed_bpm, 'String'));
handles.unitbeat = unitbeat;

logo = imread('6G_logo.png');
axes(handles.ax_logo)
imshow(logo);

% Update handles structure
guidata(hObject, handles);



function varargout = synthe_OutputFcn(hObject, eventdata, handles)
% Get default command line output from handles structure
varargout{1} = handles.output;



function pb_C5_Callback(hObject, eventdata, handles)
white = ones(20,140,3);         % Change the color of the pressed keys
blue(:,:,1) = ones(20,140)*.3;
blue(:,:,2) = ones(20,140)*.75;
blue(:,:,3) = ones(20,140)*.93;
Si = get(handles.pb_C3, 'userdata');
freq = 523.25;
if handles.pb_C5.Value == 1         % Sound the pressed keys
    singit(handles, Si, freq);
    set(handles.pb_C5, 'Cdata', blue);
else handles.pb_C5.Value == 0;
    set(handles.pb_C5, 'Cdata', white);
end



function pb_B4_Callback(hObject, eventdata, handles)
white = ones(30,140,3);
blue(:,:,1) = ones(20,140)*.3;
blue(:,:,2) = ones(20,140)*.75;
blue(:,:,3) = ones(20,140)*.93;
Si = get(handles.pb_C3, 'userdata');
freq = 493.88;
if handles.pb_B4.Value == 1
    singit(handles, Si, freq);
    set(handles.pb_B4, 'Cdata',blue);
else handles.pb_B4.Value == 0;
    set(handles.pb_B4, 'Cdata',white);
end



function pb_A4_Callback(hObject, eventdata, handles)
white = ones(30,140,3);
blue(:,:,1) = ones(20,140)*.3;
blue(:,:,2) = ones(20,140)*.75;
blue(:,:,3) = ones(20,140)*.93;
Si = get(handles.pb_C3, 'userdata');
freq = 440;
if handles.pb_A4.Value == 1
    singit(handles, Si, freq);
    set(handles.pb_A4, 'Cdata',blue);
else handles.pb_A4.Value == 0;
    set(handles.pb_A4, 'Cdata',white);
end



function pb_G4_Callback(hObject, eventdata, handles)
white = ones(30,140,3);
blue(:,:,1) = ones(20,140)*.3;
blue(:,:,2) = ones(20,140)*.75;
blue(:,:,3) = ones(20,140)*.93;
Si = get(handles.pb_G4, 'userdata');
freq = 392;
if handles.pb_G4.Value == 1
    singit(handles, Si, freq);
    set(handles.pb_G4, 'Cdata',blue);
else handles.pb_G4.Value == 0;
    set(handles.pb_G4, 'Cdata',white);
end



function pb_F4_Callback(hObject, eventdata, handles)
white = ones(30,140,3);
blue(:,:,1) = ones(20,140)*.3;
blue(:,:,2) = ones(20,140)*.75;
blue(:,:,3) = ones(20,140)*.93;
Si = get(handles.pb_F4, 'userdata');
freq = 349.23;
if handles.pb_F4.Value == 1
    singit(handles, Si, freq);
    set(handles.pb_F4, 'Cdata',blue);
else handles.pb_F4.Value == 0;
    set(handles.pb_F4, 'Cdata',white);
end



function pb_E4_Callback(hObject, eventdata, handles)
white = ones(30,140,3);
blue(:,:,1) = ones(20,140)*.3;
blue(:,:,2) = ones(20,140)*.75;
blue(:,:,3) = ones(20,140)*.93;
Si = get(handles.pb_C3, 'userdata');
freq = 329.63;
if handles.pb_E4.Value == 1
    singit(handles, Si, freq);
    set(handles.pb_E4, 'Cdata',blue);
else handles.pb_E4.Value == 0;
    set(handles.pb_E4, 'Cdata',white);
end



function pb_D4_Callback(hObject, eventdata, handles)
white = ones(30,140,3);
blue(:,:,1) = ones(20,140)*.3;
blue(:,:,2) = ones(20,140)*.75;
blue(:,:,3) = ones(20,140)*.93;
Si = get(handles.pb_C3, 'userdata');
freq = 293.66;
if handles.pb_D4.Value == 1
    singit(handles, Si, freq);
    set(handles.pb_D4, 'Cdata',blue);
else handles.pb_D4.Value == 0;
    set(handles.pb_D4, 'Cdata',white);
end



function pb_C4_Callback(hObject, eventdata, handles)
white = ones(30,140,3);
blue(:,:,1) = ones(20,140)*.3;
blue(:,:,2) = ones(20,140)*.75;
blue(:,:,3) = ones(20,140)*.93;
Si = get(handles.pb_C3, 'userdata');
freq = 261.625;
if handles.pb_C4.Value == 1
    singit(handles, Si, freq);
    set(handles.pb_C4, 'Cdata',blue);
else handles.pb_C4.Value == 0;
    set(handles.pb_C4, 'Cdata',white);
end



function pb_B3_Callback(hObject, eventdata, handles)
white = ones(30,140,3);
blue(:,:,1) = ones(20,140)*.3;
blue(:,:,2) = ones(20,140)*.75;
blue(:,:,3) = ones(20,140)*.93;
Si = get(handles.pb_C3, 'userdata');
freq = 246.94;
if handles.pb_B3.Value == 1
    singit(handles, Si, freq);
    set(handles.pb_B3, 'Cdata',blue);
else handles.pb_B3.Value == 0;
    set(handles.pb_B3, 'Cdata',white);
end



function pb_A3_Callback(hObject, eventdata, handles)
white = ones(30,140,3);
blue(:,:,1) = ones(20,140)*.3;
blue(:,:,2) = ones(20,140)*.75;
blue(:,:,3) = ones(20,140)*.93;
Si = get(handles.pb_C3, 'userdata');
freq = 220;
if handles.pb_A3.Value == 1
    singit(handles, Si, freq);
    set(handles.pb_A3, 'Cdata',blue);
else handles.pb_A3.Value == 0;
    set(handles.pb_A3, 'Cdata',white);
end



function pb_G3_Callback(hObject, eventdata, handles)
white = ones(30,140,3);
blue(:,:,1) = ones(20,140)*.3;
blue(:,:,2) = ones(20,140)*.75;
blue(:,:,3) = ones(20,140)*.93;
Si = get(handles.pb_C3, 'userdata');
freq = 196;
if handles.pb_G3.Value == 1
    singit(handles, Si, freq);
    set(handles.pb_G3, 'Cdata',blue);
else handles.pb_G3.Value == 0;
    set(handles.pb_G3, 'Cdata',white);
end



function pb_E3_Callback(hObject, eventdata, handles)
white = ones(30,140,3);
blue(:,:,1) = ones(20,140)*.3;
blue(:,:,2) = ones(20,140)*.75;
blue(:,:,3) = ones(20,140)*.93;
Si = get(handles.pb_C3, 'userdata');
freq = 164.81;
if handles.pb_E3.Value == 1
    singit(handles, Si, freq);
    set(handles.pb_E3, 'Cdata',blue);
else handles.pb_E3.Value == 0;
    set(handles.pb_E3, 'Cdata',white);
end



function pb_F3_Callback(hObject, eventdata, handles)
white = ones(30,140,3);
blue(:,:,1) = ones(20,140)*.3;
blue(:,:,2) = ones(20,140)*.75;
blue(:,:,3) = ones(20,140)*.93;
Si = get(handles.pb_C3, 'userdata');
freq = 174.61;
if handles.pb_F3.Value == 1
    singit(handles, Si, freq);
    set(handles.pb_F3, 'Cdata',blue);
else handles.pb_F3.Value == 0;
    set(handles.pb_F3, 'Cdata',white);
end



function pb_D3_Callback(hObject, eventdata, handles)
white = ones(30,140,3);
blue(:,:,1) = ones(20,140)*.3;
blue(:,:,2) = ones(20,140)*.75;
blue(:,:,3) = ones(20,140)*.93;
Si = get(handles.pb_C3, 'userdata');
freq = 146.83;
if handles.pb_D3.Value == 1
    singit(handles, Si, freq);
    set(handles.pb_D3, 'Cdata',blue);
else handles.pb_D3.Value == 0;
    set(handles.pb_D3, 'Cdata',white);
end



function pb_C3_Callback(hObject, eventdata, handles)
white = ones(30,140,3);
blue(:,:,1) = ones(20,140)*.3;
blue(:,:,2) = ones(20,140)*.75;
blue(:,:,3) = ones(20,140)*.93;
Si = get(handles.pb_C3, 'userdata');
freq = 130.81;
if handles.pb_C3.Value == 1
    singit(handles, Si, freq);
    set(handles.pb_C3, 'Cdata',blue);
else handles.pb_C3.Value == 0;
    set(handles.pb_C3, 'Cdata',white);
end



function pb_Bb4_Callback(hObject, eventdata, handles)
black = zeros(20,108,3);
darkblue(:,:,1) = zeros(20,108);
darkblue(:,:,2) = ones(20,108)*.45;
darkblue(:,:,3) = ones(20,108)*.74;
Si = get(handles.pb_C3, 'userdata');
freq = 466.16;
if handles.pb_Bb4.Value == 1
    singit(handles, Si, freq);
    set(handles.pb_Bb4, 'Cdata',darkblue);
else handles.pb_Bb4.Value == 0;
    set(handles.pb_Bb4, 'Cdata',black);
end



function pb_Ab4_Callback(hObject, eventdata, handles)
black = zeros(20,108,3);
darkblue(:,:,1) = zeros(20,108);
darkblue(:,:,2) = ones(20,108)*.45;
darkblue(:,:,3) = ones(20,108)*.74;
Si = get(handles.pb_C3, 'userdata');
freq = 415.3;
if handles.pb_Ab4.Value == 1
    singit(handles, Si, freq);
    set(handles.pb_Ab4, 'Cdata', darkblue);
else handles.pb_Ab4.Value == 0;
    set(handles.pb_Ab4, 'Cdata', black);
end



function pb_Gb4_Callback(hObject, eventdata, handles)
black = zeros(20,108,3);
darkblue(:,:,1) = zeros(20,108);
darkblue(:,:,2) = ones(20,108)*.45;
darkblue(:,:,3) = ones(20,108)*.74;
Si = get(handles.pb_C3, 'userdata');
freq = 369.99;
if handles.pb_Gb4.Value == 1
    singit(handles, Si, freq);
    set(handles.pb_Gb4, 'Cdata',darkblue);
else handles.pb_Gb4.Value == 0;
    set(handles.pb_Gb4, 'Cdata',black);
end


function pb_Eb4_Callback(hObject, eventdata, handles)
black = zeros(20,108,3);
darkblue(:,:,1) = zeros(20,108);
darkblue(:,:,2) = ones(20,108)*.45;
darkblue(:,:,3) = ones(20,108)*.74;
Si = get(handles.pb_C3, 'userdata');
freq = 311.13;
if handles.pb_Eb4.Value == 1
    singit(handles, Si, freq);
    set(handles.pb_Eb4, 'Cdata',darkblue);
else handles.pb_Eb4.Value == 0;
    set(handles.pb_Eb4, 'Cdata',black);
end



function pb_Db4_Callback(hObject, eventdata, handles)
black = zeros(20,108,3);
darkblue(:,:,1) = zeros(20,108);
darkblue(:,:,2) = ones(20,108)*.45;
darkblue(:,:,3) = ones(20,108)*.74;
Si = get(handles.pb_C3, 'userdata');
freq = 277.18;
if handles.pb_Db4.Value == 1
    singit(handles, Si, freq);
    set(handles.pb_Db4, 'Cdata',darkblue);
else handles.pb_Db4.Value == 0;
    set(handles.pb_Db4, 'Cdata',black);
end



function pb_Bb3_Callback(hObject, eventdata, handles)
black = zeros(20,108,3);
darkblue(:,:,1) = zeros(20,108);
darkblue(:,:,2) = ones(20,108)*.45;
darkblue(:,:,3) = ones(20,108)*.74;
Si = get(handles.pb_C3, 'userdata');
freq = 233.08;
if handles.pb_Bb3.Value == 1
    singit(handles, Si, freq);
    set(handles.pb_Bb3, 'Cdata',darkblue);
else handles.pb_Bb3.Value == 0;
    set(handles.pb_Bb3, 'Cdata',black);
end



function pb_Ab3_Callback(hObject, eventdata, handles)
black = zeros(20,108,3);
darkblue(:,:,1) = zeros(20,108);
darkblue(:,:,2) = ones(20,108)*.45;
darkblue(:,:,3) = ones(20,108)*.74;
Si = get(handles.pb_C3, 'userdata');
freq = 207.65;
if handles.pb_Ab3.Value == 1
    singit(handles, Si, freq);
    set(handles.pb_Ab3, 'Cdata',darkblue);
else handles.pb_Ab3.Value == 0;
    set(handles.pb_Ab3, 'Cdata',black);
end



function pb_Gb3_Callback(hObject, eventdata, handles)
black = zeros(20,108,3);
darkblue(:,:,1) = zeros(20,108);
darkblue(:,:,2) = ones(20,108)*.45;
darkblue(:,:,3) = ones(20,108)*.74;
Si = get(handles.pb_C3, 'userdata');
freq = 185;
if handles.pb_Gb3.Value == 1
    singit(handles, Si, freq);
    set(handles.pb_Gb3, 'Cdata',darkblue);
else handles.pb_Gb3.Value == 0;
    set(handles.pb_Gb3, 'Cdata',black);
end



function pb_Eb3_Callback(hObject, eventdata, handles)
black = zeros(20,108,3);
darkblue(:,:,1) = zeros(20,108);
darkblue(:,:,2) = ones(20,108)*.45;
darkblue(:,:,3) = ones(20,108)*.74;
Si = get(handles.pb_C3, 'userdata');
freq = 155.56;
if handles.pb_Eb3.Value == 1
    singit(handles, Si, freq);
    set(handles.pb_Eb3, 'Cdata',darkblue);
else handles.pb_Eb3.Value == 0;
    set(handles.pb_Eb3, 'Cdata',black);
end



function pb_Db3_Callback(hObject, eventdata, handles)
black = zeros(20,108,3);
darkblue(:,:,1) = zeros(20,108);
darkblue(:,:,2) = ones(20,108)*.45;
darkblue(:,:,3) = ones(20,108)*.74;
Si = get(handles.pb_C3, 'userdata');
freq = 138.59;
if handles.pb_Db3.Value == 1
    singit(handles, Si, freq);
    set(handles.pb_Db3, 'Cdata',darkblue);
else handles.pb_Db3.Value == 0;
    set(handles.pb_Db3, 'Cdata',black);
end



function pb_load_Callback(hObject, eventdata, handles)
filename = uigetfile('*.fig');
openfig(filename);



function pb_save_Callback(hObject, eventdata, handles)
h = handles.ax_main;
[filename, filepath] = uiputfile('*.fig');
saveas(h, filename);



function ed_bpm_Callback(hObject, eventdata, handles)
bpm     = str2double(get(hObject, 'String'));           % Saves the typed BPM by user
unitbeat = 60/bpm;
handles.unitbeat = unitbeat;
guidata(handles.fig, handles);



function ed_bpm_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pb_play_Callback(hObject, eventdata, handles)
pb_name = get(handles.pb_play, 'String');

switch pb_name
    case 'play'
        S = get(handles.ax_main, 'userdata');
        Si = get(handles.pb_C3, 'userdata');
        R = get(handles.pb_rec, 'userdata');
        R.rec = [R.rec; zeros(10000000,1)];
        W = get(handles.ax_wave, 'userdata');
        unitbeat = handles.unitbeat;
        S.modpatch = [];
        S.score = [];
        for i = 1:25
            if Si.rec(i,1) == 0
                for j = 1:128
                    if S.patchdata(j,i) > 0
                        S.modpatch(i,(j-1)*2500*unitbeat+1:(j-1)*2500*...
                            unitbeat+S.patchdata(j,i)/48*20000*unitbeat...
                            +W.rel*20000) = modifypatch(handles,...
                            S.waves(i,1), S.freq(i), S.patchdata(j,i));
                    end
                end
            elseif Si.rec(i,1) ==1
                for j = 1:128
                    if S.patchdata(j,i) > 0
                        rwave = R.waves{i,1};
                        S.modpatch(i,(j-1)*2500*unitbeat+1:(j-1)*2500*...
                            unitbeat+S.patchdata(j,i)/48*20000*unitbeat)...
                            = rwave(1:S.patchdata(j,i)/48*20000*unitbeat);
                    end
                end
            end
        end
        S.score = sum(S.modpatch);
        S.player = audioplayer(S.score, 20000);
        set(S.player, 'TimerFcn', {@c_bar,handles.ax_main}, 'TimerPeriod', .005);        
        play(S.player)
        set(handles.pb_play, 'String', 'pause')
        set(handles.ax_main, 'userdata', S);
    case 'pause'
        S = get(handles.ax_main, 'UserData');
        pause(S.player)
        set(handles.pb_play, 'String', 'resume')
    case 'resume'
        S = get(handles.ax_main, 'UserData');
        if S.player.CurrentSample > 1;
            resume(S.player)
            set(handles.pb_play, 'String', 'pause')
        else
            set(handles.pb_play, 'String', 'play')
        end
end



function pb_stop_Callback(hObject, eventdata, handles)
S = get(handles.ax_main, 'UserData');
S.player = audioplayer(S.score, 20000);
stop(S.player)
set(handles.ax_main, 'UserData', S)
set(handles.pb_play, 'String', 'play')



function pop_note_Callback(hObject, eventdata, handles)

function pop_note_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function fig_WindowButtonDownFcn(hObject, eventdata, handles)
S = get(handles.ax_main, 'userdata');
if handles.pop_note.Value == 1.0           % Load a note length data from pop_note
    S.notelength = 95;
elseif handles.pop_note.Value == 2.0
    S.notelength = 47;
elseif handles.pop_note.Value == 3.0
    S.notelength = 23;
elseif handles.pop_note.Value == 4.0
    S.notelength = 11;
elseif handles.pop_note.Value == 5.0
    S.notelength = 5;
end
hold(handles.ax_main,'on')
if strcmp(get(gcf, 'SelectionType'),'normal')
    if or(strcmp(get(gco, 'Tag'), 'ax_main'), strcmp(get(gco, 'Type'), 'line'))  % if you click ax_main, a patch is drawn
        cp = get(handles.ax_main, 'CurrentPoint');
        pp = [6*floor(cp(1,1)/6),20*floor(cp(1,2)/20)];
        x = [pp(1,1), pp(1,1) + S.notelength, pp(1,1) + S.notelength, pp(1,1)];
        y = [pp(1,2), pp(1,2), pp(1,2)+20, pp(1,2)+20];
        pat =  patch(x,y,'green');
        pat.FaceVertexAlphaData = 0.7;
        pat.FaceAlpha = 'flat';
        pat.FaceColor = [0.3 0.9 0.3];
        pat.LineWidth = 0.05;
        pat.EdgeColor = 'g';
        
        S.patchdata(floor(cp(1,1)/6)+1, floor(cp(1,2)/20)+1) = S.notelength+1;    % The patchdata is saved
        set(handles.ax_main, 'userdata', S);
        
    elseif strcmp(get(gco, 'Type'), 'patch')
        S.patch = gco;
        S.startpoint = get(handles.ax_main, 'CurrentPoint');
        set(S.patch,'UserData', {get(S.patch, 'XData') get(S.patch, 'YData')});
        set(handles.ax_main, 'userdata', S);
    end
elseif strcmp(get(gcf, 'SelectionType'),'alt')
    if strcmp(get(gco, 'Type'),'patch')               % if you right-click patch, it is erased.
        xdata = get(gco, 'XData');
        ydata = get(gco, 'YData');
        S.patchdata(floor(xdata(1)/6)+1, floor(ydata(1)/20)+1) = 0;
        delete(gco);
        set(handles.ax_main, 'userdata', S);
    end
end
set(handles.fig, 'WindowButtonMotionFcn', {@fig_WindowButtonMotionFcn,handles});



function fig_WindowButtonMotionFcn(hObject, eventdata, handles)
S = get(handles.ax_main, 'userdata');
if strcmp(get(gco, 'type'),'patch');
    if strcmp(get(gcf, 'SelectionType'),'extend')            % If your selctoion type is 'extend',
        cp = get(handles.ax_main, 'CurrentPoint');           % when you dragging patch, patch's length is chagned
        pp = [6*floor(cp(1,1)/6),20*floor(cp(1,2)/20)];
        greenP = gco;
        x=get(greenP,'xdata');
        y=get(greenP,'ydata');
        if pp(1,1) > x(1)
            set(greenP,'x',[x(1), pp(1,1), pp(1,1), x(4)]);
            S.patchdata(floor(x(1)/6)+1, floor(y(1)/20)+1) = pp(1,1) - x(1);
            set(handles.ax_main, 'userdata', S);
        end
    elseif strcmp(get(gcf, 'SelectionType'),'normal')           % If you click and drag the patch, patch is moving
        pos = get(gca,'CurrentPoint')-S.startpoint;
        XYData = get(S.patch,'UserData');
        S.patchdata(floor(S.patch.XData(1)/6)+1, floor(S.patch.YData(1)/20)+1)=0;
        xdata = XYData{1} + 6*floor(pos(1,1)/6);
        ydata = 20*floor((XYData{2} + pos(1,2))/20);
        set(S.patch,'XData', xdata);
        set(S.patch,'YData', ydata);        
        S.patchdata(floor(xdata(1)/6)+1, floor(ydata(1)/20)+1) = xdata(2) - xdata(1) + 1;
        set(handles.ax_main, 'userdata', S);
        drawnow;
    end
end



function fig_WindowButtonUpFcn(hObject, eventdata, handles)
set(handles.fig, 'WindowButtonMotionFcn', '');



function pop_osc1_Callback(hObject, eventdata, handles)
W = get(handles.ax_wave, 'userdata');
W.pop_osc1 = hObject.Value;
exe(handles, W, 220, 1, handles.ax_wave);



function pop_osc1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pop_osc2_Callback(hObject, eventdata, handles)
W = get(handles.ax_wave, 'userdata');
W.pop_osc2 = hObject.Value;
exe(handles, W, 220, 1, handles.ax_wave);



function pop_osc2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sl_osc_Callback(hObject, eventdata, handles)
W = get(handles.ax_wave, 'userdata');
W.ratio = get(hObject, 'value');
exe(handles, W, 220, 1, handles.ax_wave);
set(handles.ax_wave, 'UserData', W);



function sl_osc_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function pb_apply_Callback(hObject, eventdata, handles)
W = get(handles.ax_wave,'userdata');
S = get(handles.ax_main, 'userdata');
Si = get(handles.pb_C3, 'userdata');
if get(handles.pb_C3,'Value') ==1
    S.waves(1,1) = W;
    set(handles.ax_main, 'userdata', S);
    Si.rec(1,1) = 0;
    set(handles.pb_C3, 'userdata', Si);
end
if get(handles.pb_Db3,'Value') ==1
    S.waves(2,1) = W;
    set(handles.ax_main, 'userdata', S);
    Si.rec(2,1) = 0;
    set(handles.pb_C3, 'userdata', Si);
end
if get(handles.pb_D3,'Value') ==1
    S.waves(3,1) = W;
    set(handles.ax_main, 'userdata', S);
    Si.rec(3,1) = 0;
    set(handles.pb_C3, 'userdata', Si);
end
if get(handles.pb_Eb3,'Value') ==1
    S.waves(4,1) = W;
    set(handles.ax_main, 'userdata', S);
    Si.rec(4,1) = 0;
    set(handles.pb_C3, 'userdata', Si);
end
if get(handles.pb_E3,'Value') ==1
    S.waves(5,1) = W;
    set(handles.ax_main, 'userdata', S);
    Si.rec(5,1) = 0;
    set(handles.pb_C3, 'userdata', Si);
end
if get(handles.pb_F3,'Value') ==1
    S.waves(6,1) = W;
    set(handles.ax_main, 'userdata', S);
    Si.rec(6,1) = 0;
    set(handles.pb_C3, 'userdata', Si);
end
if get(handles.pb_Gb3,'Value') ==1
    S.waves(7,1) = W;
    set(handles.ax_main, 'userdata', S);
    Si.rec(7,1) = 0;
    set(handles.pb_C3, 'userdata', Si);
end
if get(handles.pb_G3,'Value') ==1
    S.waves(8,1) = W;
    set(handles.ax_main, 'userdata', S);
    Si.rec(8,1) = 0;
    set(handles.pb_C3, 'userdata', Si);
end
if get(handles.pb_Ab3,'Value') ==1
    S.waves(9,1) = W;
    set(handles.ax_main, 'userdata', S);
    Si.rec(9,1) = 0;
    set(handles.pb_C3, 'userdata', Si);
end
if get(handles.pb_A3,'Value') ==1
    S.waves(10,1) = W;
    set(handles.ax_main, 'userdata', S);
    Si.rec(10,1) = 0;
    set(handles.pb_C3, 'userdata', Si);
end
if get(handles.pb_Bb3,'Value') ==1
    S.waves(11,1) = W;
    set(handles.ax_main, 'userdata', S);
    Si.rec(11,1) = 0;
    set(handles.pb_C3, 'userdata', Si);
end
if get(handles.pb_B3,'Value') ==1
    S.waves(12,1) = W;
    set(handles.ax_main, 'userdata', S);
    Si.rec(12,1) = 0;
    set(handles.pb_C3, 'userdata', Si);
end
if get(handles.pb_C4,'Value') ==1
    S.waves(13,1) = W;
    set(handles.ax_main, 'userdata', S);
    Si.rec(13,1) = 0;
    set(handles.pb_C3, 'userdata', Si);
end
if get(handles.pb_Db4,'Value') ==1
    S.waves(14,1) = W;
    set(handles.ax_main, 'userdata', S);
    Si.rec(14,1) = 0;
    set(handles.pb_C3, 'userdata', Si);
end
if get(handles.pb_D4,'Value') ==1
    S.waves(15,1) = W;
    set(handles.ax_main, 'userdata', S);
    Si.rec(15,1) = 0;
    set(handles.pb_C3, 'userdata', Si);
end
if get(handles.pb_Eb4,'Value') ==1
    S.waves(16,1) = W;
    set(handles.ax_main, 'userdata', S);
    Si.rec(16,1) = 0;
    set(handles.pb_C3, 'userdata', Si);
end
if get(handles.pb_E4,'Value') ==1
    S.waves(17,1) = W;
    set(handles.ax_main, 'userdata', S);
    Si.rec(17,1) = 0;
    set(handles.pb_C3, 'userdata', Si);
end
if get(handles.pb_F4,'Value') ==1
    S.waves(18,1) = W;
    set(handles.ax_main, 'userdata', S);
    Si.rec(18,1) = 0;
    set(handles.pb_C3, 'userdata', Si);
end
if get(handles.pb_Gb4,'Value') ==1
    S.waves(19,1) = W;
    set(handles.ax_main, 'userdata', S);
    Si.rec(19,1) = 0;
    set(handles.pb_C3, 'userdata', Si);
end
if get(handles.pb_G4,'Value') ==1
    S.waves(20,1) = W;
    set(handles.ax_main, 'userdata', S);
    Si.rec(20,1) = 0;
    set(handles.pb_C3, 'userdata', Si);
end
if get(handles.pb_Ab4,'Value') ==1
    S.waves(21,1) = W;
    set(handles.ax_main, 'userdata', S);
    Si.rec(21,1) = 0;
    set(handles.pb_C3, 'userdata', Si);
end
if get(handles.pb_A4,'Value') ==1
    S.waves(22,1) = W;
    set(handles.ax_main, 'userdata', S);
    Si.rec(22,1) = 0;
    set(handles.pb_C3, 'userdata', Si);
end
if get(handles.pb_Bb4,'Value') ==1
    S.waves(23,1) = W;
    set(handles.ax_main, 'userdata', S);
    Si.rec(23,1) = 0;
    set(handles.pb_C3, 'userdata', Si);
end
if get(handles.pb_B4,'Value') ==1
    S.waves(24,1) = W;
    set(handles.ax_main, 'userdata', S);
    Si.rec(24,1) = 0;
    set(handles.pb_C3, 'userdata', Si);
end
if get(handles.pb_C5,'Value') ==1
    S.waves(25,1) = W;
    set(handles.ax_main, 'userdata', S);
    Si.rec(25,1) = 0;
    set(handles.pb_C3, 'userdata', Si);
end



function pb_applyall_Callback(hObject, eventdata, handles)
S = get(handles.ax_main, 'userdata');
W = get(handles.ax_wave, 'userdata');
for i = 1:25
    S.waves(i,1) = W;
    set(handles.ax_main, 'userdata', S);
end



function sl_cut_Callback(hObject, eventdata, handles)
W = get(handles.ax_wave, 'userdata');
W.cut = get(hObject, 'value');
exe(handles, W, 220, 1, handles.ax_wave);
set(handles.ax_wave, 'UserData', W);
cut = handles.sl_cut.Value;
handles.tx_cut.String = cut;



function sl_cut_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function sl_res_Callback(hObject, eventdata, handles)
W = get(handles.ax_wave, 'userdata');
W.res = hObject.Value;
exe(handles, W, 220, 1, handles.ax_wave);
set(handles.ax_wave, 'userdata', W);
res = handles.sl_res.Value;
handles.tx_res.String = res;



function sl_res_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function tx_cut_Callback(hObject, eventdata, handles)

function tx_cut_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tx_res_Callback(hObject, eventdata, handles)

function tx_res_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pb_rec_Callback(hObject, eventdata, handles)
S = get(handles.ax_main, 'userdata');
W = get(handles.ax_wave, 'userdata');
R = get(hObject, 'userdata');

% Record the sound user want to apply to key
rec1 = audiorecorder(20000, 16, 1);
disp('Start recording.')
recordblocking(rec1, handles.unitbeat*(S.notelength+1)/48+0.1);
disp('End of Recording.')
R.rec = getaudiodata(rec1);
R.rec = R.rec(2001:end);
plot(handles.ax_wave, R.rec);
set(handles.ax_wave, 'userdata', W);
set(hObject, 'userdata', R);



function sl_a_Callback(hObject, eventdata, handles)
W = get(handles.ax_wave, 'userdata');
W.att = hObject.Value;
set(handles.ax_wave, 'userdata', W);



function sl_a_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function sl_d_Callback(hObject, eventdata, handles)
W = get(handles.ax_wave, 'userdata');
W.dec = hObject.Value;
set(handles.ax_wave, 'userdata', W);



function sl_d_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function sl_s_Callback(hObject, eventdata, handles)
W = get(handles.ax_wave, 'userdata');
W.sus = hObject.Value;
set(handles.ax_wave, 'userdata', W);



function sl_s_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function sl_r_Callback(hObject, eventdata, handles)
W = get(handles.ax_wave, 'userdata');
W.rel = hObject.Value;
set(handles.ax_wave, 'userdata', W);



function sl_r_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function sl_dep_Callback(hObject, eventdata, handles)
W = get(handles.ax_wave, 'userdata');
W.dep = hObject.Value;
set(handles.ax_wave, 'userdata', W);



function sl_dep_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function pb_sound_Callback(hObject, eventdata, handles)
% sound the wave made by user in oscillator
W = get(handles.ax_wave, 'userdata');
userwave = exe(handles, W, 220, 1, handles.ax_wave);
attack = linspace(0, 1, W.att*20000+1);
decay = linspace(1, W.sus, W.dec*20000);
sustain = W.sus*ones(1, ceil(1*20000 - W.att*20000 - W.dec*20000));
release = linspace(W.sus, 0, W.rel*20000);
userwave = userwave.*[attack decay sustain release];
sound(userwave, 20000);
set(handles.ax_wave, 'userdata', W);



% userwave function
function userwave = exe(handles, W, freq, sec, ax)
time = 0:1/20000:sec+W.rel;
x = 2*pi*freq*time;
pop_osc1 = get(handles.pop_osc1);
pop_osc2 = get(handles.pop_osc2);
switch pop_osc1.Value
    case 1        % sine wave
        W.osc1 = sin(x);
        set(handles.ax_wave, 'userdata', W);
    case 2  % pulse wave
        W.osc1 = square(x, 30);
        set(handles.ax_wave, 'userdata', W);
    case 3  % square wave
        W.osc1 = square(x);
        set(handles.ax_wave, 'userdata', W);
    case 4  % sawtooth wave
        W.osc1 = sawtooth(x-pi);
        set(handles.ax_wave, 'userdata', W);
    case 5  % triangle wave
        W.osc1 = sawtooth(x+0.5*pi, 0.5);
        set(handles.ax_wave, 'userdata', W);
end
switch pop_osc2.Value
    case 1
        W.osc2 = 0*x;
        W.ratio = 1;
        set(handles.ax_wave, 'userdata', W);
        set(handles.sl_osc, 'Enable', 'inactive');
    case 2        % sine wave
        W.osc2 = sin(x);
        W.ratio = get(handles.sl_osc, 'value');
        set(handles.sl_osc, 'Enable', 'on');
        set(handles.ax_wave, 'userdata', W);
    case 3  % pulse wave
        W.osc2 = square(x, 30);
        W.ratio = get(handles.sl_osc, 'value');
        set(handles.sl_osc, 'Enable', 'on');
        set(handles.ax_wave, 'userdata', W);
    case 4  % square wave
        W.osc2 = square(x);
        W.ratio = get(handles.sl_osc, 'value');
        set(handles.sl_osc, 'Enable', 'on');
        set(handles.ax_wave, 'userdata', W);
    case 5  % sawtooth wave
        W.osc2 = sawtooth(x-pi);
        W.ratio = get(handles.sl_osc, 'value');
        set(handles.sl_osc, 'Enable', 'on');
        set(handles.ax_wave, 'userdata', W);
    case 6  % triangle wave
        W.osc2 = sawtooth(x+0.5*pi, 0.5);
        W.ratio = get(handles.sl_osc, 'value');
        set(handles.sl_osc, 'Enable', 'on');
        set(handles.ax_wave, 'userdata', W);
end
osc = W.ratio*W.osc1 + (1-W.ratio)*W.osc2;
switch handles.bg_filter.SelectedObject.Tag
    case 'rb_hi'
        W.filter = designfilt('highpassfir', 'StopbandFrequency', W.cut-0.1, 'PassbandFrequency', W.cut, 'PassbandRipple', 0.5, 'StopbandAttenuation', 65);
    case 'rb_lo'
        W.filter = designfilt('lowpassfir', 'PassbandFrequency', W.cut, 'StopbandFrequency', W.cut+0.1,'PassbandRipple', 0.5, 'StopbandAttenuation', 65);
    case 'rb_bp'
        W.filter = designfilt('bandpassfir', 'FilterOrder', 200, 'CutoffFrequency1', W.cut-0.1, 'CutoffFrequency2', W.cut+0.1,'PassbandRipple', 0.5, 'StopbandAttenuation1',65, 'StopbandAttenuation2', 65);
    case 'rb_bc'
        W.filter = designfilt('bandstopfir', 'FilterOrder', 200, 'CutoffFrequency1', W.cut-0.1, 'CutoffFrequency2', W.cut+0.1, 'PassbandRipple1', 0.5, 'PassbandRipple2', 0.5, 'StopbandAttenuation', 65);
end
switch get(handles.cb_filter, 'value')
    case 1
        filtered = filter(W.filter, osc);
        resonanced = filtered;
    case 0
        resonanced = osc;
end
userwave = resonanced;
plot(ax, userwave(1:100), 'linewidth', 1.5);            % Plot the mixed wave form
attack = linspace(0, 1, W.att*20000+1);
decay = linspace(1, W.sus, W.dec*20000);
sustain = W.sus*ones(1, ceil(1*20000 - W.att*20000 - W.dec*20000));
release = linspace(W.sus, 0, W.rel*20000);
userwave = userwave.*[attack decay sustain release];
ax.XLim = [0 91];
ax.XTick = [];
W.userwave = userwave;
set(ax, 'userdata', W);



function pb_applyrec_Callback(hObject, eventdata, handles)
R = get(handles.pb_rec,'userdata');
S = get(handles.ax_main, 'userdata');
Si = get(handles.pb_C3, 'userdata');
if get(handles.pb_C3,'Value') ==1
    Si.rec(1,1) = 1;
    R.waves{1,1} = R.rec;
    set(handles.pb_C3, 'userdata', Si);
    set(handles.pb_rec, 'userdata', R);
end
if get(handles.pb_Db3,'Value') ==1
    Si.rec(2,1) = 1;
    R.waves{2,1} = R.rec;
    set(handles.pb_C3, 'userdata', Si);
    set(handles.pb_rec, 'userdata', R);
end
if get(handles.pb_D3,'Value') ==1
    Si.rec(3,1) = 1;
    R.waves{3,1} = R.rec;
    set(handles.pb_C3, 'userdata', Si);
    set(handles.pb_rec, 'userdata', R);
end
if get(handles.pb_Eb3,'Value') ==1
    Si.rec(4,1) = 1;
    R.waves{4,1} = R.rec;
    set(handles.pb_C3, 'userdata', Si);
    set(handles.pb_rec, 'userdata', R);
end
if get(handles.pb_E3,'Value') ==1
    Si.rec(5,1) = 1;
    R.waves{5,1} = R.rec;
    set(handles.pb_C3, 'userdata', Si);
    set(handles.pb_rec, 'userdata', R);
end
if get(handles.pb_F3,'Value') ==1
    Si.rec(6,1) = 1;
    R.waves{6,1} = R.rec;
    set(handles.pb_C3, 'userdata', Si);
    set(handles.pb_rec, 'userdata', R);
end
if get(handles.pb_Gb3,'Value') ==1
    Si.rec(7,1) = 1;
    R.waves{7,1} = R.rec;
    set(handles.pb_C3, 'userdata', Si);
    set(handles.pb_rec, 'userdata', R);
end
if get(handles.pb_G3,'Value') ==1
    Si.rec(8,1) = 1;
    R.waves{8,1} = R.rec;
    set(handles.pb_C3, 'userdata', Si);
    set(handles.pb_rec, 'userdata', R);
end
if get(handles.pb_Ab3,'Value') ==1
    Si.rec(9,1) = 1;
    R.waves{9,1} = R.rec;
    set(handles.pb_C3, 'userdata', Si);
    set(handles.pb_rec, 'userdata', R);
end
if get(handles.pb_A3,'Value') ==1
    Si.rec(10,1) = 1;
    R.waves{10,1} = R.rec;
    set(handles.pb_C3, 'userdata', Si);
    set(handles.pb_rec, 'userdata', R);
end
if get(handles.pb_Bb3,'Value') ==1
    Si.rec(11,1) = 1;
    R.waves{11,1} = R.rec;
    set(handles.pb_C3, 'userdata', Si);
    set(handles.pb_rec, 'userdata', R);
end
if get(handles.pb_B3,'Value') ==1
    Si.rec(12,1) = 1;
    R.waves{12,1} = R.rec;
    set(handles.pb_C3, 'userdata', Si);
    set(handles.pb_rec, 'userdata', R);
end
if get(handles.pb_C4,'Value') ==1
    Si.rec(13,1) = 1;
    R.waves{13,1} = R.rec;
    set(handles.pb_C3, 'userdata', Si);
    set(handles.pb_rec, 'userdata', R);
end
if get(handles.pb_Db4,'Value') ==1
    Si.rec(14,1) = 1;
    R.waves{14,1} = R.rec;
    set(handles.pb_C3, 'userdata', Si);
    set(handles.pb_rec, 'userdata', R);
end
if get(handles.pb_D4,'Value') ==1
    Si.rec(15,1) = 1;
    R.waves{15,1} = R.rec;
    set(handles.pb_C3, 'userdata', Si);
    set(handles.pb_rec, 'userdata', R);
end
if get(handles.pb_Eb4,'Value') ==1
    Si.rec(16,1) = 1;
    R.waves{16,1} = R.rec;
    set(handles.pb_C3, 'userdata', Si);
    set(handles.pb_rec, 'userdata', R);
end
if get(handles.pb_E4,'Value') ==1
    Si.rec(17,1) = 1;
    R.waves{17,1} = R.rec;
    set(handles.pb_C3, 'userdata', Si);
    set(handles.pb_rec, 'userdata', R);
end
if get(handles.pb_F4,'Value') ==1
    Si.rec(18,1) = 1;
    R.waves{18,1} = R.rec;
    set(handles.pb_C3, 'userdata', Si);
    set(handles.pb_rec, 'userdata', R);
end
if get(handles.pb_Gb4,'Value') ==1
    Si.rec(19,1) = 1;
    R.waves{19,1} = R.rec;
    set(handles.pb_C3, 'userdata', Si);
    set(handles.pb_rec, 'userdata', R);
end
if get(handles.pb_G4,'Value') ==1
    Si.rec(20,1) = 1;
    R.waves{20,1} = R.rec;
    set(handles.pb_C3, 'userdata', Si);
    set(handles.pb_rec, 'userdata', R);
end
if get(handles.pb_Ab4,'Value') ==1
    Si.rec(21,1) = 1;
    R.waves{21,1} = R.rec;
    set(handles.pb_C3, 'userdata', Si);
    set(handles.pb_rec, 'userdata', R);
end
if get(handles.pb_A4,'Value') ==1
    Si.rec(22,1) = 1;
    R.waves{22,1} = R.rec;
    set(handles.pb_C3, 'userdata', Si);
    set(handles.pb_rec, 'userdata', R);
end
if get(handles.pb_Bb4,'Value') ==1
    Si.rec(23,1) = 1;
    R.waves{23,1} = R.rec;
    set(handles.pb_C3, 'userdata', Si);
    set(handles.pb_rec, 'userdata', R);
end
if get(handles.pb_B4,'Value') ==1
    Si.rec(24,1) = 1;
    R.waves{24,1} = R.rec;
    set(handles.pb_C3, 'userdata', Si);
    set(handles.pb_rec, 'userdata', R);
end
if get(handles.pb_C5,'Value') ==1
    Si.rec(25,1) = 1;
    R.waves{25,1} = R.rec;
    set(handles.pb_C3, 'userdata', Si);
    set(handles.pb_rec, 'userdata', R);
end



% singit function
function singit(handles, Si, freq)
S = get(handles.ax_main, 'userdata');
W = get(handles.ax_wave, 'userdata');
beat = handles.unitbeat*(S.notelength + 1)/48 + W.rel;
time = 0:1/20000:beat;
x = 2*pi*freq*time;
pop_osc1 = get(handles.pop_osc1);
pop_osc2 = get(handles.pop_osc2);
switch pop_osc1.Value
    case 1        % sine wave
        Si.osc1 = sin(x);
        set(handles.pb_C3, 'userdata', Si);
    case 2  % pulse wave
        Si.osc1 = square(x, 30);
        set(handles.pb_C3, 'userdata', Si);
    case 3  % square wave
        Si.osc1 = square(x);
        set(handles.pb_C3, 'userdata', Si);
    case 4  % sawtooth wave
        Si.osc1 = sawtooth(x-pi);
        set(handles.pb_C3, 'userdata', Si);
    case 5  % triangle wave
        Si.osc1 = sawtooth(x+0.5*pi, 0.5);
        set(handles.pb_C3, 'userdata', Si);
end
switch pop_osc2.Value
    case 1
        Si.osc2 = 0*x;
        Si.ratio = 1;
        set(handles.pb_C3, 'userdata', Si);
        set(handles.sl_osc, 'Enable', 'inactive');
    case 2        % sine wave
        Si.osc2 = sin(x);
        Si.ratio = get(handles.sl_osc, 'value');
        set(handles.sl_osc, 'Enable', 'on');
        set(handles.pb_C3, 'userdata', Si);
    case 3  % pulse wave
        Si.osc2 = square(x, 30);
        Si.ratio = get(handles.sl_osc, 'value');
        set(handles.sl_osc, 'Enable', 'on');
        set(handles.pb_C3, 'userdata', Si);
    case 4  % square wave
        Si.osc2 = square(x);
        Si.ratio = get(handles.sl_osc, 'value');
        set(handles.sl_osc, 'Enable', 'on');
        set(handles.pb_C3, 'userdata', Si);
    case 5  % sawtooth wave
        Si.osc2 = sawtooth(x-pi);
        Si.ratio = get(handles.sl_osc, 'value');
        set(handles.sl_osc, 'Enable', 'on');
        set(handles.pb_C3, 'userdata', Si);
    case 6  % triangle wave
        Si.osc2 = sawtooth(x+0.5*pi, 0.5);
        Si.ratio = get(handles.sl_osc, 'value');
        set(handles.sl_osc, 'Enable', 'on');
        set(handles.pb_C3, 'userdata', Si);
end
osc = Si.ratio*Si.osc1 + (1-Si.ratio)*Si.osc2;
switch handles.bg_filter.SelectedObject.Tag
    case 'rb_hi'
        W.filter = designfilt('highpassfir', 'StopbandFrequency', W.cut-0.1, ...
            'PassbandFrequency', W.cut, 'PassbandRipple', 0.5, 'StopbandAttenuation', 65);
    case 'rb_lo'
        W.filter = designfilt('lowpassfir', 'PassbandFrequency', W.cut, ...
            'StopbandFrequency', W.cut+0.1,'PassbandRipple', 0.5, 'StopbandAttenuation', 65);
    case 'rb_bp'
        W.filter = designfilt('bandpassfir', 'FilterOrder', 200, ...
            'CutoffFrequency1', W.cut-0.1, 'CutoffFrequency2', W.cut+0.1, ...
            'PassbandRipple', 0.5, 'StopbandAttenuation1',65, 'StopbandAttenuation2', 65);
    case 'rb_bc'
        W.filter = designfilt('bandstopfir', 'FilterOrder', 200, ...
            'CutoffFrequency1', W.cut-0.1, 'CutoffFrequency2', W.cut+0.1, ...
            'PassbandRipple1', 0.5, 'PassbandRipple2', 0.5, 'StopbandAttenuation', 65);
end
switch get(handles.cb_filter, 'value')
    case 1
        filtered = filter(W.filter, osc);
    case 0
        filtered = osc;
end
resonanced = filtered;
userwave = resonanced;
attack = linspace(0, 1, W.att*20000+1);
decay = linspace(1, W.sus, W.dec*20000);
sustain = W.sus*ones(1, floor((beat-W.rel)*20000 - W.att*20000 - W.dec*20000));
release = linspace(W.sus, 0, W.rel*20000);
userwave = userwave.*[attack decay sustain release];
sound(userwave, 20000);
set(handles.pb_C3, 'userdata', Si);



function userwave = modifypatch(handles, W, freq, patch)
sec = handles.unitbeat*(patch)/48 + W.rel;
time = 1/20000:1/20000:sec;
x = 2*pi*freq*time;
switch W.pop_osc1
    case 1        % sine wave
        W.osc1 = sin(x);
    case 2  % pulse wave
        W.osc1 = square(x, 30);
    case 3  % square wave
        W.osc1 = square(x);
    case 4  % sawtooth wave
        W.osc1 = sawtooth(x-pi);
    case 5  % triangle wave
        W.osc1 = sawtooth(x+0.5*pi, 0.5);
end
switch W.pop_osc2
    case 1
        W.osc2 = 0*x;
        W.ratio = 1;
    case 2        % sine wave
        W.osc2 = sin(x);
    case 3  % pulse wave
        W.osc2 = square(x, 30);
    case 4  % square wave
        W.osc2 = square(x);
    case 5  % sawtooth wave
        W.osc2 = sawtooth(x-pi);
    case 6  % triangle wave
        W.osc2 = sawtooth(x+0.5*pi, 0.5);
end
osc = W.ratio*W.osc1 + (1-W.ratio)*W.osc2;
switch handles.bg_filter.SelectedObject.Tag
    case 'rb_hi'
        W.filter = designfilt('highpassfir', 'StopbandFrequency', W.cut-0.1, ...
            'PassbandFrequency', W.cut, 'PassbandRipple', 0.5, 'StopbandAttenuation', 65);
    case 'rb_lo'
        W.filter = designfilt('lowpassfir', 'PassbandFrequency', W.cut, ...
            'StopbandFrequency', W.cut+0.1,'PassbandRipple', 0.5, 'StopbandAttenuation', 65);
    case 'rb_bp'
        W.filter = designfilt('bandpassfir', 'FilterOrder', 200, ...
            'CutoffFrequency1', W.cut-0.1, 'CutoffFrequency2', W.cut+0.1, ...
            'PassbandRipple', 0.5, 'StopbandAttenuation1',65, 'StopbandAttenuation2', 65);
    case 'rb_bc'
        W.filter = designfilt('bandstopfir', 'FilterOrder', 200, ...
            'CutoffFrequency1', W.cut-0.1, 'CutoffFrequency2', W.cut+0.1, ...
            'PassbandRipple1', 0.5, 'PassbandRipple2', 0.5, 'StopbandAttenuation', 65);
end
switch get(handles.cb_filter, 'value')
    case 1
        filtered = filter(W.filter, osc);
    case 0
        filtered = osc;
end
resonanced = filtered;
userwave = resonanced;
attack = linspace(0, 1, W.att*20000);
decay = linspace(1, W.sus, W.dec*20000);
sustain = W.sus*ones(1, floor((sec-W.rel)*20000 - W.att*20000 - W.dec*20000));
release = linspace(W.sus, 0, W.rel*20000);
userwave = userwave.*[attack decay sustain release];



function bg_filter_SelectionChangedFcn(hObject, eventdata, handles)

function cb_filter_Callback(hObject, eventdata, handles)
val = get(handles.cb_filter, 'value');
switch val
    case 0
        set([handles.rb_hi,handles.rb_lo,handles.rb_hi, handles.rb_bp, ...
            handles.rb_bc], 'visible', 'off')
    case 1
        set([handles.rb_hi,handles.rb_lo,handles.rb_hi, handles.rb_bp, ...
            handles.rb_bc], 'visible', 'on')
end     
W = get(handles.ax_wave, 'userdata');
exe(handles, W, 220, 1, handles.ax_wave);



function rb_hi_Callback(hObject, eventdata, handles)
W = get(handles.ax_wave, 'userdata');
exe(handles, W, 220, 1, handles.ax_wave);



function rb_lo_Callback(hObject, eventdata, handles)
W = get(handles.ax_wave, 'userdata');
exe(handles, W, 220, 1, handles.ax_wave);



function rb_bp_Callback(hObject, eventdata, handles)
W = get(handles.ax_wave, 'userdata');
exe(handles, W, 220, 1, handles.ax_wave);



function rb_bc_Callback(hObject, eventdata, handles)
W = get(handles.ax_wave, 'userdata');
exe(handles, W, 220, 1, handles.ax_wave);



% for resonance
function [B, A] = boost(g, fc, bw, fs)
	% center frequency fc in Hz,
    % bandwidth bw in Hz (default = fs/10), and
	% sampling rate fs in Hz (default = 1).
	% ex: >> boost(2, 0.25, 0.1)
if nargin<4,
 
      fs = 1;
end
if nargin<3,
    bw = fs/10;
end
c = cot(pi*fc/fs);                  % bilinear transform constant
cs = c^2; 
csp1 = cs+1;
Bc=(bw/fs)*c;
gBc=g*Bc;
nrm = 1/(csp1 + Bc);           % 1/(a0 before normalization)
b0 =  (csp1 + gBc)*nrm;
b1 =  2*(1 - cs)*nrm;
b2 =  (csp1 - gBc)*nrm;
a0 =  1;
a1 =  b1;
a2 =  (csp1 - Bc)*nrm;
A = [a0 a1 a2];
B = [b0 b1 b2];



function spectrum(signal, srate)
% Plot log magnitude of FFT spectrum 
% after applying Hamming window
% Input arguments:
%	signal		signal to analyze
%	srate		sampling rate in Hz
N = 500;
first= 1;
last = first+N-1;

% Plot original and Hamming windowed signal
% compare (signal(first:last), hamming(N) .* signal(first:last))

signal = signal';

%Y = fft(signal(1:N) .* hamming(N));
Y = fft(signal(1:N));

% get frequency values of successive fft points
w = 0:2*pi/N:2*pi-(2*pi/N);  % these are values in radians/sample
freq = w*srate/(2*pi);       % these are values in Hz
% one gird = 0.5sec 12 pixel sample rate 20000 



function pb_save_w_Callback(hObject, eventdata, handles)
S=get(handles.ax_main, 'userdata');
[filename, filepath] = uiputfile('*.wav', 'Save As');
fullpath = [filepath,filename];
audiowrite(fullpath,S.score,20000); % S.score for sig_new & 20000 for sr_new


function c_bar(varargin)        % TimerFcn
player = varargin{1,1};
ax = varargin{1,3};
line_h = line([0 0], [0, 500], 'LineWidth', 1, 'Color', 'r', 'Parent', ax);
c_sample = get(player, 'CurrentSample') / get(player, 'TotalSample')*768;
line_h.XData = [c_sample c_sample];
drawnow;
pause(eps)
delete(line_h)
