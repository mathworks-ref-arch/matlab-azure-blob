function eFlag = exists(obj, varargin)
% EXISTS Method to check if a table exists
% Check if a table exists using this method. For example:
%
%     % Connect to an Azure Cloud Storage Account
%     az = azure.storage.CloudStorageAccount;
%     az.loadConfigurationSettings();
%     az.connect();
%
%     % Create a client Object
%     client = azure.storage.table.CloudTableClient(az);
%     tableHandle = azure.storage.table.CloudTable(client,'MyTable');
%
%     % Create a container for the blobs
%     tableHandle.createIfNotExists();
%
%     % Check if the container exists
%     flag = container.exists();

% Copyright 2016 The MathWorks, Inc.

% Check if the container exists
eFlag = obj.Handle.exists();

end %function
