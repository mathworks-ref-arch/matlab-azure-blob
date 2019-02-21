function sigStr = generateSharedAccessSignature(obj, policy, groupId)
% GENERATESHAREDACCESSSIGNATURE Returns a shared access signature (SAS) string
% Returns a shared access signature for the blob using the specified group
% policy identifier and operation context. Note this does not contain the
% leading "?". A character vector is returned.
%
% Example:
%    % configure a client & connect to Azure
%    az = azure.storage.CloudStorageAccount;
%    az.loadConfigurationSettings();
%    az.connect();
%    % create a container
%    azClient = azure.storage.blob.CloudBlobClient(az)
%    container = azure.storage.blob.CloudBlobContainer(azClient,'mycontainer')
%    container.createIfNotExists()
%    % create a shared access policy
%    myPolicy = azure.storage.blob.SharedAccessBlobPolicy();
%    permSet(1) = azure.storage.blob.SharedAccessBlobPermissions.LIST;
%    permSet(2) = azure.storage.blob.SharedAccessBlobPermissions.READ;
%    myPolicy.setPermissions(permSet);
%    t1 = datetime('now');
%    t2 = t1 + hours(24);
%    myPolicy.setSharedAccessExpiryTime(t2);
%    t3 = t1 - minutes(15);
%    myPolicy.setSharedAccessStartTime(t3);
%    % generate the signature as follows
%    % blob URI + '?' + Signature string
%    % If there is no container level policy in use then this can be set to ''
%    sas = container.generateSharedAccessSignature(myPolicy,'myContainerLevelAccessPolicy')
%    sas =
%    'sig=eqqgphDjJv0uat3v%2B%2BlPqYUpJFA7ZaXe5eaIEvFIRX4%3D&st=2018-05-09T16%3A03%3A48Z&se=2018-05-10T16%3A18%3A48Z&sv=2017-04-17&si=myContainerLevelAccessPolicy&sp=rac&sr=b'
%    myUri = container.getUri;
%    fullSas = [char(myUri.EncodedURI),'?',sas];
%
%    % This SAS can now be used by 3rd parties without credentials based access
%    SASStorageUri = azure.storage.StorageUri(matlab.net.URI(fullSas));
%    SASContainer = azure.storage.blob.CloudBlobContainer(SASStorageUri);
%    blobList = SASContainer.listBlobs();
%    myBlob = myList{1};
%    myBlob.download();

% Copyright 2018 The MathWorks, Inc.

% Create a logger object
% logObj = Logger.getLogger();

% use the Handle object for the policy and convert the groupId to a string
policyJ = policy.Handle;
sigStrJ = obj.Handle.generateSharedAccessSignature(policyJ, string(groupId));
% return as a character vector
sigStr = char(sigStrJ);

end