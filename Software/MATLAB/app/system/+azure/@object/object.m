classdef object < dynamicprops
    % OBJECT Root Class for all Azure wrapper objects
    
    % Copyright 2016 The MathWorks, Inc.
    
    properties (Hidden)
        Handle;
    end
    
    methods
        %% Constructor
        function obj = object(~, varargin)
            % logObj = Logger.getLogger();
            % write(logObj,'debug','Creating root object');
        end
    end
    
end %class
