function varargout = Masterpiece(varargin)
% MASTERPIECE MATLAB code for Masterpiece.fig
%      MASTERPIECE, by itself, creates a new MASTERPIECE or raises the existing
%      singleton*.  
%
%      H = MASTERPIECE returns the handle to a new MASTERPIECE or the handle to
%      the existing singleton*.
%
%      MASTERPIECE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MASTERPIECE.M with the given input arguments.
%
%      MASTERPIECE('Property','Value',...) creates a new MASTERPIECE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Masterpiece_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Masterpiece_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only Masterpiece
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Masterpiece

% Last Modified by GUIDE v2.5 29-Jan-2016 10:46:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Masterpiece_OpeningFcn, ...
                   'gui_OutputFcn',  @Masterpiece_OutputFcn, ...
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


% --- Executes just before Masterpiece is made visible.
function Masterpiece_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Masterpiece (see VARARGIN)
warning off
ah = axes('unit', 'normalized', 'position', [0 0 0.2 1]);
bg = imread('./images/masterpiece.png'); 
imagesc(bg);
set(ah, 'handlevisibility','off','visible','off');
uistack(ah, 'bottom');

% axis for progress bar (ph:progress bar)
S.pb_gb_color = [0.1 0.1 0.5];
S.pb_ch_fg_color = [0.3 0.5 1];
S.pb_fg_color = 'w';
pb_gb_color = S.pb_gb_color;
S.pb = axes('Units','pixels',...
    'XLim',[0 1],'YLim',[0 1],...
    'XTick',[],'YTick',[],...
    'Color',pb_gb_color,...
    'XColor',pb_gb_color,'YColor',pb_gb_color,...
    'position', [493 187 450 23]);
pb = S.pb;
set(pb)


pb_fg_color = S.pb_fg_color;
patch([0.005 0.005 0.994 0.994],[0 0.9 0.9 0],pb_fg_color,...
        'Parent',pb,...
        'EdgeColor','none',...
        'EraseMode','none');
    
% three axes default images
% original axis
ori_img = imread('./images/for_original.png');
axes(handles.ax_original)
imshow(ori_img)
set(handles.tx_original,'string','Original Image')
% source axis
sor_img = imread('./images/for_source.png');
axes(handles.ax_source)
imshow(sor_img)
set(handles.tx_source,'string','Source Image')
% result axis
res_img = imread('./images/for_result.png');
axes(handles.ax_result)
imshow(res_img)
set(handles.tx_result,'string','Artified Image')

