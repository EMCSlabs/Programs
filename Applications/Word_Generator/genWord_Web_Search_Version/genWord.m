function varargout = genWord(varargin)
    % GENWORD MATLAB code for genWord.fig
    %      GENWORD, by itself, creates a new GENWORD or raises the existing
    %      singleton*.
    %
    %      H = GENWORD returns the handle to a new GENWORD or the handle to
    %      the existing singleton*.
    %
    %      GENWORD('CALLBACK',hObject,eventData,handles,...) calls the local
    %      function named CALLBACK in GENWORD.M with the given input arguments.
    %
    %      GENWORD('Property','Value',...) creates a new GENWORD or raises the
    %      existing singleton*.  Starting from the left, property value pairs are
    %      applied to the GUI before genWord_OpeningFcn gets called.  An
    %      unrecognized property name or invalid value makes property application
    %      stop.  All inputs are passed to genWord_OpeningFcn via varargin.
    %
    %      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
    %      instance to run (singleton)".
    %
    % See also: GUIDE, GUIDATA, GUIHANDLES
    
    % Edit the above text to modify the response to help genWord
    
    % Last Modified by GUIDE v2.5 15-Dec-2015 03:25:24
    
    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
        'gui_Singleton',  gui_Singleton, ...
        'gui_OpeningFcn', @genWord_OpeningFcn, ...
        'gui_OutputFcn',  @genWord_OutputFcn, ...
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
    
    % --- Executes just before genWord is made visible.
function genWord_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to genWord (see VARARGIN)
    
    % Choose default command line output for genWord
    handles.output = hObject;
    
    % Update handles structure
    guidata(hObject, handles);
    
    % UIWAIT makes genWord wait for user response (see UIRESUME)
    % uiwait(handles.figure1);
    
    
    % --- Outputs from this function are returned to the command line.
function varargout = genWord_OutputFcn(hObject, eventdata, handles)

    varargout{1} = handles.output;
    
    %% initialize the data structure
    
    %make an empty structure in userdata
    state = struct(); 
    set(gcf,'userdata',state);
    state.r_ov1 =[]; state.r_vc1 =[]; state.r_co12 =[]; state.r_ov2 =[]; state.r_vc2 =[]; state.r_co23 =[]; state.r_ov3 =[]; state.r_vc3 =[];
    state.path = pwd; state.fullpath = [pwd '/' 'mylist']; state.format = '.mat'; state.name = 'mylist'; state.sort = 0;

    % import database
    state.corpus =[];
    corpus = load('sejong_lit.mat'); % stim.mat as a combination of a wavfiles(1st column: signal, 2nd column: Fs)
    state.corpus = corpus;

    % save all tags to state
    state.scrObjAll = [handles.bg_pg1_syllnum,handles.txt_pg1_step1,...
        handles.rb_syllnum_1,handles.rb_syllnum_2,handles.rb_syllnum_3,...
        handles.bg_pg1_ftype,handles.txt_pg1_step2,...
        handles.rb_pg1_nonpos,handles.rb_pg1_pos,...
        handles.pan_pg1_step3,handles.txt_pg1_step3,...
        handles.pan_pg1_syll1,...
        handles.txt_pg1_syll1_ov_title,handles.txt_pg1_syll1_ovtop,handles.txt_pg1_syll1_ovp,...
        handles.txt_pg1_syll1_vc_title,handles.txt_pg1_syll1_vctop,handles.txt_pg1_syll1_vcp,...
        handles.ed_input_ov1,handles.ed_input_vc1,...
        handles.pan_pg1_syll2,...
        handles.txt_pg1_syll2_co_title,handles.txt_pg1_syll2_cotop,handles.txt_pg1_syll2_cop,...
        handles.txt_pg1_syll2_ov_title,handles.txt_pg1_syll2_ovtop,handles.txt_pg1_syll2_ov_title,...
        handles.txt_pg1_syll2_vc_title,handles.txt_pg1_syll2_vctop,handles.txt_pg1_syll2_vcp,...
        handles.ed_input_co12,handles.ed_input_ov2,handles.ed_input_vc2,...
        handles.pan_pg1_syll2,...
        handles.txt_pg1_syll3_co_title,handles.txt_pg1_syll3_cotop,handles.txt_pg1_syll3_cop,...
        handles.txt_pg1_syll3_ov_title,handles.txt_pg1_syll3_ovtop,handles.txt_pg1_syll2_ov_title,...
        handles.txt_pg1_syll3_vc_title,handles.txt_pg1_syll3_vctop,handles.txt_pg1_syll3_vcp,...
        handles.ed_input_co23,handles.ed_input_ov3,handles.ed_input_vc3,...
        handles.txt_pg1_wait,...
        handles.txt_pg2_realcnt,handles.txt_pg2_nonwordcnt,handles.txt_pg2_totcnt,...
        handles.lb_pg2_wordlist,handles.lb_pg2_nonwordlist,...
        handles.txt_pg2_name,handles.txt_pg2_format,...
        handles.ed_pg2_save,handles.pop_pg2_save,...
        handles.txt_pg2_dir,handles.ed_pg2_dir,handles.pb_pg2_save,...
        handles.pb_pg2_finalsave,handles.txt_pg2_done,...
        handles.bg_pg2_sort,handles.rb_pg2_sort_hangul,handles.rb_pg2_sort_prob];

    % step1 tags
        state.step1 = [handles.txt_pg1_step1,...
                       handles.rb_syllnum_1,handles.rb_syllnum_2,handles.rb_syllnum_3];  
    % step2 tags
        state.step2 =  [handles.txt_pg1_step2,...
                        handles.rb_pg1_nonpos,handles.rb_pg1_pos];
                    
    % step3 tags
            %syll1 tags
                state.step3syll1 = [handles.txt_pg1_syll1_ov_title,handles.txt_pg1_syll1_ovtop,handles.txt_pg1_syll1_ovp,...
                                    handles.txt_pg1_syll1_vc_title,handles.txt_pg1_syll1_vctop,handles.txt_pg1_syll1_vcp,...
                                    handles.ed_input_ov1,handles.ed_input_vc1];
    
            %syll2 tags
                state.step3syll2 = [handles.txt_pg1_syll2_co_title,handles.txt_pg1_syll2_cotop,handles.txt_pg1_syll2_cop,...
                                    handles.txt_pg1_syll2_ov_title,handles.txt_pg1_syll2_ovtop,handles.txt_pg1_syll2_ovp,...
                                    handles.txt_pg1_syll2_vc_title,handles.txt_pg1_syll2_vctop,handles.txt_pg1_syll2_vcp,...
                                    handles.ed_input_co12,handles.ed_input_ov2,handles.ed_input_vc2];
                
            %syll3 tags
                state.step3syll3 = [handles.txt_pg1_syll3_co_title,handles.txt_pg1_syll3_cotop,handles.txt_pg1_syll3_cop,...
                                    handles.txt_pg1_syll3_ov_title,handles.txt_pg1_syll3_ovtop,handles.txt_pg1_syll3_ovp,...
                                    handles.txt_pg1_syll3_vc_title,handles.txt_pg1_syll3_vctop,handles.txt_pg1_syll3_vcp,...
                                    handles.ed_input_co23,handles.ed_input_ov3,handles.ed_input_vc3];
                                
      %results display tags
        state.viewresult = [handles.txt_pg2_realcnt,handles.txt_pg2_nonwordcnt,handles.txt_pg2_totcnt,...
                            handles.lb_pg2_wordlist,handles.lb_pg2_nonwordlist,...
                            handles.txt_pg2_name,handles.txt_pg2_format,...
                            handles.ed_pg2_save,handles.pop_pg2_save,...
                            handles.txt_pg2_dir,handles.ed_pg2_dir,handles.pb_pg2_save,...
                            handles.pb_pg2_finalsave,handles.txt_pg2_done];
                        
