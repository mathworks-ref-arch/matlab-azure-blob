function parentCloudBlobDirectory = getParent(obj)
% GETPARENT returns the parent CloudBlobDirectory of a CloudBlobDirectory

% Copyright 2016 The MathWorks, Inc.

% Create a logger object
% logObj = Logger.getLogger();

parentCloudBlobDirectory = azure.storage.blob.CloudBlobDirectory(obj.Handle.getParent());

end
