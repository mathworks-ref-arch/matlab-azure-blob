function tf = deleteIfExists(obj)
% DELETEIFEXISTS Deletes a queue if it exists
% A logical true is returned if the queue existed in the storage service and
% has been deleted, otherwise false.

% Copyright 2019 The MathWorks, Inc.

tf = obj.Handle.deleteIfExists();

end
