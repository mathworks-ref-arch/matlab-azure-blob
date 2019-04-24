function loadConfigurationSettings(obj, varargin)
% loadConfigurationSettings Method to read Cloud Storage Account
% configuration settings from a file, by default named
% cloudstorageaccount.json or the name can be specified as an argument. If
% account configuration settings are not provided the locally hosted
% development account will be used.
%
%   az = azure.storage.CloudStorageAccount;
%   az.loadConfigurationSettings('/home/user/mydir/myconfigfile.json');
%   az.connect();
%
% Alternatively the values may be specified manually as follows. It is not
% recommended to embed account keys in code.
%
%   az = azure.storage.CloudStorageAccount;
%   az.UseDevelopmentStorage = false;
%   az.AccountName = 'mystorageaccountname';
%   az.AccountKey  = 'SV<MYSTORAGEACCOUNTKEY>Gw==';
%   az.DefaultEndpointsProtocol = 'https';
%   az.connect

% Copyright 2017 The MathWorks, Inc.

% Create a logger object
logObj = Logger.getLogger();

if length(varargin) > 1
    write(logObj,'error','Too many arguments');
end

if isempty(varargin)
    configFile = which('cloudstorageaccount.json');
else
    configFile = varargin{1};
end

if which(configFile)
    config = jsondecode(fileread(which(configFile)));
    if strcmp(config.UseDevelopmentStorage,'false')
        obj.UseDevelopmentStorage = false;
    else
        obj.UseDevelopmentStorage = true;
    end
    obj.AccountName = config.AccountName;
    obj.AccountKey = config.AccountKey;
    obj.DefaultEndpointsProtocol = config.DefaultEndpointsProtocol;

    % for now this is unused as AzureStorageExplorer.m will read the config
    % file itself
    if isfield(config, 'LocalPathToStorageExplorer')
        obj.LocalPathToStorageExplorer = config.LocalPathToStorageExplorer;
    end

    % set optional fields that would only exist in the context of Cosmos DB
    % configuration files
    if isfield(config, 'CosmosDB')
        % set to true for Cosmos DB
        obj.CosmosDB = config.CosmosDB;
    end
    if isfield(config,'ServiceName')
        % set to 'table' for  Cosmos DB
        obj.ServiceName = config.ServiceName;
    end
else
    write(logObj,'error',['Configuration file not found: ',configFile]);
end

end
