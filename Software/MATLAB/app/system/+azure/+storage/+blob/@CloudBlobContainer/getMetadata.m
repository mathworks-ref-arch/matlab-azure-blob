function containerMapResult = getMetadata(obj, varargin)
% GETMETADATA Returns the metadata for the container
% This value is initialized with the metadata from the queue by a call to
% downloadAttributes, and is set on the queue with a call to uploadMetadata.
% Data is returned as containers.Map. If there is no metadata an empty
% containers.Map is returned.
%
% Example:
%   % set and retrieve a metadata key value pair
%   azContainer = azure.storage.blob.CloudBlobContainer(azClient,'mytestcontainer');
%   azContainer.setMetadata('key1','val1');
%   azContainer.uploadMetadata();
%   m = azContainer.getMetadata();
%   keys(m)
%   ans =
%     1x1 cell array
%       {'key1'}

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
