function outFlag = createIfNotExists(obj, varargin)
% CREATEIFNOTEXISTS Method to create a container on the Blob Storage service
% The createIfNotExists method creates a container on the Blob storage service.
%
%   % Connect to the Cloud Storage account
%   az = azure.storage.CloudStorageAccount;
%   az.loadConfigurationSettings();
%   az.connect();
%
%   % Create a client Object
%   client = azure.storage.blob.CloudBlobClient(az);
%
%   % Create a blob container and name it.
%   container = azure.storage.blob.CloudBlobContainer(client,'mycontainername');
%   container.createIfNotExists();
%
% This functions returns true if container was created otherwise false.

% Copyright 2016 The MathWorks, Inc.

% The object should already be configured
outFlag = obj.Handle.createIfNotExists();

end %function
