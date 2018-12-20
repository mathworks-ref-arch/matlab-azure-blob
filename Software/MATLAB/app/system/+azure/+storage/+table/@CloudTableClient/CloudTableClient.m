classdef CloudTableClient < azure.object
% CLOUDTABLECLIENT Class to provide access to the cloud table client
% Creates a table client object for transacting with the Azure table storage.
%
%     az = azure.storage.CloudStorageAccount;
%     az.loadConfigurationSettings();
%     az.connect();
%
%     % Create a client Object
%     client = azure.storage.table.CloudTableClient(az);
%

% Copyright 2017 The MathWorks, Inc.

properties
    Parent;
end

methods
	%% Constructor
	function obj = CloudTableClient(accountObject, varargin)
        % Create a logger object
        logObj = Logger.getLogger();

        if accountObject.isValid
            obj.Parent = accountObject;
            obj.Handle = accountObject.Handle.createCloudTableClient();
        else
            write(logObj,'error','The constructor for the client requires a valid CloudStorageAccount');
        end

	end
end

end %class
