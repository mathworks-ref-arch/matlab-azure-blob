classdef SharedAccessQueuePolicy < azure.object
% SHAREDACCESSQUEUEPOLICY Represents a shared access policy
% This class specifies the start time, expiry time, and permissions for a
% shared access signature.

% Copyright 2019 The MathWorks, Inc.

methods
    function obj = SharedAccessQueuePolicy(varargin)
        if nargin == 0
            obj.Handle = com.microsoft.azure.storage.queue.SharedAccessQueuePolicy();
        elseif nargin == 1
            if isa(varargin{1}, 'com.microsoft.azure.storage.queue.SharedAccessQueuePolicy')
                obj.Handle = varargin{1};
            else
                logObj = Logger.getLogger();
                write(logObj,'error','Invalid argument');
            end
        else
            logObj = Logger.getLogger();
            write(logObj,'error','Invalid number of arguments');
        end
    end
end %methods
end %class