% beginning status
state.step = []; % set up a field to record current step
step = 1; % current step
state.step = step; % save current step to step field

if ~isempty(state.step)==1 
    set(state.scrObjAll,'visible','on') % show all tags
    
    set(handles.txt_pg1_wait,'visible','off') % turn off the 'please wait...' msg
    
    set(state.step2,'enable','off') % disable step 2
    set(handles.bg_pg1_ftype,'ForegroundColor','[0.7,0.7,0.7]') % dim step2 button group
    
    set(state.step3syll1,'enable','on') % disable step 3 syll1 edit box
    set(state.step3syll2,'enable','off') % disable step 3 syll2 edit box
    set(state.step3syll3,'enable','off') % disable step 3 syll3 edit box
    set(handles.pan_pg1_step3,'ForegroundColor','[0.7,0.7,0.7]') % lit step3 panel
    set(handles.txt_pg1_step3,'enable','on') % turn off the 'please wait...' msg

    set(handles.pan_pg1_syll1,'ForegroundColor','[0.7,0.7,0.7]') % dim step3 sub-panel
    set(handles.pan_pg1_syll2,'ForegroundColor','[0.7,0.7,0.7]') % dim step3 sub-panel
    set(handles.pan_pg1_syll3,'ForegroundColor','[0.7,0.7,0.7]') % dim step3 sub-panel
 
    set(state.viewresult,'enable','off') % disable result tags
    set(handles.txt_pg2_done,'visible','off') % turn off the 'saved' msg
    set(handles.bg_pg2_sort,'ForegroundColor','[0.7,0.7,0.7]')
    set(handles.bg_pg2_sort,'ForegroundColor','[0.7,0.7,0.7]')
    set(handles.rb_pg2_sort_hangul,'enable','off')
    set(handles.rb_pg2_sort_prob,'enable','off')

    
    state.syllnum = 1; % if not selected in the next step, takes this value by default
    state.ftype = 0; % if not selected in the next step, takes this value by default

