function connect(obj, varargin)
% CONNECT Method to setup the account handle to connect to MS Azure
% Setup the handle to the Microsoft Azure Account by parsing the connection
% string and returning a handle used to create the client handle for
% service calls to Azure.
%
%   az = azure.storage.CloudStorageAccount;
%   az.loadConfigurationSettings();
%   az.connect();

% Copyright 2016 The MathWorks, Inc.

% Imports
import java.io.*;
import com.microsoft.azure.storage.*;
import com.microsoft.azure.storage.blob.*;

% Get the account handle and store it
obj.Handle = CloudStorageAccount.parse(obj.getStorageConnectionString);

end %function
