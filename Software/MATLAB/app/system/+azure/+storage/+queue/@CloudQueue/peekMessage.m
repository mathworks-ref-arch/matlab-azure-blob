function message = peekMessage(obj)
% PEEKMESSAGE Peeks a message from the queue
% A peek request retrieves a message from the front of the queue without
% changing its visibility. If no message is found an empty value is
% returned.

% Copyright 2019 The MathWorks, Inc.

messageJ = obj.Handle.peekMessage();
if isempty (messageJ)
    message = [];
else
    message = azure.storage.queue.CloudQueueMessage(messageJ);
end

end
