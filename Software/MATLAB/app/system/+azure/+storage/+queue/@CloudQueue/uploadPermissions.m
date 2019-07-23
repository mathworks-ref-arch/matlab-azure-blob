function uploadPermissions(obj, permissions)
% UPLOADMETADATA Uploads the queue's permissions

% Copyright 2019 The MathWorks, Inc.

if isa(permissions, 'azure.storage.queue.QueuePermissions')
    obj.Handle.uploadPermissions(permissions.Handle);
else
    logObj = Logger.getLogger();
    write(logObj,'error','Expected argument of type azure.storage.queue.QueuePermissions');
end

end
