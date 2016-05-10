function [] = searchGopasGUI_ver2()
%
%
% Author:  Yeonjung Hong
% Date:  2016-01-20
%% Create a blank figure window 
S.fh = figure('units','pixels',...
              'position',[300 150 1500 700],... %[left bottm width height]
              'menubar','none',...
              'name','SearchGopas',...
              'numbertitle','off',...
              'resize','on');    
%% Create a uitabgroup and tabs
S.tabGroup = uitabgroup('units', 'norm',...
    'position', [0.025 0.025 0.95 0.85]); drawnow;
S.tab1 = uitab(S.tabGroup, 'title','Recommendable');
S.tab2 = uitab(S.tabGroup, 'title', 'Unrecommendable');
S.tab3 = uitab(S.tabGroup, 'title', 'Map');
S.tab4 = uitab(S.tabGroup, 'title', 'Word Cloud'); %add
%% Add three browser objects
S.jObject1 = com.mathworks.mlwidgets.html.HTMLBrowserPanel;
[browser1,container1] = javacomponent(S.jObject1, [], S.fh); % javacomponent(browser,pos,gcf);
set(container1,...
    'Units','norm',...
    'Parent', S.tab1,...
    'Pos',[0.2,0.01,0.78,0.99]);

S.jObject2 = com.mathworks.mlwidgets.html.HTMLBrowserPanel;
[browser2,container2] = javacomponent(S.jObject2, [], S.fh); % javacomponent(browser,pos,gcf);
set(container2,...
    'Units','norm',...
    'Parent', S.tab2,...
    'Pos',[0.2,0.01,0.78,0.99]);

S.jObject3 = com.mathworks.mlwidgets.html.HTMLBrowserPanel;
[browser3,container3] = javacomponent(S.jObject3, [], S.fh); % javacomponent(browser,pos,gcf);
set(container3,...
    'Units','norm',...
    'Parent', S.tab3,...
    'Pos',[0.005,0.01,0.99,0.99]);
set(S.tab3, 'userdata', browser3);

S.jObject4 = com.mathworks.mlwidgets.html.HTMLBrowserPanel; %add
[browser4,container4] = javacomponent(S.jObject4, [], S.fh); % javacomponent(browser,pos,gcf);
set(container4,...
    'Units','norm',...
    'Parent', S.tab4,...
    'Pos',[0.2,0.01,0.78,0.99]);
set(S.tab4, 'userdata', browser4); % add or not?
%% Create an edit box for search input
S.ed = uicontrol('style', 'edit',...
                  'string',[],...
                  'units', 'norm',...
                  'position',[0.015 0.9 0.15 0.09],...
                 'fontsize',22);
set(S.ed,'callback',{@ed_call,S});
%% Create a push button for search 
S.pb = uicontrol('style', 'pushbutton',...
                  'string','SEARCH',...
                  'units', 'norm',...
                  'position',[0.172 0.9 0.08 0.09],...
                 'fontsize',14);
set(S.pb,'callback',{@pb_call,S});

%% Create a save image button
S.pb2 = uicontrol('style', 'pushbutton',...
                  'string','Image Save',...
                  'units', 'norm',...
                  'Foregroundcolor', 'r',...
                  'parent', S.tab3,...
                  'position',[0.91 0.92 0.08 0.08],...
                 'fontsize',14);
set(S.pb2,'callback',{@pb2_call,S});

%% Create two listboxes
S.lb1 = uicontrol('style','listbox',...
                 'string',[],...
                 'units','norm',...
                 'parent', S.tab1,...
                 'pos', [0.01,0.01,0.15,0.99],...
                 'userdata', browser1);
set(S.lb1,'callback',{@lb1_call,S});
S.lb2 = uicontrol('style','listbox',...
                 'string',[],...
                 'units','norm',...
                 'parent', S.tab2,...
                 'pos', [0.01,0.01,0.15,0.99],...
                 'userdata', browser2);   
set(S.lb2,'callback',{@lb2_call,S});

S.tb1 = uitable(S.tab4,...
                 'units','norm',...
                 'data',[],...
                 'ColumnName', {'words', 'frequency'},...
                 'pos', [0.01,0.52,0.50,0.48]); 
        
S.tb2 = uitable(S.tab4,...
                 'units','norm',...
                 'data',[],...
                 'ColumnName', {'words', 'frequency'},...
                 'pos', [0.01,0.02,0.50,0.48]);

%% Create two static texts
S.txt_stat= uicontrol('style','text',...
                 'string','Start search on Gopas!',...
                 'units','norm',...
                 'pos', [0.28,0.91,0.2,0.06],...
                 'fontname', 'Calibri',...
                 'fontsize', 20);
S.txt_eval= uicontrol('style','text',...
                 'string','Nice place or not?',...
                 'units','norm',...
                 'pos', [0.6,0.91,0.2,0.06],...
                 'fontname', 'Calibri',...
                 'fontsize', 22);  
