function [] = exAmple()
% Group 5
% Editor : 
% Date: 2016-01-26
%% Create a blank figure window
S.f = figure('units', 'pixels',...
             'position', [120 70 1000 670],...
             'name', 'StudyWord',...
             'userdata',0,...
             'resize', 'on');
         
%% Create a word edit box and a search button
S.ed_word = uicontrol('style', 'edit',...
                      'string', 'type word',...
                      'enable', 'inactive',...
                      'units', 'norm',...
                      'position', [0.3 0.92 0.3 0.065],...
                      'fontsize', 20);

set(S.ed_word, 'buttondownFcn', {@ed_word_bdf,S});
S.pb_search = uicontrol('style', 'pushbutton',...
                        'string', '<Html><Font color = "blue" face = "Comic Sans Ms">Search!</Font>',...
                        'units', 'norm',...
                        'position', [0.62 0.925 0.085 0.05],...
                        'fontsize', 13);
set(S.pb_search, 'callback', {@pb_search_call,S});

%% Create a uitabgroup1 and 2 tabs
S.tabGroup1 = uitabgroup('units', 'norm',...
                        'position', [0.01 0.3 0.17 0.6]); drawnow;
S.tab1 = uitab(S.tabGroup1, 'title', 'History');
S.tab2 = uitab(S.tabGroup1, 'title', '   #    ');

%% Create a uitabgroup2 and 3 tabs
S.tabGroup2 = uitabgroup('units', 'norm',...
                        'position', [0.185 0.3 0.8 0.6],...
                        'tablocation', 'top'); drawnow;
S.tab3 = uitab(S.tabGroup2, 'title', 'News','tag','news');
S.tab4 = uitab(S.tabGroup2, 'title', 'Scholar','tag','scholor');
S.tab5 = uitab(S.tabGroup2, 'title', 'EX storage');

%% Fill the tab1
S.lb_his = uicontrol('parent', S.tab1,...
                     'style', 'listbox',...
                     'fontsize', 13,...
                     'units', 'norm',...
                     'position', [0.05 0.025 0.9 0.95]);
set(S.lb_his,'callback',{@lb_his_call,S});

%% fill the tab2
S.lb_tag = uicontrol('parent', S.tab2,...
                     'style', 'listbox',...
                     'fontsize', 13,...
                     'units', 'norm',...
                     'position', [0.05 0.025 0.9 0.95]);
set(S.lb_tag, 'callback', {@lb_tag_call,S});

%% Fill the tab3
S.pop_inst3 = uicontrol('parent', S.tab3,...
                        'style', 'popup',...
                        'string', {'10', '20', '30', '40', '50'},...
                        'units', 'norm',...
                        'position', [0.006 0.95 0.1 0.03]);
set(S.pop_inst3, 'callback', {@pop_inst3_call,S});
S.tx_all3 = uicontrol('parent', S.tab3,...
                      'style', 'text',...
                      'string', 'Examples',...
                      'fontsize', 13,...
                      'horizontalalignment', 'left',...
                      'units', 'norm',...
                      'position', [0.107 0.88 0.3 0.1]);
S.tx_sel3 = uicontrol('parent', S.tab3,...
                      'style', 'text',...
                      'string', 'Selected Examples',...
                      'fontsize', 13,...
                      'horizontalalignment', 'left',...
                      'units', 'norm',...
                      'position', [0.54 0.88 0.3 0.1]);
S.lb_all3 = uicontrol('parent', S.tab3,...
                      'style', 'listbox',...
                      'fontsize', 13,...
                      'units', 'norm',...
                      'position', [0.012 0.42 0.45 0.48]);
set(S.lb_all3, 'callback', {@lb_all3_call,S});
S.lb_sel3 = uicontrol('parent', S.tab3,...
                      'style', 'listbox',...
                      'fontsize', 13,...
                      'units', 'norm',...
                      'position', [0.54 0.42 0.45 0.48]);
set(S.lb_sel3, 'callback', {@lb_sel3_call,S});
S.pb_add3 = uicontrol('parent', S.tab3,...
                      'style', 'pushbutton',...
                      'string', '>>',...
                      'fontsize', 11,...
                      'units', 'norm',...
                      'position', [0.476 0.72 0.05 0.08]);
set(S.pb_add3, 'callback', {@pb_add3_call,S});
S.pb_del3 = uicontrol('parent', S.tab3,...
                      'style', 'pushbutton',...
                      'string', '<<',...
                      'fontsize', 11,...
                      'units', 'norm',...
                      'position', [0.476 0.55 0.05 0.08]);
set(S.pb_del3, 'callback', {@pb_del3_call,S});
S.tx_detail3 = uicontrol('parent', S.tab3,...
                         'style', 'pushbutton',...
                         'enable', 'inactive',...
                         'backgroundcolor', [1 1 1],...
                         'fontsize', 13,...
                         'horizontalalignment', 'left',...
                         'units', 'norm',...
                         'position', [0.013 0.1 0.975 0.3]);
