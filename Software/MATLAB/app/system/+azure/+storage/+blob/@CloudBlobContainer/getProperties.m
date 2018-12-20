function props = getProperties(obj)
% GETPROPERTIES Returns the properties for the container
%
% Example:
%   % Here we get the properties of an existing container
%   % and then return the Etag property
%   azContainer = azure.storage.blob.CloudBlobContainer(azClient,'mytestcontainer');
%   p = azContainer.getProperties();
%   p.getEtag()
%   ans =
%   '0x8D63A86D9B4B6EB'

% Copyright 2018 The MathWorks, Inc.

%logObj = Logger.getLogger();

props = azure.storage.blob.BlobContainerProperties();

props.Handle = obj.Handle.getProperties();

end %function
