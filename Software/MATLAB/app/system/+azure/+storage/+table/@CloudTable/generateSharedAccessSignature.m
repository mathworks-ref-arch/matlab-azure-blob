function sigStr = generateSharedAccessSignature(obj, policy, accessPolicyIdentifier, startPartitionKey, startRowKey, endPartitionKey, endRowKey)
% GENERATESHAREDACCESSSIGNATURE Returns a shared access signature (SAS)
% Returns a shared access signature for a blob. Note this does not contain the
% leading "?". The SAS is returned as a character vector.
% An optional group policy identifier can be specified if required.
%
%   % First create a shared access policy, setting permissions and times
%   myPolicy = azure.storage.table.SharedAccessTablePolicy();
%   permSet(1) = azure.storage.table.SharedAccessTablePermissions.QUERY;
%   myPolicy.setPermissions(permSet);
%
%   % Allow access for the next 24 hours
%   % Allow a margin of 15 minutes for clock variances
%   t1 = datetime('now','TimeZone','UTC') + hours(24);
%   myPolicy.setSharedAccessExpiryTime(t1);
%   t2 = datetime('now','TimeZone','UTC') - minutes(15);
%   myPolicy.setSharedAccessStartTime(t2);
%
%   % Set row and partition restrictions
%   pk = 'Smith';
%   rk = 'John';
%   accessPolicyIdentifier = '';
%   startPartitionKey = pk;
%   startRowKey = rk;
%   endPartitionKey = pk;
%   endRowKey = rk;
%
%   % Generate the SAS, note the leading ? and URI are not included
%   sas = tableHandle.generateSharedAccessSignature(myPolicy,accessPolicyIdentifier,startPartitionKey,startRowKey,endPartitionKey,endRowKey)
%
%   sas =
%
%      'sig=2wOZrXmqMQgJ6KPJXwCVK3D9hxpcY166eMJ8mxDBZdc%3D&st=2018-05-10T08%3A38%3A43Z&epk=Smith&se=2018-05-11T08%3A53%3A43Z&sv=2017-04-17&tn=sampletable&sp=r&srk=John&spk=Smith&erk=John'
%
%   % Build the full SAS
%   myUri = tableHandle.getUri;
%   fullSas = [char(myUri.EncodedURI),'?',sas];
%
%   % Create a StorageURI object based on this
%   SASTableURI = matlab.net.URI(fullSas);
%   SASStorageURI = azure.storage.StorageUri(SASTableURI);
%
%   % Create a CloudTable object via the StorageURI object
%   sasTableHandle = azure.storage.table.CloudTable(SASStorageURI);
%
%   % Return the name of the table using the SAS table handle
%   nameValue = sasTableHandle.Name;
%   testCase.verifyTrue(strcmp(nameValue, tableHandle.Name));
%
%   % Build a Table Operation
%   dResolver = com.mathworks.azure.sdk.DynamicResolver.getDynamicResolver();
%   tableOperation = azure.storage.table.TableOperation.retrieve(pk, rk, dResolver);
%   % Query the table using the handle and operation to return the Name and Value
%   results = sasTableHandle.execute(tableOperation);

% Copyright 2018 The MathWorks, Inc.

% Create a logger object
% logObj = Logger.getLogger();

p = inputParser;
p.CaseSensitive = false;
p.FunctionName = 'generateSharedAccessSignature';
validationFcn = @(x) isa(x, 'azure.storage.table.SharedAccessTablePolicy');
addRequired(p,'policy',validationFcn);
addRequired(p,'accessPolicyIdentifier',@ischar);
addRequired(p,'startPartitionKey',@ischar);
addRequired(p,'startRowKey',@ischar);
addRequired(p,'endPartitionKey',@ischar);
addRequired(p,'endRowKey',@ischar);
parse(p,policy, accessPolicyIdentifier, startPartitionKey, startRowKey, endPartitionKey, endRowKey);

policyP = p.Results.policy;
accessPolicyIdentifierP = p.Results.accessPolicyIdentifier;
startPartitionKeyP = p.Results.startPartitionKey;
startRowKeyP = p.Results.startRowKey;
endPartitionKeyP = p.Results.endPartitionKey;
endRowKeyP = p.Results.endRowKey;

% use the Handle object for the policy and convert the chars to strings
policyJ = policyP.Handle;
sigStrJ = obj.Handle.generateSharedAccessSignature(policyJ, string(accessPolicyIdentifierP), string(startPartitionKeyP), string(startRowKeyP), string(endPartitionKeyP), string(endRowKeyP));
% return as a character vector
sigStr = char(sigStrJ);

end % function
