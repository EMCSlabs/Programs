function [] = searchGopasGUI_ver2()
% Author:  Yeonjung Hong
% Date:  2016-01-20
%% Create a blank figure window 
S.fh = figure('units','pixels',...
              'position',[300 150 1500 700],... %[left bottom width height]
              'menubar','none',...
              'name','SearchGopas',...
              'numbertitle','off',...
              'resize','on');    
%% Create a uitabgroup and tabs
S.tabGroup = uitabgroup('units', 'norm',...
    'position', [0.025 0.025 0.95 0.85]); drawnow;
S.tab1 = uitab(S.tabGroup, 'title',char([52628, 52380]));
S.tab2 = uitab(S.tabGroup, 'title',char([51068, 48152]));
S.tab3 = uitab(S.tabGroup, 'title', 'Map');
S.tab4 = uitab(S.tabGroup, 'title', 'Word Cloud');
%% Add three browser objects (Do not Edit)
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

% S.jObject4 = com.mathworks.mlwidgets.html.HTMLBrowserPanel; %add
% [browser4,container4] = javacomponent(S.jObject4, [], S.fh); % javacomponent(browser,pos,gcf);
% set(container4,...
%     'Units','norm',...
%     'Parent', S.tab4,...
%     'Pos',[0.2,0.01,0.78,0.99]);
% set(S.tab4, 'userdata', browser4); % add or not?
%% Create an edit box for search input
S.ed = uicontrol('style', 'edit',...
                  'string',[],...
                  'units', 'norm',...
                  'position',[0.015 0.9 0.15 0.09],...
                 'fontsize',22);
set(S.ed,'callback',{@ed_call,S}); % function 'ed_call', starting variable 'S' (type=cell)
%% Create a push button for search 
S.pb = uicontrol('style', 'pushbutton',...
                  'string','SEARCH',...
                  'units', 'norm',...
                  'position',[0.172 0.9 0.08 0.09],...
                 'fontsize',14);
set(S.pb,'callback',{@pb_call,S});
S.pb2 = uicontrol('style', 'pushbutton',...
                  'string','Image Save',...
                  'units', 'norm',...
                  'Foregroundcolor', 'r',...
                  'parent', S.tab3,...
                  'position',[0.9 0.92 0.08 0.08],...
                 'fontsize',14);
set(S.pb2,'callback',{@pb2_call,S});
S.pb3 = uicontrol('style', 'pushbutton',...
                  'string',char([52628, 52380]),...
                  'units', 'norm',...
                  'Foregroundcolor', 'r',...
                  'parent', S.tab4,...
                  'position',[0.19,0.95,0.05,0.05],...
                 'fontsize',18);
set(S.pb3,'callback',{@pb3_call,S});
S.pb4 = uicontrol('style', 'pushbutton',...
                  'string',char([51068, 48152]),...
                  'units', 'norm',...
                  'Foregroundcolor', 'r',...
                  'parent', S.tab4,...
                  'position',[0.19,0.49,0.05,0.05],...
                 'fontsize',18);
set(S.pb4,'callback',{@pb4_call,S});
%% Create two listboxes
S.lb1 = uicontrol('style','listbox',...
                 'string',[],...
                 'units','norm',...
                 'parent', S.tab1,...
                 'pos', [0.01,0.01,0.19,0.99],...
                 'userdata', browser1,...
                 'fontsize',14);
set(S.lb1,'callback',{@lb1_call,S});
S.lb2 = uicontrol('style','listbox',...
                 'string',[],...
                 'units','norm',...
                 'parent', S.tab2,...
                 'pos', [0.01,0.01,0.19,0.99],...
                 'userdata', browser2,...
                 'fontsize',14);   
set(S.lb2,'callback',{@lb2_call,S});

S.tb1 = uitable(S.tab4,...
                 'units','norm',...
                 'data',[],...
                 'ColumnName', {'words', 'frequency'},...
                 'pos', [0.01,0.51,0.18,0.49]); 
        
S.tb2 = uitable(S.tab4,...
                 'units','norm',...
                 'data',[],...
                 'ColumnName', {'words', 'frequency'},...
                 'pos', [0.01,0.05,0.18,0.49]);

