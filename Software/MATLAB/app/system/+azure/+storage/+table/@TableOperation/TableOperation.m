classdef TableOperation < azure.object
% TABLEOPERATION Class to perform a single operation on the Azure Cloud Table 
% 
% This class can be used to perform operations on tables that insert, 
% update, merge, delete, replace or retrieve table entities. To execute 
% a TableOperation instance, call the execute method on a CloudTableClient 
% instance. A TableOperation may be executed directly or as part of a 
% TableBatchOperation. 
% 
% If a TableOperation returns an entity result, it is stored in the 
% corresponding TableResult returned by the execute method.
        
% Copyright 2017 The MathWorks, Inc.

properties
end

methods
	%% Constructor 
	function obj = TableOperation(~, varargin)
        import 
	end
end

methods(Static)
    to = insert(varargin);
    to = insertOrMerge(varargin);
    to = insertOrReplace(varargin);
    to = delete(varargin);
    to = merge(varargin);
    to = replace(varargin);
    to = retrieve(varargin);
end

end %class
