function permSet = getPermissions(obj)
% GETPERMISSIONS Gets the permissions for a shared access signature policy
% An array of azure.storage.table.SharedAccessAccountTablePermissions
% enumerations are returned.
%
%   % create a table policy object
%   myPolicy = azure.storage.table.SharedAccessTablePolicy();
%   % add query and add privileges to that policy
%   myPolicy.setPermissionsFromString('ra');
%   % read back those permissions from the policy
%   myEnumPerms = myPolicy.getPermissions
%   x =
%     1x2 SharedAccessTablePermissions enumeration array
%       QUERY    ADD
%

% Copyright 2018 The MathWorks, Inc.

% Create a logger object
logObj = Logger.getLogger();

% call the Handle method and assign iterator
permEnumSetJ = obj.Handle.getPermissions();
pIterator = permEnumSetJ.iterator();

% default to an empty array
permSet = azure.storage.table.SharedAccessTablePermissions.empty;

while (pIterator.hasNext())
    permJ = pIterator.next;
    switch char(permJ.toString)
        case 'ADD'
            permSet(end + 1) = azure.storage.table.SharedAccessTablePermissions.ADD; %#ok<AGROW>
        case 'DELETE'
            permSet(end + 1) = azure.storage.table.SharedAccessTablePermissions.DELETE; %#ok<AGROW>
        case 'NONE'
            permSet(end + 1) = azure.storage.table.SharedAccessTablePermissions.NONE; %#ok<AGROW>
        case 'QUERY'
            permSet(end + 1) = azure.storage.table.SharedAccessTablePermissions.QUERY; %#ok<AGROW>
        case 'UPDATE'
            permSet(end + 1) = azure.storage.table.SharedAccessTablePermissions.UPDATE; %#ok<AGROW>
        otherwise
            str = char(permJ.toString);
            write(logObj,'error',['Invalid SharedAccessTablePermissions enum value: ', str]);
    end % switch
end
end % function
