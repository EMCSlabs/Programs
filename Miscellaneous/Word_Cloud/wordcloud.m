function wordcloud(scriptFullPath,textDirFullPath)

% Usage: wordcloud('~/Downloads/matlabR/wordcloud.r','~/Downloads/matlabR/text/')
%
%    - wordcloud.r: script file to execute commands in R
%    - text: text directory including text files
%
%    PNG files will be created as output
%
%    * Prerequisite *
%    Install following packages in R
%
% 1) install.packages('wordcloud')
% 2) install.packages('png')
% 3) install.packages('tm')
% 4) install.packages('RColorBrewer')
%
% 2016-1-16

% Check script file
if ~exist(scriptFullPath)
    error('Check wordcloud.r file in your path')
end

% Check text directory
try
    dt = dir(textDirFullPath);
    dtNames = {dt.name};
catch
    error('Check your text directory and text files')
end

if sum(~cellfun(@isempty,regexp(dtNames,'.txt$'))) == 0
    error('No txt file in your text directory')
end

% read wordcloud.r
fid = fopen(scriptFullPath,'r');
C = textscan(fid,'%s','delimiter','\n');
fclose(fid);
C = C{1};
% change & write wordcloud.r
new = regexprep(C,'directory = .*',['directory = ''' textDirFullPath '''']);
fid = fopen(scriptFullPath,'w');
fprintf(fid,'%s\n',new{:});
fclose(fid);

% check R path
rpath = '/Library/Frameworks/R.framework/Versions/3.1/Resources/bin/R';
if ~exist(rpath)
    error(sprintf('Check your R path\nin %s',rpath))
end

% execute commands in R
disp('Creating wordcloud...')
system(sprintf('%s CMD BATCH %s',rpath,scriptFullPath));
disp('Finished')
