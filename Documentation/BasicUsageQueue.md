# Basic Usage of Azure Queue Storage

## Getting Started

This package is used to enable the use of the Azure™ Queue Storage service with MATLAB®. In the Software/MATLAB directory run the *startup.m* to make the software available in the MATLAB environment.

Azure Queue storage is a service for storing large numbers of messages. Messages are accessed via authenticated calls using HTTP or HTTPS. A queue message can be up to 64 KB in size. A queue may contain many millions of messages, up to the total capacity of a storage account.

The Queue URL format is: ```https://<storage account name>.queue.core.windows.net/<queue name>```

### Create and configure a storage account

If this is the first time using the interface, as a one-time operation per session (assuming only one storage account is used), setup the Cloud Storage Account. This is done using:
```
% Create a handle to the storage account
az = azure.storage.CloudStorageAccount;
```

The storage account will need to be configured to work with a Azure account or the development emulator. By default the UseDevelopmentStorage flag is set to *true* and so the emulator running on localhost will be used. For details of the development emulator see here: [https://docs.microsoft.com/en-us/azure/storage/storage-use-emulator](https://docs.microsoft.com/en-us/azure/storage/storage-use-emulator). To use Azure itself, disable this setting as follows:
```
az.UseDevelopmentStorage = false;
```

The following allows one to specify the credentials for the Azure storage account of choice.
```
az.AccountName = 'myaccountname'
az.AccountKey  = 'SVn445qMEABafld3k225l*****[REDACTED_FOR_SECURITY]****RfIhAQtvYzAQr0328/d030GGw=='
```

This can be provisioned in the [Azure Portal](https://portal.azure.com):

![Portal](Images/AzureStorageKeys.png)

Rather than configuring the storage account credentials in code which requires the sensitive account key to be embedded in code load it and other related settings from a file which is more readily protected.
```
az.loadConfigurationSettings();
```
Storing the settings in a file also allows for more simple management of multiple storage accounts. The file is a short json file stored in the config directory by default, the template for which is as follows:
```
{
    "DefaultEndpointsProtocol" : "https",
    "AccountKey" : "SVn<MYACCOUNTKEY>0GGw==",
    "UseDevelopmentStorage" : "false",
    "AccountName" : "myaccountname"
    "LocalPathToStorageExplorer" : "C:\\Program Files (x86)\\Microsoft Azure Storage Explorer\\StorageExplorer.exe"
}
```

The account is now ready to connect. When fully configured this looks like:
```
az.connect()
az

az =

  CloudStorageAccount with properties:

                   AccountName: 'myaccountname'
                    AccountKey: 'SVn<MYACCOUNTKEY>0GGw=='
                   ServiceName: 'blob'
      DefaultEndpointsProtocol: 'http'
         UseDevelopmentStorage: 0
    DevelopmentStorageProxyUri: []
                     Secondary: 0
                           URI: 'http://myaccountname.blob.core.windows.net/'
                  BlobEndpoint: 'http://myaccountname.blob.core.windows.net/'
```

### Create a Client

With a fully configured connection get a handle to a client that is required to perform CRUD (Create, Retrieve, Update, Delete) operations on queue storage.
```
queueClient = az.createCloudQueueClient()

queueClient =
 CloudQueueClient with no properties.
```

Now Windows Azure Queue Storage can be accessed from MATLAB.

See [Logging](Logging.md) for details of enabling verbose output during development and testing.

### Create a queue

A queue contains a set of messages. The queue name must be all lowercase. The client can be used to create a queue as follows, first create a CloudQueue object. Then using this object call ```createIfNotExists```, a logical true is returned if the queue is created in the service. A queue contains a set of messages. The queue name must be all lowercase. For more details on naming see: [https://msdn.microsoft.com/library/azure/dd179349.aspx](https://msdn.microsoft.com/library/azure/dd179349.aspx)
```
queue = queueClient.getQueueReference('my-queue-name');
tf = queue.createIfNotExists();
```
List existing queues as follows:
```
% List all queues, an array of queue object is returned
queues = queueClient.listQueues();

% List only queues with a name begining with the given prefix
queues = queueClient.listQueues('myqueueprefix');

% check the name of a queue in the returned array
queues(1).getName()
```

The method ```queue.exists()``` will return a logical true or false based on the existence of a given queue. ```queue.clear()``` can be used to delete all messages from a queue. when a queue is no longer required it can be deleted:
```
tf = queue.deleteIfExists();
```


### Create a message

As message can be created as simply as: ```message = azure.storage.queue.CloudQueueMessage('Hello World');```
This creates a local message object it must then be added to a queue: ```queue.addMessage(message)```.
Byte array messages are also supported, in this case the message content is set using the ```setMessageContent()``` method, this approach is not required:
```
% Create a message with any value
message = azure.storage.queue.CloudQueueMessage('dummy value');

% Create a byte array, in this case corresponding to the ASCII values 69-72
% Note the data is passed as a uint8 not a character vector
byteMsgVal = uint8('EFGH');

% Update the content and enqueue the message
message.setMessageContent(byteMsgVal);
queue.addMessage(message);
```


### Retrieve a message

To get the next message in a queue call ```retrieveMessage()```. A returned message becomes invisible to any other retrieve calls to this queue. By default, the message stays invisible for 30 seconds. To finish removing the message from the queue, call ```deleteMessage()```. A message is retrieved from a queue as follows:
```
retrievedMessage = queue.retrieveMessage();
retrievedContent = retrievedMessage.getMessageContentAsString();
```
This retrieves a message from the front of the queue. This operation marks the retrieved message as invisible in the queue for the default visibility timeout period.

Once *processed* the message should be deleted within the visibility window:
```
queue.deleteMessage(retrievedMessage);
```

In some cases it may be preferable to look at a message without making it unavailable for processing, i.e. changing its visibility. This process is called *peeking*.
```
peekedMessage = queue.peekMessage();
peekedContent = peekedMessage.getMessageContentAsString();
```

It may be useful to know how long a message has been in a queue:
```
insertionTime = retrievedMessage.getInsertionTime();
```
Messages expire from a queue in a given period, by default 1 week. To check when this is due:
```
expirationTime = retrievedMessage.getExpirationTime();
```
The values along with the time to visibility can also be set.


### Updating a message

A message can be updated while it remains queued. This feature can be used for example to alter the state of a message as it moves through a multi-step workflow.

```
% Retrieve a message from the queue and update the contents
retrievedMessage = queue.retrieveMessage();
retrievedMessage.setMessageContent('New message content');

% Default values for QueueRequestOptions and OperationContext
requestOptions = azure.storage.queue.QueueRequestOptions();
operationContext = azure.storage.OperationContext();

% Set the new visibility timeout window
visibilityTimeout = 10;

% Build an array with the fields we want to updated using MessageUpdateFields enums
updateFields(1) = azure.storage.queue.MessageUpdateFields.CONTENT;
updateFields(2) = azure.storage.queue.MessageUpdateFields.VISIBILITY;

% Do the update
queue.updateMessage(retrievedMessage, visibilityTimeout, updateFields, requestOptions, operationContext);
```

The visibility timeout alone can be changed as follows:
```
queue.updateMessage(retrievedMessage2, visibilityTimeout);
```


### Using Shared Access Signatures

As with other blob types Shared Access Signatures (SAS) can be used to access queue without using credentials as previously shown. A SAS is a URL that identifies a queue and encoded information about its access properties. A SAS may be produced from an external source e.g. Storage Explorer or the Azure portal. A SAS can also be produced using this package:
```
% Configure a policy object for a SAS
policy = azure.storage.queue.SharedAccessQueuePolicy();
% Grant read permissions
permSet(1) = azure.storage.queue.SharedAccessQueuePermissions.READ;
policy.setPermissions(permSet);

% Set the SAS to be valid for 24 hours beginning 15 minutes ago to allow for clock drift
t1 = datetime('now','TimeZone','UTC') + hours(24);
policy.setSharedAccessExpiryTime(t1);
t2 = datetime('now','TimeZone','UTC') - minutes(15);
policy.setSharedAccessStartTime(t2);

% Do not use a policy identifier, these may be configured in some cases
groupPolicyIdentifier = '';

% Generate the SAS token
sasToken = queue.generateSharedAccessSignature(policy, groupPolicyIdentifier);

% Get the base part of the queue URI
resourceUri = queue.getUri();
% Build the full URI from the base URI and token
sasUri = [char(resourceUri.EncodedURI), '?', sasToken];

% Create a queue object from the using the SAS URI, note this step can be done using an externally provided URI.
sasQueue = azure.storage.queue.CloudQueue(azure.storage.StorageUri(matlab.net.URI(sasUri)));
```


### Miscellaneous

* The approximate number of messages is a queue can be obtained as follows:
```
queue.downloadAttributes();
messageCount = queue.getApproximateMessageCount();
```

* Network proxy support is enabled using a OperationCentext object as described in: [Network Configuration](NetworkConfiguration.md)    

* Given a queue, e.g. one based on a SAS, a client can be obtained using ```client = queue.getServiceClient()```.

* Key-value metadata can be set on a queue.

## References
[How to use Queue storage from Java](https://docs.microsoft.com/en-us/azure/storage/queues/storage-java-how-to-use-queue-storage)
[Azure Queue Storage API Reference](https://docs.microsoft.com/en-us/java/api/com.microsoft.azure.storage.queue._cloud_queue?view=azure-java-legacy)

## Notes
[Microsoft® Azure Storage Explorer](https://azure.microsoft.com/en-us/features/storage-explorer/) is a free, standalone application from Microsoft that provides a GUI for Azure Storage data on Windows®, macOS®, and Linux.
When installed, it is possible to bring this up from MATLAB using the *AzureStorageExplorer* command. For more information, please see: https://docs.microsoft.com/en-us/azure/vs-azure-tools-storage-manage-with-storage-explorer


[//]: #  (Copyright 2019, The MathWorks, Inc.)
