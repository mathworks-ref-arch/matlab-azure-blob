classdef BlobContainerPermissions < azure.object
% BLOBCONTAINERPERMISSIONS Object to set the permissions for a container
% Use this class to set permissions on Blobs or Containers or to turn off public
% access.
%
% Example:
%   perm = azure.storage.blob.BlobContainerPermissions;+
%   % Supported values:
%   perm.AccessType = 'BLOB'; % Blob level public access
%   perm.AccessType = 'CONTAINER';  % Container-level public access
%   perm.AccessType = 'OFF';        % Turn off public access
%
% This object can then be used in the uploadPermissions() method.

% Copyright 2016 The MathWorks, Inc.

properties(Dependent)
    AccessType = '';
end

properties(Hidden)
    i_AccessType = '';
end

methods
	%% Constructor
	function obj = BlobContainerPermissions(~, varargin)
        obj.i_AccessType = 'OFF'; % default
        obj.Handle = javaObject('com.microsoft.azure.storage.blob.BlobContainerPermissions');
    end

    %% Get/set for the AccessType
    function str = get.AccessType(obj)
        str = upper(obj.i_AccessType);
    end

    function set.AccessType(obj, str)
        % Imports
        import com.microsoft.azure.storage.blob.*;

        switch upper(str)
            case 'BLOB'
                % Set blob level public access
                obj.i_AccessType = 'BLOB';

                % Configure the handle accordingly
                obj.Handle.setPublicAccess(BlobContainerPublicAccessType.BLOB);

            case 'CONTAINER'
                % Set blob level public access
                obj.i_AccessType = 'CONTAINER';

                % Configure the handle accordingly
                obj.Handle.setPublicAccess(BlobContainerPublicAccessType.CONTAINER);

            case 'OFF'
                % Set blob level public access
                obj.i_AccessType = 'OFF';

                % Configure the handle accordingly
                obj.Handle.setPublicAccess(BlobContainerPublicAccessType.OFF);

        end
    end
end

end %class
