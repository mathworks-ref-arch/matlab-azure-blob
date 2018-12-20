function parentCloudBlobDirectory = getParent(obj)
% GETPARENT returns the parent directory of a CloudBlockBlob
% The parent is returned as a azure.storage.blob.CloudBlobDirectory.

% Copyright 2016 The MathWorks, Inc.

% Create a logger object
% logObj = Logger.getLogger();

parentCloudBlobDirectory = azure.storage.blob.CloudBlobDirectory(obj.Handle.getParent());

end
