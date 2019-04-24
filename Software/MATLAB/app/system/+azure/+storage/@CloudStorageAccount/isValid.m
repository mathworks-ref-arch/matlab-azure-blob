function flag = isValid(obj, varargin)
% ISVALID Method to check if a given object is properly initialized
% This method tests if the object has been created correctly.
%
%
% Example:
%  az = azure.storage.CloudStorageAccount;
%  az.loadConfigurationSettings();
%  az.connect();
%
% The validity of the object is checked using:
%   [FLAG] = az.isValid();

% Copyright 2016 The MathWorks, Inc.

flag = ~isempty(obj.Handle) && strcmpi(class(obj.Handle), 'com.microsoft.azure.storage.CloudStorageAccount');

end %function
