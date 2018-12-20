classdef OperationContext < azure.object
    % OPERATIONCONTEXT class used for client settings such as proxy servers
    % This context will set the default proxy values based on the MATLAB preferences
    % where set and on Windows the system preferences. To override this behavior call
    % setDefaultProxy() subsequently with the desired arguments.
    %
    % Example:
    %   az = azure.storage.CloudStorageAccount;
    %   az.loadConfigurationSettings();
    %   az.connect();
    %   oc = azure.storage.OperationContext();
    %

    % Copyright 2017 The MathWorks, Inc.

    properties
    end

    methods
        function obj = OperationContext()
             % construct an operation context
             obj.Handle = com.microsoft.azure.storage.OperationContext();
             % set the default proxy based on the MATLAB or system
             % (Windows only) preferences
             obj.setDefaultProxy();
        end
    end
end
