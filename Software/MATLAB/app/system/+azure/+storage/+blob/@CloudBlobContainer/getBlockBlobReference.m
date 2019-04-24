function blob = getBlockBlobReference(obj, varargin)
% GETBLOBREFERENCE Method to create reference(s) to WASB CloudBlockBlob(s)
% This method will create CloudBlockBlob object(s). A local file name argument
% corresponding to the file being reference must be provided as a full path. An
% optional blob name may provided otherwise the file name will be used as the
% blob name. The file name and the blob name can also be provided as cell arrays
% allowing vectorized input.
%
%   % use which to expand a file name on the path
%   blob = container.getBlockBlobReference(which('MyData.mat'));
%   % provide a full path directly
%   blob = container.getBlockBlobReference('/my/local/path/filename.mat');
%   % provide a blob name
%   blob = container.getBlockBlobReference('/my/local/path/filename.mat', 'myalternatename.mat');
%
% The input can be a cell array of character vectors but they need to be
% fully qualified file names. In this case an array of CloudBlockBlobs will be
% returned:
%
%   blobs = container.getBlockBlobReference(myFileCellArray);
%   % with blob names
%   blobs = container.getBlockBlobReference(myFileNameCellArray, myBlobNameCellArray);
%
% The size and type of file and blob name arrays must match.

% Copyright 2018 The MathWorks, Inc.

logObj = Logger.getLogger();

% validate input
p = inputParser;
p.CaseSensitive = false;
p.FunctionName = 'getBlockBlobReference';
checkNames = @(x) ischar(x) || iscell(x);
addRequired(p,'localFileName',checkNames);
addOptional(p,'blobName','',checkNames);
parse(p,varargin{:});
localFileName = p.Results.localFileName;
% blobName may not be provided to the default of '' is tested for and the
% blobName is then based on the file name
blobName = p.Results.blobName;


% check type and size of name arguments
if ~isempty(blobName)
    if ~strcmp(class(localFileName), class(blobName))
        write(logObj,'error','File name and blob name arguments must both be of the same class');
    end

    if iscell(localFileName)
        if numel(localFileName) ~= numel(blobName)
            write(logObj,'error','The number of file names should match the number of blob names');
        end
    end
end

% Only one file was specified
if ischar(localFileName)
    if isempty(blobName)
        % derive the blobname from the filename
        % Deconstruct the name so that we can store it.
        [~, fileName, fileExt] = fileparts(localFileName);
        blobName = [fileName, fileExt];
    end
    blob = azure.storage.blob.CloudBlockBlob(obj, blobName, localFileName);
end

% Handle vectorized input
if iscell(localFileName)
    for fCount = 1:numel(localFileName)
        if ~ischar(localFileName{fCount})
            write(logObj,'error','Expected file name of type character vector');
        else
            % pass a container (obj) and the local file name to the constructor
            % and optionally a blob name
            if isempty(blobName)
                % derive the blobname from the filename
                % Deconstruct the name so that we can store it.
                [~, fileName, fileExt] = fileparts(localFileName{fCount});
                individualBlobName = [fileName, fileExt];
            else
                individualBlobName = blobName{fCount};
            end
            blob(fCount) = azure.storage.blob.CloudBlockBlob(obj, individualBlobName, localFileName{fCount});
        end
    end
end

end %function