S.tx_source3 = uicontrol('parent', S.tab3,...
                        'visible', 'on',...
                         'style', 'text',...
                         'string', 'Source:',...
                         'fontsize', 15,...
                         'horizontalalignment', 'left',...
                         'units', 'norm',...
                         'position', [0.013 0.008 0.075 0.07]);
S.tx_sourcedetail3 = uicontrol('parent', S.tab3,...
                                'visible', 'on',...
                              'style', 'text',...
                              'backgroundcolor', [1 1 1],...
                              'fontsize', 13,...
                              'horizontalalignment', 'left',...
                              'units', 'norm',...
                              'position', [0.09 0.008 0.395 0.07]);
S.tx_time3 = uicontrol('parent', S.tab3,...
                        'visible', 'on',...
                       'style', 'text',...
                       'string', 'Time:',...
                       'fontsize', 15,...
                       'horizontalalignment', 'left',...
                       'units', 'norm',...
                       'position', [0.5 0.008 0.075 0.07]);
S.tx_timedetail3 = uicontrol('parent', S.tab3,...
                            'visible', 'on',...
                            'style', 'text',...
                            'backgroundcolor', [1 1 1],...
                            'fontsize', 13,...
                            'horizontalalignment', 'left',...
                            'units', 'norm',...
                            'position', [0.56 0.008 0.428 0.07]);

%% fill the tab4
S.pop_inst4 = uicontrol('parent', S.tab4,...
                        'style', 'popup',...
                        'string', {'5', '10', '15', '20'},...
                        'units', 'norm',...
                        'position', [0.006 0.95 0.1 0.03]);
set(S.pop_inst4, 'callback', {@pop_inst4_call,S});
S.tx_all4 = uicontrol('parent', S.tab4,...
                      'style', 'text',...
                      'string', 'Examples',...
                      'fontsize', 13,...
                      'horizontalalignment', 'left',...
                      'units', 'norm',...
                      'position', [0.107 0.88 0.3 0.1]);
S.tx_sel4 = uicontrol('parent', S.tab4,...
                      'style', 'text',...
                      'string', 'Selected Examples',...
                      'fontsize', 13,...
                      'horizontalalignment', 'left',...
                      'units', 'norm',...
                      'position', [0.54 0.88 0.3 0.1]);
S.lb_all4 = uicontrol('parent', S.tab4,...
                      'style', 'listbox',...
                      'fontsize', 13,...
                      'units', 'norm',...
                      'position', [0.012 0.42 0.45 0.48]);
set(S.lb_all4, 'callback', {@lb_all4_call,S});
S.lb_sel4 = uicontrol('parent', S.tab4,...
                      'style', 'listbox',...
                      'fontsize', 13,...
                      'units', 'norm',...
                      'position', [0.54 0.42 0.45 0.48]);
set(S.lb_sel4, 'callback', {@lb_sel4_call,S});
S.pb_add4 = uicontrol('parent', S.tab4,...
                      'style', 'pushbutton',...
                      'string', '>>',...
                      'fontsize', 11,...
                      'units', 'norm',...
                      'position', [0.476 0.72 0.05 0.08]);
set(S.pb_add4, 'callback', {@pb_add4_call,S});
S.pb_del4 = uicontrol('parent', S.tab4,...
                      'style', 'pushbutton',...
                      'string', '<<',...
                      'fontsize', 11,...
                      'units', 'norm',...
                      'position', [0.476 0.55 0.05 0.08]);
set(S.pb_del4, 'callback', {@pb_del4_call,S});
S.tx_detail4 = uicontrol('parent', S.tab4,...
                        'style', 'pushbutton',...
                         'enable', 'inactive',...
                         'backgroundcolor', [1 1 1],...
                         'fontsize', 13,...
                         'horizontalalignment', 'left',...
                         'units', 'norm',...
                         'position', [0.013 0.1 0.975 0.3]);
S.tx_source4 = uicontrol('parent', S.tab4,...
                        'visible', 'on',...
                         'style', 'text',...
                         'string', 'Source:',...
                         'fontsize', 15,...
                         'horizontalalignment', 'left',...
                         'units', 'norm',...
                         'position', [0.013 0.008 0.075 0.07]);
S.tx_sourcedetail4 = uicontrol('parent', S.tab4,...
                                'visible', 'on',...
                              'style', 'text',...
                              'backgroundcolor', [1 1 1],...
                              'fontsize', 13,...
                              'horizontalalignment', 'left',...
                              'units', 'norm',...
                              'position', [0.09 0.008 0.395 0.07]);
S.tx_time4 = uicontrol('parent', S.tab4,...
                        'visible', 'on',...
                       'style', 'text',...
                       'string', 'Time:',...
                       'fontsize', 15,...
                       'horizontalalignment', 'left',...
                       'units', 'norm',...
                       'position', [0.5 0.008 0.075 0.07]);