end
    set(gcf,'userdata',state); % save the updated 'state' to userdata 
    
    
%% syllable number selection callbacks
function rb_syllnum_1_Callback(hObject,eventdata,handles)
    
    state = get(gcf,'userdata');

    state.syllnum = 1;
    state.ftype = []; % frequency type (step 2) does not apply to syllable of length 1
    if state.syllnum == 1 
        
        set(state.step2,'enable','off') % disable step2
        set(handles.bg_pg1_ftype,'ForegroundColor','[0.7,0.7,0.7]') % dim step2 button group
    
        set(handles.pan_pg1_step3,'ForegroundColor','[0,0,0]') % lit step3 sub-panel
        
        set(state.step3syll1,'enable','on') % enable step 3 syll1 edit box        
        set(state.step3syll2,'enable','off') % disable step 3 syll2 edit box
        set(state.step3syll3,'enable','off') % disable step 3 syll3 edit box
        
        set(handles.pan_pg1_syll1,'ForegroundColor','[0,0,0]') % lit step3 sub-panel
        set(handles.pan_pg1_syll2,'ForegroundColor','[0.7,0.7,0.7]') % dim step3 sub-panel
        set(handles.pan_pg1_syll3,'ForegroundColor','[0.7,0.7,0.7]') % dim step3 sub-panel
  
        set(state.viewresult,'enable','off') % disable result tags
        set(handles.txt_pg2_done,'visible','off')

    end

    set(gcf,'userdata',state); % save updated state to userdata
    
    
function rb_syllnum_2_Callback(hObject, eventdata, handles)
    
    state = get(gcf,'userdata');
    state.syllnum = 2;
    
    if state.syllnum == 2
        
        set(state.step2,'enable','on') % enable step2
        set(handles.bg_pg1_ftype,'ForegroundColor','[0,0,0]') % lit step2 button group
                
        set(handles.pan_pg1_step3,'ForegroundColor','[0,0,0]') % lit step3 panel
        set(handles.pan_pg1_syll1,'ForegroundColor','[0,0,0]') % lit step3 sub-panel
        set(handles.pan_pg1_syll2,'ForegroundColor','[0,0,0]') % lit step3 sub-panel
        set(handles.pan_pg1_syll3,'ForegroundColor','[0.7,0.7,0.7]') % dim step3 sub-panel
 
        set(state.step3syll1,'enable','on') % enable step 3 syll1 edit box        
        set(state.step3syll2,'enable','on') % enable step 3 syll2 edit box
        set(state.step3syll3,'enable','off') % disable step 3 syll3 edit box

        set(state.viewresult,'enable','off') % disable result tags
        set(handles.txt_pg2_done,'visible','off') % turn off the 'saved' msg

        
    end

    
    set(gcf,'userdata',state); % save updated state to userdata
    
function rb_syllnum_3_Callback(hObject, eventdata, handles)
    
    state = get(gcf,'userdata');
    state.syllnum = 3;

       if state.syllnum == 3
        
        set(state.step2,'enable','on') % enable step2
        set(handles.bg_pg1_ftype,'ForegroundColor','[0,0,0]') % lit step2 button group
            
        set(handles.pan_pg1_step3,'ForegroundColor','[0,0,0]') % lit step3 panel
        set(handles.pan_pg1_syll1,'ForegroundColor','[0,0,0]') % lit step3 sub-panel
        set(handles.pan_pg1_syll2,'ForegroundColor','[0,0,0]') % lit step3 sub-panel
        set(handles.pan_pg1_syll3,'ForegroundColor','[0,0,0]') % dim step3 sub-panel
 
        set(state.step3syll1,'enable','on') % enable step 3 syll1 edit box        
        set(state.step3syll2,'enable','on') % enable step 3 syll2 edit box
        set(state.step3syll3,'enable','on') % disable step 3 syll3 edit box
        
        set(state.viewresult,'enable','off') % disable result tags
        set(handles.txt_pg2_done,'visible','off') % turn off the 'saved' msg

       end
    
    
    set(gcf,'userdata',state); % save updated state to userdata

%% frequency type

