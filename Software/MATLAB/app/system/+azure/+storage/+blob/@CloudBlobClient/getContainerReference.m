function azContainer = getContainerReference(obj, containerName)
% GETCONTAINERREFERENCE Method to get a named container reference
% This method creates a CloudObjectContainer reference object from the
% given name for a container. The name of the container, which must adhere to
% container naming rules. The container name should not include any path
% separator characters (/). Container names must be lowercase, between 3-63
% characters long and must start with a letter or number. Container names may
% contain only letters, numbers, and the dash (-) character. This package does
% not validate that a name is valid before passing it to the underlying Azure
% SDK. However it does convert to lower case.
%
%     % Create a client
%     az = azure.storage.CloudStorageAccount;
%     az.loadConfigurationSettings();
%     az.connect();
%     azClient = azure.storage.blob.CloudBlobClient(az);
%     % Create a container reference
%     container = azClient.getContainerReference('mycontainername');
%     % Create the container
%     container.createIfNotExists;
%
% Alternatively a container could be created as follows:
%     container = azure.storage.blob.CloudBlobContainer(client,'mycontainer');
%     container.createIfNotExists;


% Copyright 2018 The MathWorks, Inc.

p = inputParser;
p.CaseSensitive = false;
addRequired(p,'containerName',@ischar);
parse(p,containerName);

containerName = p.Results.containerName;

% pass the ClouldBlobClient (obj) and the containerName to the CloudBlobContainer
% constructor which calls getContainerReference and returns a CloudBlobConainter
azContainer = azure.storage.blob.CloudBlobContainer(obj, containerName);

end %function
