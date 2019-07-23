function result = getMetadata(obj)
% GETMETADATA Gets metadata collection for the queue as stored in this object
% This value is initialized with the metadata from the queue by a call to
% downloadAttributes, and is set on the queue with a call to uploadMetadata.
% A containers.Map is returned, if there is no metadata an empty containers.Map
% is returned.
%
% Example:
%    queue.downloadAttributes();
%    metadata = queue2.getMetadata();
%    keys(metadata)
%    values(metadata)

% Copyright 2019 The MathWorks, Inc.

mapJ = obj.Handle.getMetadata();

if isempty(mapJ)
    result = containers.Map();
else
    % return and entrySet to get an iterator
    entrySetJ = mapJ.entrySet();
    % get the iterator
    entrySetIteratorJ = entrySetJ.iterator();
    % declare empty cell arrays for values and keys
    mapKeys = {};
    mapValues = {};

    while entrySetIteratorJ.hasNext()
        % pick metadata from the entry set one at a time
        entryJ = entrySetIteratorJ.next();
        % get the key and the value
        mapKey = entryJ.getKey();
        mapValueJ = entryJ.getValue();
        % build the cell arrays of keys and values
        mapKeys{end+1} = mapKey; %#ok<AGROW>
        if ischar(mapValueJ)
            mapValues{end+1} = mapValueJ; %#ok<AGROW>
        else
            logObj = Logger.getLogger();
            write(logObj,'error','Metadata value not of type character vector');
        end
    end
    result = containers.Map(mapKeys, mapValues);
end

end
