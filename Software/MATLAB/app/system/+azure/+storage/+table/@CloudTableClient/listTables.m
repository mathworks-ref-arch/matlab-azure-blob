function tables = listTables(obj, varargin)
% LISTTABLES Method to list all the available tables
% List all available tables for the given client
%
%     % Connect to the service
%     az = azure.storage.CloudStorageAccount;
%     az.loadConfigurationSettings();
%     az.connect();
%
%     % Create a client Object
%     client = azure.storage.table.CloudTableClient(az);
%
%     % List all tables
%     azTables = client.listTables();
%     tableNames = {azTables.Name};

% Copyright 2017 The MathWorks, Inc.

% Initialize an array
cCount = 1;

% Return a list of tables
containerIterable = obj.Handle.listTables();
cIterator = containerIterable.iterator();

while cIterator.hasNext()
    % Create a table object
    tables(cCount) = azure.storage.table.CloudTable(obj, cIterator.next()); %#ok<AGROW>
    tables(cCount).Parent = obj;  %#ok<AGROW>

    % Populate the handles
    tables(cCount).Handle = obj.Handle.getTableReference(tables(cCount).Name); %#ok<AGROW>
    cCount = cCount+1;
end

end %function
