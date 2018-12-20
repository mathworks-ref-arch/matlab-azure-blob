function flag = isValid(obj, varargin)
% ISVALID Method to check if a given object is properly initialized
% This method tests if the object has been created and initialized
% correctly.
%
%   az = azure.storage.CloudStorageAccount;
%   az.loadConfigurationSettings();
%   az.connect();
%
%   client = azure.storage.blob.CloudBlobClient(az);
%   container = azure.storage.blob.CloudBlobContainer(client,'mycontainer');
%
% The validity of the object is checked using:
%   flag = container.isValid();

% Copyright 2018 The MathWorks, Inc.

flag = ~isempty(obj.Handle) && strcmpi(class(obj.Handle), 'com.microsoft.azure.storage.blob.CloudBlobContainer');

end %function