S.tx_timedetail4 = uicontrol('parent', S.tab4,...
                            'visible', 'on',...
                            'style', 'text',...
                            'backgroundcolor', [1 1 1],...
                            'fontsize', 13,...
                            'horizontalalignment', 'left',...
                            'units', 'norm',...
                            'position', [0.56 0.008 0.428 0.07]);

%% Fill the tab5
S.tx_sel5 = uicontrol('parent', S.tab5,...
                      'style', 'text',...
                      'string', 'Selected Examples',...
                      'fontsize', 13,...
                      'horizontalalignment', 'left',...
                      'units', 'norm',...
                      'position', [0.012 0.88 0.3 0.1]);
S.lb_sel5 = uicontrol('parent', S.tab5,...
                      'style', 'listbox',...
                      'fontsize', 13,...
                      'units', 'norm',...
                      'position', [0.012 0.42 0.977 0.48]);
set(S.lb_sel5, 'callback', {@lb_sel5_call,S});
S.tx_detail5 = uicontrol('parent', S.tab5,...
                        'style', 'pushbutton',...
                         'enable', 'inactive',...
                         'backgroundcolor', [1 1 1],...
                         'fontsize', 13,...
                         'horizontalalignment', 'left',...
                         'units', 'norm',...
                         'position', [0.013 0.04 0.975 0.35]);
S.tx_source5 = uicontrol('parent', S.tab5,...
                         'visible', 'off',...
                         'style', 'text',...
                         'string', 'Source:',...
                         'fontsize', 15,...
                         'horizontalalignment', 'left',...
                         'units', 'norm',...
                         'position', [0.013 0.008 0.075 0.07]);
S.tx_sourcedetail5 = uicontrol('parent', S.tab5,...
                               'visible', 'off',...
                               'style', 'text',...
                               'backgroundcolor', [1 1 1],...
                               'fontsize', 13,...
                               'horizontalalignment', 'left',...
                               'units', 'norm',...
                               'position', [0.09 0.008 0.395 0.07]);

%% Create a pop-up menu for tag list
S.tx_tag = uicontrol('style', 'text',...
                     'string', 'Tags',...
                     'fontsize', 15,...
                     'horizontalalignment', 'left',...
                     'units', 'norm',...
                     'position', [0.02 0.2 0.3 0.1]);
S.pop_tag = uicontrol('style', 'popup',...
                      'string', '#',...
                      'fontsize', 11,...
                      'units', 'norm',...
                      'position', [0.015 0.06 0.165 0.2]);
set(S.pop_tag, 'callback', {@pop_tag_call,S});

%% Create a panel
S.panel_def = uipanel('title', 'Definition',...
                     'fontsize', 16,...
                     'units', 'norm',...
                     'position', [0.192 0.08 0.785 0.22]); drawnow;

%% Fill the panel
S.tx_def = uicontrol('parent', S.panel_def,...
                     'style', 'text',...
                     'backgroundcolor', [1 1 1],...
                     'fontsize', 14,...
                     'horizontalalignment', 'left',...
                     'units', 'norm',...
                     'position', [0.012 0.1 0.955 0.85]);
S.sl_def = uicontrol('parent', S.panel_def,...
                     'style', 'slider',...
                     'Min', 1, 'Max', 2, 'value', 2,...
                     'visible', 'off',...
                     'units', 'norm',...
                     'position', [0.98 0.07 0.01 0.98]);
set(S.sl_def, 'callback', {@sl_def_call,S});

%% Create an edit box for tag
S.ed_tag = uicontrol('style', 'edit',...
                     'string', 'Write Tags (ex. #animal #politics)',...
                     'enable', 'inactive',...
                     'units', 'norm',...
                     'position', [0.53 0.022 0.35 0.045],...
                     'fontsize', 13);
set(S.ed_tag, 'buttondownFcn', {@ed_tag_bdf,S});

%% Create a save button
S.pb_save = uicontrol('style', 'pushbutton',...
                      'string', 'Save',...
                      'units', 'norm',...
                      'position', [0.89 0.01 0.088 0.065],...
                      'fontsize', 14);
set(S.pb_save,'callback',{@pb_save_call,S});
set(S.pb_save,'userdata',0);

