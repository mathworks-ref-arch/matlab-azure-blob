function to = retrieve(partitionKey, rowKey, tableEntityResolver) 
% RETRIEVE Method to retrieve a table entity

% Copyright 2017 The MathWorks, Inc.

to = com.microsoft.azure.storage.table.TableOperation.retrieve(partitionKey, rowKey, tableEntityResolver);

end %function
