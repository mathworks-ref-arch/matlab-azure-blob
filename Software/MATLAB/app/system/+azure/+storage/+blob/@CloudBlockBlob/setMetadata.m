function setMetadata(obj, varargin)
% SETMETADATA Sets the metadata for the blob
% Key Value pairs in char vector format can be passed as an individual pair or
% as containers.Map containing multiple Key Value pairs.

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