function rb_pg1_nonpos_Callback(hObject, eventdata, handles)
    
    state = get(gcf,'userdata');
    
    state.ftype = 0;
    
    if state.syllnum ==2
        set(handles.pan_pg1_step3,'ForegroundColor','[0,0,0]') % lit step3 panel
        set(handles.txt_pg1_step3,'ForegroundColor','[0,0,0]') % lit step3 directions
        set(handles.pan_pg1_syll1,'ForegroundColor','[0,0,0]') % lit step3 sub-panel
        set(handles.pan_pg1_syll2,'ForegroundColor','[0,0,0]') % lit step3 sub-panel
        set(handles.pan_pg1_syll3,'ForegroundColor','[0.7,0.7,0.7]') % dim step3 sub-panel
 
        set(state.step3syll1,'enable','on') % enable step 3 syll1 edit box        
        set(state.step3syll2,'enable','on') % enable step 3 syll2 edit box
        set(state.step3syll3,'enable','off') % disable step 3 syll3 edit box
    else
        set(handles.pan_pg1_step3,'ForegroundColor','[0,0,0]') % lit step3 panel
        set(handles.pan_pg1_syll1,'ForegroundColor','[0,0,0]') % lit step3 sub-panel
        set(handles.pan_pg1_syll2,'ForegroundColor','[0,0,0]') % lit step3 sub-panel
        set(handles.pan_pg1_syll3,'ForegroundColor','[0,0,0]') % lit step3 sub-panel
 
        set(state.step3syll1,'enable','on') % disable step 3 syll1 edit box        
        set(state.step3syll2,'enable','on') % disable step 3 syll2 edit box
        set(state.step3syll3,'enable','on') % disable step 3 syll3 edit box
        
        set(state.viewresult,'enable','off') % disable result tags
        set(handles.txt_pg2_done,'visible','off') % turn off the 'saved' msg

    end
    
    set(gcf,'userdata',state) % save updated state to userdata
    
function rb_pg1_pos_Callback(hObject, eventdata, handles)
    
    state = get(gcf,'userdata');
    
    state.ftype = 1;
    
    if state.syllnum ==2
        set(handles.pan_pg1_step3,'ForegroundColor','[0,0,0]') % lit step3 panel
        set(handles.txt_pg1_step3,'ForegroundColor','[0,0,0]') % lit step3 directions
        set(handles.pan_pg1_syll1,'ForegroundColor','[0,0,0]') % lit step3 sub-panel
        set(handles.pan_pg1_syll2,'ForegroundColor','[0,0,0]') % lit step3 sub-panel
        set(handles.pan_pg1_syll3,'ForegroundColor','[0.7,0.7,0.7]') % dim step3 sub-panel
 
        set(state.step3syll1,'enable','on') % enable step 3 syll1 edit box        
        set(state.step3syll2,'enable','on') % enable step 3 syll2 edit box
        set(state.step3syll3,'enable','off') % disable step 3 syll3 edit box
    else
        set(handles.pan_pg1_step3,'ForegroundColor','[0,0,0]') % dim step3 panel
        set(handles.pan_pg1_syll1,'ForegroundColor','[0,0,0]') % dim step3 sub-panel
        set(handles.pan_pg1_syll2,'ForegroundColor','[0,0,0]') % dim step3 sub-panel
        set(handles.pan_pg1_syll3,'ForegroundColor','[0,0,0]') % dim step3 sub-panel
 
        set(state.step3syll1,'enable','on') % disable step 3 syll1 edit box        
        set(state.step3syll2,'enable','on') % disable step 3 syll2 edit box
        set(state.step3syll3,'enable','on') % disable step 3 syll3 edit box
        
        set(state.viewresult,'enable','off') % disable result tags
        set(handles.txt_pg2_done,'visible','off') % turn off the 'saved' msg
        
    end
    
    set(gcf,'userdata',state) % save updated state to userdata
   
    %% range input edit boxes
function ed_input_ov1_Callback(hObject, eventdata, handles)
    
    state = get(gcf,'userdata'); % reassign userdata as 'state'
    
    input_ov1 = get(hObject,'String'); % get the input content of ed_input_ov1
    state.r_ov1 = num2str(input_ov1); % save range to state
    
    set(state.viewresult,'enable','off') % disable result tags
    set(handles.txt_pg2_done,'visible','off') % turn off the 'saved' msg
    
    set(gcf,'userdata',state); % save updated state to userdata
    
function ed_input_vc1_Callback(hObject, eventdata, handles)
    
    state = get(gcf,'userdata'); % reassign userdata as 'state'
    
    input_vc1 = get(hObject,'String'); % get the input content of this editbox
    state.r_vc1 = num2str(input_vc1); % save range to state
    
    set(state.viewresult,'enable','off') % disable result tags
    set(handles.txt_pg2_done,'visible','off') % turn off the 'saved' msg
    
    set(gcf,'userdata',state); % save updated state to userdata
    
    
function ed_input_co12_Callback(hObject, eventdata, handles)
    
    state = get(gcf,'userdata'); % reassign userdata as 'state'
    
    input_co12 = get(hObject,'String');  % get the input content of this editbox
    state.r_co1 = num2str(input_co12); % save range to state
    
    set(state.viewresult,'enable','off') % disable result tags
    set(handles.txt_pg2_done,'visible','off') % turn off the 'saved' msg
    
    set(gcf,'userdata',state); % save updated state to userdata
    
    
