function props = getProperties(obj)
% GETPROPERTIES Returns the properties for the blob
%

% Copyright 2018 The MathWorks, Inc.

%logObj = Logger.getLogger();

props = azure.storage.blob.BlobProperties();

props.Handle = obj.Handle.getProperties();

end %function
