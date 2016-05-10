function vecspace
% Simulation of variable space with vector space simultaneously
% 2016-01-30
% Jaegu
clc
S.fh = figure('units','pixels','position',[300 200 800 600],'numbertitle','off',...
    'menubar','none','name','VectorSpace','renderer', 'painters','resize','off');
S.ax1 = axes('units','pixels','position',[50 320 335 250]); % variable space
S.ax2 = axes('units','pixels','position',[430 320 335 250]); % vector space

S.ax_param = axes('units','pixels','position',[207 20 385 250],'XTick',[],'YTick',[],'box','on'); %
S.cb_regress = uicontrol('style','checkbox','units','pixels','position',[30 240 147 50],...
    'string','regression line','value',0,'FontSize',15);
S.pb_reset = uicontrol('style','push','units','pixels','position',[30 200 147 50],...
    'fontsize',14,'string','Reset','callback',{@pb_reset,S});

% set variable space
S.maxRange = 50;
axis(S.ax1,'equal')
grid(S.ax1,'minor')
xlim(S.ax1,[-S.maxRange S.maxRange])
ylim(S.ax1,[-S.maxRange S.maxRange])
xLIM = get(S.ax1,'xlim');
yLIM = get(S.ax1,'ylim'); hold(S.ax1,'on')
plot(S.ax1,[xLIM(1) xLIM(2)],[0 0],'color',[0.7 0.7 0.7]);
plot(S.ax1,[0 0],[yLIM(1) yLIM(2)],'color',[0.7 0.7 0.7]); hold(S.ax1,'off')
title(S.ax1,'Variable space','FontSize',20)
xlabel(S.ax1,'variable \bfX','FontSize',20)
ylabel(S.ax1,'variable \bfY','FontSize',20)

% set vector space
plot(S.ax2,0,0,'bo')
axis(S.ax2,'equal')
xlim(S.ax2,[-S.maxRange*5 S.maxRange*5])
ylim(S.ax2,[-S.maxRange*5 S.maxRange*5])
title(S.ax2,'Vector space','FontSize',20)
set(S.ax2,'box','on')
set(S.ax2,'XTick',[])
set(S.ax2,'YTick',[])
set(S.ax2,'color',get(gcf,'color'))

% setup
S.LW = 5; % LineWidth
S.MS = 5; % MarkerSize
S.cnt = 0; % click count
S.LSline = [];

% set information axis
xlim(S.ax_param,[0 15])
ylim(S.ax_param,[0 10])

S.tx1 = text(0.5,8,sprintf('SD_{x}=%.1f, SD_{y}=%.1f, Angle=%.1f',0,0,0),'FontSize',22,...
                'Parent',S.ax_param);
S.tx2 = text(0.5,6,'\bfLine: \color{red}\rma\color{black}x + \color{blue}b \color{black}(\color{red}a\color{black}:slope,\color{blue}b\color{black}:intercept)',...
    'FontSize',22,'Parent',S.ax_param);
S.tx3 = text(0.5,4,['\color{red}a\color{black}',sprintf('=%.1f,',0),' \color{blue}b\color{black}',sprintf('=%.1f,',0),' \color{magenta}r\color{black}',sprintf('=%.1f',0)],...
    'FontSize',22,'Parent',S.ax_param);

% set buttondownfcn to plot points
set(S.ax1, 'buttondownfcn',{@ax_buttondown,S})
hold(S.ax1,'on'); hold(S.ax2,'on');

    function ax_buttondown(varargin)
        % ButtonDownFcn for the axes
        if strcmp(get(S.fh,'selectiontype'),'normal') % Left click
            S.cnt = S.cnt + 1;
            if S.cnt > 1
                set([S.hplot1;S.hplot2;S.LSline],'XData',[])
                set([S.hplot1;S.hplot2;S.LSline],'YData',[])
            end
            
            % plot current point
            pt = get(S.ax1, 'currentpoint');
            plot(S.ax1,pt(1),pt(3),'o','color','b');
            
            % save data
            xDATA = [S.ax1.Children(1:end-2).XData];
            yDATA = [S.ax1.Children(1:end-2).YData];
            
            %xDATA = xDATA - mean(xDATA);
            %yDATA = yDATA - mean(yDATA);
            
            % calculate vectors
            dotProduct = dot(xDATA,yDATA);
            angXY = acos(dotProduct/(norm(xDATA)*norm(yDATA)));
            
            xVec = [norm(xDATA),0];
            yVec = [cos(angXY)*norm(yDATA),sin(angXY)*norm(yDATA)];
            
            % plot least-squares line
            if get(S.cb_regress,'value')
                slope = dot(xDATA,yDATA)/dot(xDATA,xDATA);
                intercept = mean(yDATA) - slope*mean(xDATA);
                xvalues = -S.maxRange:.1:S.maxRange;
                S.LSline = plot(S.ax1,xvalues,xvalues*slope+intercept,'color',[0.7 0.7 0.7]);
            end
            
            % set information
            SDX = norm(xDATA);
            SDY = norm(yDATA);
            angXY_deg = angXY*180/pi;
            a = dot(xDATA,yDATA)/dot(xDATA,xDATA);
            b = mean(yDATA) - a*mean(xDATA);
            r = dot(xDATA,yDATA)/(norm(xDATA)*norm(yDATA));
            
            delete([S.tx1,S.tx3])
            S.tx1 = text(0.5,8,sprintf('SD_{x}=%.1f, SD_{y}=%.1f, Angle=%.1f',SDX,SDY,angXY_deg),'FontSize',22,...
                'Parent',S.ax_param);
            S.tx3 = text(0.5,4,['\color{red}a\color{black}',sprintf('=%.2f,',a),' \color{blue}b\color{black}',sprintf('=%.2f,',b),' \color{magenta}r\color{black}',sprintf('=%.2f',r)],...
                'FontSize',22,'Parent',S.ax_param);
            
            % plot vectors
            S.hplot1 = plot(S.ax2,[0 xVec(1)],[0 xVec(2)],'g-','LineWidth',S.LW);
            S.hplot2 = plot(S.ax2,[0 yVec(1)],[0 yVec(2)],'r-','LineWidth',S.LW);
            legend([S.hplot1,S.hplot2],'X','Y')
        end
    end

    function pb_reset(varargin)
        % remove data points
        set([S.ax1.Children(1:end-2)],'XData',[])
        set([S.ax1.Children(1:end-2)],'YData',[])
        
        set([S.ax2.Children(1:end-1)],'XData',[])
        set([S.ax2.Children(1:end-1)],'YData',[])
        
        delete([S.tx1,S.tx3]);
        if isfield(S,'tx1')
            S.tx1 = text(0.5,8,sprintf('SD_{x}=%.1f, SD_{y}=%.1f, Angle=%.1f',0,0,0),'FontSize',22,...
                'Parent',S.ax_param);
            S.tx3 = text(0.5,4,['\color{red}a\color{black}',sprintf('=%.1f,',0),' \color{blue}b\color{black}',sprintf('=%.1f,',0),' \color{magenta}r\color{black}',sprintf('=%.1f',0)],...
                'FontSize',22,'Parent',S.ax_param);
        end
    end
end

