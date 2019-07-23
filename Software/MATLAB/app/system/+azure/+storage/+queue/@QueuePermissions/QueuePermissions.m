classdef QueuePermissions < azure.object
% QUEUEPERMISSIONS Class to represent the permissions for a queue

% Copyright 2019 The MathWorks, Inc.

methods
    %% Constructor
    function obj = QueuePermissions(varargin)
        if nargin == 0
            obj.Handle = com.microsoft.azure.storage.queue.QueuePermissions();
        elseif nargin == 1
            if isa(varargin{1}, 'com.microsoft.azure.storage.queue.QueuePermissions')
                obj.Handle = varargin{1};
            else
                logObj = Logger.getLogger();
                write(logObj,'error','Expected argument of type com.microsoft.azure.storage.queue.QueuePermissions');
            end
        else
            logObj = Logger.getLogger();
            write(logObj,'error','Invalid number of arguments');
        end
    end %function

end %methods

end %class
