function container = getContainer(obj)
% GETCONTAINER returns the container of a CloudBlockblob
% The container is returned as a azure.storage.blob.CloudBlobContainer.
%
% container = azure.storage.blob.CloudBlobContainer(myBlockBlob);

% Copyright 2016 The MathWorks, Inc.

% Create a logger object
% logObj = Logger.getLogger();

container = azure.storage.blob.CloudBlobContainer(obj.Handle.getContainer());

end
