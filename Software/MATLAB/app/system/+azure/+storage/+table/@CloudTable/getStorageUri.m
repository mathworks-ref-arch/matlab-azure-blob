function uri = getStorageUri(obj)
% GETSTORAGEURI Returns the list of URIs for all locations
%

% TODO add example and test

% Copyright 2018 The MathWorks, Inc.

% Check if the container exists
uriJ = obj.Handle.getStorageUri();

uri = azure.storage.StorageUri(uriJ);

end %function
