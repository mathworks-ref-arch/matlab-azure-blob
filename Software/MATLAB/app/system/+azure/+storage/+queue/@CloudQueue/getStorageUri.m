function uri = getStorageUri(obj)
% GETSTORAGEURI Returns the list of URIs for all locations

% Copyright 2019 The MathWorks, Inc.

uri = azure.storage.StorageUri(obj.Handle.getStorageUri);

end
