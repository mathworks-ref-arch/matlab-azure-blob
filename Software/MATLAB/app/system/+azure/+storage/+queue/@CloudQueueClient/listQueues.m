function queues = listQueues(obj, prefix)
% LISTQUEUES Gets queues for this queue service client
% An array of azure.storage.queue.CloudQueues are returned.
% If there are no queues an empty array is returned.

% Copyright 2019 The MathWorks, Inc.

% Create a logger object
logObj = Logger.getLogger();

if nargin > 1
    if ~ischar(prefix)
        write(logObj,'error','Expecting prefix of type character vector');
    end
end

% assume no queues are returned initially
queues = azure.storage.queue.CloudQueue.empty;

% The list of queues returned will be com.microsoft.azure.storage.<xyz> queues
% rather than azure.storage.<xyz> as they are being returned by a Handle call
if nargin > 1
    queueLazySegment = obj.Handle.listQueues(prefix);
else
    queueLazySegment = obj.Handle.listQueues();
end

% Retrieve the iterator for the object
queueIterator = queueLazySegment.iterator;

while queueIterator.hasNext()
    queueNativeHandle = queueIterator.next();
    queues(end+1) = azure.storage.queue.CloudQueue(queueNativeHandle); %#ok<AGROW>
end

end
