function outTable = table(obj, varargin)
% TABLE Method to cast a TableResult into a MATLAB table
% Returns an empty table for an empty TableResult

% Copyright 2018 The MathWorks, Inc.

% get a cell array of cell arrays of all obj properties
allPropNames = arrayfun(@properties, obj, 'UniformOutput', false);
% get the unique entries
allPropNames = unique(vertcat(allPropNames{:}));

if isempty(allPropNames)
    outTable = table();
else
    logObj = Logger.getLogger();
    write(logObj,'error','Populated TableResult not yet supported, expecting use of DynamicTableEntity');
end 
end