function setSharedAccessPolicies(obj, permissions)
% SETSHAREDACCESSPOLICIES Sets shared access policies
% permissions should be an array of azure.storage.queue.SahredAccessQueiePolicy
% objects

% Copyright 2019 The MathWorks, Inc.

if ~isa(permissions, 'azure.storage.queue.SharedAccessQueuePolicy')
    logObj = Logger.getLogger();
    write(logObj,'error','Expected permissions of type azure.storage.queue.SharedAccessQueuePolicy');
end

% create a empty Java HashMap
hmJ = java.util.HashMap;
for n = 1:numel(permissions)
    key = ['policy-', num2str(n)];
    hmJ.put(key, permissions(n).Handle);
end

obj.Handle.setSharedAccessPolicies(hmJ);

end
