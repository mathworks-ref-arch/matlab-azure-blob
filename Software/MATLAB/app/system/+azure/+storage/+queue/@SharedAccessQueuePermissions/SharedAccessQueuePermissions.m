classdef SharedAccessQueuePermissions  < azure.object
% SHAREDACCESSQUEUEPERMISSIONS Specifies the set of possible permissions
% The permissions are used for a shared access queue policy.
%
% Valid values are:
%   ADD             Permission to add messages granted.
%   NONE	        No shared access granted.
%   PROCESSMESSAGES	Permission to get and delete messages granted.
%   READ	        Permission to peek messages and get queue metadata granted.
%   UPDATE          Permissions to update messages granted.

% Copyright 2019 The MathWorks, Inc.

enumeration
    ADD
    NONE
    PROCESSMESSAGES
    READ
    UPDATE
end

methods
    function typeJ = toJava(obj)
        switch obj
        case azure.storage.queue.SharedAccessQueuePermissions.ADD
            typeJ = com.microsoft.azure.storage.queue.SharedAccessQueuePermissions.ADD;
        case azure.storage.queue.SharedAccessQueuePermissions.NONE
            typeJ = com.microsoft.azure.storage.queue.SharedAccessQueuePermissions.NONE;
        case azure.storage.queue.SharedAccessQueuePermissions.PROCESSMESSAGES
            typeJ = com.microsoft.azure.storage.queue.SharedAccessQueuePermissions.PROCESSMESSAGES;
        case azure.storage.queue.SharedAccessQueuePermissions.READ
            typeJ = com.microsoft.azure.storage.queue.SharedAccessQueuePermissions.READ;
        case azure.storage.queue.SharedAccessQueuePermissions.UPDATE
            typeJ = com.microsoft.azure.storage.queue.SharedAccessQueuePermissions.UPDATE;
        otherwise
            logObj = Logger.getLogger();
            write(logObj,'error','azure.storage.queue.SharedAccessQueuePermissions');
        end
    end
end

end
