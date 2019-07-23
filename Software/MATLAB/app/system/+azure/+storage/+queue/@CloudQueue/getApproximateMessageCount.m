function result = getApproximateMessageCount(obj)
% GETAPPROXIMATEMESSAGECOUNT Get the approximate number of messages in the queue
% It is initialized by a call to downloadAttributes and represents the
% approximate message count when that request completed.
%
% Example:
%    queue.downloadAttributes();
%    cachedMessageCount = queue.getApproximateMessageCount();

% Copyright 2019 The MathWorks, Inc.

result = obj.Handle.getApproximateMessageCount();

end
