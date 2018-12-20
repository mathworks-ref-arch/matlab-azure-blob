function outFlag = deleteIfExists(obj, varargin)
% DELETEIFEXISTS Method to delete a container on the Blob Storage Service
% The deleteIfExists method deletes a container on the Blob storage service.
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
%   container = azure.storage.blob.CloudBlobContainer(client,'MyContainer');
%   container.deleteIfExists();
%
% This functions returns true if container was deleted otherwise false

% Copyright 2016 The MathWorks, Inc.

% The object should already be configured
outFlag = obj.Handle.deleteIfExists();

end %function
