classdef CloudTable < azure.object
    % CLOUDTABLE Class to provide references to a table.
    % The cloud table allows table level operations to create
    % new tables, add/remove contents and change permissions.
    %
    %     az = azure.storage.CloudStorageAccount;
    %     az.loadConfigurationSettings();
    %     az.connect();
    %
    %     % Create a client Object
    %     azClient = azure.storage.table.CloudTableClient(az);
    %     tableH = azure.storage.table.CloudTable(Client,'MyTable');
    %
    % This table handle can be used to transact with the cloud-based
    % table API. The name of the table can only be set at creation
    % time. The name of a table must always be lowercase. If you include
    % an upper-case letter in a container name, it would violate the Azure
    % container naming rules, and cause 400 errors (Bad Request). This
    % object will convert the given name to lowercase.
    %
    % Alternatively one can construct a CloudTable using a StorageUri input.
    % This is used if constructing a handle to Shared Access Signature (SAS),
    % where the SAS URL is stored in the StorageUri.
    %
    %      SASMatlabURI = matlab.net.URI('https://myaccount.table.core.windows.net/mbsampletable?sv=2017-04-17&si=myidentifer&tn=mbsampletable&sig=eaGeUXr4yMvww%2BVTL5zIAmhkdjYwhzBVSM7y%2FPX8bdI%3D');
    %      SASStorageURI = azure.storage.StorageUri(SASMatlabURI);
    %      tableHandle = azure.storage.table.CloudTable(SASStorageURI);
    %

    % Copyright 2017 The MathWorks, Inc.

    properties
        Parent;
    end

    properties(SetAccess=immutable)
        Name;
    end

    methods
        %% Constructor
        function obj = CloudTable(varargin)

            % Create a logger object
            logObj = Logger.getLogger();

            switch (nargin)
                case 1
                    sURI = varargin{1};
                    if isa(sURI,'azure.storage.StorageUri')
                        obj.Handle = com.microsoft.azure.storage.table.CloudTable(sURI.Handle);
                        obj.Name = string(obj.Handle.getName());
                        obj.Parent = sURI;
                    else
                        write(logObj,'error','Invalid argument, expecting an azure.storage.StorageURI');
                    end

                case 2
                    client = varargin{1};
                    tableName = varargin{2};

                    if client.isValid() && (ischar(tableName) || isstring(tableName))
                        tableName = lower(tableName);
                        obj.Name = string(tableName);
                        obj.Parent = client;
                        obj.Handle = client.Handle.getTableReference(char(tableName));
                    else
                        write(logObj,'error','The constructor for the client requires a valid CloudBlobClient');
                    end
                otherwise
                    write(logObj,'error','The constructor for the client requires either a valid CloudBlobClient object of type com.microsoft.azure.storage.blob.CloudBlobContainer');

            end

        end
    end

end %class
