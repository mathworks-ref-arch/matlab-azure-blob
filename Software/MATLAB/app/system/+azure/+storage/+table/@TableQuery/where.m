function obj = where(obj, varargin)
% WHERE Method to define the filter expression for the table query

% Copyright 2018 The MathWorks, Inc.

% Pass through to the Java layer.
obj.Handle = obj.Handle.where(varargin{:});


end %function
