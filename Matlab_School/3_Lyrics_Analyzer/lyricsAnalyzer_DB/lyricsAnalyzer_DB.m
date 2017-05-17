function varargout = lyricsAnalyzer_DB(varargin)
% LYRICSANALYZER_DB MATLAB code for lyricsAnalyzer_DB.fig
%% Last updated: 2016.01.29. 1:48 PM
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @lyricsAnalyzer_DB_OpeningFcn, ...
    'gui_OutputFcn',  @lyricsAnalyzer_DB_OutputFcn, ...
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


% --- Executes just before lyricsAnalyzer_DB is made visible.
function lyricsAnalyzer_DB_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.

% Choose default command line output for lyricsAnalyzer_DB
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
end


% --- Outputs from this function are returned to the command line.
function varargout = lyricsAnalyzer_DB_OutputFcn(hObject, eventdata, handles)

% Get default command line output from handles structure
varargout{1} = handles.output;

load 'lyricsDB.mat';

global S;
S = struct;
S.Lyrics = DB;

set(handles.pb_anal,'Enable','off');
set(handles.pb_cloud,'Enable','off');
set(handles.rb_posOFF,'Enable','off');
set(handles.rb_posON,'Enable','off');
set(handles.rb_uni,'Enable','off');
set(handles.rb_bi,'Enable','off');
set(handles.rb_N,'Enable','off');
set(handles.rb_V,'Enable','off');
set(handles.rb_Adj,'Enable','off');

artist = S.Lyrics(:,3);
artist = unique(artist);
set(handles.lb_artist, 'string', artist);

end


% --- Executes on button press in pb_cloud.
function pb_cloud_Callback(hObject, eventdata, handles)

WordList = get(handles.tb_word,'data');
WordList = cell2table(WordList);
wordcloud(hObject, eventdata, handles,WordList);

end

function rb_posON_Callback(hObject, eventdata, handles)

set(handles.rb_bi,'Enable','off');
load('lyricsDB_tagged_all.mat');

global S;
S.tagLyrics = taggedDB;

selected = get(handles.bg_artistORyear,'SelectedObject');

switch selected.Tag
    case 'rb_artist'
        info = [];
        for i = 1: size(S.tagLyrics);
            full_list = cellstr(get(handles.lb_artist, 'string'));
            sel_val = get(handles.lb_artist, 'value');
            sel_artist = full_list(sel_val);
            if strcmp(S.tagLyrics{i,3}, sel_artist{1,1});
                info = [info ; S.tagLyrics(i,:)];
                S.songinfo_tagged = info;
            end
        end
        
        set(handles.tb_info, 'data', S.songinfo_tagged) ;
        
    case 'rb_year';
        yearMin = get(handles.ed_yearMin,'String');
        yearMax = get(handles.ed_yearMax,'String');
        yearMin = str2double(yearMin);
        yearMax = str2double(yearMax);
        yearData = [];
        for i = 1:size(S.tagLyrics,1);
            if yearMin <= str2double(S.tagLyrics{i,1}) && str2double(S.tagLyrics{i,1}) <= yearMax
                yearData = [yearData ; S.tagLyrics(i,:)];
            end
        end
        
        S.yeardata_tagged = yearData;
        set(handles.tb_info,'data',S.yeardata_tagged);
end

set(handles.rb_N,'Enable','on');
set(handles.rb_V,'Enable','on');
set(handles.rb_Adj,'Enable','on');
set(handles.rb_bi,'Enable','off');

end



% --- Executes on button press in pb_anal.
function pb_anal_Callback(hObject, eventdata, handles)

set(handles.pb_anal,'String','Please Wait...');
pause(0.01);

set(handles.pb_go,'Enable','off');
set(handles.rb_artist,'Enable','off');
set(handles.rb_year,'Enable','off');
set(handles.ed_yearMin,'Enable','off');
set(handles.ed_yearMax,'Enable','off');

pause(0.01);

