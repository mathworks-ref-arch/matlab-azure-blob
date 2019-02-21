function containerMapResult = getMetadata(obj, varargin)
% GETMETADATA Returns the metadata for the blob
% Data is returned as containers.Map. If there is no metadata and empty
% containers.Map is returned.
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

% logObj = Logger.getLogger();


% returns a java.util.HashMap
hashmapJ = obj.Handle.getMetadata();

% the following conversion process is not optimal for performance or scale
% but is straightforward and sufficient for object metadata

% return and entrySet to get an iterator
entrySetJ = hashmapJ.entrySet();
% get the iterator
iteratorJ = entrySetJ.iterator();

% declare empty cell arrays for values and keys
metadataKeys = {};
metadataValues = {};

while iteratorJ.hasNext()
    % pick metadata from the entry set one at a time
    entryJ = iteratorJ.next();
    % get the key and the value
    metadataKey = entryJ.getKey();
    metadataValue = entryJ.getValue();
    % build the cell arrays of keys and values
    metadataKeys{end+1} = metadataKey; %#ok<AGROW>
    metadataValues{end+1} = metadataValue; %#ok<AGROW>
end

% if the cell arrays are still empty then create an empty containers.Map and
% return that else build it from the arrays of values and keys
if isempty(metadataKeys)
    containerMapResult = containers.Map('KeyType','char','ValueType','char');
else
    containerMapResult = containers.Map(metadataKeys,metadataValues);
end

end %function
