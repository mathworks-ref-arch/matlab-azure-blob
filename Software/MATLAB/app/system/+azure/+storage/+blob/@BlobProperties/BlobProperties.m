classdef BlobProperties < azure.object
% BLOBPROPERTIES Represents the system properties for a blob

% Copyright 2018 The MathWorks, Inc.

methods
    function obj = BlobProperties()
        import com.microsoft.azure.storage.blob.BlobProperties;

        % logObj = Logger.getLogger();
        obj.Handle = com.microsoft.azure.storage.blob.BlobProperties();

    end %function
end %methods
end %class
