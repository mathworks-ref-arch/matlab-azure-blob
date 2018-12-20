function flag = isValid(obj, varargin)
% ISVALID Method to check if a given object is properly initialized
% This method tests if the object has been created correctly.
%
%   az = azure.storage.CloudStorageAccount;
%   az.loadConfigurationSettings();
%   az.connect();
%
%   client = azure.storage.table.CloudTableClient(az);
%
% The validity of the object is checked using:
%   [FLAG] = client.isValid();

% Copyright 2016 The MathWorks, Inc.

flag = ~isempty(obj.Handle) && strcmpi(class(obj.Handle), 'com.microsoft.azure.storage.table.CloudTableClient');

end %function
