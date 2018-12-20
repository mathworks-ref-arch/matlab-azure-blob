function connStr = getStorageConnectionString(obj, varargin)
% GETSTORAGECONNECTIONSTRING Method to return the account connection string
% with the necessary credentials to connect to the Azure Storage.

% Copyright 2016 The MathWorks, Inc.

% if obj.UseDevelopmentStorage
%     devStr = 'UseDevelopmentStorage=true;';
% else
%     devStr='';
% end
%
% if obj.CosmosDB
%     devStr = ['TableEndpoint=' obj.URI ';'];
% end
%
% connStr = ['DefaultEndpointsProtocol=',obj.DefaultEndpointsProtocol,';',...
%     'AccountName=',obj.AccountName,';'...
%     'AccountName=',obj.AccountName,';'...
%     'BlobEndpoint=',obj.BlobEndpoint,';'...
%     devStr];


if obj.UseDevelopmentStorage
    % DefaultEndpointsProtocol, AccountName, AccountKey, BlobEndpoint,
    % TableEndpoint are all set in the
    % CloudStorageAccount object prior to this method being called
    % the following is the equivalent of 'UseDevelopmentStorage=true;'
    connStr = [
        'DefaultEndpointsProtocol=http;',...
        'AccountName=devstoreaccount1;',...
        'AccountKey=Eby8vdM02xNOcqFlqUwJPLlmEtlCDXJ1OUzFT50uSRZ6IFsuFq2UVErCz4I6tq/K1SZFPTOtr/KBHBeksoGMGw==;',...
        'BlobEndpoint=http://127.0.0.1:10000/devstoreaccount1;',...
        'TableEndpoint=http://127.0.0.1:10002/devstoreaccount1;',...
        'QueueEndpoint=http://127.0.0.1:10001/devstoreaccount1;'
        ];
else
    if obj.CosmosDB
        tableStr = ['TableEndpoint=' obj.URI ';'];
    else
        tableStr = '';
    end
    
    connStr = ['DefaultEndpointsProtocol=',obj.DefaultEndpointsProtocol,';',...
        'AccountName=',obj.AccountName,';',...
        'AccountKey=',obj.AccountKey,';',...
        tableStr
        ];
end

end %function
