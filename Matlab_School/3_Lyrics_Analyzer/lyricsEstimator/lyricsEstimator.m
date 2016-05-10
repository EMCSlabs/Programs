function varargout = lyricsEstimator(varargin)
%% Last updated: 2016.01.28. 7:31 PM
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @lyricsEstimator_OpeningFcn, ...
                   'gui_OutputFcn',  @lyricsEstimator_OutputFcn, ...
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
end
% End initialization code - DO NOT EDIT


% --- Executes just before lyricsEstimator is made visible.
function lyricsEstimator_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
end


% --- Outputs from this function are returned to the command line.
function varargout = lyricsEstimator_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;
global data1
load 'lyricsDB.mat';
data1 = DB;
end

% --- Executes on button press in pb_estimate.
function pb_estimate_Callback(hObject, eventdata, handles)
global data1
load 'Summary.mat'
songdata = get(handles.eb_lyrics,'String');
estYearC = estYear(data,songdata);
estArtistC = estArtist(data,songdata);
set(handles.st_result,'String',estYearC);
set(handles.tb_artist,'data',estArtistC);
end


function eb_lyrics_Callback(hObject, eventdata, handles)
end


% --- Executes during object creation, after setting all properties.
function eb_lyrics_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes during object creation, after setting all properties.
function tb_artist_CreateFcn(hObject, eventdata, handles)
end

% --- Executes when entered data in editable cell(s) in tb_artist.
function tb_artist_CellEditCallback(hObject, eventdata, handles)
end

% --- Executes on button press in pb_search.
function pb_search_Callback(hObject, eventdata, handles)
global data1;
songdata = get(handles.eb_lyrics,'String');
searchedArtist = searchArtist(data1,songdata);
set(handles.tb_artist,'data',searchedArtist);
end

% --- Executes on button press in pb_update.
function pb_update_Callback(hObject, eventdata, handles)
global data1
summarizeData(data1);
dlg = dialog('Position',[300 300 200 100],'Name','Complete');
txt = uicontrol('Parent',dlg,...
    'Style','text',...
    'Position',[25 50 150 30],...
    'FontSize',20,...
    'String','Complete');
btn = uicontrol('Parent',dlg,...
    'Position',[60 20 70 25],...
    'String','Close',...
    'Callback','delete(gcf)');

end