S.ax2 = axes('units','norm',...   
                  'parent', S.tab4,...
                  'visible','off',...
                  'pos',[0.15,0.55,0.8,0.4])

S.ax3 = axes('units','norm',...
                  'parent', S.tab4,...
                  'visible','off',...
                  'pos',[0.15,0.05,0.8,0.4])
%% Create one axes 
S.ax1 = axes('units','norm',...
    'visible', 'off',...
    'pos', [0.9,0.88,0.07,0.1]);   
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
                 'pos', [0.6,0.91,0.3,0.06],...
                 'fontname', 'Calibri',...
                 'fontsize', 22);
%% edit callback 
    function [] = ed_call(varargin)
        S.keyword = get(S.ed, 'string');
    end
%% search pb callback
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
            sprintf([char([52628, 52380]) ': %d'],S.num1));
        set(S.tab2, 'title', ...
            sprintf([char([51068, 48152]) ': %d'],S.num2));

        % display NAVER map browser in a Map tab
        mapbrowser = get(S.tab3, 'userdata');
        url_front = 'http://map.naver.com/?query=';
        url_back = '&type=SITE_1';
        url = [url_front S.keyword url_back];
        msg = 'Loading ... please wait';
        mapbrowser.setHtmlText(msg); pause(0.1); drawnow;
        mapbrowser.setCurrentLocation(url);
        %% Word Cloud
        list_content1 = [];
        for i = 1:length(S.link1)
        options = weboptions('Timeout', 100);
        source2 = webread(S.link1{i}, options);
        content1 = regexp(source2, '<td align=left valign=top class=han style=line-height:165%>.*</span></div>','match');
        content1 = regexprep(content1, '</?.*?>',''); 
        list_content1 = [list_content1; content1];
        fid1 = (list_content1{:});
        C1 = textscan(fid1, '%s', 'delimiter', ' ');
        C1 = C1{1};
        load post.mat
        for i = 1:length(post)
            C1 = regexprep(C1,post{1,i},'');
            C1 = regexprep(C1, '\W', '');
        end
        txt1 = C1;
        name1 = unique(txt1);
 txt_number1 = zeros(length(name1),1);
 for i = 1:length(name1)
    if size(name1{i,1}, 2) == 0
        name1{i,1} = ' ';
    end
end
 for i = 1:length(name1)
     num = 0;
    for k = 1:length(txt1)
        % Plus one if any .txt found
        if strcmp(txt1{k}, name1{i})      
            num = num+1;
            txt_number1(i) = num;
        end
    end
 end
    S.h1 = [name1, num2cell(txt_number1)];
    %
        S.h1 = sortrows(S.h1, -2)
    set(S.tb1, 'data', S.h1);
        end
      
        % add unrecommend
        list_content2 = [];
        for i = 1:length(S.link2)
        options = weboptions('Timeout', 100);
        source2 = webread(S.link2{i}, options);
        content2 = regexp(source2, '<td align=left valign=top class=han style=line-height:165%>.*</span></div>','match');
        content2 = regexprep(content2, '</?.*?>',''); 
        list_content2 = [list_content2 ;content2];
        fid2 =(list_content2{:});
        C2 = textscan(fid2, '%s', 'delimiter', ' ');
        C2 = C2{1};
        for i = 1:length(post)
            C2 = regexprep(C2,post{1,i},'');
            C2 = regexprep(C2, '\W', '');
        end
        txt2 = C2;
        name2 = unique(txt2);
 txt_number2 = zeros(length(name2),1);
 for i = 1:length(name2)
    if size(name2{i,1}, 2) == 0
        name2{i,1} = ' ';
    end
