classdef QueueRequestOptions < azure.object
% QUEUEREQUESTOPTIONS Represents options specified on a queue request

% Copyright 2019 The MathWorks, Inc.

methods
    %% Constructor
    function obj = QueueRequestOptions(varargin)
        if nargin == 0
            obj.Handle = com.microsoft.azure.storage.queue.QueueRequestOptions();
        elseif nargin == 1
            if isa(varargin{1}, 'com.microsoft.azure.storage.queue.QueueRequestOptions')
                obj.Handle = varargin{1};
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
