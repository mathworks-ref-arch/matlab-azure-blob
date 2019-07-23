function sasToken = generateSharedAccessSignature(obj, policy, groupPolicyIdentifier)
% GENERATESHAREDACCESSSIGNATURE Returns a shared access signature for the queue
% policy should be of type azure.storage.queue.SharedAccessQueuePolicy
% groupPolicyIdentifier should be of type character vector.
% The SAS Token is returned as a character vector.
% To derived the full SAS URI combine the output of this call with the output
% of getUri(), note the inclusion of a ? separator.
%
% Example:
%    sasToken = queue.generateSharedAccessSignature(policy, groupPolicyIdentifier);
%    resourceUri = queue.getUri();
%    sasUri = [char(resourceUri.EncodedURI), '?', sasToken];


% Copyright 2019 The MathWorks, Inc.

if ~isa(policy, 'azure.storage.queue.SharedAccessQueuePolicy')
    logObj = Logger.getLogger();
    write(logObj,'error','Expected policy of type azure.storage.queue.SharedAccessQueuePolicy');
end

if ~ischar(groupPolicyIdentifier)
    logObj = Logger.getLogger();
    write(logObj,'error','Expected groupPolicyIdentifier of type character vector');
end

sasToken = char(obj.Handle.generateSharedAccessSignature(policy.Handle, groupPolicyIdentifier));

end
