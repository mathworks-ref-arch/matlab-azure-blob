function tc = getCloudTableClient(obj, varargin)
% GETCLOUDTABLECLIENT Method to create a cloud storage client
% Use this method to create a handle to the CloudTableClient to interact
% with the Table API service.
%
%   az = azure.storage.CloudStorageAccount;
%   az.loadConfigurationSettings();
%   az.connect();
%   tc = az.getCloudTableClient();

% Copyright 2017 The MathWorks, Inc.

tc = azure.storage.table.CloudTableClient(obj);

end %function
