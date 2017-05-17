function varargout = lyricsAnalyzer_web(varargin)
%% Last updated: 2016.01.29. 05:24 AM
% - 'n th lyrics tag completed' message added
% - 'Add' push button added
% - POS radiobuttons, Save/Load pushbuttons added
% - POS tagger enabled
%% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @lyricsAnalyzer_web_OpeningFcn, ...
    'gui_OutputFcn',  @lyricsAnalyzer_web_OutputFcn, ...
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

% --- Executes just before lyricsAnalyzer_web is made visible.
function lyricsAnalyzer_web_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for lyricsAnalyzer_web
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
end

% --- Outputs from this function are returned to the command line.
function varargout = lyricsAnalyzer_web_OutputFcn(hObject, eventdata, handles)
% Get default command line output from handles structure
varargout{1} = handles.output;
set(handles.rb_POSon,'Enable','off');
set(handles.rb_POSoff,'Enable','off');
set(handles.rb_bigram,'Enable','off');
set(handles.rb_unigram,'Enable','off');
end

% --- Executes on selection change in lb_info.
function lb_info_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function lb_info_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in lb_anal.
function lb_anal_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function lb_anal_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in pb_go.
function pb_go_Callback(hObject, eventdata, handles)
% cla reset;
% Set tables and edit boxes EMPTY
set(handles.tb_info,'data',[]);
set(handles.tb_anal,'data',[]);
set(handles.tb_freqWord,'data',[]);
set(handles.ed_yearMin,'string','');
set(handles.ed_yearMax,'string','');
set(handles.rb_POSoff,'value',1);

% Display 'Please Wait...' while processing
set(handles.pb_go,'String','Please Wait...')
pause(0.01)

% Disable all other objects while processing
set(handles.pb_go,'Enable','off');
set(handles.ed_txtArtist,'Enable','off');
set(handles.ed_txtNsongs,'Enable','off');
set(handles.ed_yearMin,'Enable','off');
set(handles.ed_yearMax,'Enable','off');
set(handles.pb_yearRefine,'Enable','off');
set(handles.pb_refresh,'Enable','off');
pause(0.01)

% Get data
global S
S = struct;
artistName = get(handles.ed_txtArtist,'String');
nSongs = get(handles.ed_txtNsongs,'String');
nSongs = str2double(nSongs);

S.songInfo = ArtistSongs(artistName,nSongs);

if isempty(S.songInfo)
    set(handles.tx_noData,'Visible','on')
else
    set(handles.tx_noData,'Visible','off')
    S.songInfo = lyricsPrep(S.songInfo);
    set(handles.tb_info,'data', S.songInfo);
    
    [wordsPerSong] = Token(S.songInfo, 'artist', artistName, 'word');
    [syllsPerSong] = Token(S.songInfo, 'artist', artistName, 'syllable');
    [AvgNrepWord, AvgNrep] = repWord(S.songInfo, 'artist', artistName);
    [foreignRatio] = foreignRate(S.songInfo, 'artist', artistName);
    S.basicStats = [{'Words per song',wordsPerSong};...
        {'Syllables per song',syllsPerSong};...
        {'Repeated words per song',AvgNrepWord};...
        {'Total Repetitions',AvgNrep};...
        {'Foreign word ratio(%)', foreignRatio}];
    set(handles.tb_anal,'data',S.basicStats);
end

% Re-Display 'Start' after retrieving data (go back to default message)
set(handles.pb_go,'String','Start')

% Enable all other objects as before
set(handles.pb_go,'Enable','on');
set(handles.ed_txtArtist,'Enable','on');
set(handles.ed_txtNsongs,'Enable','on');
set(handles.ed_yearMin,'Enable','on');
set(handles.ed_yearMax,'Enable','on');
set(handles.pb_yearRefine,'Enable','on');
set(handles.pb_refresh,'Enable','on');
set(handles.rb_POSon,'Enable','on');
set(handles.rb_POSoff,'Enable','on');
set(handles.rb_unigram,'Enable','on');
set(handles.rb_bigram,'Enable','on');
set(handles.rb_unigram,'value',1);

