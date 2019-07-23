function client = createCloudQueueClient(obj, varargin)
% CREATECLOUDQUEUECLIENT Method to create a client for the Queue Service
%

% Copyright 2019 The MathWorks, Inc.

clientJ = obj.Handle.createCloudQueueClient();

client = azure.storage.queue.CloudQueueClient(clientJ);

end %function
