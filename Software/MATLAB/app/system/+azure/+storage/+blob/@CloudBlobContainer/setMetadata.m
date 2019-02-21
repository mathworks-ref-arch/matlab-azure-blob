function setMetadata(obj, varargin)
% SETMETADATA Sets the metadata for the container
% Sets the metadata collection of name-value pairs to be set on the container
% with an uploadMetadata call. This collection will overwrite any existing
% container metadata. If this is set to an empty collection, the container
% metadata will be cleared on an uploadMetadata call.
% Key Value pairs in char vector format can be passed as an individual pair or
% as containers.Map containing multiple key value pairs.
%
% Example:
%   % set and retrieve a metadata key value pair
%   azContainer = azure.storage.blob.CloudBlobContainer(azClient,'mytestcontainer');
%   azContainer.setMetadata('key1','val1');
%   azContainer.uploadMetadata();
%   m = azContainer.getMetadata();
%   keys(m)
%   ans =
%     1x1 cell array
%       {'key1'}
%
%   % to set multiple metadata values
%   myKeys = {'key1','key2'};
%   myVals = {'val1','val2'};
%   cMap = containers.Map(myKeys, myVals);
%   azContainer.setMetadata(cMap);
%   azContainer.uploadMetadata();
%   m = azContainer.getMetadata();

%   ans =
%     1x2 cell array
%       {'val1'}    {'val2'}

% Copyright 2018 The MathWorks, Inc.

logObj = Logger.getLogger();

if nargin == 3
    keyStr = varargin{1};
    valStr = varargin{2};
    if ~ischar(keyStr)
        write(logObj,'error','Expected key of type char');
    end
    if ~ischar(valStr)
        write(logObj,'error','Expected value of type char');
    end
    % build a containers.Map from individual char entries so all containers.Map
    % from here on
    cMap = containers.Map({keyStr},{valStr});
elseif nargin == 2
    cMap = varargin{1};
    if ~isa(cMap,'containers.Map')
        write(logObj,'error','Expected a map of type containers.Map');
    end
else
    write(logObj,'error','Invalid number of arguments');
end

% extract the keys and values from the containers map
cMapKeys = keys(cMap);
cMapVals = values(cMap);

% create a empty Java HashMap
hmJ = java.util.HashMap;

for n = 1:numel(cMapKeys)
    if ~ischar(cMapKeys{n})
        write(logObj,'error','Expected containers.Map key entry of type char');
    end
    if ~ischar(cMapVals{n})
        write(logObj,'error','Expected containers.Map value entry of type char');
    end
    % add an entry to the HashMap per iteration
    hmJ.put(cMapKeys{n}, cMapVals{n});
end

% call handle method on the newly constructed Java HashMap
obj.Handle.setMetadata(hmJ);

end %function
