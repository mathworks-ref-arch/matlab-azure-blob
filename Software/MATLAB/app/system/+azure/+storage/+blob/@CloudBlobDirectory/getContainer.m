function container = getContainer(obj)
% GETCONTAINER returns the container object of a CloudBlobDirectory

% Copyright 2016 The MathWorks, Inc.

% Create a logger object
% logObj = Logger.getLogger();

container = azure.storage.blob.CloudBlobContainer(obj.Handle.getContainer());

end
