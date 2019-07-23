function addMessage(obj, message)
% ADDMESSAGE Adds a message to a queue

% Copyright 2019 The MathWorks, Inc.

if isa(message, 'azure.storage.queue.CloudQueueMessage')
    obj.Handle.addMessage(message.Handle);
else
    logObj = Logger.getLogger();
    write(logObj,'error','Expected message of type azure.storage.queue.CloudQueueMessage');
end

end
