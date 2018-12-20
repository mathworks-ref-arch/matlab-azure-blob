function setPermissions(obj, permSet)
% SETPERMISSIONS Sets permissions for a shared access policy
% This policy is used for a Shared Access Signature. permSet
% should be an array of azure.storage.table.SharedAccessTablePermissions
% enumerations.

%   % create an array of permissions enumerations
%   permSet(1) = azure.storage.table.SharedAccessTablePermissions.ADD;
%   permSet(2) = azure.storage.table.SharedAccessTablePermissions.READ;
%   permSet(3) = azure.storage.table.SharedAccessTablePermissions.QUERY;
%   % create a table policy object
%   myPolicy = azure.storage.table.SharedAccessTablePolicy();
%   % set permissions on the policy
%   myPolicy.setPermissions(permSet);

% Copyright 2018 The MathWorks, Inc.

import java.util.EnumSet

% Create a logger object
logObj = Logger.getLogger();

% we use the EnumSet.of method to construct the EnumSet using the
% first entry and then the add methods to add further entries to this.
if numel(permSet) > 0
    switch char(permSet(1))
        case 'ADD'
            enumSetJ = EnumSet.of(com.microsoft.azure.storage.table.SharedAccessTablePermissions.ADD);
        case 'DELETE'
            enumSetJ = EnumSet.of(com.microsoft.azure.storage.table.SharedAccessTablePermissions.DELETE);
        case 'NONE'
            enumSetJ = EnumSet.of(com.microsoft.azure.storage.table.SharedAccessTablePermissions.NONE);
        case 'QUERY'
            enumSetJ = EnumSet.of(com.microsoft.azure.storage.table.SharedAccessTablePermissions.QUERY);
        case 'UPDATE'
            enumSetJ = EnumSet.of(com.microsoft.azure.storage.table.SharedAccessTablePermissions.UPDATE);
        otherwise
            str =  char(permSet(1));
            write(logObj,'error',['Invalid SharedAccessTablePermissions enum value: ',str]);
    end %switch
else
    write(logObj,'error','Array of input permissions is empty');
end


if numel(permSet) > 1
    for n=2:numel(permSet)
        switch char(permSet(n))
            case 'ADD'
                if ~enumSetJ.add(com.microsoft.azure.storage.table.SharedAccessTablePermissions.ADD)
                    write(logObj,'warning',['Error adding SharedAccessTablePermissions enum value: ',char(permSet(n))]);
                end
            case 'DELETE'
                if ~enumSetJ.add(com.microsoft.azure.storage.table.SharedAccessTablePermissions.DELETE)
                    write(logObj,'warning',['Error adding SharedAccessTablePermissions enum value: ',char(permSet(n))]);
                end
            case 'NONE'
                if ~enumSetJ.add(com.microsoft.azure.storage.table.SharedAccessTablePermissions.NONE)
                    write(logObj,'warning',['Error adding SharedAccessTablePermissions enum value: ',char(permSet(n))]);
                end
            case 'QUERY'
                if ~enumSetJ.add(com.microsoft.azure.storage.table.SharedAccessTablePermissions.QUERY)
                    write(logObj,'warning',['Error adding SharedAccessTablePermissions enum value: ',char(permSet(n))]);
                end
            case 'UPDATE'
                if ~enumSetJ.add(com.microsoft.azure.storage.table.SharedAccessTablePermissions.UPDATE)
                    write(logObj,'warning',['Error adding SharedAccessTablePermissions enum value: ',char(permSet(n))]);
                end
            otherwise
                str =  char(permSet(n));
                write(logObj,'error',['Invalid SharedAccessTablePermissions enum value: ',str]);
        end %switch
    end
end

obj.Handle.setPermissions(enumSetJ);

end %function
