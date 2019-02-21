# Network proxy configuration

From an enterprise's network it may be required to use a http(s) proxy to get access to the Internet and thus Azure's™ Blob servers. To use a proxy server create an OperationContext object as follows:
```
az = azure.storage.CloudStorageAccount;
az.loadConfigurationSettings();
az.connect();
oc = azure.storage.OperationContext();
```
Typically create the OperationContext object when configuring the account (as shown) and prior to creating a client. This context will set the default proxy values based on the MATLAB ®preferences where set and on Windows® the system preferences. To override this behavior call setDefaultProxy() subsequently with the desired arguments.

![PreferencesPanel](Images/prefspanel.png)

To set the default proxy to a specific value call setDefaultProxy as follows:
```
oc.setDefaultProxy('myproxy.mycompany.com', 8080);
```
To set the default to a direct connection i.e. no proxy or the default behavior without a OperationContext:
```
oc.setDefaultProxy('NO_PROXY');
```
Once set these settings will be used for subsequent data transfers with Azure.


----------------

[//]: #  (Copyright 2017, The MathWorks, Inc.)
