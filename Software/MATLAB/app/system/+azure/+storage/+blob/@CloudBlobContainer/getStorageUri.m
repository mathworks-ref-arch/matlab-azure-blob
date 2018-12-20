function storageUri = getStorageUri(obj)
% GETSTORAGEURI returns the StorageUri for a container
% The URI is returned as a azure.storage.StorageUri object.


% Copyright 2018 The MathWorks, Inc.

storageUriJ = obj.getStorageUri();

storageUri = azure.storage.StorageUri(storageUriJ);

end %function
