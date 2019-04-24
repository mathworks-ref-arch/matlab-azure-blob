function outTable = table(obj, varargin)
% TABLE Method to cast a Dynamic Table Entity into a MATLAB table
% Converts the result into a table with the appropriate types. This method
% removes the handle from the DynamicTableEntity.
% The ordering of columns is not guaranteed relative to how they might be
% presented in Azure interfaces, e.g. Storage explorer
% All datetime entries must be in the UTC time zone.
% Where a row does not have a value for a given column i.e. a null an empty
% logical will be returned.
% A partitionKey, rowKey and timestamp column will be included

% Copyright 2018 The MathWorks, Inc.

% Disable the following warning:
% Warning: Calling STRUCT on an object prevents the object from hiding its
% implementation details and should thus be avoided. Use DISP or DISPLAY to
% see the visible public details of an object. See 'help struct' for more
% information.
%
warnState = warning('off','MATLAB:structOnObject');

try
    % get a cell array of cell arrays of all obj properties
allPropNames = arrayfun(@properties, obj, 'UniformOutput', false);
% get the unique entries
allPropNames = unique(vertcat(allPropNames{:}));

if numel(allPropNames) < 3
    % too few properties
    logObj = Logger.getLogger();
    write(logObj,'error','Expecting properties for partitionKey, rowKey and timstamp');
else
    % get the names that are not on the expected list
    otherProps = setdiff(allPropNames, {'partitionKey','rowKey','timestamp'});
    % put the names in a specific order starting with partitionKey
    orderedPropNames = union({'partitionKey','rowKey','timestamp'}, otherProps);

    % for each obj entry build a struct array entry and then convert that
    % struct array to a table
    for n = 1:numel(obj)
        % create a struct from the object and remove the handle
        sTmp = rmfield(struct(obj(n)),'Handle');
        % determine what fields from the complete set are missing and add them
        % these equate to nulls and are set to an empty logical array
        missingProps = setdiff(orderedPropNames, fields(sTmp));
        for m = 1:numel(missingProps)
            sTmp.(missingProps{m}) = logical([]);
        end
        % add sTmp to the array when it has all the necessary fields
        sArray(n) = sTmp; %#ok<AGROW>
    end
    % arrange the fields in the predetermined order & create the table
    sArray = orderfields(sArray, orderedPropNames);
    outTable = struct2table(sArray);
end

catch tErr
    warning(warnState.state,'MATLAB:structOnObject');
end

end