function ed_input_ov2_Callback(hObject, eventdata, handles)
    
    state = get(gcf,'userdata'); % reassign userdata as 'state'
    
    input_ov2 = get(hObject,'String');  % get the input content of this editbox
    state.r_ov2 = input_ov2; % save range to state
    
    
    set(state.viewresult,'enable','off') % disable result tags
    set(handles.txt_pg2_done,'visible','off') % turn off the 'saved' msg
    set(gcf,'userdata',state); % save updated state to userdata
    
    
function ed_input_vc2_Callback(hObject, eventdata, handles)
    
    state = get(gcf,'userdata'); % reassign userdata as 'state'
    
    input_vc2 = get(hObject,'String');  % get the input content of this editbox
    state.r_vc2 = num2str(input_vc2); % save range to state
    
    set(state.viewresult,'enable','off') % disable result tags
    set(handles.txt_pg2_done,'visible','off') % turn off the 'saved' msg
    set(gcf,'userdata',state); % save updated state to userdata
    
    
function ed_input_co23_Callback(hObject, eventdata, handles)
    
    state = get(gcf,'userdata'); % reassign userdata as 'state'
    
    input_co23 = get(hObject,'String');  % get the input content of this editbox
    state.r_co2 = num2str(input_co23); % save range to state
    
    set(state.viewresult,'enable','off') % disable result tags
    set(handles.txt_pg2_done,'visible','off') % turn off the 'saved' msg
    
    set(gcf,'userdata',state); % save updated state to userdata
    
function ed_input_ov3_Callback(hObject, eventdata, handles)
    
    state = get(gcf,'userdata'); % reassign userdata as 'state'
    
    input_ov3 = get(hObject,'String'); % get the input content of this editbox
    state.r_ov3 = num2str(input_ov3); % save range to state
    
    set(state.viewresult,'enable','off') % disable result tags
    set(handles.txt_pg2_done,'visible','off') % turn off the 'saved' msg
    
    set(gcf,'userdata',state); % save updated state to userdata
    
    
function ed_input_vc3_Callback(hObject, eventdata, handles)
    
    state = get(gcf,'userdata'); % reassign userdata as 'state'
    
    input_vc3 = get(hObject,'String'); % get the input content of this editbox
    state.r_vc3 =  num2str(input_vc3); % save range to state
    
    set(state.viewresult,'enable','off') % disable result tags
    set(handles.txt_pg2_done,'visible','off') % turn off the 'saved' msg
    
    set(gcf,'userdata',state); % save updated state to userdata
  
    
    
    
%% callback for 'getwords
function pb_pg1_getwords_Callback(hObject, eventdata, handles)
    %% modify frequency range input for processing

    state = get(gcf,'userdata');
    
%     if ~isempty(state.syllnum) ==1;
        set(handles.txt_pg1_wait,'visible','on')
        drawnow
