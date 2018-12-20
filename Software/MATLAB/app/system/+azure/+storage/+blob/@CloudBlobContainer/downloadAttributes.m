function downloadAttributes(obj)
% DOWNLOADATTRIBUTES Downloads the container's attributes
% Attributes consist of metadata and properties.
%

% Copyright 2018 The MathWorks, Inc.

% For related info see: https://docs.microsoft.com/en-us/java/api/com.microsoft.azure.storage.blob._cloud_blob_container.downloadattributes

%logObj = Logger.getLogger();

obj.Handle.downloadAttributes()

end %function
