classdef CloudQueueClient < azure.object
% CLOUDQUEUECLIENT Class to provide access to the CloudQueue client
% A client object is used to perform many basic operations when working with
% queues.
%
% Example:
%    % Create the Client
%    az = azure.storage.CloudStorageAccount;
%    az.loadConfigurationSettings();
%    az.connect();
%    queueClient = az.createCloudQueueClient();
%    % List all queues
%    queues = queueClient.listQueues();

% Copyright 2019 The MathWorks, Inc.

methods
    %% Constructor
    function obj = CloudQueueClient(varargin)
        if nargin == 1
            if  ~isa(varargin{1}, 'com.microsoft.azure.storage.queue.CloudQueueClient')
                logObj = Logger.getLogger();
                write(logObj,'error','argument not of type com.microsoft.azure.storage.queue.CloudQueueClient');
            else
                obj.Handle = varargin{1};
            end
        elseif nargin == 0
            obj.Handle = com.microsoft.azure.storage.queue.CloudQueueClient();
        else
            logObj = Logger.getLogger();
            write(logObj,'error','Invalid number of arguments');
        end
    end %function

end %methods

end %class