%end
    click = 1;  
    state.getwords = click;
    if ~isempty(state.getwords)==1
        msg = 'processing... please wait';
        set(handles.txt_pg1_wait,'String',msg) % THIS GUY WORKS ONLY DURUING DEBUGGING (WHY?!)
    end
    

    if state.syllnum >=1

        input_ov1 = state.r_ov1; % save range to state
        if isempty(regexp(input_ov1,',')) ==1 % when freq range input is given by a single number
            r_ov1 = [0 str2double(input_ov1)]; % add lower limit ('0')
        else % when freq range input is given by two numbers with ',' delimiter
            idx = regexp(input_ov1,','); % locate the ','
            r_ov1 = [str2double(input_ov1(1:idx-1)) str2double(input_ov1(idx+1:end))]; % change format to double by separating to the left/right of ','
        end
        state.r_ov1 = r_ov1; % save range to state
        
        input_vc1 =state.r_vc1; % save range to state
        if isempty(regexp(input_vc1,',')) ==1 % when freq range input is given by a single number
            r_vc1 = [0 str2double(input_vc1)]; % add lower limit ('0')
        else % when freq range input is given by two numbers with ',' delimiter
            idx = regexp(input_vc1,',');  % locate the ','
            r_vc1 = [str2double(input_vc1(1:idx-1)) str2double(input_vc1(idx+1:end))];% change format to double by separating to the left/right of ','
        end
        state.r_vc1 = r_vc1; % save range to state
    end
    
    if state.syllnum >= 2
        input_co12 =state.r_co1 ; % save range to state
        if isempty(regexp(input_co12,',')) ==1 % when freq range input is given by a single number
            r_co1 = [0 str2double(input_co12)]; % add lower limit ('0')
        else % when freq range input is given by two numbers with ',' delimiter
            idx = regexp(input_co12,','); % locate the ','
            r_co1 = [str2double(input_co12(1:idx-1)) str2double(input_co12(idx+1:end))];% change format to double by separating to the left/right of ','
        end
        state.r_co1 = r_co1; % save range to state
        
        input_ov2 =state.r_ov2; % save range to state
        if isempty(regexp(input_ov2,',')) ==1 % when freq range input is given by a single number
            r_ov2 = [0 str2double(input_ov2)];% get the input content of this editbox
        else % when freq range input is given by two numbers with ',' delimiter
            idx = regexp(input_ov2,','); % locate the ','
            r_ov2 = [str2double(input_ov2(1:idx-1)) str2double(input_ov2(idx+1:end))];% change format to double by separating to the left/right of ','
        end
        state.r_ov2 = r_ov2; % save range to state
        
        input_vc2 = state.r_vc2; % save range to state
        if isempty(regexp(input_vc2,',')) ==1 % when freq range input is given by a single number
            r_vc2 = [0 str2double(input_vc2)]; % get the input content of this editbox
        else % when freq range input is given by two numbers with ',' delimiter
            idx = regexp(input_vc2,','); % locate the ','
            r_vc2 = [str2double(input_vc2(1:idx-1)) str2double(input_vc2(idx+1:end))]; % change format to double by separating to the left/right of ','
        end
        state.r_vc2 = r_vc2; % save range to state
    end
    
    if state.syllnum ==3
        input_co23 = state.r_co2; % save range to state
        if isempty(regexp(input_co23,',')) ==1 % when freq range input is given by a single number
            r_co2 = [0 str2double(input_co23)];  % add lower limit ('0')
        else % when freq range input is given by two numbers with ',' delimiter
            idx = regexp(input_ov1,','); % locate the ','
            r_co2 = [str2double(input_co23(1:idx-1)) str2double(input_co23(idx+1:end))]; % change format to double by separating to the left/right of ','
        end
        state.co_2 = r_co2; % save range to state
        
        input_ov3 = state.r_ov3 ; % save range to state
        if isempty(regexp(input_ov3,',')) ==1 % when freq range input is given by a single number
            r_ov3 = [0 str2double(input_ov3)]; % add lower limit ('0')
        else % when freq range input is given by two numbers with ',' delimiter
            idx = regexp(input_ov1,','); % locate the ','
            r_ov3 = [str2double(input_ov3(1:idx-1)) str2double(input_ov3(idx+1:end))]; % change format to double by separating to the left/right of ','
        end
        state.r_ov3 = r_ov3; % save range to state
        
        input_vc3=state.r_vc3; % save range to state
        if isempty(regexp(input_vc3,',')) ==1 % when freq range input is given by a single number
            r_vc3 = [0 str2double(input_vc3)]; % add lower limit ('0')
        else % when freq range input is given by two numbers with ',' delimiter
            idx = regexp(input_ov1,','); % locate the ','
            r_vc3 = [str2double(input_vc3(1:idx-1)) str2double(input_vc3(idx+1:end))]; % change format to double by separating to the left/right of ','
        end
        state.r_vc3 = r_vc3; % save range to state
    end
    %% get word list
        
    if state.syllnum == 1;
        %% 1syll
        % import sections needed, as table
        ov = sortrows(state.corpus.sejong_lit.Noun.Bigram.Position_Nonspecific.onset_vowel,'prob_ov', 'descend');
        vc = sortrows(state.corpus.sejong_lit.Noun.Bigram.Position_Nonspecific.vowel_coda, 'prob_vc', 'descend');
        
        % run function gen1syll

        sprintf('getting words...')
        [allW1, realW1, nonW1] = gen1syll(ov,vc,r_ov1,r_vc1);
        
         result = {allW1,realW1,nonW1};
         state.result = result;
         sprintf('you got the words!')

        
    elseif state.syllnum == 2
        %% 2syll
        if state.ftype ==0
            % position non-specific
            
            % import sections needed, as table
            ov = sortrows(state.corpus.sejong_lit.Noun.Bigram.Position_Nonspecific.onset_vowel,'freq_ov','descend');
            vc = sortrows(state.corpus.sejong_lit.Noun.Bigram.Position_Nonspecific.vowel_coda,'freq_vc','descend');
            co = sortrows(state.corpus.sejong_lit.Noun.Bigram.Position_Nonspecific.coda_onset,'freq_co','descend');
            
            % run function gen2syll
            sprintf('getting words...')
            [allW2, realW2, nonW2] = gen2syll(ov, vc, co,r_ov1,r_vc1,r_co1,r_ov2,r_vc2);
            result = {allW2,realW2,nonW2};
            state.result = result;
            sprintf('you got the words!')      
            
        elseif state.ftype ==1
            % position specific
            % import sections needed, as table
            initov = sortrows(state.corpus.sejong_lit.Noun.Bigram.Position_Specific.initial.onset_vowel,'freq_ov','descend');
            initvc = sortrows(state.corpus.sejong_lit.Noun.Bigram.Position_Specific.initial.vowel_coda,'freq_vc','descend');
            initco = sortrows(state.corpus.sejong_lit.Noun.Bigram.Position_Specific.initial.coda_onset,'freq_co','descend');
            finov = sortrows(state.corpus.sejong_lit.Noun.Bigram.Position_Specific.final.onset_vowel,'freq_ov','descend');
            finvc = sortrows(state.corpus.sejong_lit.Noun.Bigram.Position_Specific.final.vowel_coda,'freq_vc','descend');
            
            % run function gen2syll_pos
            sprintf('getting words...')
            [allW2, realW2, nonW2] = gen2syll_pos(initov, initvc, initco, finov, finvc,r_ov1,r_vc1,r_co1,r_ov2,r_vc2);
            result = {allW2,realW2,nonW2};
            state.result = result;
            
            sprintf('you got the words!')

        end
        
    else
        %% 3syll
        if state.ftype ==0
            % position specific
            % import sections needed, as table
            initov = sortrows(state.corpus.sejong_lit.Noun.Bigram.Position_Specific.initial.onset_vowel,'prob_ov','descend');
            initvc = sortrows(state.corpus.sejong_lit.Noun.Bigram.Position_Specific.initial.vowel_coda,'prob_vc','descend');
            initco = sortrows(state.corpus.sejong_lit.Noun.Bigram.Position_Specific.initial.coda_onset,'prob_co','descend');
            
            medov = sortrows(state.corpus.sejong_lit.Noun.Bigram.Position_Specific.medial.onset_vowel,'prob_ov','descend');
            medvc = sortrows(state.corpus.sejong_lit.Noun.Bigram.Position_Specific.medial.vowel_coda,'prob_vc','descend');
            medco = sortrows(state.corpus.sejong_lit.Noun.Bigram.Position_Specific.medial.coda_onset,'prob_co','descend');
            
            finov = sortrows(state.corpus.sejong_lit.Noun.Bigram.Position_Specific.final.onset_vowel,'prob_ov','descend');
            finvc = sortrows(state.corpus.sejong_lit.Noun.Bigram.Position_Specific.final.vowel_coda,'prob_vc','descend');
            
            % run function gen3syll_pos
            sprintf('getting words...')
            [allW3,realW3, nonW3] = gen3syll_pos(initov,initvc,initco,medov,medvc,medco,finov,finvc,r_ov1,r_vc1,r_co1,r_ov2,r_vc2,r_co2,r_ov3,r_vc3);
            result = {allW3,realW3,nonW3};
            state.result = result;
            sprintf('you got the words!')

       elseif state.ftype ==1
            % position non-specific
            % import sections needed, as table
            ov = sortrows(state.corpus.sejong_lit.Noun.Bigram.Position_Nonspecific.onset_vowel,'prob_ov','descend');
            vc = sortrows(state.corpus.sejong_lit.Noun.Bigram.Position_Nonspecific.vowel_coda,'prob_vc','descend');
            co = sortrows(state.corpus.sejong_lit.Noun.Bigram.Position_Nonspecific.coda_onset,'prob_co','descend');
            
            % run function gen3syll
             sprintf('getting words...')
            [allW3,realW3,nonW3] = gen3syll(ov,vc,co,r_ov1,r_vc1,r_co1,r_ov2,r_vc2,r_co2,r_ov3,r_vc3);
            result = {allW3,realW3,nonW3};
            state.result = result;
             sprintf('you got the words!')
            
        end
        set(gcf,'userdata',state);

    end
