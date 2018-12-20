function Etag = getEtag(obj)
% GETETAG Gets the ETag value of the container
% The ETag value is a unique identifier that is updated when a write operation
% is performed against the container. It may be used to perform operations
% conditionally, providing concurrency control and improved efficiency. The
% Etag is returned as a char vector.
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

Etag = char(obj.Handle.getEtag());

end %function