%% edit callback 
    function [] = ed_call(varargin)
        S.keyword = get(S.ed, 'string');
    end
%% pushbutton callback
    function [] = pb_call(varargin)
         % search GOPAS and get title/link list
        [S.num1,S.title1, S.link1] = searchGopas(S.keyword,1);
        [S.num2, S.title2, S.link2] = searchGopas(S.keyword,2);

        % show the title list in the list box
        set(S.lb1, 'string', S.title1);
        set(S.lb2, 'string', S.title2);

        % display 'Search Finished'
        set(S.txt_stat, 'string', 'Search Finished!');

        % renew the tab title
        set(S.tab1, 'title', ...
            sprintf('Recommendable: %d ', S.num1));
        set(S.tab2, 'title', ...
            sprintf('Unrecommendable: %d',S.num2));

        % display NAVER map browser in a Map tab
        mapbrowser = get(S.tab3, 'userdata');
        url_front = 'http://map.naver.com/?query=';
        url_back = '&type=SITE_1';
        url = [url_front S.keyword url_back];
        msg = 'Loading ... please wait';
        mapbrowser.setHtmlText(msg); pause(0.1); drawnow;
        mapbrowser.setCurrentLocation(url);

        % add recommend
        list_content1 = [];
        for i = 1:length(S.link1)
        options = weboptions('Timeout', 100);
        source2 = webread(S.link1{i}, options);
        content1 = regexp(source2, '<td align=left valign=top class=han style=line-height:165%>.*</span></div>','match');
        content1 = regexprep(content1, '</?.*?>',''); 
        list_content1 = [list_content1; content1];
        end   
        % add unrecommend
        list_content2 = [];
        for i = 1:length(S.link2)
        options = weboptions('Timeout', 100);
        source2 = webread(S.link2{i}, options);
        content2 = regexp(source2, '<td align=left valign=top class=han style=line-height:165%>.*</span></div>','match');
        content2 = regexprep(content2, '</?.*?>',''); 
        list_content2 = [list_content2 ;content2];
        end

        % listbox3(tab4) callback
       % list_newcontent1 = list_content1    
    allWords1 = regexp(list_content1,'\<\S+\>','match');% get all words
        % listbox4(tab4) callback
        %list_newcontent2 = list_content2    
    allWords2 = regexp(list_content2,'\<\S+\>','match');                    % get all words
    
    words1 = [];
    for k= 1:length(allWords1)
        newallwords1 = allWords1{k}';
        words1 = [words1 ; newallwords1];    
    end
    
    words2 = [];
    for k= 1:length(allWords2)
        newallwords2 = allWords2{k}';
        words2 = [words2 ; newallwords2];    
    end
   
    %count
    name = unique(words1)
 txt_number = zeros(length(name),1);
 for i = 1:length(name)
     num = 0;
    for k = 1:length(words1)
        % Plus one if any .txt found
        if strcmp(words1{k}, name{i})      
            num = num+1;
            txt_number(i) = num;
        end
    end
 end
 
 S.h1 = [name, num2cell(txt_number)];
 
    name = unique(words2)
 txt_number = zeros(length(name),1);
 for i = 1:length(name)
     num = 0;
    for k = 1:length(words2)
        % Plus one if any .txt found
        if strcmp(words2{k}, name{i})      
            num = num+1;
            txt_number(i) = num;
        end
    end
 end

 S.h2 = [name, num2cell(txt_number)];
    %
    set(S.tb1, 'data', S.h1);
    set(S.tb2, 'data', S.h2);
    
    
    
    % evaluate the keyword based on the total number of results
        if S.num1/S.num2 >= 2
            set(S.txt_eval, 'string', 'You should definitely try!');
            msgbox('Good Choice', 'Congratulation');
        elseif S.num1/S.num2 >= 1
            set(S.txt_eval, 'string', 'Not a bad place!');
            questdlg('Trust Your Gut', 'Question');
        elseif S.num1/S.num2 >= 0.5
            set(S.txt_eval, 'string', 'Controversial..');
            warndlg('!!! Warning', 'Warning');
        else 
            set(S.txt_eval, 'string', 'Nope!');
            errordlg('!!! Doomed', 'Doomed');
        end
    end

%% save picture call back
function [] = pb2_call(varargin)
    screencapture(S.tab3)
    end
%% listbox(recommendable) callback
    function [] = lb1_call(varargin)
        browser = get(S.lb1, 'userdata');
        idx = get(S.lb1, 'value');
        url = S.link1{idx};
        msg='Loading ... please wait';
        browser.setHtmlText(msg); pause(0.1); drawnow;
        browser.setCurrentLocation(url);
    end
%% listbox(unrecommendable) callback
    function [] = lb2_call(varargin)
        browser = get(S.lb2, 'userdata');
        idx = get(S.lb2, 'value');
        url = S.link2{idx};
        msg='Loading ... please wait';
        browser.setHtmlText(msg); pause(0.1); drawnow;
        browser.setCurrentLocation(url);
    end

end