global tagCount_full
global tagCount_partial
tagCount_full = 0;
tagCount_partial = 0;

S.yearData = [];
end
%%

function ed_txtArtist_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function ed_txtArtist_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

%--- Executes when entered data in editable cell(s) in tb_info.
function tb_info_CellEditCallback(hObject, eventdata, handles)
end

%--- Executes when entered data in editable cell(s) in tb_freqWord.
function tb_freqWord_CellEditCallback(hObject, eventdata, handles)
end

function ed_txtNsongs_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function ed_txtNsongs_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in pb_yearRefine.
function pb_yearRefine_Callback(hObject, eventdata, handles)
%set(handles.rb_POSoff,'value',1)

yearMin = get(handles.ed_yearMin,'String');
yearMax = get(handles.ed_yearMax,'String');

yearMin = str2double(yearMin);
yearMax = str2double(yearMax);

yearData = [];

global S
fullData = S.songInfo;

for i = 1:size(fullData,1)
    if yearMin <= str2double(fullData{i,1}) && str2double(fullData{i,1}) <= yearMax
        yearData = [yearData ; fullData(i,:)];
    end
end

S.yearData = yearData;

if isempty(S.yearData)
    set(handles.tx_noData,'Visible','on')
else
    set(handles.tx_noData,'Visible','off')
    S.yearData = lyricsPrep(S.yearData);
    set(handles.tb_info,'data',S.yearData);
    
    artistName = get(handles.ed_txtArtist,'String');
    [wordsPerSong] = Token(S.yearData, 'artist', artistName, 'word');
    [syllsPerSong] = Token(S.yearData, 'artist', artistName, 'syllable');
    [AvgNrepWord, AvgNrep] = repWord(S.yearData, 'artist', artistName);
    [foreignRatio] = foreignRate(S.yearData, 'artist', artistName);
    basicStats = [{'Words per song', wordsPerSong};...
        {'Syllables per song', syllsPerSong};...
        {'Repeated words per song', AvgNrepWord};...
        {'Total Repetitions', AvgNrep};...
        {'Foreign word ratio(%)', foreignRatio}];
    set(handles.tb_anal,'data', basicStats);
end
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

% --- Executes on button press in rb_POSoff.
function rb_POSoff_Callback(hObject, eventdata, handles)
set(handles.rb_noun,'Enable','off');
set(handles.rb_verb,'Enable','off');
set(handles.rb_adj,'Enable','off');
set(handles.rb_bigram,'Enable','on');
global S
if isempty(S.yearData)
    set(handles.tb_info,'data', S.songInfo);
elseif ~isempty(S.yearData)
    set(handles.tb_info,'data', S.yearData);
end
end

% --- Executes on button press in rb_POSon.
function rb_POSon_Callback(hObject, eventdata, handles)
% Disable POS radio button group while processing
global S
global tagCount_full % Count how many times the data is FULLY tagged
global tagCount_partial % Count how many times the data is PARTIALLY tagged (cf. year range)

% Enable radio button & disable bigram radio button
set(handles.tx_POSprogress,'Visible','on');
set(handles.tx_progressN,'Visible','on');
set(handles.rb_noun,'Enable','on');
set(handles.rb_verb,'Enable','on');
set(handles.rb_adj,'Enable','on');
set(handles.rb_unigram,'value',1);
set(handles.rb_bigram,'Enable','off');

