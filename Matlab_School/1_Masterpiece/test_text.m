% f = figure('Name', 'Progress Bar Example', 'Position', [100 100 800 50]);
% 
% progressBar = uiProgressBar(f);
% 
% for i = 0:10:100
%     uiProgressBar(progressBar, i/100);
%     pause(.5);
% end

% 
%  h=waitbar(0,'Please wait','Name','Inputs'); 
%  N=100;
%     for o = 1:N %N is defined before
%       waitbar(o/N,h);
%       pause(.1)
%     end

% f = figure();
% set(f,'Position',[100,100,400,40]);
% MyProgressBar(f, 0.5); % corresponds to 50% progress

bg_color = 'g';
%fg_color = 'b';
figure()
h = axes('Units','pixel',...
    'XLim',[0 1],'YLim',[0 1],...
    'XTick',[],'YTick',[],...
    'Color',bg_color,...
    'XColor',bg_color,'YColor',bg_color,...
    'position', [30 30 30 30]);
set(h)

%%

S.pb_gb_color = [0.1 0.1 0.5];
S.pb_fg_color = 'w'
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
patch([0 0 0.999 0.999],[0 0.9 0.9 0],pb_fg_color,...
        'Parent',pb,...
        'EdgeColor','none',...
        'EraseMode','none');
    
%%

try 
    a = 1+3
catch 
    disp('you don''t have a gpu')
end


    