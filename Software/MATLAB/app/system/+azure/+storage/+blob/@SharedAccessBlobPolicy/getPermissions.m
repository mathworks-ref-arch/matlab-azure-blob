function permSet = getPermissions(obj)
% GETPERMISSIONS Gets the permissions for a shared access signature policy
% An array of azure.storage.blob.SharedAccessAccountBlobPermissions
% enumerations are returned.
%
%   % create a blob policy object
%   myPolicy = azure.storage.blob.SharedAccessBlobPolicy();
%   % add read and add privileges to that policy
%   myPolicy.setPermissionsFromString('ra');
%   % read back those permissions from the policy
%   myEnumPerms = myPolicy.getPermissions
%   x =
%     1x2 SharedAccessBlobPermissions enumeration array
%       READ    ADD
%

% Copyright 2018 The MathWorks, Inc.

% Create a logger object
logObj = Logger.getLogger();

% call the Handle method and assign iterator
permEnumSetJ = obj.Handle.getPermissions();
pIterator = permEnumSetJ.iterator();

% default to an empty array
permSet = azure.storage.blob.SharedAccessBlobPermissions.empty;

while (pIterator.hasNext())
    permJ = pIterator.next;
    switch char(permJ.toString)
        case 'ADD'
            permSet(end + 1) = azure.storage.blob.SharedAccessBlobPermissions.ADD; %#ok<AGROW>
        case 'CREATE'
            permSet(end + 1) = azure.storage.blob.SharedAccessBlobPermissions.CREATE; %#ok<AGROW>
        case 'DELETE'
            permSet(end + 1) = azure.storage.blob.SharedAccessBlobPermissions.DELETE; %#ok<AGROW>
        case 'READ'
            permSet(end + 1) = azure.storage.blob.SharedAccessBlobPermissions.READ; %#ok<AGROW>
        case 'WRITE'
            permSet(end + 1) = azure.storage.blob.SharedAccessBlobPermissions.WRITE; %#ok<AGROW>
        case 'LIST'
            permSet(end + 1) = azure.storage.blob.SharedAccessBlobPermissions.LIST; %#ok<AGROW>
        otherwise
            str = char(permJ.toString);
            write(logObj,'error',['Invalid SharedAccessBlobPermissions enum value: ', str]);
    end % switch
end
end % function
