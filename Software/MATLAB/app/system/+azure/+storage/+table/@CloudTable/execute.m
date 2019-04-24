function tableResults = execute(obj, varargin)
% EXECUTE Method to execute a table operation on the Azure Table service
% Method to execute queries and operations on the Azure Table.

% Copyright 2017 The MathWorks, Inc.

% logObj.DisplayLevel also used for verbose indicator feedback
logObj = Logger.getLogger();

% Perform the execution
if isjava(varargin{1})
    jResults = obj.Handle.execute(varargin{:});
else
    jResults = obj.Handle.execute(varargin{:}.Handle);
end

% Check if we have a single result or an array of results
if isa(jResults,'java.util.Array')||isa(jResults,'java.util.ArrayList')||isa(jResults,'com.microsoft.azure.storage.core.LazySegmentedIterable')
    % We are dealing with an array
    jIter = jResults.iterator;

    rCount = 1;
    while jIter.hasNext()
        tableResults(rCount)=iProcessResults(jIter.next()); %#ok<AGROW>
        rCount = rCount+1;

        if strcmp(logObj.DisplayLevel, 'verbose')
            fprintf(1,'.');
            if mod(rCount,80) == 0
                fprintf(1,'\n');
            end
        end
    end
    % If we proceduced output then output an ending new line
    if rCount > 1
        if strcmp(logObj.DisplayLevel, 'verbose')
            fprintf(1,'\n');
        end
    end
    if rCount == 1
        % If the iterator did not have a next and we didn't go around the while loop
        % create an empty tableResults return value
        emptyResultJ = com.microsoft.azure.storage.table.TableResult();
        tableResults = azure.storage.table.TableResult(emptyResultJ);
    end
else
    % Process the result
    tableResults = iProcessResults(jResults);
end

end %function

%% Internal function to process the results
function tableResults = iProcessResults(jResult)

switch class(jResult)
    case 'com.microsoft.azure.storage.table.TableResult'
        tableResults = azure.storage.table.TableResult(jResult.getResult());
    case 'com.microsoft.azure.storage.table.DynamicTableEntity'
        tableResults = azure.storage.table.DynamicTableEntity;
        tableResults.Handle = jResult;
        tableResults.partitionKey = char(jResult.getPartitionKey());
        tableResults.rowKey = char(jResult.getRowKey());

        % Add timestamp
        tableResults.addprop('timestamp');
        dateJ = jResult.getTimestamp();
        tableResults.timestamp = datetime(dateJ.getTime()/1000,'convertfrom','posixtime','TimeZone','UTC');

        % Handle the rest of the results
        props = jResult.getProperties();
        keys = props.keySet();
        vals = props.values();

        % Add an object property for each key
        kIter = keys.iterator();
        vIter = vals.iterator();
        while kIter.hasNext()
            keyName = char(kIter.next());
            if ~isprop(tableResults,keyName)
                tableResults.addprop(keyName);
            end

            % Extract the value and store
            val = vIter.next();
            tableResults.(keyName)=azure.storage.table.TableResult.getTypedResult(val);
        end
    otherwise
        % Create a logger object here for performance reasons
        logObj = Logger.getLogger();
        write(logObj,'error',['Unsupported result type: ', class(jResult)]);
end

end %function