% (1) If FIRST time tagging, newly start POS tag
if tagCount_full == 0 && tagCount_partial == 0
    
    % (1-i) If year input is NOT given, tag all data
    if isempty(S.yearData)
        tagCount_full = 0;
        set(handles.rb_POSon,'Enable','off');
        set(handles.rb_POSoff,'Enable','off');
        pause(0.1)
        
        S.tagged = S.songInfo;
        
        %S.progressN = handles.tx_progressN;
        taggedStr = [];
        
        % KorPOStag
        strArray = S.songInfo(:,4);
        fulldirec1 = fullfile(cd,'komoranWrapper.jar');
        fulldirec2 = fullfile(cd,'models-full');
        javaaddpath(fulldirec1);
        me = com.scarlet.wrapper.Main();
        
        for i = 1:size(strArray,1)
            returnval = me.DoConvert(strArray{i,1}, fulldirec2);
            taggedStr{i,1} = cell(returnval);
            taggedStr{i,1} = taggedStr{i,1}{1,1};
            if i==1
               txt = sprintf('%dst lyrics tag completed\n',i);
            elseif i==2
                txt = sprintf('%dnd lyrics tag completed\n',i);
            elseif i==3
                txt = sprintf('%drd lyrics tag completed\n',i);
            else
                txt = sprintf('%dth lyrics tag completed\n',i);
            end
            set(handles.tx_progressN,'String',txt);
            pause(0.01)
        end
        S.tagged(:,4) = taggedStr;
        tagCount_full = tagCount_full + 1;
        
        
        % (1-ii) If YEAR input is given, tag the data in range only
    elseif ~isempty(S.yearData)
        
        tagCount_partial = 0;
        set(handles.rb_POSon,'Enable','off');
        set(handles.rb_POSoff,'Enable','off');
        pause(0.1)
        
        S.tagged = S.yearData;
        S.tagged(:,4) = KorPOStag(S.yearData(:,4));
        tagCount_partial = tagCount_partial + 1;
    end
    
    % Display 'Complete' after tagging procedure
    dlg = dialog('Position',[500 500 200 100],'Name','Complete');
    txt = uicontrol('Parent',dlg,...
        'Style','text',...
        'Position',[25 50 150 30],...
        'FontSize',20,...
        'String','Complete');
    btn = uicontrol('Parent',dlg,...
        'Position',[60 20 70 25],...
        'String','Close',...
        'Callback','delete(gcf)');
    
    % Display tagged data to tb_info
    set(handles.tb_info,'data', S.tagged);
    set(handles.rb_POSon,'Enable','on');
    set(handles.rb_POSoff,'Enable','on');
    
    
    % (2) If ALREADY tagged, display the previously tagged data
elseif tagCount_full > 0 || tagCount_partial > 0
    
    % (2-i) If year range input is NOT given, display the tagged full data in tb_info
    if isempty(S.yearData)
        set(handles.tb_info,'data', S.tagged);
        
        % (2-ii) If YEAR range input is given, display the tagged partial data in tb_info
    else ~isempty(S.yearData);
        S.yearData_tagged = [];
        yearMin = get(handles.ed_yearMin,'String');
        yearMax = get(handles.ed_yearMax,'String');
        yearMin = str2double(yearMin);
        yearMax = str2double(yearMax);
        for i = 1:size(S.tagged,1)
            if yearMin <= str2double(S.tagged{i,1}) && str2double(S.tagged{i,1}) <= yearMax
                S.yearData_tagged = [S.yearData_tagged ; S.tagged(i,:)];
            end
        end
        S.tagged = S.yearData_tagged;
        set(handles.tb_info,'data', S.tagged);
    end
    
end
set(handles.tx_POSprogress,'Visible','off');
set(handles.tx_progressN,'String','');
set(handles.tx_progressN,'Visible','off');
set(handles.rb_bigram,'Enable','off');
end

% --- Executes on button press in pb_wordcloud.
function pb_wordcloud_Callback(hObject, eventdata, handles)
WordList = get(handles.tb_freqWord,'data');
WordList = cell2table(WordList);
wordcloud(hObject, eventdata, handles, WordList);
end


% --- Executes on button press in pb_unigram.
function pb_unigram_Callback(hObject, eventdata, handles)
end

% --- Executes on button press in pb_bigram.
function pb_bigram_Callback(hObject, eventdata, handles)
end

% --- Executes on button press in pb_freqAnal.
function pb_freqAnal_Callback(hObject, eventdata, handles)
set(handles.tb_freqWord,'data',[]);

