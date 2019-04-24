#  Use with MATLAB Parallel Server

When using this package with MATLAB Parallel Server™ note that the interface's objects cannot be serialized and thus cannot be passed between nodes. For example as required by a *parfor* call. Shared Access signatures can be generated and distributed as the URLs can be readily serialized. To use multiple workers to carry out Azure™ WASB transactions then using *spmd* calls is an alternative approach. In many cases bandwidth between Azure WASB and the MATLAB Parallel Server cluster will be a limiting factor relative to bandwidth within the cluster and so doing uploads and downloads on a single node and sharing resulting MATLAB variables in the normal way may be a preferable comprise in terms of simplicity and performance depending on the workload.

------------

[//]: #  (Copyright 2017, The MathWorks, Inc.)
