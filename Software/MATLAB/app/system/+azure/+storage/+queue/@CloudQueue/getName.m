function name = getName(obj)
% GETNAME Gets the name of the queue
% The value is returned as a character vector.

% Copyright 2019 The MathWorks, Inc.

name = char(obj.Handle.getName);

end
