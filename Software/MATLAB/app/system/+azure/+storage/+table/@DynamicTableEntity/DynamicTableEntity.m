classdef DynamicTableEntity < azure.object
    % DYNAMICTABLEENTITY Dynamic Table Entity for use with the Table Operations
    % This class specifies the entity that is used in the TableOperations with
    % the Azure table storage.
    %
    % For details of mapping of MATLAB datatype to Table Properties see
    % the TableResult class documentation.

    % Copyright 2017 The MathWorks, Inc.

    properties
        partitionKey='';
        rowKey=''
    end

    methods
        %% Constructor
        function obj = DynamicTableEntity(~, varargin)
        end

        %% Initialize
        function initialize(obj, varargin)
            % Imports
            import java.util.HashMap;

            % Read the properties of the object and create the java property
            oProps = setdiff(properties(obj),{'rowKey','partitionKey'});

            % Create the HashMap
            hMap = java.util.HashMap;
            for pCount = 1:numel(oProps)
                % Check the datatype of the give property
                % see: https://azure.github.io/azure-sdk-for-java/com/microsoft/azure/storage/table/EntityProperty.html
                % EntityProperty represents single typed property and overloads
                % the constructor that sets the type and value based on the input
                % The MATLAB Java marshaling presents the right value to the API
                % in most cases
                % Creating a null EdmType Entity is not supported by the
                % Java API

                % Only support char vectors and uint8 as vectors of other
                % datatypes are not supported by the table API
                if ~(ischar(obj.(oProps{pCount})) || isa(obj.(oProps{pCount}), 'uint8')) && ~isscalar(obj.(oProps{pCount}))
                    logObj = Logger.getLogger();
                    oPropClass = class(obj.(oProps{pCount}));
                    write(logObj,'error',['Values of type: ', oPropClass, ' must be scalar, only vectors of type char vector and uint8 are supported']);
                end

                if isempty(obj.(oProps{pCount})) && ~(ischar(obj.(oProps{pCount})) || isstring(obj.(oProps{pCount})))
                    logObj = Logger.getLogger();
                    write(logObj,'error','Empty values are supported for strings and char vectors only');
                end

                % At this point datetime is scalar only based on previous
                % test, convert to posix time from MATLAB time
                if isa(obj.(oProps{pCount}),'datetime')
                    dateJ = java.util.Date(int64(posixtime(obj.(oProps{pCount}))*1000));
                    hMap.put(oProps{pCount}, com.microsoft.azure.storage.table.EntityProperty(dateJ));
                else
                    % For all other conversions and marshaling pass to EntityProperty()
                    hMap.put(oProps{pCount}, com.microsoft.azure.storage.table.EntityProperty(obj.(oProps{pCount})));
                end

            end

            % Create a handle to the Java entity
            obj.Handle = com.microsoft.azure.storage.table.DynamicTableEntity(obj.partitionKey, obj.rowKey, '*' , hMap);

        end
    end

end %class
