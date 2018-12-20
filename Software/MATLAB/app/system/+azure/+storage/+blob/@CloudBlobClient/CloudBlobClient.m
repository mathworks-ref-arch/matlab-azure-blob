classdef CloudBlobClient < azure.object
% CLOUDBLOBCLIENT Class to provide access to the CloudBlob client
% Creates a blob client object for transacting with the Azure blob storage.
%
%     % Setup Storage account
%     az = azure.storage.CloudStorageAccount;
%     az.loadConfigurationSettings();
%     az.connect();
%     % Create a client object using a StorageAccount
%     client = azure.storage.blob.CloudBlobClient(az);
%
% Alternatively a CloudBlobClient can be constructed by passing a Java
% com.microsoft.azure.storage.blob.CloudBlobClient object.
%     % Create a client Object
%     client = azure.storage.blob.CloudBlobClient(existingJavabObject);
%
% A client object can be used to create containers and otherwise transact with
% WASB.

% Copyright 2016 The MathWorks, Inc.

properties
    DirectoryDelimiter;
end

methods
    %% Constructor
    function obj = CloudBlobClient(srcObj)
        % Create a logger object
        logObj = Logger.getLogger();

        % construct BlobClient based on a Java CloudBlobClient input
        if isa(srcObj, 'com.microsoft.azure.storage.blob.CloudBlobClient')
            obj.Handle = srcObj;
            %obj.Parent = '';
            srcDelimiter = char(srcObj.getDirectoryDelimiter());
            % the source client used another delimiter so use that
            obj.setDirectoryDelimiter(srcDelimiter);

        % else construct the BlobClient based on a storage account
        elseif isa(srcObj, 'azure.storage.CloudStorageAccount')
            if srcObj.isValid
                obj.Handle = srcObj.Handle.createCloudBlobClient();
                %obj.Parent = srcObj;
                obj.setDirectoryDelimiter('/');
            else
                write(logObj,'error','Cannot create CloudBlobClient invalid azure.storage.CloudStorageAccount input');
            end
        else
            write(logObj,'error','Cannot create CloudBlobClient requires a CloudStorageAccount or CloudBlobClient (Java Object) input');
        end
    end %function

end %methods

end %class
