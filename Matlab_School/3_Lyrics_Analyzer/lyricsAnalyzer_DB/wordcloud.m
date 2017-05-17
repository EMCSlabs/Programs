function wordcloud(hObject, eventdata, handles, WordList)
%cla
fig = figure;
fig.Name = 'wordcloud';
fig.NumberTitle = 'off';
fig.Position = [230 250 800 800];
fig.DockControls = 'off';

numWords = 70;

if size(WordList(:,1),1) < numWords
    numWords = size(WordList(:,1),1);
end

sortrows(WordList,2);

Words = WordList{1:numWords,1};
Words(:,2) = num2cell(zeros(size(Words,1),1));
Words(:,3) = num2cell(zeros(size(Words,1),1));
Words(:,4) = num2cell(zeros(size(Words,1),1));
Words(:,5) = num2cell(zeros(size(Words,1),1));
firstFont = WordList{1,2};
Words(:,4) = num2cell(WordList{1:numWords,2}./firstFont.*80);

for i = 1:numWords
    d = randi([1 12]);
    switch d
        case 1
            Words(i,5) = {[0.9 0.9 0.1]};
        case 2
            Words(i,5) = {'m'};
        case 3
            Words(i,5) = {'c'};
        case 4
            Words(i,5) = {'r'};
        case 5
            Words(i,5) = {'g'};
        case 6
            Words(i,5) = {[0.5 0.5 0.8]};
        case 7
            Words(i,5) = {[0.5 0.5 1]};
        case 8
            Words(i,5) = {[0.2 0.7 0.1]};
        case 9
            Words(i,5) = {[0.1 0.2 0.8]};
        case 10
            Words(i,5) = {[0.9 0 0.8]};
        case 11
            Words(i,5) = {[0.2 0.5 0.9]};
        case 12
            Words(i,5) = {[1 0.2 0.1]};
    end
end

t = 0;
for i = 1:numWords
    t = [t randi([10 25])*(1/(10*sqrt(i)))];
    a(i) = sum(t);
end
x = sqrt(a).*cos(a)*0.7;
y = sqrt(a).*sin(a)*0.7;

for i = 1:numWords
x(i) = randn(1,1)/8 + x(i);
y(i) = randn(1,1)/8 + y(i);
end

Words(:,2) = num2cell(x');
Words(:,3) = num2cell(y');

for i = 1:size(x,2)
    r = randi([1 size(x,2)]);
    Words(i,2) = num2cell(x(r));
    Words(i,3) = num2cell(y(r));
    x(r) = [];
    y(r) = [];
end

Words(1,2) = num2cell(0);
Words(1,3) = num2cell(0);


xlim([-4 4]);
ylim([-4 4]);

hold on
for i=1:size(Words,1)
    h = text(Words{i,2},Words{i,3},Words{i,1},'FontUnits','pixels','FontSize',Words{i,4},'Color',Words{i,5},'HorizontalAlignment','center','VerticalAlignment','middle');
end
hold off
axis off
end