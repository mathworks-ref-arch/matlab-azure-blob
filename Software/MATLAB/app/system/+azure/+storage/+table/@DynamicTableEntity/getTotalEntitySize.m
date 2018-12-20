function sizeInBytes = getTotalEntitySize(obj, varargin)
% GETTOTALENTITYSIZE Method to return the size of the payload for the entity
% Use this method to calculate the size of the property
%
% For example:
%     % Create a batch of 100 entities
%     batchSize = 100;
%     for bCount = 1:batchSize
%         dynamicEntity(bCount) = azure.storage.table.DynamicTableEntity;
%         dynamicEntity(bCount).addprop('Name');
%         dynamicEntity(bCount).Name = ['john',num2str(bCount)];
%         dynamicEntity(bCount).partitionKey = 'pk';
%         dynamicEntity(bCount).rowKey = ['rk',num2str(bCount),datestr(now)];
%         dynamicEntity(bCount).initialize();
%     end
%
% You can compute the size of the payload using:
%
%     dynamicEntity.getTotalSize();
%

% Copyright 2017 The MathWorks, Inc.

% Defensive initialization
sizeInBytes=0;

% Vectorize
for eCount = 1:numel(obj)

    pk = obj(eCount).partitionKey; %#ok<NASGU>
    rk = obj(eCount).rowKey; %#ok<NASGU>

    pSize = whos('pk');
    rSize = whos('rk');

    props = properties(obj);
    oProps = setdiff(props,{'rowKey','partitionKey'});

    propSize = 0;
    for pCount = 1:numel(oProps)
        propSize = propSize + 8 + numel(oProps{pCount})*2 + iGetTypeSize(obj.(oProps{pCount}));
    end

    % The size is computed using:
    sizeInBytes = sizeInBytes + 4 + (pSize.bytes + rSize.bytes)*2 + propSize;

end

end %function

% Helper function
function outSize = iGetTypeSize(in)
    switch lower(class(in))
        case 'char'
            outSize = numel(in)*2 +4;
        case 'datetime'
            outSize = 8;
        case 'guid'
            outSize = 16;
        case 'double'
            outSize = 8;
        case 'int'
            outSize = 4;
        case 'int64'
            outSize = 8;
        case {'boolean','logical'}
            outSize = 1;
    end
end
