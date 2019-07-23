function deleteMessage(obj, message)
% DELETEMESSAGE Deletes the specified message from the queue

% Copyright 2019 The MathWorks, Inc.

if isa(message, 'azure.storage.queue.CloudQueueMessage')
    obj.Handle.deleteMessage(message.Handle)
else
    logObj = Logger.getLogger();
    write(logObj,'error','Expected message of type azure.storage.queue.CloudQueueMessage');
end

end
