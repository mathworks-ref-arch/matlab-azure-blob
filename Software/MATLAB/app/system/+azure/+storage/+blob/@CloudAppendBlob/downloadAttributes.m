function  downloadAttributes(obj)
% DOWNLOADATTRIBUTES Populates a blob's properties and metadata
% This method populates the blob's system properties and user-defined metadata.
% Before reading or modifying a blob's properties or metadata, call this method
% retrieve the latest values for the blob's properties and metadata from Azure.
%
% Example:
%  % Given an existing container with a number of blobs
%  azContainer = azure.storage.blob.CloudBlobContainer(azClient,'testcontainer');
%  % get a list of the blobs in the container
%  l = azContainer.listBlobs();
%  % populate the properties and metadata
%  l{1}.downloadAttributes();
%  % get the metadata
%  m = l{1}.getMetadata()
%  m =
%    Map with properties:
%          Count: 1
%        KeyType: char
%      ValueType: char
%  keys(m)
%  ans =
%    1x1 cell array
%       {'mykey1'}


% Copyright 2018 The MathWorks, Inc.

% Create a logger object
% logObj = Logger.getLogger();

obj.Handle.downloadAttributes();

end
