function tf = exists(obj)
% EXISTS Method returns true if a blob exists, otherwise false
%
%   tf = myblob.exists();
%

% Copyright 2018 The MathWorks, Inc.

tf = obj.Handle.exists();

end %function