% Display 'Please Wait...' while processing
set(handles.pb_freqAnal,'String','Please Wait...');
pause(0.01);

% Disable all other objects while processing
set(handles.pb_go,'Enable','off');
set(handles.ed_txtArtist,'Enable','off');
set(handles.ed_txtNsongs,'Enable','off');
set(handles.ed_yearMin,'Enable','off');
set(handles.ed_yearMax,'Enable','off');
set(handles.pb_yearRefine,'Enable','off');
set(handles.pb_refresh,'Enable','off');
set(handles.pb_freqAnal,'Enable','off');
set(handles.rb_POSoff,'Enable','off');
set(handles.rb_POSon,'Enable','off');
set(handles.rb_unigram,'Enable','off');
set(handles.rb_bigram,'Enable','off');
pause(0.01);

% Get Songinfo
info = get(handles.tb_info,'data');
info = info(:,4);

% switch setting for radio button
selectedWordsNum = get(handles.ubg_freqAnal, 'selectedobject');
selectedPos = get(handles.ubg_POS, 'selectedobject');
selectedTag = get(handles.ubg_tag, 'selectedobject');

%% Frequency analysis (5 Cases)
%  (1) Posoff - unigram | bigram
%  (2) Pos On - noun | verb | adj
switch selectedPos.Tag
    case 'rb_POSoff'
        datatype = 'raw';
        switch selectedWordsNum.Tag
            case 'rb_unigram'
                List = stopWords(info,datatype,'unigram');
                FreqList = FreqAnal(List,'raw','unigram');
            case 'rb_bigram'
                List = stopWords(info,datatype,'bigram');
                FreqList = FreqAnal(List,'raw','bigram');
        end
        
    case 'rb_POSon'
        datatype = 'tagged';
        tagNostop = stopWords(info,datatype);
        switch selectedTag.Tag
            case 'rb_noun'
                List = getPOS(tagNostop, 'N');
                FreqList = FreqAnal(List,'tagged');
            case 'rb_verb'
                List = getPOS(tagNostop, 'V');
                FreqList = FreqAnal(List,'tagged');
            case 'rb_adj'
                List = getPOS(tagNostop, 'Adj');
                FreqList = FreqAnal(List,'tagged');
        end
end

set(handles.tb_freqWord,'data', FreqList);


% Display 'Please Wait...' while processing
set(handles.pb_freqAnal,'String','Analyze');
pause(0.01);

% Re-Display 'Start' after retrieving data (go back to default message)
set(handles.pb_freqAnal,'String','Start')

% Enable all other objects as before
set(handles.pb_go,'Enable','on');
set(handles.ed_txtArtist,'Enable','on');
set(handles.ed_txtNsongs,'Enable','on');
set(handles.ed_yearMin,'Enable','on');
set(handles.ed_yearMax,'Enable','on');
set(handles.pb_yearRefine,'Enable','on');
set(handles.pb_refresh,'Enable','on');
set(handles.pb_freqAnal,'Enable','on');
set(handles.rb_POSoff,'Enable','on');
set(handles.rb_POSon,'Enable','on');
set(handles.rb_unigram,'Enable','on');
set(handles.rb_bigram,'Enable','on');

end

% --- Executes on button press in pb_refresh.
function pb_refresh_Callback(hObject, eventdata, handles)
global S
set(handles.ed_yearMin,'string','');
set(handles.ed_yearMax,'string','');
if ~isempty(S.songInfo)
    set(handles.tx_noData,'Visible','off')
    set(handles.tb_info,'data', S.songInfo);
    set(handles.tb_anal,'data', S.basicStats);
end
end

% --- Executes on button press in pb_save.
function pb_save_Callback(hObject, eventdata, handles)

% get data in two table
songInfo = get(handles.tb_info,'data');
basicStats = get(handles.tb_anal,'data');

% make structure A
A.songInfo = songInfo;
A.basicStats = basicStats;