%% display results and save    

    if ~isempty(state.result) ==1; % if data has been created in this field, turn off the waiting msg, and display results
        set(handles.txt_pg1_wait,'visible','off')
        set(state.viewresult,'enable','on')
        set(handles.bg_pg2_sort,'ForegroundColor','[0,0,0]')
        set(handles.rb_pg2_sort_hangul,'enable','on')
        set(handles.rb_pg2_sort_prob,'enable','on')
    end
    
%% display 

        result = state.result;

        real = table2cell(result{2}); 
        non = table2cell(result{3}); 
        all = table2cell((result{1}));

        if ~isempty(real) ==1;
            set(handles.lb_pg2_wordlist,'String',real(:,1));
            set(handles.txt_pg2_realcnt,'String',['real words:   ' num2str(height(result{2}))])
        else
            set(handles.lb_pg2_wordlist,'String',{'N/A'})
            set(handles.txt_pg2_realcnt,'String',['real words:   ' '0'])
        end
        
        if ~isempty(non) ==1;
            set(handles.lb_pg2_nonwordlist,'String',non(:,1)) % display nonwords
            set(handles.txt_pg2_nonwordcnt,'String',['nonwords:   ' num2str(height(result{3}))]) % display nonword count
        else
            set(handles.lb_pg2_nonwordlist,'String',{'N/A'}) % display nonwords
            set(handles.txt_pg2_nonwordcnt,'String',['nonwords:   ' '0']) % display nonword count
        end
        
        if ~isempty(all)
            set(handles.txt_pg2_totcnt,'String', ['total:   ' num2str(height(result{1}))])
        else
            set(handles.txt_pg2_totcnt,'String',['nonwords:   ' '0']) % display nonword count
            
        end
        set(gcf,'userdata',state);
    
