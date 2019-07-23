function queue = getQueueReference(obj, queueName)
% GETQUEUEREFERENCE Gets a CloudQueue object with the specified name
%
% Example:
%    queue = queueClient.getQueueReference(queueName);
%    tf  = queue.exists();

% Copyright 2019 The MathWorks, Inc.

if ischar(queueName)
    queueJ = obj.Handle.getQueueReference(queueName);
    queue = azure.storage.queue.CloudQueue(queueJ);
else
    logObj = Logger.getLogger();
    write(logObj,'error','Expected queueName of type character vector');
end

end
