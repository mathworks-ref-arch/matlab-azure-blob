classdef TableQuery < azure.object
    % TABLEQUERY Represents a query against a given table

    % Copyright 2018 The MathWorks, Inc.

    properties
    end

    methods
        %% Constructor
        function obj = TableQuery(~, varargin)
            % Initialize the object
            obj.Handle = com.microsoft.azure.storage.table.TableQuery();

            % Initialize the object with the proper dynamic entity
            de = azure.storage.table.DynamicTableEntity;
            de.initialize();
            returnClass = de.Handle.getClass();

            % Return a dynamic class
            obj.Handle.setClazzType(returnClass);
        end
    end

    methods(Static)
        function str = generateFilterCondition(partitionKey, queryComparison, value, varargin)
            qcObj = queryComparison.Handle.(char(queryComparison));
            str = char(com.microsoft.azure.storage.table.TableQuery.generateFilterCondition(partitionKey, qcObj, value));
        end
    end


end %class