%% pb_search callback
    function [] = pb_search_call(varargin)
        
        % change 'pb_search' string when loading results
        set(S.ed_tag, 'string', 'Write Tags (ex. #animal #politics)');
        set(S.pb_search, 'string', 'LOADING..');
        set(S.pb_search, 'foregroundcolor', 'r');
        set(S.lb_his,'Enable','Off');
        pause(.1)
    
        % Search by using #(tag)
        cmpvalue = get(S.ed_word,'String');
        
        if isempty(regexp(cmpvalue,'^#','match')) ==0;
            % Change Tab when Searching by Using Tag
            set(S.tabGroup1,'SelectedTab',S.tab2);
            set(S.tabGroup2,'SelectedTab',S.tab5);
            % Clear 'String'
            set(S.tx_detail5,'String',[]);
            set(S.tx_def,'String',[]);
            
            T = load('vocab.mat');
            tagidx = [];
                % Transfer Field to Cell    
                word = {T.V.word};
                tag = {T.V.tag};
                def = {T.V.def};
                ex = {T.V.ex};
            
            tag_dl = [];
            
            for i = 1:length(tag)
                
                tag_detail = tag{1,i};
                tag_detail = regexp(tag_detail,'\s','split');
                A = strcmp(cmpvalue, tag_detail);
                tagcmp = find(A,1);
                
                if ~isempty(tagcmp)
                    tagidx = [tagidx i];
                    
                end
                tag_dl{i} = {tag_detail};
            end
            if isempty(tagidx);
                set(S.lb_tag, 'string', 'No Data');
                set(S.lb_sel5, 'string', 'No Data');
                def = {'No Data'};

            else
            list = word(tagidx);
            list = list';
            set(S.lb_tag, 'String',list);
            def = def{1,tagidx(1)};
            set(S.pop_tag,'String',tag_dl{1,tagidx(1)}{1,1});
            set(S.lb_sel5,'String',ex{1,tagidx(1)});
            set(S.tx_detail5,'String',ex{1,tagidx(1)}(1));
            end
        
        else
            
        %Change Tab
        set(S.tabGroup1,'SelectedTab',S.tab1);    
        tabvalue = get(S.tabGroup2,'SelectedTab');
        tabvalue = get(tabvalue, 'tag');
        if  strcmp(tabvalue, 'scholor');
            set(S.tabGroup2,'SelectedTab',S.tab4);
        else
            set(S.tabGroup2,'SelectedTab',S.tab3);
        end
        set(S.pop_tag,'String','#');
        
        % tab3 - search Google News
        set(S.lb_all3,'Userdata',[]);
        
        word = get(S.ed_word, 'string');
        n = get(S.pop_inst3, 'string');
        idx = get(S.pop_inst3, 'value');
        inst = str2num(n{idx});
        [exa1,source1,time1] = wordEx(word,inst);
        
        set(S.lb_all3, 'string', exa1); % show all examples
        set(S.lb_all3, 'value', 1);
        set(S.lb_sel3, 'string', []);   % delete selected examples
        set(S.tx_detail3, 'string', exa1{1});   % example detail
        set(S.tx_sourcedetail3, 'string', source1{1});  % source
        set(S.tx_timedetail3, 'string', time1{1});  % time
        
     
        % tab4 - search Google Scholar
        n = get(S.pop_inst4, 'string');
        idx = get(S.pop_inst4, 'value');
        inst = str2num(n{idx});
        [exa2,source2,time2] = wordExSch(word,inst);
        
        set(S.lb_all4, 'string', exa2); % show all examples
        set(S.lb_all4, 'value', 1);
        set(S.lb_sel4, 'string', []);   % delete selected examples
        set(S.tx_detail4, 'string', exa2{1});   % example detail
        set(S.tx_sourcedetail4, 'string', source2{1});  % source
        set(S.tx_timedetail4, 'string', time2{1});  % time
        
        % Save in 'Userdata' to execute lb_all3 & lb_all4
        A.exa1 = exa1;
        A.source1 = source1;
        A.time1 = time1;
        A.exa2 = exa2;
        A.source2 = source2;
        A.time2 = time2;
        set(S.lb_all3,'Userdata',A);
        
        % definition (error)
        set(S.tx_def, 'foregroundcolor', 'k');
        error_msg = {'The word does not exist. Please re-check your word.'};
        
        try def = wordDef(word);
        catch
            def = error_msg;
            set(S.tx_def, 'string', def);
            set(S.tx_def, 'foregroundcolor', 'r');
            set(S.lb_all3, 'string', []);
            set(S.lb_sel3, 'string', []);
            set(S.tx_detail3, 'string', []);
        end
        end
        set(S.tx_def, 'string', def);
       
        
        % definition (interwork slider)
        max = length(def);
        set(S.sl_def,'Max', max);
        set(S.sl_def,'value',max);
        D.def = def;
        set(S.tx_def,'Userdata',D);
       
        if max == 1 ;
            set(S.sl_def, 'visible', 'off')
            
        elseif max > 1 ;
            set(S.sl_def, 'visible', 'on');
            if max>10
            set(S.sl_def, 'sliderstep', [1/(max-1) 10/(max-1)]);
            else
            set(S.sl_def, 'sliderstep', [1/(max-1) 1/(max-1)]);
            end
            value = get(S.sl_def,'value');
            value = max - value + 1;            
            def = def(value);            
            set(S.tx_def, 'string', def);            
        end
       
        % history
        his = get(S.lb_his, 'string');
        word = get(S.ed_word,'string');
        if isempty(his);
            his = {word};
        else
            his = [his; word];
            his = unique(his,'stable');
        end
        
        set(S.lb_his, 'string', his);
        
        len = length(his);
        set(S.lb_his, 'value', len);
        
        % end
        set(S.ed_word, 'enable', 'inactive');
        set(S.ed_tag, 'enable', 'inactive');
        
        pause(.1)
        
        set(S.pb_search, 'string', '<Html><Font color = "blue" face = "Comic Sans Ms">Search!</Font>');
        set(S.pb_search, 'foregroundcolor', 'k');
        set(S.lb_his,'Enable','On');
       
    end

