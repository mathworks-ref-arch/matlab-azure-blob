function eFlag = exists(obj, varargin)
% EXISTS Method to check if a container exists
% Check if a container exists using this method.
%
%     % Connect to an Azure Cloud Storage Account
%     az = azure.storage.CloudStorageAccount;
%     az.loadConfigurationSettings();
%     az.connect();
%
%     % Create a client Object
%     client = azure.storage.blob.CloudBlobClient(az);
%     container = azure.storage.blob.CloudBlobContainer(client,'MyContainer');
%
%     % Create a container for the blobs
%     container.createIfNotExists();
%
%     % Check if the container exists
%     flag = container.exists();

% Copyright 2016 The MathWorks, Inc.

% Check if the container exists
eFlag = obj.Handle.exists();

end %function
