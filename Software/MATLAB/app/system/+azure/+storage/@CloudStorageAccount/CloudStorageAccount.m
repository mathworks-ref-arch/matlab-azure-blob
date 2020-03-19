classdef CloudStorageAccount < azure.object
    % AZURE Storage Account for the Microsoft Azure services in MATLAB
    % This account object provides MATLAB the appropriate access to the Azure
    % cloud services and serves as a container for the various handles to the
    % Azure Platform.
    %
    % If the UseDevelopmentStorage flag is set to true, the client will ignore
    % the URI for the Azure Storage account and use the default settings for
    % the Azure Storage Emulator running on the localhost. The defaults for
    % this development configuration are:
    %
    %     BlobEndpoint  = 'http://127.0.0.1:10000/devstoreaccount1';
    %     QueueEndpoint = 'http://127.0.0.1:10001/devstoreaccount1';
    %     TableEndpoint = 'http://127.0.0.1:10002/devstoreaccount1';
    %
    % Turning on the Secondary flag will leverage the RA-GRS (Read-access
    % Geo-Redundant Secondary) Storage.
    %
    % To use a the WASB (Windows Azure Blob Storage), create a
    % CloudStorageAccount object and connect.
    %
    %    az = azure.storage.CloudStorageAccount;
    %    az.loadConfigurationSettings();
    %    az.connect();
    %
    % To use a configuration/credentials file with a non default
    % (cloudstorageaccount.json) name then create the CloudStorageAccount as
    % follows specifying the file path:
    %    az = azure.storage.CloudStorageAccount;
    %    az.loadConfigurationSettings('/home/user/mydir/myconfigfile.json');
    %    az.connect();
    %
    % This approach can be useful if multiple accounts are needed at the same time
    % for example development and production or if one is also using the related
    % Cosmos DB functionality which requires Cosmos DB credentials for its
    % CloudStorageAccount object.
    %
    % Blob and Table Endpoint getters return 'Please connect() first' prior to
    % connection.
    %

    % Copyright 2016 The MathWorks, Inc.

    properties
        AccountName = 'devstoreaccount1';
        % This is a well known key value associated with the
        % devstoreaccount1 name used for local storage, it is not sensitive
        % and can be embedded in code and publicly shared.
        AccountKey = 'Eby8vdM02xNOcqFlqUwJPLlmEtlCDXJ1OUzFT50uSRZ6IFsuFq2UVErCz4I6tq/K1SZFPTOtr/KBHBeksoGMGw==';
        ServiceName = 'blob';
        DefaultEndpointsProtocol = 'https';
        UseDevelopmentStorage = true;
        CosmosDB = false;
        DevelopmentStorageProxyUri;
        Secondary = false; % RA-GRS support
        % for now this is not used as AzureStorageExplorer will read the config
        % file itself
        LocalPathToStorageExplorer = '';
    end

    properties (Hidden)

    end

    properties (Dependent)
        URI;
        BlobEndpoint;
        TableEndpoint;
        QueueEndpoint;
    end

    methods
        %% Constructor
        function obj = CloudStorageAccount(~, varargin)
            % Create a logger object
            logObj = Logger.getLogger();
            % Logger prefix of Azure Data Lake Store Interface, can be used when catching errors
            logObj.MsgPrefix = 'Azure:WASB';
            % In normal operation use default level: debug
            % logObj.DisplayLevel = 'verbose';

            if ~usejava('jvm')
                write(logObj,'error','MATLAB must be used with the JVM enabled');
            end
            if verLessThan('matlab','9.2') % R2017a
                write(logObj,'error','MATLAB Release 2017a or newer is required');
            end
        end

        %% Getter for the URI dependent property
        function str = get.URI(obj)
            if obj.UseDevelopmentStorage
                str = 'Using localhost (since the Development Storage Flag is TRUE)';
            else
                if obj.Secondary
                    ragrs = '-secondary';
                else
                    ragrs = '';
                end

                % Resolve the name of the endpoint
                if obj.CosmosDB
                    target = 'cosmosdb.azure.com:443/';
                else
                    target = 'core.windows.net/';
                end

                str = [obj.DefaultEndpointsProtocol,'://',...
                    obj.AccountName,ragrs,'.',...
                    obj.ServiceName,'.',...
                    target];
            end
        end

        %% Getter for the URI dependent property
        function str = get.BlobEndpoint(obj)
            if isempty(obj.Handle)
                str = 'Please connect() first';
            else
                % Retrieve the endpoints
                str = char(obj.Handle.getBlobEndpoint().toString());
            end
        end

        %% Getter for the URI dependent property
        function str = get.TableEndpoint(obj)
            if isempty(obj.Handle)
                str = 'Please connect() first';
            else
                % Retrieve the endpoints
                str = char(obj.Handle.getTableEndpoint().toString());
            end
        end

        %% Getter for the URI dependent property
        function str = get.QueueEndpoint(obj)
            if isempty(obj.Handle)
                str = 'Please connect() first';
            else
                % Retrieve the endpoints
                str = char(obj.Handle.getQueueEndpoint().toString());
            end
        end
    end

end %class
