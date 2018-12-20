function client = getServiceClient(obj)
% GETSERVICECLIENT returns the client associated with a given container
%
%     % Setup a storage account object
%     az = azure.storage.CloudStorageAccount;
%     az.connect();
%
%     % Create a client object and then a container
%     client = azure.storage.blob.CloudBlobClient(az);
%     container = azure.storage.blob.CloudBlobContainer(client,'mycontainer');
%
%     % Derive a CloudBlobClient from a container object
%     client2 = container.getServiceClient();


% Copyright 2018 The MathWorks, Inc.

client = azure.storage.blob.CloudBlobClient(obj.Handle.getServiceClient());

end %function
