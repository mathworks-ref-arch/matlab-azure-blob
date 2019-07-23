function perms = downloadPermissions(obj)
% DOWNLOADPERMISSIONS Downloads the permission settings for the queue
% A azure.storage.queue.QueuePermissions object is returned.

% Copyright 2019 The MathWorks, Inc.

permsJ = obj.Handle.downloadPermissions();
perms = azure.storage.queue.QueuePermissions(permsJ);

end