%% ed_word button down Function
    function [] = ed_word_bdf(varargin)
        set(S.ed_word, 'enable', 'on');
        uicontrol(S.ed_word);
    end

%% ed_tag button down Function
    function [] = ed_tag_bdf(varargin)
        set(S.ed_tag, 'enable', 'on');
        uicontrol(S.ed_tag);
    end

%% pop_inst3 callback
    function [] = pop_inst3_call(varargin)
        % change string
        set(S.pb_search, 'string', 'LOADING..');
        set(S.pb_search, 'foregroundcolor', 'r');
        pause(.1)

        
        % search Google News
        
      
        word = get(S.ed_word, 'string');
        n = get(S.pop_inst3, 'string');
        idx = get(S.pop_inst3, 'value');
        inst = str2num(n{idx});
        [exa1,source1,time1] = wordEx(word,inst);
        
        set(S.lb_all3, 'string', exa1); % show all examples
        set(S.lb_all3, 'value', 1);
        
        % Save in 'Userdata' to execute lb_all3
        A = get(S.lb_all3,'Userdata');
        A.exa1 = exa1;
        A.source1 = source1;
        A.time1 = time1;
        set(S.lb_all3,'Userdata',A);
       
            
        
        % selected examples
        his = get(S.lb_his, 'string');
        if length(his)~=0;
            s1 = his{end};
            s2 = get(S.ed_word,'string');
            if strcmp(s1, s2) == 0;
                set(S.lb_sel3, 'string', []);
            end
        end
        
        set(S.tx_detail3, 'string', exa1{1});   % example detail
        set(S.tx_sourcedetail3, 'string', source1{1});  % source
        set(S.tx_timedetail3, 'string', time1{1});  % time
        
        % definition (error)
        set(S.tx_def, 'foregroundcolor', 'k');
        error_msg = {'The word does not exist. Please re-check your word.'};
        
        try def = wordDef(word);
        catch
            def = error_msg;
            set(S.tx_def, 'string', def);
            set(S.tx_def, 'foregroundcolor', 'r');
            set(S.lb_all3, 'string', []);
            set(S.lb_sel3, 'string', []);
            set(S.tx_detail3, 'string', []);
        end
        set(S.tx_def, 'string', def);
        
        % definition (interwork slider)
        max = length(def);
        set(S.sl_def,'Max', max);
        set(S.sl_def,'value',max);
        D.def = def;
        set(S.tx_def,'Userdata',D);
       
        if max == 1 ;
            set(S.sl_def, 'visible', 'off')
            
        elseif max > 1 ;
            set(S.sl_def, 'visible', 'on');
            if max>10
            set(S.sl_def, 'sliderstep', [1/(max-1) 10/(max-1)]);
            else
            set(S.sl_def, 'sliderstep', [1/(max-1) 1/(max-1)]);
            end
            value = get(S.sl_def,'value');
            value = max - value + 1;
            def = def(value);
            set(S.tx_def, 'string', def);
        end
     
        
       % history
        his = get(S.lb_his, 'string');
        
        if isempty(his);
            his = {word};
        else
            his = [his; word];
            his = unique(his,'stable');
        end
        
        set(S.lb_his, 'string', his);
        
        len = length(his);
        set(S.lb_his, 'value', len);
        
        % end
        set(S.ed_word, 'enable', 'inactive');
        set(S.ed_tag, 'enable', 'inactive');
        
        pause(.1)
        
        set(S.pb_search, 'string', 'Search');
        set(S.pb_search, 'foregroundcolor', 'k');
        
        set(S.lb_all3,'Userdata',A);
    end