% save using uiputfile
[filename, filepath] = uiputfile('*.mat','select directory.');
save(filename,'A');
if ~strcmp(filepath,cd)
    movefile(filename,filepath,'f');
end
end


% --- Executes on button press in pb_load.
function pb_load_Callback(hObject, eventdata, handles)

% set table & text empty
set(handles.tb_info,'data',[]);
set(handles.tb_anal,'data',[]);
set(handles.tb_freqWord,'data',[]);
set(handles.ed_yearMin,'string','');
set(handles.ed_yearMax,'string','');
set(handles.ed_txtArtist,'string','');
set(handles.ed_txtNsongs,'string','');
set(handles.rb_POSoff,'value',1);

% load file 
[filename, filepath] = uigetfile('*.mat','select .mat file.');
fullpath = [filepath filename];
load(fullpath);

songInfo = A.songInfo;
basicStats = A.basicStats;

% set data (tb_info , tb_anal, Num of Song, ArtistName)
set(handles.tb_info,'data', songInfo);
set(handles.tb_anal,'data', basicStats);
NumOfSong = size(songInfo,1);
ArtistName = songInfo{1,3};
set(handles.ed_txtArtist,'string',ArtistName);
set(handles.ed_txtNsongs,'string',NumOfSong);

% update S for more analysis
global S
S.songInfo = songInfo;
S.basicStats = basicStats;
set(handles.rb_POSon,'Enable','on');
set(handles.rb_POSoff,'Enable','on');

global tagCount_full % Count how many times the data is FULLY tagged
global tagCount_partial % Count how many times the data is PARTIALLY tagged (cf. year range)

if strfind(filename,'tagged')
    tagCount_full = 1;
    set(handles.rb_POSon,'value',1);
    set(handles.rb_POSoff,'Enable','off');
    set(handles.rb_unigram,'Enable','on');
    set(handles.rb_unigram,'value',1);
    set(handles.rb_bigram,'Enable','off');
    set(handles.rb_noun,'Enable','on');
    set(handles.rb_verb,'Enable','on');
    set(handles.rb_adj,'Enable','on');
else
    tagCount_full = 0;
    tagCount_partial = 0;
    set(handles.rb_POSon,'value',0);
end
end


% --- Executes on button press in pb_add.
function pb_add_Callback(hObject, eventdata, handles)
% load file
[filename, filepath] = uigetfile('*.mat','select .mat file.');
fullpath = [filepath filename];
load(fullpath);

% add songinfo data
songInfoOri = get(handles.tb_info,'data');
songInfoAdded = A.songInfo;
songInfoAll = [songInfoOri; songInfoAdded];

set(handles.tb_info,'data', songInfoAll);

% update basicstats data
[wordsPerSong] = Tokendata(songInfoAll, 'word');
[syllsPerSong] = Tokendata(songInfoAll, 'syllable');
[AvgNrepWord, AvgNrep] = repWorddata(songInfoAll);
[foreignRatio] = foreignRatedata(songInfoAll);
basicStats = [{'Words per song',wordsPerSong};...
    {'Syllables per song',syllsPerSong};...
    {'Repeated words per song',AvgNrepWord};...
    {'Total Repetitions',AvgNrep};...
    {'Foreign word ratio(%)', foreignRatio}];
set(handles.tb_anal,'data', basicStats);

% Number of song & Artistname set
NumOfSong = size(songInfoAll,1);
Name = songInfoAll(:,3);
Name = unique(Name);
NameGroup = [];
if isequal(size(Name,1),'1');
    NameGroup = Name;
elseif ~isequal(size(Name,1),'1')
    for i = 1 : size(Name,1);
        ArtistName = Name{i,1};
        NameGroup = [NameGroup ArtistName ' '];
    end
end
set(handles.ed_txtArtist,'string',NameGroup);
set(handles.ed_txtNsongs,'string',NumOfSong);

% update S for more analysis
global S
S.songInfo = songInfoAll;
S.basicStats = basicStats;

end
