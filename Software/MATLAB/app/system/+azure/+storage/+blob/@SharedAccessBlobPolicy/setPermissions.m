function setPermissions(obj, permSet)
% SETPERMISSIONS Sets permissions for a shared access policy
% This policy is used for a Shared Access Signature. permSet
% should be an array of azure.storage.blob.SharedAccessBlobPermissions
% enumerations.
%
%   % create an array of permissions enumerations
%   permSet(1) = azure.storage.blob.SharedAccessBlobPermissions.ADD;
%   permSet(2) = azure.storage.blob.SharedAccessBlobPermissions.READ;
%   permSet(3) = azure.storage.blob.SharedAccessBlobPermissions.CREATE;
%   % create a blob policy object
%   myPolicy = azure.storage.blob.SharedAccessBlobPolicy();
%   % set permissions on the policy
%   myPolicy.setPermissions(permSet);
%

% Copyright 2018 The MathWorks, Inc.

import java.util.EnumSet

% Create a logger object
logObj = Logger.getLogger();

% we use the EnumSet.of method to construct the EnumSet using the
% first entry and then the add methods to add further entries to this.
if numel(permSet) > 0
    switch char(permSet(1))
        case 'ADD'
            enumSetJ = EnumSet.of(com.microsoft.azure.storage.blob.SharedAccessBlobPermissions.ADD);
        case 'CREATE'
            enumSetJ = EnumSet.of(com.microsoft.azure.storage.blob.SharedAccessBlobPermissions.CREATE);
        case 'DELETE'
            enumSetJ = EnumSet.of(com.microsoft.azure.storage.blob.SharedAccessBlobPermissions.DELETE);
        case 'READ'
            enumSetJ = EnumSet.of(com.microsoft.azure.storage.blob.SharedAccessBlobPermissions.READ);
        case 'WRITE'
            enumSetJ = EnumSet.of(com.microsoft.azure.storage.blob.SharedAccessBlobPermissions.WRITE);
        otherwise
            str =  char(permSet(1));
            write(logObj,'error',['Invalid SharedAccessBlobPermissions enum value: ',str]);
    end %switch
else
    write(logObj,'error','Array of input permissions is empty');
end


if numel(permSet) > 1
    for n=2:numel(permSet)
        switch char(permSet(n))
            case 'ADD'
                if ~enumSetJ.add(com.microsoft.azure.storage.blob.SharedAccessBlobPermissions.ADD)
                    write(logObj,'warning',['Error adding SharedAccessBlobPermissions enum value: ',char(permSet(n))]);
                end
            case 'CREATE'
                if ~enumSetJ.add(com.microsoft.azure.storage.blob.SharedAccessBlobPermissions.CREATE)
                    write(logObj,'warning',['Error adding SharedAccessBlobPermissions enum value: ',char(permSet(n))]);
                end
            case 'DELETE'
                if ~enumSetJ.add(com.microsoft.azure.storage.blob.SharedAccessBlobPermissions.DELETE)
                    write(logObj,'warning',['Error adding SharedAccessBlobPermissions enum value: ',char(permSet(n))]);
                end
            case 'READ'
                if ~enumSetJ.add(com.microsoft.azure.storage.blob.SharedAccessBlobPermissions.READ)
                    write(logObj,'warning',['Error adding SharedAccessBlobPermissions enum value: ',char(permSet(n))]);
                end
            case 'WRITE'
                if ~enumSetJ.add(com.microsoft.azure.storage.blob.SharedAccessBlobPermissions.WRITE)
                    write(logObj,'warning',['Error adding SharedAccessBlobPermissions enum value: ',char(permSet(n))]);
                end
            otherwise
                str =  char(permSet(n));
                write(logObj,'error',['Invalid SharedAccessBlobPermissions enum value: ',str]);
        end %switch
    end
end

obj.Handle.setPermissions(enumSetJ);

end %function