%% pop_inst4 callback
    function [] = pop_inst4_call(varargin)
        % change string
        set(S.pb_search, 'string', 'LOADING..');
        set(S.pb_search, 'foregroundcolor', 'r');
        pause(.1)
        
        % search Google Scholor
       
        word = get(S.ed_word, 'string');
        n = get(S.pop_inst4, 'string');
        idx = get(S.pop_inst4, 'value');
        inst = str2num(n{idx});
        [exa2,source2,time2] = wordExSch(word,inst);
        
               
        set(S.lb_all4, 'string', exa2); % show all examples
        set(S.lb_all4, 'value', 1);
        
        % selected examples
        his = get(S.lb_his, 'string');
        if length(his)~=0;
            s1 = his{end};
            s2 = get(S.ed_word,'string');
            if strcmp(s1, s2) == 0;
                set(S.lb_sel4, 'string', []);
            end
        end
               
        A = get(S.lb_all3,'Userdata');
        A.exa2 = exa2;
        A.source2 = source2;
        A.time2 = time2;
        set(S.lb_all3,'Userdata',A);
        
        set(S.lb_all3,'Userdata',A);
        set(S.tx_detail4, 'string', exa2{1});   % example detail
        set(S.tx_sourcedetail4, 'string', source2{1});  % source
        set(S.tx_timedetail4, 'string', time2{1});  % time
        
              
        % definition (error)
        set(S.tx_def, 'foregroundcolor', 'k');
        error_msg = {'The word does not exist. Please re-check your word.'};
        
        try def = wordDef(word);
        catch
            def = error_msg;
            set(S.tx_def, 'string', def);
            set(S.tx_def, 'foregroundcolor', 'r');
            set(S.lb_all4, 'string', []);
            set(S.lb_sel4, 'string', []);
            set(S.tx_detail4, 'string', []);
        end
        set(S.tx_def, 'string', def);
        
        % definition (interwork slider)
       max = length(def);
        set(S.sl_def,'Max', max);
        set(S.sl_def,'value',max);
        D.def = def;
        set(S.tx_def,'Userdata',D);
       
        if max == 1 ;
            set(S.sl_def, 'visible', 'off')
            
        elseif max > 1 ;
            set(S.sl_def, 'visible', 'on');
            if max>10
            set(S.sl_def, 'sliderstep', [1/(max-1) 10/(max-1)]);
            else
            set(S.sl_def, 'sliderstep', [1/(max-1) 1/(max-1)]);
            end
            value = get(S.sl_def,'value');
            value = max - value + 1;
            def = def(value);
            set(S.tx_def, 'string', def);

        end
       
        % history
        his = get(S.lb_his, 'string');
        
        if isempty(his);
            his = {word};
        else
            his = [his; word];
            his = unique(his,'stable');
        end
        
        set(S.lb_his, 'string', his);
        
        len = length(his);
        set(S.lb_his, 'value', len);
        
        % end
        set(S.ed_word, 'enable', 'inactive');
        set(S.ed_tag, 'enable', 'inactive');
        
        pause(.1)
        
        set(S.pb_search, 'string', 'Search');
        set(S.pb_search, 'foregroundcolor', 'k');
        
        set(S.lb_all3,'Userdata',A);
    end

%% pb_add3 callback
    function [] = pb_add3_call(varargin)
        all = get(S.lb_all3, 'string');
        idx = get(S.lb_all3, 'value');
        detail = all{idx};
        sel = get(S.lb_sel3, 'string');
        
        if isempty(sel)
            set(S.lb_sel3, 'string', {detail});
            set(S.lb_sel3, 'value', 1);
        else
            sel = [sel; detail];
            len1 = length(sel);
            sel = unique(sel,'stable');
            len2 = length(sel);
            set(S.lb_sel3, 'string', sel);
            if len1 == len2;
                set(S.lb_sel3, 'value', len2);
            end
        end
       
        set(S.ed_word, 'enable', 'inactive');
        set(S.ed_tag, 'enable', 'inactive');
    end
    
%% pb_del3 callback
    function [] = pb_del3_call(varargin)
        sel = get(S.lb_sel3, 'string');
        if length(sel) == 1;
            set(S.lb_sel3, 'string', []);
        elseif length(sel) > 1;
            idx = get(S.lb_sel3, 'value');
            sel(idx) = [];
            if idx == 1
                set(S.lb_sel3, 'value', 1)
            else
                set(S.lb_sel3, 'value', idx-1)
            end
            set(S.lb_sel3, 'string', sel);
        end
       
        set(S.ed_word, 'enable', 'inactive');
        set(S.ed_tag, 'enable', 'inactive');
    end

%% pb_add4 callback
    function [] = pb_add4_call(varargin)
        all = get(S.lb_all4, 'string');
        idx = get(S.lb_all4, 'value');
        detail = all{idx};
        sel = get(S.lb_sel4, 'string');
        
        if isempty(sel)
            set(S.lb_sel4, 'string', {detail});
            set(S.lb_sel4, 'value', 1);
        else
            sel = [sel; detail];
            len1 = length(sel);
            sel = unique(sel,'stable');
            len2 = length(sel);
            set(S.lb_sel4, 'string', sel);
            if len1 == len2;
                set(S.lb_sel4, 'value', len2);
            end
        end
       
        set(S.ed_word, 'enable', 'inactive');
        set(S.ed_tag, 'enable', 'inactive');
    end
    
