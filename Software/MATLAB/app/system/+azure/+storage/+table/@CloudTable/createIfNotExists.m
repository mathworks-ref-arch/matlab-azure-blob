function outFlag = createIfNotExists(obj, varargin)
% CREATEIFNOTEXISTS Method to create a table on the Blob Storage service
% The createIfNotExists method creates a table on the Table storage service.
%
%   % Connect to the Cloud Storage account
%   az = azure.storage.CloudStorageAccount;
%   az.loadConfigurationSettings();
%   az.connect();
%
%   % Create a client Object
%   client = azure.storage.table.CloudTableClient(az);
%
%   % Create a blob container and name it.
%   tableHandle = azure.storage.table.CloudTable(client,'MyTable');
%   tableHandle.createIfNotExists();
%
% This functions returns true if table was created otherwise false

% Copyright 2016 The MathWorks, Inc.

% The object should already be configured
outFlag = obj.Handle.createIfNotExists();

end %function
