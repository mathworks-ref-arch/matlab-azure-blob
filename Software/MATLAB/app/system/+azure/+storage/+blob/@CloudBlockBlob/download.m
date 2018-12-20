function download(obj, varargin)
% DOWNLOAD Method to download CloudBlockBlob(s)
% Use this method to download a CloudBlockBlob or an array of CloudBlockBlobs if
% a vector input is provided. If no argument is provided the current working
% directory will be used as the download destination and the blob name will be
% used as the filename. If a directory is provided then that directory will be
% used as the destination directory. When specifying a destination directory but
% not a destination file use a trailing delimiter. Again if a destination file
% name is not provided the blob name will be used as the filename. If vectorized
% blob inputs are provided avoid specifying a destination filename as all blobs
% will be downloaded with the same filename and so all but the last blob will be
% overwritten. A destination directory can be used in this scenario.
%
% If a blob has a virtual directory hierarchy, this hierarchy will be removed on
% download unless preserved by specifying the parameter 'useVirtualDirectory'
% as true. In which case the blob's virtual hierarchy will be appended to a
% destination directory, if specified, when creating the final download
% destination. This is a change to functionality in releases prior to 0.6.0.
%
% / & \ delimiters for virtual directories will be automatically altered to that
% used on the destination system if required. Other delimiters though supported
% by WASB will not be adjusted and in general are strongly discouraged. The
% default delimiter '/' is strongly recommended.
%
% Examples:
%   % download a list of CloudBlockBlobs to the current working directory using
%   % the blob names as filenames but removing any virtual directory hierarchy
%   blobList = azContainer.listBlobs();
%   for n=1:numel(blobList)
%     if isa(blobList{n}, azure.storage.blob.CloudBlockBlob)
%       blobList{n}.download()
%     end
%   end
%
%  % download a blob called SampleData.mat from the container azContainer to the
%  % current working directory
%  blob = azure.storage.blob.CloudBlockBlob(azContainer, 'SampleData.mat');
%  blob.download();
%
%  % download a blob called SampleData.mat from the container azContainer to the
%  % current working directory but retain the mydir1/mydir2 hierarchy
%  % Note, if setting useVirtualDirectory and not specifying a destination directory
%  % an empty directory, '', should be specified.
%  blob = azure.storage.blob.CloudBlockBlob(azContainer, 'mydir1/mydir2/SampleData.mat');
%  blob.download('','useVirtualDirectory',true);
%
%  % download a blob called SampleData.mat from the container azContainer to the
%  % directory /tmp/mydownloads/, do not retain virtual hierarchy but use the name
%  % SampleData.mat, note the trailing delimiter following mydownloads/
%  blob = azure.storage.blob.CloudBlockBlob(azContainer, 'mydir1/SampleData.mat');
%  blob.download('/tmp/mydownloads/');
%
%  % download a blob called myAzureName.txt from the container azContainer to the
%  % directory /mydownloads/ within the current working directory. The blob name
%  % is not used for the local download.
%  blob = azure.storage.blob.CloudBlockBlob(azContainer, 'myAzureName.txt');
%  blob.download(fullfile(pwd, '/mydownloads/myLocalName.txt'));
%

% Copyright 2018 The MathWorks, Inc.

% Imports
import java.io.*;

% Create a logger object
logObj = Logger.getLogger();

% validate input
p = inputParser;
p.CaseSensitive = false;
p.FunctionName = 'download';
addOptional(p,'destinationStr','',@ischar);
addParameter(p,'useVirtualDirectory',false,@islogical);
parse(p,varargin{:});
destinationStr = p.Results.destinationStr;
useVirtualDirectory = p.Results.useVirtualDirectory;

% Simple progress logging to the screen if verbose level output is enabled
% and input is vectorized
if strcmp(logObj.DisplayLevel, 'verbose') && numel(obj) > 1
    statusLog = true;
    fprintf(1,'\n');
else
    statusLog = false;
end

% If a destination string is provided clean it by changing delimiters to match
% the host OS
if isempty(destinationStr)
    adjustedDestinationDir = '';
    adjustedDestinationName = '';
    adjustedDestinationExt = '';
else
    adjustedDestinationStr = adjustDelimiters(destinationStr);
    [adjustedDestinationDir, adjustedDestinationName, adjustedDestinationExt] = fileparts(adjustedDestinationStr);
end

% For each object passed in set a destination and download it to that destination
for bCount = 1:numel(obj)

    % If a destination name has not been provided as an argument derive it from the blob name
    if isempty(adjustedDestinationName)
        [adjustedVirtualDirectory, adjustedDestinationName, adjustedDestinationExt] = fileparts(adjustDelimiters(obj(bCount).Name));
    end

    % If the flag to retain virtual directory hierarchy is set append it to the destination directory
    % which may or may not be set, if neither are set adjustedDestinationDir will be empty
    if useVirtualDirectory
        adjustedDestinationDir = fullfile(adjustedDestinationDir, adjustedVirtualDirectory);
    end

    % If there is a destination directory check if it exists and if not create it
    if ~isempty(adjustedDestinationDir)
        if exist(adjustedDestinationDir,'dir') ~= 7
            [status, msg] = mkdir(adjustedDestinationDir);
            if status ~= 1
                write(logObj,'error',['Error creating directory: ',adjustedDestinationDir, ' - ', msg]);
            end
        end
    end

    % Build the full filename to use with the file handle
    destinationFullName = fullfile(adjustedDestinationDir, [adjustedDestinationName, adjustedDestinationExt]);

    % Create a file output stream
    % TODO replace with downloadToFile when downloading to later SDK versions e.g. 8.0.0
    % or add error handling
    fileStream = FileOutputStream(destinationFullName);
    obj(bCount).Handle.download(fileStream);
    fileStream.close;

    % Simple progress bar
    if statusLog
        fprintf(1,'.');
        if mod(bCount,80) == 0
            fprintf(1,'\n');
        end
    end
end

% New line at end of simple progress bar
if statusLog
    fprintf(1,'\n');
end

end %function


% swap \ and / delimiters in paths
function adjusted  = adjustDelimiters(unadjusted)

if ~ischar(unadjusted)
    logObj = Logger.getLogger();
    write(logObj,'error','Expected input of type character vector');
end

if ispc
    adjusted = strrep(unadjusted, '/', '\');
else
    adjusted = strrep(unadjusted, '\', '/');
end
end