%% pb_del4 callback
    function [] = pb_del4_call(varargin)
        sel = get(S.lb_sel4, 'string');
        if length(sel) == 1;
            set(S.lb_sel4, 'string', []);
        elseif length(sel) > 1;
            idx = get(S.lb_sel4, 'value');
            sel(idx) = [];
            if idx == 1
                set(S.lb_sel4, 'value', 1)
            else
                set(S.lb_sel4, 'value', idx-1)
            end
            set(S.lb_sel4, 'string', sel);
        end
       
        set(S.ed_word, 'enable', 'inactive');
        set(S.ed_tag, 'enable', 'inactive');
    end

%% lb_all3 callback
    function [] = lb_all3_call(varargin)
        
        A = get(S.lb_all3, 'Userdata');
        exa1 = A.exa1;
        source1 = A.source1;
        time1 = A.time1;       
        
        idx = get(S.lb_all3, 'value');
        
        set(S.tx_detail3, 'string', exa1(idx));
        set(S.tx_sourcedetail3, 'string', source1(idx));
        set(S.tx_timedetail3, 'string', time1(idx));
        
        set(S.ed_word, 'enable', 'inactive');
        set(S.ed_tag, 'enable', 'inactive');
    end

%% lb_sel3 callback
    function [] = lb_sel3_call(varargin)
              
        A = get(S.lb_all3, 'Userdata');
        exa1 = A.exa1;
        source1 = A.source1;
        time1 = A.time1;
        
        sel = get(S.lb_sel3, 'string');
        idx = get(S.lb_sel3, 'value');
        set(S.tx_detail3, 'string', sel(idx));
        set(S.tx_sourcedetail3, 'string', source1(idx));
        set(S.tx_timedetail3, 'string', time1(idx));
        
        set(S.ed_word, 'enable', 'inactive');
        set(S.ed_tag, 'enable', 'inactive');
    end

%% lb_all4 callback
    function [] = lb_all4_call(varargin)
        A = get(S.lb_all3, 'Userdata');
        exa2 = A.exa2;
        source2 = A.source2;
        time2 = A.time2;
        
        idx = get(S.lb_all4, 'value');
        set(S.tx_detail4, 'string', exa2(idx));
        set(S.tx_sourcedetail4, 'string', source2(idx));
        set(S.tx_timedetail4, 'string', time2(idx));
        
        set(S.ed_word, 'enable', 'inactive');
        set(S.ed_tag, 'enable', 'inactive');
    end

%% lb_sel4 callback
    function [] = lb_sel4_call(varargin)
        
        A = get(S.lb_all3, 'Userdata');
        exa2 = A.exa2;
        source2 = A.source2;
        time2 = A.time2;
        
        sel = get(S.lb_sel4, 'string');
        idx = get(S.lb_sel4, 'value');
        set(S.tx_detail4, 'string', sel(idx));
        set(S.tx_sourcedetail4, 'string', source2(idx));
        set(S.tx_timedetail4, 'string', time2(idx));
        
        set(S.ed_word, 'enable', 'inactive');
        set(S.ed_tag, 'enable', 'inactive');
    end


%% sl_def callback
    function [] = sl_def_call(varargin)
       
        D = get(S.tx_def,'userdata');
        def = D.def;
        max = length(def);
       
        
        value = get(S.sl_def, 'value');
        value = max - value + 1;
        value = round(value);
        def = def(value);
        set(S.tx_def, 'string', def);
        
        set(S.ed_word, 'enable', 'inactive');
        set(S.ed_tag, 'enable', 'inactive');
    end

%% pop_tag callback
    function [] = pop_tag_call(varargin)

          cmpvalue = get(S.pop_tag,'String');         
          cmpidx = get(S.pop_tag,'Value');
          cmpvalue = cmpvalue{cmpidx};
          set(S.ed_word,'string',cmpvalue);
            
            set(S.tabGroup1,'SelectedTab',S.tab2);
            set(S.tabGroup2,'SelectedTab',S.tab5);
            
            set(S.tx_detail5,'String',[]);
            set(S.tx_def,'String',[]);
            
            T = load('vocab.mat');
            tagidx = [];
            C = struct2cell(T.V);
            [a b c] = size(C);
            
                word = {T.V.word};
                tag = {T.V.tag};
                def = {T.V.def};
                ex = {T.V.ex};
            
            tag_dl = [];
        
            for i = 1:length(tag)
                
                tag_detail = tag{1,i};
                tag_detail = regexp(tag_detail,'\s','split');
                A = strcmp(cmpvalue, tag_detail);
                tagcmp = find(A,1);
                
                if ~isempty(tagcmp)
                    tagidx = [tagidx i];
                    tag_dl = [tag_dl tag_detail];
                end
            end
            list = word(tagidx);
            list{1,1};
            list = list';           
            set(S.lb_tag, 'String',list);
            set(S.lb_tag, 'Max',length(list));
            set(S.lb_tag, 'Value', 1);
            
            def = def{1,tagidx(1)};
            tag = tag{1,tagidx(1)};
            tag_newdl = regexp(tag,'\s','split');
            
            set(S.pop_tag,'String',tag_newdl);
            set(S.lb_sel5,'String',ex{1,tagidx(1)});
            set(S.tx_detail5,'String',ex{1,tagidx(1)}(1));
            set(S.tx_def, 'string', def);
        
        % definition (interwork slider)
        max = length(def);
        set(S.sl_def,'Max', max);
        set(S.sl_def,'value',max);
       
        if max == 1 ;
            set(S.sl_def, 'visible', 'off')
            
        elseif max > 1 ;
            set(S.sl_def, 'visible', 'on');
            if max>10
            set(S.sl_def, 'sliderstep', [1/(max-1) 10/(max-1)]);
            else
            set(S.sl_def, 'sliderstep', [1/(max-1) 1/(max-1)]);
            end
            value = get(S.sl_def,'value');
            value = max - value + 1;
            D.def = def;
            def = def(value);
            
            set(S.tx_def, 'string', def);
            set(S.tx_def,'Userdata',D);
        end
     set(S.ed_word, 'enable', 'inactive');
        set(S.ed_tag, 'enable', 'inactive');
        
    end

