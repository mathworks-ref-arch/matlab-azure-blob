function to = insertOrMerge(tableEntity, varargin)
% INSERTORMERGE Method to insert or merge an existing entity
% This method will use either a TableOperation or a TableBatchOperation to
% insert the elements into the table.
%
% Example:
%     % Connect to an Azure Cloud Storage Account
%     az = azure.storage.CloudStorageAccount;
%     az.loadConfigurationSettings();
%     az.connect();
%
%     % Create a client Object
%     client = azure.storage.table.CloudTableClient(az);
%     tableHandle = azure.storage.table.CloudTable(client,'TestTable');
%
%     % Create a table
%     tableHandle.createIfNotExists();
%
%     % Check if the table exists
%     flag = tableHandle.exists();
%     testCase.assertTrue(flag);
%
%
%     % Create a number of sample entities and insert into the database
%     % 100 is a hard limit (see notes below)
%
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
%     % Create a table operation to execute on the database
%     tableOperation = azure.storage.table.TableOperation.insertOrMerge(dynamicEntity); % vectorized
%     tableHandle.execute(tableOperation);
%
% Notes:
%
% The following limitations are imposed by the service:
%
% * All entities subject to operations as part of the transaction must
%   have the same PartitionKey value.
%
% * An entity can appear only once in the transaction, and only one
%   operation may be performed against it.
%
% * The transaction can include at most 100 entities, and its total payload
%   may be no more than 4 MB in size.
%
% * All entities are subject to the limitations described in Understanding
%   the Table Service Data Model as described at:
%   https://msdn.microsoft.com/en-us/library/azure/dd179338.aspx

% Copyright 2017 The MathWorks, Inc.

if numel(tableEntity)==1
    % just a single operation
    to = com.microsoft.azure.storage.table.TableOperation.insertOrMerge(tableEntity.Handle);
else
    % use a batched operation for performance.
    to = com.microsoft.azure.storage.table.TableBatchOperation();
    for tCount = 1:numel(tableEntity)
        to.insertOrMerge(tableEntity(tCount).Handle);
    end
end

end %function
