classdef CloudBlobContainer < azure.object
    % CLOUDBLOBCONTAINER Class to provide references to a container.
    % The cloud blob container allows container level operations to create
    % new containers, list contents, add/remove contents and change
    % permissions.
    %
    %     % Setup a storage account object
    %     az = azure.storage.CloudStorageAccount;
    %     az.loadConfigurationSettings();
    %     az.connect();
    %
    %     % Create a client object and then a container
    %     client = azure.storage.blob.CloudBlobClient(az);
    %     container = azure.storage.blob.CloudBlobContainer(client,'mycontainer');
    %
    % This container handle can be used to transact with the cloud-based
    % container. The name of the container can only be set at creation
    % time. The name of the container must adhere to container naming rules.
    % The container name should not include any path separator characters (/).
    % Container names must be lowercase, between 3-63 characters long and must
    % start with a letter or number. Container names may contain only letters,
    % numbers, and the dash (-) character. This package does not validate that a
    % name is valid before passing it to the underlying Azure SDK. However it
    % does convert to lowercase. If you violate the Azure container naming
    % rules, it will cause 400 errors (Bad Request).
    %
    % A container object can also be constructed by passing a Java container
    % object of type com.microsoft.azure.storage.blob.CloudBlobContainer
    %
    %     container = azure.storage.blob.CloudBlobContainer(myJavaContainerObj);
    %
    % A container object can also be constructed by passing a Shared Access
    % Signature (SAS) as a azure.storage.StorageURI as follows:
    %
    %     % create an azure.storage.StorageURI
    %     SASURL = 'https://myaccount.blob.core.windows.net/mywasbtestcontainer?st=2018-08-15T17%3<REDACTED>WvIIzQ%3D';
    %     SASStorageUri = StorageUri(matlab.net.URI(SESASURL));
    %     % create a container using the StorageUri
    %     SASContainer = azure.storage.blob.CloudBlobContainer(SASStorageUri);
    %     % access the blobs as normal
    %     mylist = SASContainer.listBlobs()
    %     mylist =
    %
    %       1x3 cell array
    %
    %       {1x1 azure.storage.blob.CloudBlockBlob}    {1x1 azure.storage.blob.CloudBlobDirectory}    {1x1 azure.storage.blob.CloudBlockBlob}
    %     mylist{3}.download;
    %
    % See also the client.getContainerReference() method which is the idiomatic
    % way to construct a container.

    % Copyright 2016 The MathWorks, Inc.

    % The ServiceClient is set to the client azure.storage.blob.CloudBlobClient
    % associated with this container
    properties
        ServiceClient;
    end

    properties(SetAccess=immutable)
        Name;
    end


    methods
        %% Constructor
        function obj = CloudBlobContainer(varargin)
            % Create a logger object
            logObj = Logger.getLogger();

            switch (nargin)
                case 1
                    if isa(varargin{1}, 'com.microsoft.azure.storage.blob.CloudBlobContainer')
                        % constructing based on a Java CloudBlobContainer
                        % object being passed in
                        containerObjJ = varargin{1};
                        obj.Name = char(containerObjJ.getName());
                        obj.ServiceClient = azure.storage.blob.CloudBlobClient(containerObjJ.getServiceClient);
                        obj.Handle = containerObjJ;
                    elseif isa(varargin{1}, 'azure.storage.StorageUri')
                        myStorageUri = varargin{1};
                        containerObjJ = com.microsoft.azure.storage.blob.CloudBlobContainer(myStorageUri.Handle);
                        obj.Name = char(containerObjJ.getName());
                        obj.ServiceClient = azure.storage.blob.CloudBlobClient(containerObjJ.getServiceClient);
                        obj.Handle = containerObjJ;
                    else
                         write(logObj,'error','Invalid input expecting a com.microsoft.azure.storage.blob.CloudBlobContainer or azure.storage.StorageUri');
                    end

                case 2
                    % construct based on a name and a client
                    client = varargin{1};
                    containerName = varargin{2};

                    if client.isValid() && ( ischar(containerName) || isstring(containerName))
                        containerName = char(lower(containerName));
                        obj.Name = containerName;
                        obj.ServiceClient = client;
                        obj.Handle = client.Handle.getContainerReference(string(containerName));
                    else
                        write(logObj,'error','The constructor for the client requires a valid CloudBlobClient');
                    end

                otherwise
                    write(logObj,'error','The constructor for the client requires either a valid CloudBlobClient object of type com.microsoft.azure.storage.blob.CloudBlobContainer');

            end

        end
    end

end %class