end
 for i = 1:length(name2)
     num = 0;
    for k = 1:length(txt2)
        % Plus one if any .txt found
        if strcmp(txt2{k}, name2{i})      
            num = num+1;
            txt_number2(i) = num;
        end
    end
 end
    S.h2 = [name2, num2cell(txt_number2)];
    %
    S.h2 = sortrows(S.h2, -2)
    set(S.tb2, 'data', S.h2);
        end

    % evaluate the keyword based on the total number of results
        if S.num1/S.num2 >= 2
            set(S.txt_eval, 'string', 'You should definitely try!');
            %msgbox('Good Choice', 'Congratulation');
            set(S.ax1, 'visible', 'on');
            axes(S.ax1)
            imshow('good.jpeg')
        elseif S.num1/S.num2 >= 1
            set(S.txt_eval, 'string', 'Trust Your Gut');
            %questdlg('Trust Your Gut', 'Question');
            set(S.ax1, 'visible', 'on');
            axes(S.ax1)
            imshow('soso.png')
        elseif S.num1/S.num2 >= 0.5
            set(S.txt_eval, 'string', 'Controversial..');
            %warndlg('!!! Warning', 'Warning');
            set(S.ax1, 'visible', 'on');
            axes(S.ax1)
            imshow('controversial.png')
        else 
            set(S.txt_eval, 'string', '!!! Doomed', 'Doomed');
            %errordlg('!!! Doomed', 'Doomed');
            set(S.ax1, 'visible', 'on');
            axes(S.ax1)
            imshow('bad.jpeg')
        end
    end
%% chuchun 3d
        function [] = pb3_call(varargin)
           newfig = figure('numbertitle','off',...
            'name',[char([52628, 52380]) '3D']);
%         axes(S.ax2)
numWords = 40;
if length(S.h1(:,1)) < numWords
    numWords = length(S.h1(:,1));
end

Word = S.h1(1:numWords,1);
Frequency = cell2mat(S.h1(1:numWords,2));

prompt = {'Spread (Xaxis)';...
    'Spread (Yaxis)';...
    'MaxFontSize';...
    'MinFontSize';...
    'Rotate(1:Yes, 0:No)';...
    'ColorMap';'Binary or Freq (Binary: 0, Freq: 1)'};
DefaultAns = {num2str(10),num2str(10),num2str(2),num2str(1),num2str(0),'jet',num2str(1)}; 
Answer={num2str(500),num2str(500),num2str(3),num2str(1),num2str(0),'jet',num2str(1)};
% options.Resize='on'; 
% options.WindowStyle='normal';
x_std=str2double(Answer(1)); y_std=str2double(Answer(2));
Max=str2double(Answer(3)); Min=str2double(Answer(4));
Rotate=str2double(Answer(5)); Color=char(Answer(6));
BorF=str2double(Answer(7));

key_words = Word;
switch Color
        case 'hsv'
    colors = colormap(hsv(length(key_words)));
        case 'jet'
    colors = colormap(jet(length(key_words)));
        case 'parula'
    colors = colormap(parula(length(key_words)));
        case 'hot'
    colors = colormap(hot(length(key_words)));
        case 'cool'
    colors = colormap(cool(length(key_words)));
        case 'spring'
    colors = colormap(spring(length(key_words)));
        case 'summer'
    colors = colormap(summer(length(key_words)));
        case 'autumn'
    colors = colormap(autumn(length(key_words)));
        case 'winter'
    colors = colormap(winter(length(key_words)));
end


[~,IX] = sort(Frequency,'descend');
Beta2=0.7;
sizes = (Frequency.^(Beta2)) * (Max-Min) + Min;
sizes= sizes*5
% Initialize



alpha=0.00000001;
Gamma=0.6;
Beta=0.6;
Delta=1.5;
lambda1=0.000000001;
lambda2=0.00000001;

pos(:,1) = randn(length(key_words),1); pos(:,2) = randn(length(key_words),1); pos(:,3)=randn(length(key_words),1);
[~,order] = sort(abs(pos(:,1).*pos(:,2)));
pos = pos(order,:);
pos(:,1) = x_std.*pos(:,1); 
pos(:,2) = y_std.*pos(:,2);

POS_G=zeros(length(key_words),3);
pos=pos+alpha*POS_G-alpha*(repmat((lambda1+Frequency.*lambda2),1,3).*pos);


% plot the data
xlim([-1500 1500]); % x axis range 
ylim([-1500 1500]); % y axis range

hold on


