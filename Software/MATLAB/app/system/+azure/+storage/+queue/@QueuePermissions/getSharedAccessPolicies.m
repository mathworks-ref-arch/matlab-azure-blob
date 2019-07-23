function containerMapResult = getSharedAccessPolicies(obj)
% GETSHAREDACCESSPOLICIES Returns the set of shared access policies
% A containers.Map of the is returned.

% Copyright 2019 The MathWorks, Inc.

% returns a java.util.HashMap
hashmapJ = obj.Handle.getSharedAccessPolicies();

% return and entrySet to get an iterator
entrySetJ = hashmapJ.entrySet();
% get the iterator
iteratorJ = entrySetJ.iterator();

% declare empty cell arrays for values and keys
policyKeys = {};
policyValues = {};

while iteratorJ.hasNext()
    % pick metadata from the entry set one at a time
    entryJ = iteratorJ.next();
    % get the key and the value
    policyKey = entryJ.getKey();
    policyValueJ = entryJ.getValue();
    if ~isa(policyValueJ, 'com.microsoft.azure.storage.queue.SharedAccessQueuePolicy')
        logObj = Logger.getLogger();
        write(logObj,'error','Expected policyValue of type com.microsoft.azure.storage.queue.SharedAccessQueuePolicy');
    else
        policyValue = azure.storage.queue.SharedAccessQueuePolicy(policyValueJ);
    end
    % build the cell arrays of keys and values
    policyKeys{end+1} = policyKey; %#ok<AGROW>
    policyValues{end+1} = policyValue; %#ok<AGROW>
end

% if the cell arrays are still empty then create an empty containers.Map and
% return that else build it from the arrays of values and keys
if isempty(policyKeys)
    containerMapResult = containers.Map('KeyType','char','ValueType','any');
else
    containerMapResult = containers.Map(policyKeys, policyValues);
end

end
