function sigStr = generateSharedAccessSignature(obj, policy, accessPolicyIdentifier, startPartitionKey, startRowKey, endPartitionKey, endRowKey)
% GENERATESHAREDACCESSSIGNATURE Returns a policy string
% Returns a shared access signature for the table using the specified group
% policy identifier and operation context. Note this does not contain the
% leading "?".
%
%   % First create a shared access policy, setting permissions and times
%   myPolicy = azure.storage.table.SharedAccessTablePolicy();
%   permSet(1) = azure.storage.table.SharedAccessTablePermissions.QUERY;
%   myPolicy.setPermissions(permSet);
%
%   % Allow access for the next 24 hours
%   t1 = datetime('now');
%   t2 = t1 + hours(24);
%   myPolicy.setSharedAccessExpiryTime(t2);
%
%   % Allow a margin of 15 minutes for clock variances
%   t3 = t1 - minutes(15);
%   myPolicy.setSharedAccessStartTime(t3);
%
%   % Set row and partition restrictions
%   accessPolicyIdentifier = 'myAccessPolicyIdentifier';
%   startPartitionKey = 'Smith';
%   startRowKey = 'John';
%   endPartitionKey = 'Smith';
%   endRowKey = 'John';
%
%   % Generate the SAS, note the leading ? and URI are not included
%   sas = tableHandle.generateSharedAccessSignature(myPolicy,accessPolicyIdentifier,startPartitionKey,startRowKey,endPartitionKey,endRowKey)
%
%   sas =
%
%      'sig=2wOZrXmqMQgJ6KPJXwCVK3D9hxpcY166eMJ8mxDBZdc%3D&st=2018-05-10T08%3A38%3A43Z&epk=Smith&se=2018-05-11T08%3A53%3A43Z&sv=2017-04-17&si=myAccessPolicyIdentifier&tn=sampletable&sp=r&srk=John&spk=Smith&erk=John'
%
%   % build the full SAS
%   myUri = tableHandle.getUri;
%
%   fullSas = [char(myUri.EncodedURI),'?',sas]
%
%   fullSas =
%
%    'https://myaccount.table.core.windows.net/sampletable?sig=2wOZrXmqMQgJ6KPJXwCVK3D9hxpcY166eMJ8mxDBZdc%3D&st=2018-05-10T08%3A38%3A43Z&epk=Smith&se=2018-05-11T08%3A53%3A43Z&sv=2017-04-17&si=accessPolicyIdentifier&tn=sampletable&sp=r&srk=John&spk=Smith&erk=John'
%


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