for i=1:length(IX)
%     h4 = text(pos(i,1),pos(i,2),pos(i,3),char(key_words{IX(i)}),'FontSize',sizes(IX(i)),'Color',colors(i,:),'HorizontalAlignment','center');
text(pos(i,1),pos(i,2),pos(i,3),char(key_words{IX(i)}),'FontSize',sizes(IX(i)),'Color',colors(i,:),'HorizontalAlignment','center');

    %     rotate text every other time if prompted
%     if Rotate==1
%         if mod(i,2)==0
%             set(h,'Rotation',180);
%         end
%     end
end
hold off
axis off
        end
%% ilban 3d !!
    function [] = pb4_call(varargin)
        newfig = figure('numbertitle','off',...
            'name',[char([51068, 48152]) '3D']);
% axes(S.ax3)

numWords = 40;
if length(S.h2(:,1)) < numWords
    numWords = length(S.h2(:,1));
end

Word = S.h2(1:numWords,1);
Frequency = cell2mat(S.h2(1:numWords,2));

prompt = {'Spread (Xaxis)';...
    'Spread (Yaxis)';...
    'MaxFontSize';...
    'MinFontSize';...
    'Rotate(1:Yes, 0:No)';...
    'ColorMap';'Binary or Freq (Binary: 0, Freq: 1)'};
DefaultAns = {num2str(10),num2str(10),num2str(2),num2str(1),num2str(0),'jet',num2str(1)}; 
Answer={num2str(500),num2str(500),num2str(3),num2str(1),num2str(0),'jet',num2str(1)};
% options.Resize='on'; 
% options.WindowStyle='normal';
x_std=str2double(Answer(1)); y_std=str2double(Answer(2));
Max=str2double(Answer(3)); Min=str2double(Answer(4));
Rotate=str2double(Answer(5)); Color=char(Answer(6));
BorF=str2double(Answer(7));

key_words = Word;
switch Color
        case 'hsv'
    colors = colormap(hsv(length(key_words)));
        case 'jet'
    colors = colormap(jet(length(key_words)));
        case 'parula'
    colors = colormap(parula(length(key_words)));
        case 'hot'
    colors = colormap(hot(length(key_words)));
        case 'cool'
    colors = colormap(cool(length(key_words)));
        case 'spring'
    colors = colormap(spring(length(key_words)));
        case 'summer'
    colors = colormap(summer(length(key_words)));
        case 'autumn'
    colors = colormap(autumn(length(key_words)));
        case 'winter'
    colors = colormap(winter(length(key_words)));
end


[~,IX] = sort(Frequency,'descend');
Beta2=0.7;
sizes = (Frequency.^(Beta2)) * (Max-Min) + Min;
sizes= sizes*5
% Initialize



alpha=0.00000001;
Gamma=0.6;
Beta=0.6;
Delta=1.5;
lambda1=0.000000001;
lambda2=0.00000001;

pos(:,1) = randn(length(key_words),1); pos(:,2) = randn(length(key_words),1); pos(:,3)=randn(length(key_words),1);
[~,order] = sort(abs(pos(:,1).*pos(:,2)));
pos = pos(order,:);
pos(:,1) = x_std.*pos(:,1); 
pos(:,2) = y_std.*pos(:,2);

POS_G=zeros(length(key_words),3);
pos=pos+alpha*POS_G-alpha*(repmat((lambda1+Frequency.*lambda2),1,3).*pos);


% plot the data
xlim([-1500 1500]); % x axis range 
ylim([-1500 1500]); % y axis range

hold on


for i=1:length(IX)
%     h4 = text(pos(i,1),pos(i,2),pos(i,3),char(key_words{IX(i)}),'FontSize',sizes(IX(i)),'Color',colors(i,:),'HorizontalAlignment','center');
text(pos(i,1),pos(i,2),pos(i,3),char(key_words{IX(i)}),'FontSize',sizes(IX(i)),'Color',colors(i,:),'HorizontalAlignment','center');

    %     rotate text every other time if prompted
%     if Rotate==1
%         if mod(i,2)==0
%             set(h,'Rotation',180);
%         end
%     end
end
hold off
axis off
    end
%% Screencapture
    function [] = pb2_call(varargin)
    screencapture(S.tab3)
    %set(S.pb2,'Callback','Way to go!')
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

