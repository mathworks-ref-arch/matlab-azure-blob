classdef QueryComparisons < azure.object
% QUERYCOMPARISONS Enumerations for the different query comparisons
% The query comparison enumerations are used to construct filter
% conditions.
%
% Example:
%   queryCondition = azure.storage.table.QueryComparison;
%

% Copyright 2018 The MathWorks, Inc.

%% Enumeration
enumeration
    EQUAL                  (java.lang.String('EQUAL'))
    GREATER_THAN           (java.lang.String('GREATER_THAN'))
    GREATER_THAN_OR_EQUAL  (java.lang.String('GREATER_THAN_OR_EQUAL'))
    LESS_THAN              (java.lang.String('LESS_THAN'))
    LESS_THAN_OR_EQUAL     (java.lang.String('LESS_THAN_OR_EQUAL'))
    NOT_EQUAL              (java.lang.String('NOT_EQUAL'))
end

%% Methods
methods
	%% Constructor
	function obj = QueryComparisons(varargin)
        obj.Handle = javaObject('com.microsoft.azure.storage.table.TableQuery$QueryComparisons');
	end
end

end %class
