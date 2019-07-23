classdef CloudQueue < azure.object
% CLOUDQUEUE Class to represent a CloudQueue
% A CloudQueue is a local representation of a queue, creating the object does
% not create the queue directly, as shown below.
%
% Example:
%    % Authenticate a storage account
%    az = azure.storage.CloudStorageAccount;
%    az.loadConfigurationSettings();
%    az.connect()
%    % Create a CloudQueueClient using the storage account
%    queueClient = az.createCloudQueueClient();
%    % Create a named CloudQueue object and create the corresponding queue
%    % if it does not already exist
%    queue = queueClient.getQueueReference('myQueueName');
%    tf = queue.createIfNotExists();
%
%    % A queue can also be accessed via a Shared Access Signature (SAS)
%    % A SAS is made up of a URI & SAS token:
%    % e.g. sasUri = [char(resourceUri.EncodedURI), '?', sasToken];
%    % They can be generated in various ways, e.g. using this package or
%    % using Azure Storage Explorer
%    sasQueue = azure.storage.queue.CloudQueue(azure.storage.StorageUri(matlab.net.URI(sasUri)));
%    % The queue can now be sued as normal:
%    tf = sasQueue.exists();
%    % read from the queue
%    peekedMessage = sasQueue.peekMessage();
%    Note, the authentication step to create a client is not required

% Copyright 2019 The MathWorks, Inc.

methods
    %% Constructor
    function obj = CloudQueue(varargin)
        if nargin == 1
            if isa(varargin{1}, 'com.microsoft.azure.storage.queue.CloudQueue')
                obj.Handle = varargin{1};
            elseif isa(varargin{1}, 'azure.storage.StorageUri')
                obj.Handle = com.microsoft.azure.storage.queue.CloudQueue(varargin{1}.Handle);
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
