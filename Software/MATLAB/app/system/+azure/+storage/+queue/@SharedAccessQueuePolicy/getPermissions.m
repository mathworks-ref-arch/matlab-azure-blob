function permSet = getPermissions(obj)
% GETPERMISSIONS Gets the permissions for a shared access signature policy
% An array of azure.storage.queue.SharedAccessQueuePermissions
% enumerations are returned.
%
%   % create a queue policy object
%   myPolicy = azure.storage.queue.SharedAccessQueuePolicy();
%   % add read and add privileges to that policy
%   myPolicy.setPermissionsFromString('ra');
%   % read back those permissions from the policy
%   myEnumPerms = myPolicy.getPermissions
%   x =
%     1x2 SharedAccessQueuePermissions enumeration array
%       READ    ADD

% Copyright 2019 The MathWorks, Inc.

% call the Handle method and assign iterator
permEnumSetJ = obj.Handle.getPermissions();
pIterator = permEnumSetJ.iterator();

% default to an empty array
permSet = azure.storage.queue.SharedAccessQueuePermissions.empty;

while (pIterator.hasNext())
    permJ = pIterator.next;
    switch char(permJ.toString)
        case 'ADD'
            permSet(end + 1) = azure.storage.queue.SharedAccessQueuePermissions.ADD; %#ok<AGROW>
        case 'NONE'
            permSet(end + 1) = azure.storage.queue.SharedAccessQueuePermissions.NONE; %#ok<AGROW>
        case 'PROCESSMESSAGES'
            permSet(end + 1) = azure.storage.queue.SharedAccessQueuePermissions.PROCESSMESSAGES; %#ok<AGROW>
        case 'READ'
            permSet(end + 1) = azure.storage.queue.SharedAccessQueuePermissions.READ; %#ok<AGROW>
        case 'UPDATE'
            permSet(end + 1) = azure.storage.queue.SharedAccessQueuePermissions.UPDATE; %#ok<AGROW>
        otherwise
            str = char(permJ.toString);
            logObj = Logger.getLogger();
            write(logObj,'error',['Invalid SharedAccessQueuePermissions enum value: ', str]);
    end % switch
end
end % function
