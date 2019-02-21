classdef CloudBlobDirectory < azure.object
% CLOUDBLOBDIRECTORY Represents a virtual directory of blobs
% Directory of blobs are designated by a delimiter character. Containers,
% which are encapsulated as CloudBlobContainer objects, hold directories,
% and directories hold block blobs and page blobs. Directories can also
% contain sub-directories. CloudBlobDirectory object are generally created as
% outputs of other function calls.
%
% Constructors:
%   CloudBlobDirectory(container, name)
%   CloudBlobDirectory(uri, prefix, client, container)
%   CloudBlobDirectory(AzureSDKJavaClassCloudBlobDirectory)
%
%   Where prefix is the directory name

% Copyright 2018 The MathWorks, Inc.

% The Prefix, Container and Parent can be obtained using get methods
properties
    % This property is referred to as Name but CloudBlobDirectories do not have
    % names they have prefixes, here we use the prefix as a 'name' to allow the
    % convenience of doing myBlobList{n}.Name where a myBlobList entry may be a
    % CloudBlobDirectory or @CloudBlockBlob which does have a name
    % The prefix can be directly obtained by calling the getPrefix method.
    Name;
end

methods
    %% Constructor
    % parse for:
    %   CloudBlobDirectory(CloudBlobDirectory_Native_Java_Class)
    %   CloudBlobDirectory(container, name)
    %   CloudBlobDirectory(uri, prefix, client, container)
    %
    function obj = CloudBlobDirectory(varargin)
        % Create a logger object
        logObj = Logger.getLogger();

        % validate input
        p = inputParser;
        p.CaseSensitive = false;
        p.FunctionName = 'CloudBlobDirectory';

        switch nargin
            case 1
                % form: CloudBlobDirectory(AzureSDKJavaClassCloudBlobDirectory)
                checkArg1 = @(x) isa(x, 'com.microsoft.azure.storage.blob.CloudBlobDirectory');
                addRequired(p,'CloudBlobDirectoryJ',checkArg1);
                parse(p,varargin{:});
                CloudBlobDirectoryJ = p.Results.CloudBlobDirectoryJ;

                obj.Handle = CloudBlobDirectoryJ;
                obj.Name = char(obj.getPrefix());

            case 2
                % form: CloudBlobDirectory(container, blobname)
                % TODO determine if this 'name' is really a prefix?
                % Convenience method for when there is a container and  a name
                checkContainerClass = @(x) isa(x, 'azure.storage.blob.CloudBlobContainer');
                addRequired(p,'container', checkContainerClass);
                addRequired(p,'blobName',@ischar);
                parse(p,varargin{:});
                container = p.Results.container;
                blobName = p.Results.blobName;

                % Get the directory ref using the name aka the prefix
                % name may come in with a trailing delimiter if so remove it
                % get the specific delimiter associated with the
                delimiter = container.ServiceClient.getDirectoryDelimiter();
                adjustedBlobName = strip(blobName, 'right', delimiter);
                obj.Handle = container.Handle.getDirectoryReference(adjustedBlobName);
                obj.Name = char(obj.getPrefix());

            case 4
                % form:  CloudBlobDirectory(uri, prefixArg, client, container)
                % Convenience method
                checkArg1 = @(x) isa(x, 'azure.storage.StorageUri');
                addRequired(p,'uri',checkArg1);
                addRequired(p,'prefix',@ischar);
                checkClientClass = @(x) isa(x, 'azure.storage.blob.CloudBlobClient');
                addRequired(p,'client', checkClientClass);
                checkContainerClass = @(x) isa(x, 'azure.storage.blob.CloudBlobContainer');
                addRequired(p,'container', checkContainerClass);
                parse(p,varargin{:});
                prefixArg = p.Results.prefix;
                uri = p.Results.uri;
                client = p.Results.client;
                container = p.Results.container;

                % TODO check if this is implemented still in v8.0.0
                obj.Handle = com.microsoft.azure.storage.blob.CloudBlobDirectory(uri.Handle, prefixArg, client.Handle, container.Handle);
                obj.Name = char(obj.getPrefix());

            otherwise
                obj.Prefix = [];
                obj.Name = [];
                obj.Handle = [];
                write(logObj,'error','Invalid azure.storage.blob.CloudBlobDirectory constructor arguments');
        end
    end
end %methods

end %class
