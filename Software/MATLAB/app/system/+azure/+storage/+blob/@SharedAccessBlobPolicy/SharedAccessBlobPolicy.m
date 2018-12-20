classdef SharedAccessBlobPolicy < azure.object
    % SHAREDACCESSBLOBPOLICY class represent shared access policy parameters
    % Represents a shared access policy, which specifies the start time, expiry
    % time, and permissions for a shared access signature.
    %
    %   myPolicy = azure.storage.blob.SharedAccessBlobPolicy;

    % Copyright 2017 The MathWorks, Inc.

    properties
    end

    methods
        function obj = SharedAccessBlobPolicy()
            % constructor
            obj.Handle = com.microsoft.azure.storage.blob.SharedAccessBlobPolicy();

        end % function
    end % methods


end % class