loadCounter = 0;
addCounter = 0;
S.loadCounter = loadCounter;
S.addCounter = addCounter;
S.ori_img = ori_img;
S.sor_img = sor_img;
S.res_img = res_img;
set(gcf,'userdata',S)
% Choose default command line output for Masterpiece
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
clc 
% UIWAIT makes Masterpiece wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Masterpiece_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in lb_style.
function lb_style_Callback(hObject, eventdata, handles)
% hObject    handle to lb_style (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
S = get(gcf,'userdata');
idx = get(handles.lb_style,'value');
list_img = get(handles.lb_style,'string');
new_list_img = list_img{idx} ;
S.list_img = imread(new_list_img);
list_img = S.list_img;

axes(handles.ax_source)
imshow(list_img)
addCounter = S.addCounter;
addCounter = addCounter +1;
S.addCounter = addCounter;
set(handles.tx_source,'string',new_list_img)
set(gcf,'userdata',S)

% Hints: contents = cellstr(get(hObject,'String')) returns lb_style contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lb_style


% --- Executes during object creation, after setting all properties.
function lb_style_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lb_style (see GCBO)
% eventdata  reserved - to be deddCounter;

% Choose default command line output for Masterpiece
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
%clc 
% UIWAIT makes Masterpiece wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Executes on button press in pb_load.
function pb_load_Callback(hObject, eventdata, handles)
% hObject    handle to pb_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
S = get(gcf,'userdata');
set(handles.msg_out,'string','Loading an image...')
pause(0.1)
filename = uigetfile('*.png','select a png image');

S.load_img = imread(filename);
load_img = S.load_img;
axes(handles.ax_original)
imshow(load_img);
set(handles.tx_original, 'string', filename)
set(gcf,'userdata',S);

% count the push button history
loadCounter = S.loadCounter;

loadCounter= loadCounter + 1;
S.loadCounter = loadCounter;
set(gcf,'userdata',S);
        
pause(5)
set(handles.msg_out,'string','Artistic Machine Learning Technique')


% --- Executes on button press in pb_add.
function pb_add_Callback(hObject, eventdata, handles)
% hObject    handle to pb_add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

S = get(gcf,'userdata');
set(handles.msg_out,'string','Adding an image...')
pause(0.1)

[filename,pathname] = uigetfile('*.png','Add as...');
list_img = get(handles.lb_style, 'string');
set(handles.lb_style,'string',[list_img;filename]);

set(handles.lb_style,'value',length(list_img)+1);
file_img = imread(fullfile(pathname,filename));

addCounter = S.addCounter;
addCounter = addCounter +1;
S.addCounter = addCounter;
set(gcf,'userdata',S)
% display the image.
axes(handles.ax_source)
imshow(file_img)
set(handles.tx_source,'string',filename)
set(handles.msg_out,'string','The image has been added.')
pause(5)
set(handles.msg_out,'string','Artistic Machine Learning Technique')


function pb_add_CreateFcn(hObject, eventdata, handles)


% --- Executes on button press in pb_start.
function pb_start_Callback(hObject, eventdata, handles)
% hObject    handle to pb_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

S = get(gcf,'userdata');
lc = S.loadCounter;
ac = S.addCounter;
if lc && ac >= 1
    S = get(gcf,'userdata');
    pb = S.pb;
    dur =100;
    pp = get(pb,'Child');
    xx = get(pp,'XData');
    %xx(3:4) = value;
    %set(pp,'XData',xx)
    ex_original = imread('./images/ex_original.png');
    ex2 = imread('./images/ex2.png');
    ex3 = imread('./images/ex3.png');
    ex4 = imread('./images/ex4.png');
    ex_result = imread('./images/ex_result.png');
    
    for i =1:dur
        if i <=3
            axes(handles.ax_result)
            imshow(ex_original)
            value = i/dur;
            xx(3:4) = value;
            set(pp,'XData',xx)
            pause(0.1)
            set(handles.msg_out,'string','Loading images...')
        elseif i <= 7
            axes(handles.ax_result)
            imshow(ex_original)
            value = i/dur;
            xx(3:4) = value;
            set(pp,'XData',xx)
            pause(0.2)
            set(handles.msg_out,'string','Restructuring images...')
        elseif i <=23
            axes(handles.ax_result)
            imshow(ex_original)
            value = i/dur;
            xx(3:4) = value;
            set(pp,'XData',xx)
            pause(0.3)
            set(handles.msg_out,'string','Constructing layers and units...') 
        elseif i <=45
            axes(handles.ax_result)
            imshow(ex2)
            value = i/dur;
            xx(3:4) = value;
            set(pp,'XData',xx)
            pause(0.5)
            set(handles.msg_out,'string','Training images...')
            elseif i <=60
            axes(handles.ax_result)
            imshow(ex3)
            value = i/dur;
            xx(3:4) = value;
            set(pp,'XData',xx)
            pause(0.5)
            set(handles.msg_out,'string','Training images...')
            elseif i <=75
            axes(handles.ax_result)
            imshow(ex4)
            value = i/dur;
            xx(3:4) = value;
            set(pp,'XData',xx)
            pause(0.5)
            set(handles.msg_out,'string','Training images...')
        elseif i <=85
            axes(handles.ax_result)
            imshow(ex4)
            value = i/dur;
            xx(3:4) = value;
            set(pp,'XData',xx)
            pause(0.3)
            set(handles.msg_out,'string','Validating images...')
        elseif i <=95
            axes(handles.ax_result)
            imshow(ex4)
            value = i/dur;
            xx(3:4) = value;
            set(pp,'XData',xx)
            pause(0.3)
            set(handles.msg_out,'string','Testing images...')
        elseif i <=99
            axes(handles.ax_result)
            imshow(ex_result)
            value = i/dur;
            xx(3:4) = value;
            set(pp,'XData',xx)
            set(handles.msg_out,'string','Finalizing the result iamge...')
            pause(0.2)
        elseif i == 100
            axes(handles.ax_result)
            imshow(ex_result)
            value = i/dur;
            xx(3:4) = value;
            set(pp,'XData',xx)
            set(handles.msg_out,'string','Process complete.')   
        end
    end
pause(5)
set(handles.msg_out,'string','Artistic Machine Learning Technique')
else
    set(handles.msg_out,'string','Please load or choose the source images first.')
    pause(5)
set(handles.msg_out,'string','Artistic Machine Learning Technique')
end


% --- Executes on button press in pb_clear.
function pb_clear_Callback(hObject, eventdata, handles)
% hObject    handle to pb_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%f = figure('Name', 'Progress Bar Example', 'Position', [100 100 800 50]);

cla(handles.ax_result,'reset')
% result axis
res_img = imread('./images/for_result.png');
axes(handles.ax_result)
imshow(res_img)
set(handles.tx_result,'string','Artified Image')
set(handles.msg_out,'string','The image has been removed.')
pause(5)
set(handles.msg_out,'string','Artistic Machine Learning Technique')
    

% --- Executes on button press in pb_save.
function pb_save_Callback(hObject, eventdata, handles)
% hObject    handle to pb_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.msg_out,'string','Saving the image...')
pause(0.1)
img_result = getimage(handles.ax_result);
[filename pathname]= uiputfile('*.png','Save as...');
imwrite(img_result, fullfile(pathname, filename));
set(handles.msg_out,'string','The image has been saved.')
pause(5)
set(handles.msg_out,'string','Artistic Machine Learning Technique')

