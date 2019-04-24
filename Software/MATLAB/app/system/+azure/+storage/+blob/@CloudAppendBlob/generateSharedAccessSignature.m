function sigStr = generateSharedAccessSignature(obj, varargin)
% GENERATESHAREDACCESSSIGNATURE Returns a shared access signature (SAS)
% Returns a shared access signature for a blob. Note this does not contain the
% leading "?". The SAS is returned as a character vector.
% An optional group policy identifier can be specified if required.
%
%    % configure a client & connect to Azure
%    az = azure.storage.CloudStorageAccount;
%    az.UseDevelopmentStorage = false;
%    az.loadConfigurationSettings();
%    az.connect();
%
%    % create a container
%    azClient = azure.storage.blob.CloudBlobClient(az);
%    azContainer = azure.storage.blob.CloudBlobContainer(azClient,'comExampleMycontainername');
%    flag = azContainer.createIfNotExists();
%
%    % create a shared access policy
%    myPolicy = azure.storage.blob.SharedAccessBlobPolicy();
%    permSet(1) = azure.storage.blob.SharedAccessBlobPermissions.LIST;
%    permSet(2) = azure.storage.blob.SharedAccessBlobPermissions.READ;
%    myPolicy.setPermissions(permSet);
%
%    t1 = datetime('now','TimeZone','UTC') + hours(24);
%    myPolicy.setSharedAccessExpiryTime(t1);
%    t2 = datetime('now','TimeZone','UTC') - minutes(15);
%    myPolicy.setSharedAccessStartTime(t2);
%
%    % create a blob in the container
%    x = rand(10);
%    filename1 = 'SampleData1.mat';
%    save(filename1,'x');
%    uploadBlob = azure.storage.blob.CloudAppendBlob(azContainer, filename1, which(filename1'));
%    uploadBlob.upload();
%
%    % generate the signature as follows: blob URI + '?' + Signature string
%    % if there is no blob level policy in use then omit it
%    % sas = uploadBlob.generateSharedAccessSignature(myPolicy, 'myPolicyID');
%    sas = uploadBlob.generateSharedAccessSignature(myPolicy);
%    myUri = uploadBlob.getUri();
%    fullSas = [char(myUri.EncodedURI),'?',sas];
%
%    % get a blob object based on the SAS URL
%    downloadBlob = azure.storage.blob.CloudAppendBlob(azure.storage.StorageUri(matlab.net.URI(fullSas)));
%    % download it to using a different filename and load the random data
%    filename2 = 'SampleData2.mat';
%    downloadBlob.download(filename2);
%    downloadStruct = load(filename2);

% Copyright 2018 The MathWorks, Inc.

% Create a logger object
% logObj = Logger.getLogger();

p = inputParser;
p.CaseSensitive = false;
p.FunctionName = 'generateSharedAccessSignature';
validationFcn = @(x) isa(x, 'azure.storage.blob.SharedAccessBlobPolicy');
addRequired(p, 'policy', validationFcn);
addOptional(p, 'groupId', '', @ischar);
parse(p,varargin{:});

policy = p.Results.policy;
groupId = p.Results.groupId;

% use the Handle object for the policy and convert the groupId to a string
policyJ = policy.Handle;
sigStrJ = obj.Handle.generateSharedAccessSignature(policyJ, string(groupId));
% return as a character vector
sigStr = char(sigStrJ);

end