%% save 

% get file name
function ed_pg2_save_Callback(hObject, eventdata, handles)
state = get(gcf,'userdata');
name = get(hObject,'String');
state.name = name;

path = state.path; fullpath = state.fullpath; format = state.format;
if ~isempty(fullpath) ==1
    fullpath = [path '/' name];
    state.path = fullpath;
end


if ~isempty(path)
    set(handles.ed_pg2_dir,'String',[fullpath format])
end


set(gcf,'userdata',state);

% get file format
function pop_pg2_save_Callback(hObject, eventdata, handles)
state = get(gcf,'userdata');
contents = get(hObject,'String');
state.format = contents{get(hObject,'Value')};
set(gcf,'userdata',state)


% get saving location
function pb_pg2_save_Callback(hObject, eventdata, handles)
% hObject    handle to pb_pg2_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
state = get(gcf,'userdata');
result = state.result;
allW = result{1}; name = state.name; format = state.format;

% select directory
path = uigetdir(pwd, 'Save as');
state.path = path;

% display the selected directory
if ~isempty(path)
    set(handles.ed_pg2_dir,'String',[path '/' name format])
end
set(gcf,'userdata',state)


function ed_pg2_dir_Callback(hObject, eventdata, handles)
state = get(gcf,'userdata')
path = get(hObject,'String');
state.path = [path '/' name format];
set(gcf,'userdata',state);

% save
function pb_pg2_finalsave_Callback(hObject, eventdata, handles)

state = get(gcf,'userdata')
format = state.format; name = state.name; path = state.path; 
result = state.result; allW = result{1};
fullpath = [path '/' name];
if isequal(format,'select') ==1  || isequal(format,'.mat') ==1
    save(fullpath,'allW')
else
    writetable(allW,fullpath)
end

state.save = 1;
if ~isempty(state.save) ==1
    set(handles.txt_pg2_done,'visible','on')
    set(state.scrObjAll,'visible','on')
    set(state.step2,'enable','on') % enable step2
    set(handles.bg_pg1_ftype,'ForegroundColor','[0,0,0]') % lit step2 button group
    set(handles.txt_pg1_step3,'enable','on')
    set(handles.txt_pg1_wait,'visible','off')
end

set(gcf,'userdata',state);


% --- Executes on button press in rb_pg2_sort_hangul.
function rb_pg2_sort_hangul_Callback(hObject, eventdata, handles)
state = get(gcf,'userdata');
sort = 0;
state.sort = sort;
result = state.result; all = result{1};real = result{2}; non = result{3};

if ~isequal(height(all),0) ==1
all = sortrows(all,'str_graph','ascend');
end

if ~isequal(height(real),0) ==1
real = sortrows(real,'str_graph','ascend');
end

if ~isequal(height(non),0) ==1
non = sortrows(non,'str_graph','ascend');
end

% save to structure
state.result = {all,real,non};

%apply sorting to display

if  ~isequal(height(real),0) ==1
real = table2cell(real);
set(handles.lb_pg2_wordlist,'String',real(:,1))
end

if ~isequal(height(non),0) ==1
non = table2cell(non);
set(handles.lb_pg2_nonwordlist,'String',non(:,1))
end

set(gcf,'userdata',state);

% --- Executes on button press in rb_pg2_sort_prob.
function rb_pg2_sort_prob_Callback(hObject, eventdata, handles)
state = get(gcf,'userdata');
sort = 1;
state.sort = sort;

result = state.result; all = result{1};real = result{2}; non = result{3};

if ~isequal(height(all),0) ==1
all = sortrows(all,'prob_total','descend');
end

if ~isequal(height(real),0) ==1
real = sortrows(real,'prob_total','descend');
end

if ~isequal(height(non),0) ==1
non = sortrows(non,'prob_total','descend');
end

% save to structure
state.result = {all,real,non};

%apply sorting to display

if  ~isequal(height(real),0) ==1
real = table2cell(real);
showreal = horzcat(real(:,1),real(:,2));
listreal = [];

for i = 1:length(showreal)
listreal{1,end+1} = [showreal{i,1} ' ' num2str(100*(showreal{i,2}))];
end

set(handles.lb_pg2_wordlist,'String',listreal)
end

if ~isequal(height(non),0) ==1
non = table2cell(non);
shownon = horzcat(non(:,1),non(:,2));
listnon = [];
for i = 1:length(shownon)
listnon{1,end+1} = [shownon{i,1} ' ' num2str(100*(shownon{i,2}))];
end

set(handles.lb_pg2_nonwordlist,'String',listnon)
end

set(gcf,'userdata',state);
% Hint: get(hObject,'Value') returns toggle state of rb_pg2_sort_prob
