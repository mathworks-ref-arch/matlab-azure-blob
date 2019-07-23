function setMetadata(obj, metadata)
% SETMETADATA Sets metadata name-value pairs to be set with uploadMetadata
% This will overwrite any existing queue metadata. If this is set to an empty
% collection, the queue metadata will be cleared on an uploadMetadata call.

% Copyright 2019 The MathWorks, Inc.

if ~isa(metadata, 'containers.Map')
    logObj = Logger.getLogger();
    write(logObj,'error','Expected metadata of type containers.Map');
end

keys = metadata.keys();
values = metadata.values();
hMapJ = java.util.HashMap;
for n = 1:numel(keys)
    % add an entry to the HashMap per iteration
    hMapJ.put(keys{n}, values{n});
end

obj.Handle.setMetadata(hMapJ);

end
