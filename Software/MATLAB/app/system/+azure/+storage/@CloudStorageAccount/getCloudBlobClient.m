function bc = getCloudBlobClient(obj, varargin)
% GETCLOUDBLOBCLIENT Method to create a client for the Blob Service
% Use this method to create a handle to the CloudBlobClient to interact
% with the Blob API service.
%
% Example:
%  az = azure.storage.CloudStorageAccount;
%  az.loadConfigurationSettings();
%  az.connect();
%  bc = az.getCloudBlobClient();

% Copyright 2017 The MathWorks, Inc.

bc = azure.storage.blob.CloudBlobClient(obj);

end %function
