function tf = generateApiDoc(varargin)
% GENERATEAPIDOC generates a Markdown file with Azure WASB interface help entries
% Returns true if successful and false if not. If a filename (& path) is specified
% it is used to create the Markdown file in the
% Azure-WASB/Documentation directory.
%

% Copyright 2017 The MathWorks, Inc.

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Customise package settings here:
targetObject = 'azure.object';
% Azure dir will be 8 levels up from the object directory
defaultOutputFile = 'AzureWASBApi.md';
clientDir = fullfile('Software','MATLAB','app','system','+azure');
docDir = 'Documentation';
functionDir = fullfile('Software','MATLAB','app','functions');
title = 'MATLAB Interface *for Windows Azure Storage Blob (WASB)*';
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


logObj = Logger.getLogger();

% basic validation of input args
if nargin > 1
    write(logObj,'warning','Invalid number of input arguments');
    tf = false;
    return;
end

% pull out the path based on something we know i.e. where listContainers is
% should give something like:
% c:\local\git\azure\Software\MATLAB\app\system\+azure\@CloudBlobClient
[pathName,fileName,extension] = fileparts(which(targetObject));
pathParts = split(pathName, filesep);
% check that the paths gets longer
if length(pathParts) < length(split(clientDir, filesep)) + 1
     % something wrong path is too short, error and return
     write(logObj,'warning',['Invalid path to object: ',pathName,filesep,fileName,extension]);
     tf = false;
     return;
end

% build a root directory
% assume software is a unique entry in the tree so check this
n = strfind(pathName, 'Software');
if length(n) ~= 1 || n(1) < 1
     write(logObj,'warning',['Invalid Software entry in path: ',pathName]);
     tf = false;
     return;
end
% works back up the tree to find 'Software'
for n = length(pathParts):-1:1
    if strcmpi('Software',char(pathParts(n)))
        rootDir = '';
        % the work from the start to that point to build the root dir
        for m = 1:n-1
            rootDir = [rootDir, char(pathParts(m)), filesep]; %#ok<AGROW>
        end
        % remove the trailing filesep
        rootDir = strip(rootDir, 'right', filesep);
        break;
    end
end


% build a list of object folders in the directories
objDirList = buildDirList([rootDir, filesep, clientDir]);


% if no output filename is given use the default
% a full path is expected as an argument if provided
if nargin == 0
    fidName = [rootDir, filesep, docDir, filesep, defaultOutputFile];
else
    fidName  = varargin{1};
end

[fid, ferrmsg] = fopen(fidName,'w');
if fid == -1
    write(logObj,'warning',['Unable to open file: ',fidName]);
    write(logObj,'warning',['fopen error message: ',ferrmsg]);
    tf = false;
    return;
end
% open the file and write header
fprintf(fid, ['# ', title, '\n\n\n']);
% don't timestamp for now as it will break diff'ing
% fprintf(fid,'Generated on: %s\n\n',char(datetime));

% Write out a list of objects
fprintf(fid,'## Objects:\n');
for n = 1:length(objDirList)
    % foreach object dir
    tmp = char(objDirList{n});
    % strip off the root dir
    tmp = tmp(length(rootDir)+2:end);
    % use only one type of file sep on output for automatic verification
    tmp = strrep(tmp,'/','\');
    fprintf(fid,'* `%s`\n', tmp);
end
fprintf(fid,'\n\n\n------');

for n = 1:length(objDirList)
    % for each object directory build a list of m files
    objFileList = dir([objDirList{n}, filesep, '*.m']);
    % write the directory name as a 'section' heading
    objPathParts = split(objDirList{n}, filesep);
    fprintf(fid,'\n\n## %s\n\n', objPathParts{end});
    for j = 1:length(objFileList)
        % for each file lookup the help entry passing help a full file name
        % write out the entries as MATLAB code blocks which seems to look
        % okay in the reader used to date
        % print the object name and the file name
        fprintf(fid,'### %s/%s\n', objPathParts{end}, char(objFileList(j).name));
        % rebuild the full path + filename as an argument for extractHelp
        helpText = extractHelp([char(objFileList(j).folder), filesep, char(objFileList(j).name)]);
        if contains(helpText,'×')
            warning(['Fancy x characters found in >>>>>>',helpText]);
        end
        helpTextClean = strrep(helpText,'×','x');
        % specify a nonexistent (probably) language so it is more likely
        % to be rendered as plain text within code blocks
        fprintf(fid,'```notalanguage\n');
        fprintf(fid,'%s\n\n\n',helpTextClean);
        fprintf(fid,'```\n');
    end
    % put in lines between the contents of each directory to break it up
    fprintf(fid,'\n------\n');
end

% object tree completed now pick up misc functions from the function tree
% assumes this is a flat single level directory, check for subdirs
entries = dir([rootDir, filesep, functionDir]);
dirEntries = [entries.isdir];
% 2 allows for the .. and . entries
if sum(dirEntries) > 2
    write(logObj,'warning','function directory has unexpected subdirectories');
    tf = false;
    % close the file cleanly
    fclose(fid);
    return;
end

% build a list of files
functionList = dir([rootDir, filesep, functionDir, filesep, '*.m']);
if ~isempty(functionList)
    % print a section heading ONLY if there are files
    fprintf(fid,'\n## Misc. Related Functions\n');
end
for j = 1:length(functionList)
    % for each file lookup the help entry passing help a full file name
    % write out the entries as MATLAB code blocks which seems to look
    % okay in the reader used to date
    fprintf(fid,'### functions/%s\n',char(functionList(j).name));
    helpText = extractHelp( [char(functionList(j).folder), filesep, char(functionList(j).name)] );
    % specific a nonexistent (probably) language so it is more likely
    % to be rendered as plain text within code blocks
    fprintf(fid,'```notalanguage\n');
    fprintf(fid,'%s\n\n\n',helpText);
    fprintf(fid,'```\n');
end

% print a footer
fprintf(fid,'\n\n\n------------    \n');
currentYear = char(datetime('now','Format','yyyy'));
fprintf(fid,'\n[//]: # (Copy');
fprintf(fid,'right %s The MathWorks, Inc.)\n',currentYear);

% close the file handle
fclose(fid);

write(logObj,'debug',['Generated API documentation: ',fidName]);
tf = true;

end
