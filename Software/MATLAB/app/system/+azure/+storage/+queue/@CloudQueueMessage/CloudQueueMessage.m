classdef CloudQueueMessage < azure.object
% CLOUDQUEUEMESSAGE Class to represent a CloudQueueMessage
% Messages are added and retrieved from queues.
%
% Example:
%    message = azure.storage.queue.CloudQueueMessage('my message');
%    queue.addMessage(message);
%
%    retrievedMessage = queue.retrieveMessage();

% Copyright 2019 The MathWorks, Inc.

methods
    %% Constructor
    function obj = CloudQueueMessage(varargin)
        if nargin == 1
            if isa(varargin{1}, 'com.microsoft.azure.storage.queue.CloudQueueMessage')
                obj.Handle = varargin{1};
            elseif ischar(varargin{1}) % text based message
                obj.Handle = com.microsoft.azure.storage.queue.CloudQueueMessage(varargin{1});
            elseif isa(varargin{1}, 'uint8') % byte array based message
                obj.Handle = com.microsoft.azure.storage.queue.CloudQueueMessage(varargin{1});
            else
                logObj = Logger.getLogger();
                write(logObj,'error','Invalid argument');
            end
        else
            logObj = Logger.getLogger();
            write(logObj,'error','Invalid number of arguments');
        end
    end %function
end %methods
end %class
