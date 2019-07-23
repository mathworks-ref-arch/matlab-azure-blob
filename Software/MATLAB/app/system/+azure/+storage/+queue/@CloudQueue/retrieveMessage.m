function message = retrieveMessage(obj)
% RETRIEVEMESSAGE Retrieves a message from the front of the queue
% This operation marks the retrieved message as invisible in the queue for the
% default visibility timeout period.

% Copyright 2019 The MathWorks, Inc.

messageJ = obj.Handle.retrieveMessage();
if isempty(messageJ)
    message = [];
else
    message = azure.storage.queue.CloudQueueMessage(messageJ);
end

end
