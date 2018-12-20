function uploadPermissions(obj, perm)
% UPLOADPERMISSIONS Upload a permission set to control container access
% Use this method to set permissions on a container.
%
%   perm = azure.storage.blob.BlobContainerPermissions;
%
% Set one of the below as appropriate
%   perm.AccessType = 'BLOB';       % Blob level public access
%   perm.AccessType = 'CONTAINER';  % Container-level public access
%   perm.AccessType = 'OFF';        % Turn off public access
%
% Upload the permissions to Azure using:
%
%   azContainer.uploadPermissions(perm);

% Copyright 2018 The MathWorks, Inc.

%% Create a logger object
logObj = Logger.getLogger();

if isa(perm,'azure.storage.blob.BlobContainerPermissions')
    obj.Handle.uploadPermissions(perm.Handle);
else
    write(logObj,'error','Invalid permission settings');
end

end %function
