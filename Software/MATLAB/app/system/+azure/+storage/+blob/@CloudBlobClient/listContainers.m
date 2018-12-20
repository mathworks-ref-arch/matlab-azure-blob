function containers = listContainers(obj, varargin)
% LISTCONTAINERS returns an array of blob containers for the given client
% Returns an array of CloudBlobContainers for this blob service client.
%
%     % Connect to the service
%     az = azure.storage.CloudStorageAccount;
%     az.loadConfigurationSettings();
%     az.connect();
%
%     % Create a client Object
%     client = azure.storage.blob.CloudBlobClient(az);
%
%     % List all containers
%     containers = client.listContainers();
%     containerNames = {containers.Name};

% Copyright 2016 The MathWorks, Inc.

% Initialize an array
containers = azure.storage.blob.CloudBlobContainer.empty();

% Return a list of containers
containerIterable = obj.Handle.listContainers();
cIterator = containerIterable.iterator();

cCount = 1;
while cIterator.hasNext()
    % Create a container object
    containers(cCount) = azure.storage.blob.CloudBlobContainer(cIterator.next());
    cCount = cCount + 1;
end

end %function
