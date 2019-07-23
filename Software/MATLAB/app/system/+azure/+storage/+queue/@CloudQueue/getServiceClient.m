function client = getServiceClient(obj)
% GETSERVICECLIENT Gets the queue service client associated with the queue

% Copyright 2019 The MathWorks, Inc.

clientJ = obj.Handle.getServiceClient();
client = azure.storage.queue.CloudQueueClient(clientJ);

end
