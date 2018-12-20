function outFlag = deleteIfExists(obj, varargin)
% DELETEIFEXISTS Method to delete a table on the Blob Storage Service
% The deleteIfExists method deletes a table on the Blob storage service.
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
%   tableHandle.deleteIfExists();
%
% This functions returns true if table was deleted otherwise false

% Copyright 2016 The MathWorks, Inc.

% The object should already be configured
outFlag = obj.Handle.deleteIfExists();

end %function
