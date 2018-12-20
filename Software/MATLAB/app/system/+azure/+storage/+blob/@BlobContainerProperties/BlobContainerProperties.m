classdef BlobContainerProperties < azure.object
% BLOBCONTAINERPROPERTIES Represents the system properties for a container

% Copyright 2018 The MathWorks, Inc.

methods
    function obj = BlobContainerProperties()
        import com.microsoft.azure.storage.blob.BlobContainerProperties;

        % logObj = Logger.getLogger();
        obj.Handle = com.microsoft.azure.storage.blob.BlobContainerProperties();

    end %function
end %methods
end %class
