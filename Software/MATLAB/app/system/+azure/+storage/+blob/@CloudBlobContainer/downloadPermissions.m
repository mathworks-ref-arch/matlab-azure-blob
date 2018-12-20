function perm = downloadPermissions(obj, varargin)
% DOWNLOADPERMISSIONS Downloads the permission settings for a container
% Use this methods to get the permissions for a container.
%
%   perm = azContainer.downloadPermissions();
%
% Perms should now have one of the following AccessTypes:
%   'OFF', 'BLOB' or 'CONTAINER'

% Copyright 2018 The MathWorks, Inc.

% Create a logger object
logObj = Logger.getLogger();

% decalre a permissions object to return
perm = azure.storage.blob.BlobContainerPermissions;
% get the java permissions object
BlobContainerPermissionsJ = obj.Handle.downloadPermissions();
% get the access type from this
PublicAccesTypeJ = BlobContainerPermissionsJ.getPublicAccess();
% convert this to a string to test against
PublicAccesType  = char(PublicAccesTypeJ.toString);

switch upper(PublicAccesType)
    case 'OFF'
        perm.AccessType = 'OFF';
    case 'BLOB'
        perm.AccessType = 'BLOB';
    case 'CONTAINER'
        perm.AccessType = 'CONTAINER';
    otherwise
        write(logObj,'error',['Invalid PublicAccessType: ', PublicAccessType]);
end

end %function