%% lb_his callback
    function [] = lb_his_call(varargin)
        list = get(S.lb_his,'String');
        idx = get(S.lb_his, 'Value');
        
        word = list{idx};
        set(S.ed_word,'String',word);
        pb_search_call
        pause(.1)
        set(S.lb_his,'Value',idx)
     end
%% lb_tag callback
    function [] = lb_tag_call(varargin)
        T = load('vocab.mat');
            wordidx = [];
            C = struct2cell(T.V);
            [a b c] = size(C);
            
                word = {T.V.word};
                tag = {T.V.tag};
                def = {T.V.def};
                ex = {T.V.ex};
                
        sel_word = get(S.lb_tag,'String');
        sel_value = get(S.lb_tag,'Value');
        
        for i = 1:c
            if strcmp(sel_word(sel_value), word(i));
            wordidx = i;
            end
        end
        def = def(wordidx);
        def = def{1,1};
        ex = ex(wordidx);
        ex = ex{1,1};
        tag = tag(wordidx);
        tag = tag{1,1};
        tag_dl = regexp(tag,'\s','split');
        max = length(def);
        set(S.sl_def,'Max', max);
        set(S.sl_def,'value',max);
       
        if max == 1 ;
            set(S.sl_def, 'visible', 'off')
            D.def = def;
        elseif max > 1 ;
            set(S.sl_def, 'visible', 'on');
            if max>10
            set(S.sl_def, 'sliderstep', [1/(max-1) 10/(max-1)]);
            else
            set(S.sl_def, 'sliderstep', [1/(max-1) 1/(max-1)]);
            end
            value = get(S.sl_def,'value');
            value = max - value + 1;
            D.def = def;
            def = def(value);
        end
         set(S.tx_def, 'string', def);
         set(S.tx_def,'Userdata',D);
         set(S.lb_sel5,'String',ex);
         set(S.tx_detail5,'String',ex(1));
         set(S.pop_tag, 'String', tag_dl);
         set(S.pop_tag, 'Value', 1);
         set(S.ed_word, 'enable', 'inactive');
         set(S.ed_tag, 'enable', 'inactive');
    end

%% lb_sel5 callback
    function [] = lb_sel5_call(varargin)
        sel = get(S.lb_sel5, 'string');
        idx = get(S.lb_sel5, 'value');
        detail = sel(idx);
        set(S.tx_detail5, 'string', detail);
        
        set(S.ed_word, 'enable', 'inactive');
        set(S.ed_tag, 'enable', 'inactive');
    end

%% pb_save callback
    function [] = pb_save_call(varargin)
    % Save 'Vocab.mat' File
    
    try load('vocab.mat')
        
    catch V = [];
          save('vocab.mat','V')
          load('vocab.mat')
    end
    
    i = length(V) +1;
    word = get(S.ed_word,'String');
    V(i).word = get(S.ed_word,'String');
    V(i).def = wordDef(get(S.ed_word,'String'));
    V(i).ex = [get(S.lb_sel3,'String');get(S.lb_sel4,'String')];
    
    tag = get(S.ed_tag, 'String');
    tag = ['#' word ' ' tag];
    V(i).tag = tag;
        
    save('vocab.mat' , 'V');            
        
    % Save Vocab Spreadsheet by using MS Excel
   

        for i = 1:length(V)
            V(i).ex = cellfun(@(a) [a '*****'], V(i).ex, 'Uniform', 0);
            V(i).def = [V(i).def{:}];
            V(i).ex = [V(i).ex{:}];
            regexprep(V(i).ex,'<[^>]*>','');
        end
    
    T = struct2table(V);
    T = unique(T,'stable');
    
    if ispc
          name = ['vocab ' date '.xls'];
          writetable(T,name);
    else ismac
         Mac = table2cell(T);
         xlswrite('vocab.csv',Mac);      
    end

    end  
end