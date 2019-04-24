function S = load(obj, blobname, varargin)
% LOAD Loads variables from an Azure Blob into a struct
% Note if only a subset of the variables in a file are required the entire
% file must still be downloaded in the background from Azure. load can be
% used very much like the functional form of the built-in load command.
%
% Example:
%       % load the variables from a .mat file stored as a blob in a given
%       % container
%       myVars = azContainer.load('myblobname.mat');
%   Or
%       myVars = azContainer.load('myblobname.mat', 'x', 'y');
%
% Non .mat files are also supported as per the built-in load command support.

% Copyright 2018 The MathWorks, Inc.

% Create a logger object
logObj = Logger.getLogger();

% empty struct to return if there is an error
S = [];

% assume same syntax as build-in load as will pass varargin through
if ~ischar(blobname)
    write(logObj,'error',['Invalid blobname argument: ',blobname]);
    return;
end

[~, ~, fileExt] = fileparts(blobname);
% create a temp file to save the results to
% use the extension of the provided blobname
% load from the resulting temp file with the built in load
tmpName = [tempname, fileExt];

% TODO find a cleaner way to do this and use azure.storage.blob.BlobType
% create a reference to the given blobname and download it
% determine if it is a CloudBlockBlob or a CloudAppendBlob first
cloudBlobJ = obj.Handle.getBlobReferenceFromServer(blobname);
propertiesJ = cloudBlobJ.getProperties();
typeJ = propertiesJ.getBlobType();
type = char(typeJ.toString());

switch type
case 'BLOCK_BLOB'
    blob = azure.storage.blob.CloudBlockBlob(obj, blobname);
case 'APPEND_BLOB'
    blob = azure.storage.blob.CloudAppendBlob(obj, blobname);
end

blob.download(tmpName);

% check what has been downloaded
try
    output = whos('-file',tmpName); %#ok<NASGU>
catch
    warnType = true;
    for n = 1:numel(varargin)
        if ischar(varargin{n})
            if strcmpi(varargin{n}, '-ascii')
                warnType = false;
            end
        end
    end
    % if whos can read the file and it is not -ascii that is being passed warn
    % about the type as load is likely to fail
    if warnType
        write(logObj,'debug',['Warning ' blobname ' is not a mat file']);
    end
end

% return a struct containing the variables from the file
S = load(tmpName, varargin{:});

% delete the local temp file
delete(tmpName);

end %function