% --- Executes on button press in pb_delete.
function pb_delete_Callback(hObject, eventdata, handles)
% hObject    handle to pb_delete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

idx = get(handles.lb_style,'value');
list = get(handles.lb_style,'string');

% deleting
list(idx) = [];
set(handles.lb_style,'string',list)
if idx == 1;
    set(handles.lb_style,'value',idx)
    imshow(list{idx})
else
    set(handles.lb_style,'value',idx-1)
    imshow(list{idx-1})
end


% --- Executes on button press in pb_stop.
function pb_stop_Callback(hObject, eventdata, handles)
% hObject    handle to pb_stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Construct a questdlg with three options
stopit = questdlg('Do you want to stop the process? You will lose all the processed data.', ...
	'STOP', ...
	'Yes','No','No');
% Handle response
switch stopit
    case 'Yes'
        system('killall python')
        set(handles.msg_out,'string','The process has been interrupted.')
        pause(5)
        set(handles.msg_out,'string','Artistic Machine Learning Technique')
    case 'No'
        set(handles.msg_out,'string','The process continues')
end


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function ax_original_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ax_original (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate ax_original


% --- Executes on button press in button_gpu.
function button_gpu_Callback(hObject, eventdata, handles)
% hObject    handle to button_gpu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if gpuDeviceCount == 0
    set(handles.msg_out,'string','GPU Mode is not supported on your computer. GPU Mode is deactivated')
    set(handles.button_gpu,'value',0)
elseif get(handles.button_gpu,'value') == 0
    set(handles.msg_out,'string','GPU mode is deactivated.')
else
    set(handles.msg_out,'string','GPU Mode is activated. Process time will decrease depending on your GPU')
end
pause(5)
set(handles.msg_out,'string','Artistic Machine Learning Technique')

% --- Executes on button press in button_booster.
function button_booster_Callback(hObject, eventdata, handles)
% hObject    handle to button_booster (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.button_booster,'value') == 1
    set(handles.msg_out,'string','Learning Rate is increased. Uncheck the button if the result is not satisfatory.')
    set(handles.button_highquality,'value',0)
else
    set(handles.msg_out,'string','Booster mode is deactivated.')
end
pause(5)
set(handles.msg_out,'string','Artistic Machine Learning Technique')

% --- Executes on button press in button_highquality.
function button_highquality_Callback(hObject, eventdata, handles)
% hObject    handle to button_highquality (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.button_highquality,'value') == 1
    set(handles.msg_out,'string','Learning Rate is decreased. Uncheck the button if the process is too slow.')
    set(handles.button_booster,'value',0)
else
    set(handles.msg_out,'string','High Quality mode is deactivated.')
end
pause(5)
set(handles.msg_out,'string','Artistic Machine Learning Technique')


% --- Executes on button press in button_saveinprogress.
function button_saveinprogress_Callback(hObject, eventdata, handles)
% hObject    handle to button_saveinprogress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.button_saveinprogress,'value') == 1
    set(handles.msg_out,'string','Saving mode is activated. 5 images will be saved during process.')
else
    set(handles.msg_out,'string','Saving mode is deactivated.')
end
pause(5)
set(handles.msg_out,'string','Artistic Machine Learning Technique')
    
