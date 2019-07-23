function blobs = listBlobs(obj, prefix)
% LISTBLOBS Method to list the blobs in a container
% This method will list all the blobs in a container. The resulting cell array
% of blobs are of type CloudBlockBlob, CloudAppendBlob and or CloudBlobDirectory.
% Other blob types are not supported. An optional prefix can be provided for
% blob items for the container whose names begin with the specified prefix.
% This value must be preceded either by the name of the container or by the
% absolute path to the container. If no blobs are present an empty cell array
% will be returned.
%
% Example:
%   Connect to an Azure Cloud Storage Account
%   az = azure.storage.CloudStorageAccount;
%   az.loadConfigurationSettings();
%   az.connect();
%
%   % Create a client Object
%   client = azure.storage.blob.CloudBlobClient(az);
%   container = azure.storage.blob.CloudBlobContainer(client,'mycontainername');
%
%   % List the contents of the container
%   blobs = container.listBlobs()

% Copyright 2018 The MathWorks, Inc.

% Create a logger object
logObj = Logger.getLogger();

if nargin > 1
    if ~ischar(prefix)
        write(logObj,'error','Expecting prefix of type char');
    end
end

% The list of blobs returned will be com.microsoft.azure.storage.<xyz> blobs
% rather than azure.storage.<xyz> as they are being returned by a Handle call
if nargin > 1
    blobLazySegment = obj.Handle.listBlobs(prefix);
else
    blobLazySegment = obj.Handle.listBlobs();
end

% Retrieve the iterator for the object
blobIterator = blobLazySegment.iterator;

% Depending on whether the blob has elements iterate through the list
iCount = 0;
while blobIterator.hasNext()
    iCount = iCount + 1;
    blobNativeHandle = blobIterator.next();

    % get type of blob in each iteration
    blobType = class(blobNativeHandle);

    switch blobType
        case 'com.microsoft.azure.storage.blob.CloudBlockBlob'
            % if the entry is a CloudBlockBlob get it's name and construct
            % CloudBlockBlob from it and the container object
            blobs{iCount} = azure.storage.blob.CloudBlockBlob(obj, char(blobNativeHandle.getName())); %#ok<AGROW>

        case 'com.microsoft.azure.storage.blob.CloudAppendBlob'
            % if the entry is a CloudAppendBlob get it's name and construct
            % CloudAppendBlob from it and the container object
            blobs{iCount} = azure.storage.blob.CloudAppendBlob(obj, char(blobNativeHandle.getName())); %#ok<AGROW>

        case 'com.microsoft.azure.storage.blob.CloudBlobDirectory'
            % if the entry is a CloudBlobDirectory construct it from the native
            % CloudBlobDirectory object
            blobs{iCount} = azure.storage.blob.CloudBlobDirectory(blobNativeHandle); %#ok<AGROW>

        otherwise
            % page blobs may get here
            write(logObj,'error',['Blob class of type: ',blobType,' is not supported']);
    end
end

% As a safety return an empty if there were no blobs
if iCount == 0
    blobs = {};
end

end %function
