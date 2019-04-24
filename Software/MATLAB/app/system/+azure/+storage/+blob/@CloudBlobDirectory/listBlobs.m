function blobs = listBlobs(obj, prefix)
% LISTBLOBS Returns a list of blob items for the directory
% This method will list all the blobs for the directory. The resulting cell
% array of blobs are of type CloudBlockBlob, CloudAppendBlob and
% CloudBlobDirectory and can be used to manipulate the blobs or blob
% directories. Other blob types are not supported.
%
%   % Connect to an Azure Cloud Storage Account
%   az = azure.storage.CloudStorageAccount;
%   az.loadConfigurationSettings();
%   az.connect();
%
%   % Create a client Object
%   client = azure.storage.blob.CloudBlobClient(az);
%   % Create a container
%   container = azure.storage.blob.CloudBlobContainer(client,'mycontainername');
%   flag = azContainer.createIfNotExists();
%
%   myCloudBlobDirectory = container.getDirectoryReference('mydirname')
%   % List the contents of the CloudBlobDirectory, this should return an empty
%   % cell array as the container has just been created
%   blobs = myCloudBlobDirectory.listBlobs()
%
%   % Create a blob and upload it to the container in the directory
%   filename = 'SampleData.mat';
%   sampleData = rand(100,100);
%   save(filename, 'sampleData');
%   blob = azure.storage.blob.CloudBlockBlob(container, [myCloudBlobDirectory.Name, filename], which(filename));
%   blob.upload();
%
%   % List the blobs again, this time blobs{1} should contain a CloudBlockBlob
%   % with a name of 'mydirname/SampleData.mat'
%   blobs = myCloudBlobDirectory.listBlobs();


% Copyright 2018 The MathWorks, Inc.

% Create a logger object
logObj = Logger.getLogger();

if nargin > 1
    if ~ischar(prefix)
        write(logObj,'error','Expecting prefix of type char');
    end
end

% The list of blob returned will be com.microsoft.azure.storage.<xyz> blobs
% rather than azure.storage.<xyz> as they are being returned by a Handle call
if nargin > 1
    blobLazySegment = obj.Handle.listBlobs(prefix);
else
    blobLazySegment = obj.Handle.listBlobs();
end

% Retrieve the iterator for the object
blobIterator = blobLazySegment.iterator;

% Assume we will need the directory's container so get that once outside the
% while loop and construct an object for it
containerJ = obj.Handle.getContainer();
container = azure.storage.blob.CloudBlobContainer(containerJ);

% Depending on whether the iterator has elements iterate through the list
iCount = 0;
while blobIterator.hasNext()
    iCount = iCount + 1;
    blobNativeHandle = blobIterator.next();

    % get type of blob in each iteration
    blobType = class(blobNativeHandle);

    switch blobType
        case 'com.microsoft.azure.storage.blob.CloudBlockBlob'
            % use the directory's container obtained in advance
            blobName = char(blobNativeHandle.getName());
            blobs{iCount} = azure.storage.blob.CloudBlockBlob(container, blobName); %#ok<AGROW>

        case 'com.microsoft.azure.storage.blob.CloudAppendBlob'
            % use the directory's container obtained in advance
            blobName = char(blobNativeHandle.getName());
            blobs{iCount} = azure.storage.blob.CloudAppendBlob(container, blobName); %#ok<AGROW>

        case 'com.microsoft.azure.storage.blob.CloudBlobDirectory'
            % if the entry is a CloudBlobDirectory construct it directly
            blobs{iCount} = azure.storage.blob.CloudBlobDirectory(blobNativeHandle); %#ok<AGROW>

        otherwise
            % page blobs may get here
            write(logObj,'error',['Blob class of type: ',blobType,' is not supported']);
    end
end % while

% As a safety return an empty if there were no blobs
if iCount == 0
    blobs = {};
end

end %function
