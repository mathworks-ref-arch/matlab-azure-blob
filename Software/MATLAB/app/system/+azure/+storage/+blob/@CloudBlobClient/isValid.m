function flag = isValid(obj, varargin)
% ISVALID Method to check if a given object is properly initialized
% This method tests if the object has been created  correctly.
% True is returned if valid otherwise false.
%
%   az = azure.storage.CloudStorageAccount;
%   az.loadConfigurationSettings();
%   az.connect();
%
%   client = azure.storage.blob.CloudBlobClient(az);
%
% The validity of the object is checked using:
%   flag = client.isValid();

% Copyright 2016 The MathWorks, Inc.

flag = ~isempty(obj.Handle) && strcmpi(class(obj.Handle), 'com.microsoft.azure.storage.blob.CloudBlobClient');

end %function
