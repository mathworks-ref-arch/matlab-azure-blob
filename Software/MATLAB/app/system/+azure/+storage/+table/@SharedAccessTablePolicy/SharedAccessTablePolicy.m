classdef SharedAccessTablePolicy < azure.object
    % SHAREDACCESSTABLEPOLICY class represent shared access policy parameters
    % Represents a shared access policy, which specifies the start time, expiry
    % time, and permissions for a shared access signature.
    %
    %   myPolicy = azure.storage.table.SharedAccessTablePolicy;
    %

    % Copyright 2018 The MathWorks, Inc.

    properties
    end

    methods
        function obj = SharedAccessTablePolicy()
            % constructor
            obj.Handle = com.microsoft.azure.storage.table.SharedAccessTablePolicy();

        end % function
    end % methods


end % class
