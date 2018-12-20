function tableHandle = getTableReference(obj, tableNames, varargin)
% GETTABLEREFERENCE Method to create a reference to a Cloud Table
% This method will create handles to azure.storage.table.CloudTable objects in MATLAB
% that can be used to operate cloud based tables on the Microsoft Azure
% Storage system.
%
%   tbl = tClient.getTableReference(tableName);
%
% For example:
%
%   az = azure.storage.CloudStorageAccount;
%   az.loadConfigurationSettings();
%   az.connect();
%   tClient = azure.storage.table.CloudTableClient(az);
%   tbl = tClient.getTableReference('SampleTable');
%
% The table name needs to be a fully qualified string that conforms to the
% Azure naming conventions.

% Copyright 2017 The MathWorks, Inc.

if ischar(tableNames)
    % Valid name was specified
    tableHandle = azure.storage.table.CloudTable(obj,tableNames);

elseif iscell(tableNames)
    for fCount = 1:numel(tableNames)
        tableHandle(fCount) = azure.storage.table.CloudTable(obj,tableNames{fCount}); %#ok<AGROW>
    end
end

end %function