selectedPOS = get(handles.bg_pos,'SelectedObject');
selectedAnal = get(handles.bg_freqAnal, 'SelectedObject');
selectedTag = get(handles.bg_mor, 'selectedobject');

info = get(handles.tb_info,'data');
info = info(:,4);

switch selectedPOS.Tag
    case 'rb_posOFF'
        set(handles.rb_N,'Enable','off');
        set(handles.rb_V,'Enable','off');
        set(handles.rb_Adj,'Enable','off');
        datatype = 'raw';
        switch selectedAnal.Tag
            case 'rb_uni'
                List = stopWords(info,datatype,'unigram');
                FreqList = FreqAnal(List, 'raw', 'unigram');
            case 'rb_bi'
                List = stopWords(info,datatype,'bigram');
                FreqList = FreqAnal(List, 'raw', 'bigram');
        end
        
    case 'rb_posON'
        set(handles.rb_bi,'Enable','off');
        set(handles.rb_N,'Enable','on');
        set(handles.rb_V,'Enable','on');
        set(handles.rb_Adj,'Enable','on');
        datatype = 'tagged';
        noStop = stopWords(info,datatype);
        switch selectedTag.Tag
            case 'rb_N'
                List = getPOS(noStop,'N');
                FreqList = FreqAnal(List, 'tagged');
            case 'rb_V'
                List = getPOS(noStop,'V');
                FreqList = FreqAnal(List, 'tagged');
            case 'rb_Adj'
                List = getPOS(noStop,'Adj');
                FreqList = FreqAnal(List, 'tagged');
        end
        
end
set(handles.tb_word,'data', FreqList);

set(handles.pb_anal,'String','Analyze');
pause(0.01);

set(handles.pb_go,'Enable','on');
set(handles.pb_cloud,'Enable','on');
set(handles.rb_artist,'Enable','on');
set(handles.rb_year,'Enable','on');
set(handles.ed_yearMin,'Enable','on');
set(handles.ed_yearMax,'Enable','on');

end


% --- Executes on selection change in lb_artist.
function lb_artist_Callback(hObject, eventdata, handles)
end



% --- Executes during object creation, after setting all properties.
function lb_artist_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on button press in pb_go.
function pb_go_Callback(hObject, eventdata, handles)
set(handles.tb_info,'data',[]);
set(handles.tb_anal,'data',[]);
set(handles.tb_word,'data',[]);
set(handles.txt_noData,'Visible','off');

set(handles.pb_go,'String','Please Wait...')
pause(0.01)

set(handles.pb_go,'Enable','off');
set(handles.rb_artist,'Enable','off');
set(handles.rb_year,'Enable','off');
set(handles.ed_yearMin,'Enable','off');
set(handles.ed_yearMax,'Enable','off');
set(handles.lb_artist,'Enable','off');
set(handles.rb_posON,'value',0);
pause(0.01)

global S;

selected = get(handles.bg_artistORyear,'SelectedObject');

switch selected.Tag
    case 'rb_artist'
        info = [];
        for i = 1: size(S.Lyrics);
            full_list = cellstr(get(handles.lb_artist, 'string'));
            sel_val = get(handles.lb_artist, 'value');
            sel_artist = full_list(sel_val);
            if strcmp(S.Lyrics{i,3}, sel_artist{1,1});
                info = [info ; S.Lyrics(i,:)];
            end
        end
        S.songinfo = info;
        S.yearData = [];
        set(handles.tb_info, 'data', info) ;
        
        artist = sel_artist;
        inputType = 'artist';
        NTokens = Token(S.songinfo, inputType, 'word', artist);
        NTokensS = Token(S.songinfo, inputType, 'syllable',artist);
        [NrepWord, Nrep] = repWord(S.songinfo, inputType, artist);
        foreignRatio = foreignRate(S.songinfo, inputType, artist);
        basicStats = [{'Words per song',NTokens};{'Syllables per song',NTokensS};...
            {'Repeated words per song',NrepWord}; {'Total Repetitions',Nrep};{'Foreign word ratio(%)',foreignRatio}];
        set(handles.tb_anal,'data',basicStats);
        
        set(handles.lb_artist,'Enable','on');
        
    case 'rb_year';
        yearMin = get(handles.ed_yearMin,'String');
        yearMax = get(handles.ed_yearMax,'String');
        
        yearMin = str2double(yearMin);
        yearMax = str2double(yearMax);
        
        yearData = [];
        
        for i = 1:size(S.Lyrics,1)
            if yearMin <= str2double(S.Lyrics(i,1)) && str2double(S.Lyrics{i,1}) <= yearMax
                yearData = [yearData ; S.Lyrics(i,:)];
            end
        end
        
        S.yearData = yearData;
        S.songinfo = [];
        if ~isempty(S.yearData)
            if yearMin > max(str2double(S.Lyrics(:,1))) || min(str2double(S.Lyrics(:,1))) > yearMax
                set(handles.txt_noData,'Visible','on')
            else
                set(handles.txt_noData,'Visible','off');
                set(handles.tb_info,'data',S.yearData);
                NTokens = []; NTokensS=[]; NrepWord=[]; Nrep=[]; foreignRatio = [];
                NTokens = [NTokens Token(S.yearData, 'all', 'word')];
                NTokensS = [NTokensS Token(S.yearData, 'all', 'syllable')];
                [Nrepword, NRep] = repWord(S.yearData, 'all');
                NrepWord = [NrepWord Nrepword];
                Nrep = [Nrep NRep];
                foreignRatio = [foreignRatio foreignRate(S.yearData, 'all')];
                
            end
            
            NTokens = mean(NTokens);
            NTokensS = mean(NTokensS);
            NrepWord = mean(NrepWord);
            Nrep = mean(Nrep);
            foreignRatio = mean(foreignRatio);
            
            basicStats = [{'Words per song', NTokens};...
                {'Syllables per song', NTokensS};...
                {'Repeated words per song', NrepWord};...
                {'Total Repetitions', Nrep};...
                {'Foreign word ratio(%)', foreignRatio}];
            set(handles.tb_anal,'data', basicStats);
        elseif isempty(S.yearData)
            set(handles.txt_noData,'Visible','on')
        end
        set(handles.ed_yearMin,'Enable','on');
        set(handles.ed_yearMax,'Enable','on');
end

set(handles.pb_go,'String','Start');
set(handles.pb_go,'Enable','on');
set(handles.rb_artist,'Enable','on');
set(handles.rb_year,'Enable','on');
set(handles.pb_anal,'Enable','on');
set(handles.rb_posOFF,'Enable','on');
set(handles.rb_posON,'Enable','on');
set(handles.rb_uni,'Enable','on');
set(handles.rb_bi,'Enable','on');
end

function ed_yearMin_Callback(hObject, eventdata, handles)
end


% --- Executes during object creation, after setting all properties.
function ed_yearMin_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function ed_yearMax_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function ed_yearMax_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in rb_posOFF.
function rb_posOFF_Callback(hObject, eventdata, handles)
set(handles.rb_N,'Enable','off');
set(handles.rb_V,'Enable','off');
set(handles.rb_Adj,'Enable','off');
set(handles.rb_bi,'Enable','on');
global S
if ~isempty(S.songinfo)
    set(handles.tb_info,'data', S.songinfo);
elseif isempty(S.songinfo)
    set(handles.tb_info,'data', S.yearData);
end
end


function rb_year_Callback(hObject, eventdata, handles)
set(handles.lb_artist,'Enable','off');
set(handles.ed_yearMin,'Enable','on');
set(handles.ed_yearMax,'Enable','on');
end


% --- Executes on button press in rb_artist.
function rb_artist_Callback(hObject, eventdata, handles)
set(handles.ed_yearMin,'Enable','off');
set(handles.ed_yearMax,'Enable','off');
set(handles.lb_artist,'Enable','on');
end
