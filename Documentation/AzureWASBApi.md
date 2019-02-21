# MATLAB Interface *for Windows Azure Storage Blob (WASB)*


## Objects:
* `Software\MATLAB\app\system\+azure\@object`
* `Software\MATLAB\app\system\+azure\+storage\@CloudStorageAccount`
* `Software\MATLAB\app\system\+azure\+storage\@OperationContext`
* `Software\MATLAB\app\system\+azure\+storage\@StorageUri`
* `Software\MATLAB\app\system\+azure\+storage\+blob\@BlobContainerPermissions`
* `Software\MATLAB\app\system\+azure\+storage\+blob\@BlobContainerProperties`
* `Software\MATLAB\app\system\+azure\+storage\+blob\@BlobProperties`
* `Software\MATLAB\app\system\+azure\+storage\+blob\@CloudBlobClient`
* `Software\MATLAB\app\system\+azure\+storage\+blob\@CloudBlobContainer`
* `Software\MATLAB\app\system\+azure\+storage\+blob\@CloudBlobDirectory`
* `Software\MATLAB\app\system\+azure\+storage\+blob\@CloudBlockBlob`
* `Software\MATLAB\app\system\+azure\+storage\+blob\@SharedAccessBlobPermissions`
* `Software\MATLAB\app\system\+azure\+storage\+blob\@SharedAccessBlobPolicy`
* `Software\MATLAB\app\system\+azure\+storage\+table\@CloudTable`
* `Software\MATLAB\app\system\+azure\+storage\+table\@CloudTableClient`
* `Software\MATLAB\app\system\+azure\+storage\+table\@DynamicTableEntity`
* `Software\MATLAB\app\system\+azure\+storage\+table\@QueryComparisons`
* `Software\MATLAB\app\system\+azure\+storage\+table\@SharedAccessTablePermissions`
* `Software\MATLAB\app\system\+azure\+storage\+table\@SharedAccessTablePolicy`
* `Software\MATLAB\app\system\+azure\+storage\+table\@TableOperation`
* `Software\MATLAB\app\system\+azure\+storage\+table\@TableQuery`
* `Software\MATLAB\app\system\+azure\+storage\+table\@TableResult`



------

## @object

### @object/object.m
```notalanguage
  OBJECT Root Class for all Azure wrapper objects



```

------


## @CloudStorageAccount

### @CloudStorageAccount/CloudStorageAccount.m
```notalanguage
  AZURE Storage Account for the Microsoft Azure services in MATLAB
  This account object provides MATLAB the appropriate access to the Azure
  cloud services and serves as a container for the various handles to the
  Azure Platform.
 
  If the UseDevelopmentStorage flag is set to true, the client will ignore
  the URI for the Azure Storage account and use the default settings for
  the Azure Storage Emulator running on the localhost. The defaults for
  this development configuration are:
 
      BlobEndpoint  = 'http://127.0.0.1:10000/devstoreaccount1';
      QueueEndpoint = 'http://127.0.0.1:10001/devstoreaccount1';
      TableEndpoint = 'http://127.0.0.1:10002/devstoreaccount1';
 
  Turning on the Secondary flag will leverage the RA-GRS (Read-access
  Geo-Redundant Secondary) Storage.
 
  To use a the WASB (Windows Azure Blob Storage), create a
  CloudStorageAccount object and connect.
 
     az = azure.storage.CloudStorageAccount;
     az.loadConfigurationSettings();
     az.connect();
 
  To use a configuration/credentials file with a non default
  (cloudstorageaccount.json) name then create the CloudStorageAccount as
  follows specifying the file path:
     az = azure.storage.CloudStorageAccount;
     az.loadConfigurationSettings('/home/user/mydir/myconfigfile.json');
     az.connect();
 
  This approach can be useful if multiple accounts are needed at the same time
  for example development and production or if one is also using the related
  Cosmos DB functionality which requires Cosmos DB credentials for its
  CloudStorageAccount object.
 
  Blob and Table Endpoint getters return 'Please connect() first' prior to
  connection.
 



```
### @CloudStorageAccount/connect.m
```notalanguage
  CONNECT Method to setup the account handle to connect to MS Azure
  Setup the handle to the Microsoft Azure Account by parsing the connection
  string and returning a handle used to create the client handle for
  service calls to Azure.
 
    az = azure.storage.CloudStorageAccount;
    az.loadConfigurationSettings();
    az.connect();



```
### @CloudStorageAccount/getCloudBlobClient.m
```notalanguage
  GETCLOUDBLOBCLIENT Method to create a client for the Blob Service
  Use this method to create a handle to the CloudBlobClient to interact
  with the Table API service.
 
    az = azure.storage.CloudStorageAccount;
    az.loadConfigurationSettings();
    az.connect();
    bc = az.getCloudBlobClient();



```
### @CloudStorageAccount/getCloudTableClient.m
```notalanguage
  GETCLOUDTABLECLIENT Method to create a cloud storage client
  Use this method to create a handle to the CloudTableClient to interact
  with the Table API service.
 
    az = azure.storage.CloudStorageAccount;
    az.loadConfigurationSettings();
    az.connect();
    tc = az.getCloudTableClient();



```
### @CloudStorageAccount/getStorageConnectionString.m
```notalanguage
  GETSTORAGECONNECTIONSTRING Method to return the account connection string
  with the necessary credentials to connect to the Azure Storage.



```
### @CloudStorageAccount/isValid.m
```notalanguage
  ISVALID Method to check if a given object is properly initialized
  This method tests if the object has been created correctly.
 
    az = azure.storage.CloudStorageAccount;
    az.loadConfigurationSettings();
    az.connect();
 
  The validity of the object is checked using:
    [FLAG] = az.isValid();



```
### @CloudStorageAccount/loadConfigurationSettings.m
```notalanguage
  loadConfigurationSettings Method to read Cloud Storage Account
  configuration settings from a file, by default named
  cloudstorageaccount.json or the name can be specified as an argument. If
  account configuration settings are not provided the locally hosted
  development account will be used.
 
    az = azure.storage.CloudStorageAccount;
    az.loadConfigurationSettings('/home/user/mydir/myconfigfile.json');
    az.connect();
 
  Alternatively the values may be specified manually as follows. It is not
  recommended to embed account keys in code.
 
    az = azure.storage.CloudStorageAccount;
    az.UseDevelopmentStorage = false;
    az.AccountName = 'mystorageaccountname';
    az.AccountKey  = 'SV<MYSTORAGEACCOUNTKEY>Gw==';
    az.DefaultEndpointsProtocol = 'https';
    az.connect
 



```

------


## @OperationContext

### @OperationContext/OperationContext.m
```notalanguage
  OPERATIONCONTEXT class used for client settings such as proxy servers
  This context will set the default proxy values based on the MATLAB preferences
  where set and on Windows the system preferences. To override this behavior call
  setDefaultProxy() subsequently with the desired arguments.
 
  Example:
    az = azure.storage.CloudStorageAccount;
    az.loadConfigurationSettings();
    az.connect();
    oc = azure.storage.OperationContext();
 



```
### @OperationContext/setDefaultProxy.m
```notalanguage
  SETDEFAULTPROXY Sets the default proxy server used by the client
  By default this will pick up the MATLAB settings or if not set and on
  Windows the systems preferences will be used.
 
  Examples:
    Set the default client proxy to that set in the MATLAB preferences
    panel, if preferences are not set then use system preferences (Windows only):
        obj.setDefaultProxy();
 
    Set the default proxy to a specific value:
        obj.setDefaultProxy('myproxy.mycompany.com', 8080);
 
    Set the default to a direct connection i.e. no proxy
        obj.setDefaultProxy('NO_PROXY');
 



```

------


## @StorageUri

### @StorageUri/StorageUri.m
```notalanguage
  STORAGEURI class used for storage URIs e.g. for CloudBlobDirectory
 
  A StorageUri object can be created in two ways, it can be constructed using
  a Java com.microsoft.azure.storage.StorageUri object:
 
     myStorageUri = StorageUri(my_com_microsoft_azure_storage_StorageUri);
 
  or alternatively it can be constructed by passing in URIs for the primary and
  or secondary URIs:
     myStorageUri = StorageUri(matlab.net.URI('myUriValue'));
 
     myStorageUri = StorageUri(matlab.net.URI('myUriValue1'), matlab.net.URI('myUriValue1'));
 
  If passing URLs directly first convert them to matlab.net.URI type as shown.
 



```

------


## @BlobContainerPermissions

### @BlobContainerPermissions/BlobContainerPermissions.m
```notalanguage
  BLOBCONTAINERPERMISSIONS Object to set the permissions for a container
  Use this class to set permissions on Blobs or Containers or to turn off public
  access.
 
  Example:
    perm = azure.storage.blob.BlobContainerPermissions;+
    % Supported values:
    perm.AccessType = 'BLOB'; % Blob level public access
    perm.AccessType = 'CONTAINER';  % Container-level public access
    perm.AccessType = 'OFF';        % Turn off public access
 
  This object can then be used in the uploadPermissions() method.



```

------


## @BlobContainerProperties

### @BlobContainerProperties/BlobContainerProperties.m
```notalanguage
  BLOBCONTAINERPROPERTIES Represents the system properties for a container



```
### @BlobContainerProperties/getEtag.m
```notalanguage
  GETETAG Gets the ETag value of the container
  The ETag value is a unique identifier that is updated when a write operation
  is performed against the container. It may be used to perform operations
  conditionally, providing concurrency control and improved efficiency. The
  Etag is returned as a char vector.
 
  Example:
    % Get the properties of an existing container
    % and then return the Etag property
    azContainer = azure.storage.blob.CloudBlobContainer(azClient,'mytestcontainer');
    p = azContainer.getProperties();
    p.getEtag()
    ans =
    '0x8D63A86D9B4B6EB'



```

------


## @BlobProperties

### @BlobProperties/BlobProperties.m
```notalanguage
  BLOBPROPERTIES Represents the system properties for a blob



```
### @BlobProperties/getLength.m
```notalanguage
  GETLENGTH Gets the size, in bytes, of the blob
  Before using getLength() call downloadAttributes() and getProperties() for the
  blob.
 
  Example:
   % Given an existing container with a number of blobs
   azContainer = azure.storage.blob.CloudBlobContainer(azClient,'testcontainer');
   % get a list of the blobs in the container
   l = azContainer.listBlobs();
   % populate the properties and metadata
   l{1}.downloadAttributes();
   % get the Properties
   p = l{1}.getProperties();
   p.getLength
     ans =
         7566357



```

------


## @CloudBlobClient

### @CloudBlobClient/CloudBlobClient.m
```notalanguage
  CLOUDBLOBCLIENT Class to provide access to the CloudBlob client
  Creates a blob client object for transacting with the Azure blob storage.
 
      % Setup Storage account
      az = azure.storage.CloudStorageAccount;
      az.loadConfigurationSettings();
      az.connect();
      % Create a client object using a StorageAccount
      client = azure.storage.blob.CloudBlobClient(az);
 
  Alternatively a CloudBlobClient can be constructed by passing a Java
  com.microsoft.azure.storage.blob.CloudBlobClient object.
      % Create a client Object
      client = azure.storage.blob.CloudBlobClient(existingJavabObject);
 
  A client object can be used to create containers and otherwise transact with
  WASB.



```
### @CloudBlobClient/getContainerReference.m
```notalanguage
  GETCONTAINERREFERENCE Method to get a named container reference
  This method creates a CloudObjectContainer reference object from the
  given name for a container. The name of the container, which must adhere to
  container naming rules. The container name should not include any path
  separator characters (/). Container names must be lowercase, between 3-63
  characters long and must start with a letter or number. Container names may
  contain only letters, numbers, and the dash (-) character. This package does
  not validate that a name is valid before passing it to the underlying Azure
  SDK. However it does convert to lower case.
 
      % Create a client
      az = azure.storage.CloudStorageAccount;
      az.loadConfigurationSettings();
      az.connect();
      azClient = azure.storage.blob.CloudBlobClient(az);
      % Create a container reference
      container = azClient.getContainerReference('mycontainername');
      % Create the container
      container.createIfNotExists;
 
  Alternatively a container could be created as follows:
      container = azure.storage.blob.CloudBlobContainer(client,'mycontainer');
      container.createIfNotExists;



```
### @CloudBlobClient/getDirectoryDelimiter.m
```notalanguage
  GETDIRECTORYDELIMITER Returns delimiter used for cloud blob directories
  Method returns the value for the default delimiter used for cloud blob
  directories. The default is '/'. The value of the delimiter used by a client
  can be set using setDirectoryDelimiter. Using the default / is strongly
  recommended.



```
### @CloudBlobClient/isValid.m
```notalanguage
  ISVALID Method to check if a given object is properly initialized
  This method tests if the object has been created  correctly.
  True is returned if valid otherwise false.
 
    az = azure.storage.CloudStorageAccount;
    az.loadConfigurationSettings();
    az.connect();
 
    client = azure.storage.blob.CloudBlobClient(az);
 
  The validity of the object is checked using:
    flag = client.isValid();



```
### @CloudBlobClient/listContainers.m
```notalanguage
  LISTCONTAINERS returns an array of blob containers for the given client
  Returns an array of CloudBlobContainers for this blob service client.
 
      % Connect to the service
      az = azure.storage.CloudStorageAccount;
      az.loadConfigurationSettings();
      az.connect();
 
      % Create a client Object
      client = azure.storage.blob.CloudBlobClient(az);
 
      % List all containers
      containers = client.listContainers();
      containerNames = {containers.Name};



```
### @CloudBlobClient/setDirectoryDelimiter.m
```notalanguage
  SETDIRECTORYDELIMITER sets the directory delimiter for use with this client
  By default the client is created with '/' as the delimiter
  In the unlikely event that another delimiter is preferred then it can be set
  as follows before the client is used, this should be done with caution and is
  strongly discouraged, a warning message is displayed:
 
  Example:
      % Create a client Object
      client = azure.storage.blob.CloudBlobClient(az);
      % Set delimiter to a \
      client.setDirectoryDelimiter('\');



```

------


## @CloudBlobContainer

### @CloudBlobContainer/CloudBlobContainer.m
```notalanguage
  CLOUDBLOBCONTAINER Class to provide references to a container.
  The cloud blob container allows container level operations to create
  new containers, list contents, add/remove contents and change
  permissions.
 
      % Setup a storage account object
      az = azure.storage.CloudStorageAccount;
      az.loadConfigurationSettings();
      az.connect();
 
      % Create a client object and then a container
      client = azure.storage.blob.CloudBlobClient(az);
      container = azure.storage.blob.CloudBlobContainer(client,'mycontainer');
 
  This container handle can be used to transact with the cloud-based
  container. The name of the container can only be set at creation
  time. The name of the container must adhere to container naming rules.
  The container name should not include any path separator characters (/).
  Container names must be lowercase, between 3-63 characters long and must
  start with a letter or number. Container names may contain only letters,
  numbers, and the dash (-) character. This package does not validate that a
  name is valid before passing it to the underlying Azure SDK. However it
  does convert to lowercase. Violating the Azure container naming
  rules, it will cause 400 errors (Bad Request).
 
  A container object can also be constructed by passing a Java container
  object of type com.microsoft.azure.storage.blob.CloudBlobContainer
 
      container = azure.storage.blob.CloudBlobContainer(myJavaContainerObj);
 
  A container object can also be constructed by passing a Shared Access
  Signature (SAS) as a azure.storage.StorageURI as follows:
 
      % create an azure.storage.StorageURI
      SASURL = 'https://myaccount.blob.core.windows.net/mywasbtestcontainer?st=2018-08-15T17%3<REDACTED>WvIIzQ%3D';
      SASStorageUri = StorageUri(matlab.net.URI(SESASURL));
      % create a container using the StorageUri
      SASContainer = azure.storage.blob.CloudBlobContainer(SASStorageUri);
      % access the blobs as normal
      mylist = SASContainer.listBlobs()
      mylist =
 
        1x3 cell array
 
        {1x1 azure.storage.blob.CloudBlockBlob}    {1x1 azure.storage.blob.CloudBlobDirectory}    {1x1 azure.storage.blob.CloudBlockBlob}
      mylist{3}.download;
 
  See also the client.getContainerReference() method which is the idiomatic
  way to construct a container.



```
### @CloudBlobContainer/createIfNotExists.m
```notalanguage
  CREATEIFNOTEXISTS Method to create a container on the Blob Storage service
  The createIfNotExists method creates a container on the Blob storage service.
 
    % Connect to the Cloud Storage account
    az = azure.storage.CloudStorageAccount;
    az.loadConfigurationSettings();
    az.connect();
 
    % Create a client Object
    client = azure.storage.blob.CloudBlobClient(az);
 
    % Create a blob container and name it.
    container = azure.storage.blob.CloudBlobContainer(client,'mycontainername');
    container.createIfNotExists();
 
  This functions returns true if container was created otherwise false.



```
### @CloudBlobContainer/deleteIfExists.m
```notalanguage
  DELETEIFEXISTS Method to delete a container on the Blob Storage Service
  The deleteIfExists method deletes a container on the Blob storage service.
 
    % Connect to the Cloud Storage account
    az = azure.storage.CloudStorageAccount;
    az.loadConfigurationSettings();
    az.connect();
 
    % Create a client Object
    client = azure.storage.blob.CloudBlobClient(az);
 
    % Create a blob container and name it.
    container = azure.storage.blob.CloudBlobContainer(client,'MyContainer');
    container.deleteIfExists();
 
  This functions returns true if container was deleted otherwise false



```
### @CloudBlobContainer/downloadAttributes.m
```notalanguage
  DOWNLOADATTRIBUTES Downloads the container's attributes
  Attributes consist of metadata and properties.
 



```
### @CloudBlobContainer/downloadPermissions.m
```notalanguage
  DOWNLOADPERMISSIONS Downloads the permission settings for a container
  Use this methods to get the permissions for a container.
 
    perm = azContainer.downloadPermissions();
 
  Perms should now have one of the following AccessTypes:
    'OFF', 'BLOB' or 'CONTAINER'



```
### @CloudBlobContainer/exists.m
```notalanguage
  EXISTS Method to check if a container exists
  Check if a container exists using this method.
 
      % Connect to an Azure Cloud Storage Account
      az = azure.storage.CloudStorageAccount;
      az.loadConfigurationSettings();
      az.connect();
 
      % Create a client Object
      client = azure.storage.blob.CloudBlobClient(az);
      container = azure.storage.blob.CloudBlobContainer(client,'MyContainer');
 
      % Create a container for the blobs
      container.createIfNotExists();
 
      % Check if the container exists
      flag = container.exists();



```
### @CloudBlobContainer/generateSharedAccessSignature.m
```notalanguage
  GENERATESHAREDACCESSSIGNATURE Returns a shared access signature (SAS) string
  Returns a shared access signature for the blob using the specified group
  policy identifier and operation context. Note this does not contain the
  leading "?". A character vector is returned.
 
  Example:
     % configure a client & connect to Azure
     az = azure.storage.CloudStorageAccount;
     az.loadConfigurationSettings();
     az.connect();
     % create a container
     azClient = azure.storage.blob.CloudBlobClient(az)
     container = azure.storage.blob.CloudBlobContainer(azClient,'mycontainer')
     container.createIfNotExists()
     % create a shared access policy
     myPolicy = azure.storage.blob.SharedAccessBlobPolicy();
     permSet(1) = azure.storage.blob.SharedAccessBlobPermissions.LIST;
     permSet(2) = azure.storage.blob.SharedAccessBlobPermissions.READ;
     myPolicy.setPermissions(permSet);
     t1 = datetime('now');
     t2 = t1 + hours(24);
     myPolicy.setSharedAccessExpiryTime(t2);
     t3 = t1 - minutes(15);
     myPolicy.setSharedAccessStartTime(t3);
     % generate the signature as follows
     % blob URI + '?' + Signature string
     % If there is no container level policy in use then this can be set to ''
     sas = container.generateSharedAccessSignature(myPolicy,'myContainerLevelAccessPolicy')
     sas =
     'sig=eqqgphDjJv0uat3v%2B%2BlPqYUpJFA7ZaXe5eaIEvFIRX4%3D&st=2018-05-09T16%3A03%3A48Z&se=2018-05-10T16%3A18%3A48Z&sv=2017-04-17&si=myContainerLevelAccessPolicy&sp=rac&sr=b'
     myUri = container.getUri;
     fullSas = [char(myUri.EncodedURI),'?',sas];
 
     % This SAS can now be used by 3rd parties without credentials based access
     SASStorageUri = azure.storage.StorageUri(matlab.net.URI(fullSas));
     SASContainer = azure.storage.blob.CloudBlobContainer(SASStorageUri);
     blobList = SASContainer.listBlobs();
     myBlob = myList{1};
     myBlob.download();



```
### @CloudBlobContainer/getBlockBlobReference.m
```notalanguage
  GETBLOBREFERENCE Method to create reference(s) to WASB CloudBlockBlob(s)
  This method will create CloudBlockBlob object(s). A local file name argument
  corresponding to the file being reference must be provided as a full path. An
  optional blob name may provided otherwise the file name will be used as the
  blob name. The file name and the blob name can also be provided as cell arrays
  allowing vectorized input.
 
    % use which to expand a file name on the path
     blob = container.getBlockBlobReference(which('MyData.mat'));
    % provide a full path directly
    blob = container.getBlockBlobReference('/my/local/path/filename.mat');
    % provide a blob name
    blob = container.getBlockBlobReference('/my/local/path/filename.mat', 'myalternatename.mat');



```
### @CloudBlobContainer/getDirectoryReference.m
```notalanguage
  GETDIRECTORYREFERENCE Returns a virtual blob directory within this container
  Returns a CloudBlobDirectory object to represent a directory of the given name
  within the current directory.
 
  Example:
     myCloubBlobDirectory = azContainer.getDirectoryReference('mydirname')



```
### @CloudBlobContainer/getMetadata.m
```notalanguage
  GETMETADATA Returns the metadata for the container
  This value is initialized with the metadata from the queue by a call to
  downloadAttributes, and is set on the queue with a call to uploadMetadata.
  Data is returned as containers.Map. If there is no metadata an empty
  containers.Map is returned.
 
  Example:
    % set and retrieve a metadata key value pair
    azContainer = azure.storage.blob.CloudBlobContainer(azClient,'mytestcontainer');
    azContainer.setMetadata('key1','val1');
    azContainer.uploadMetadata();
    m = azContainer.getMetadata();
    keys(m)
    ans =
      1x1 cell array
        {'key1'}



```
### @CloudBlobContainer/getProperties.m
```notalanguage
  GETPROPERTIES Returns the properties for the container
 
  Example:
    % Get the properties of an existing container
    % and then return the Etag property
    azContainer = azure.storage.blob.CloudBlobContainer(azClient,'mytestcontainer');
    p = azContainer.getProperties();
    p.getEtag()
    ans =
    '0x8D63A86D9B4B6EB'



```
### @CloudBlobContainer/getServiceClient.m
```notalanguage
  GETSERVICECLIENT returns the client associated with a given container
 
      % Setup a storage account object
      az = azure.storage.CloudStorageAccount;
      az.connect();
 
      % Create a client object and then a container
      client = azure.storage.blob.CloudBlobClient(az);
      container = azure.storage.blob.CloudBlobContainer(client,'mycontainer');
 
      % Derive a CloudBlobClient from a container object
      client2 = container.getServiceClient();



```
### @CloudBlobContainer/getStorageUri.m
```notalanguage
  GETSTORAGEURI returns the StorageUri for a container
  The URI is returned as a azure.storage.StorageUri object.



```
### @CloudBlobContainer/getUri.m
```notalanguage
  GETURI Returns the URI for this container
  The URI is returned as a matlab.net.URI object.



```
### @CloudBlobContainer/isValid.m
```notalanguage
  ISVALID Method to check if a given object is properly initialized
  This method tests if the object has been created and initialized
  correctly.
 
    az = azure.storage.CloudStorageAccount;
    az.loadConfigurationSettings();
    az.connect();
 
    client = azure.storage.blob.CloudBlobClient(az);
    container = azure.storage.blob.CloudBlobContainer(client,'mycontainer');
 
  The validity of the object is checked using:
    flag = container.isValid();



```
### @CloudBlobContainer/listBlobs.m
```notalanguage
  LISTBLOBS Method to list the blobs in a container
  This method will list all the blobs in a container. The resulting cell array
  of blobs are of type CloudBlockBlob and or CloudBlobDirectory. Other blob
  types are not supported. An optional prefix can be provided for blob items for
  the container whose names begin with the specified prefix.  This value must be
  preceded either by the name of the container or by the absolute path to the
  container. If no blobs are present an empty cell array will be returned.
 
  Example:
    Connect to an Azure Cloud Storage Account
    az = azure.storage.CloudStorageAccount;
    az.loadConfigurationSettings();
    az.connect();
 
    % Create a client Object
    client = azure.storage.blob.CloudBlobClient(az);
    container = azure.storage.blob.CloudBlobContainer(client,'mycontainername');
 
    % List the contents of the container
    blobs = container.listBlobs()



```
### @CloudBlobContainer/load.m
```notalanguage
  LOAD Loads variables from an Azure Blob into a struct
  Note if only a subset of the variables in a file are required the entire
  file must still be downloaded in the background from Azure. load can be
  used very much like the functional form of the built-in load command.
 
  Example:
        % load the variables from a .mat file stored as a blob in a given
        % container
        myVars = azContainer.load('myblobname.mat');
    Or
        myVars = azContainer.load('myblobname.mat', 'x', 'y');
 
  Non .mat files are also supported as per the built-in load command support.



```
### @CloudBlobContainer/save.m
```notalanguage
  SAVE Save variables to an Azure WASB CloudBlockBlob
  Save will overwrite existing blobs and create parent virtual directories if
  required.
 
  Save can be used very much like the functional form of the built-in save
  command with two exceptions:
    1) The '-append' option is not supported.
    2) An entire workspace cannot be saved i.e. Container.save('myfile.mat')
       because the Azure WASB objects are not serializable. The
       workspace variables should be listed explicitly to overcome this.
 
  Example:
        % save the variables x and y to a blob holding a .mat file
        y = rand(10);
        x = rand(10);
        mycontainer.save('myblobname.mat', 'x', 'y');



```
### @CloudBlobContainer/setMetadata.m
```notalanguage
  SETMETADATA Sets the metadata for the container
  Sets the metadata collection of name-value pairs to be set on the container
  with an uploadMetadata call. This collection will overwrite any existing
  container metadata. If this is set to an empty collection, the container
  metadata will be cleared on an uploadMetadata call.
  Key Value pairs in char vector format can be passed as an individual pair or
  as containers.Map containing multiple key value pairs.
 
  Example:
    % set and retrieve a metadata key value pair
    azContainer = azure.storage.blob.CloudBlobContainer(azClient,'mytestcontainer');
    azContainer.setMetadata('key1','val1');
    azContainer.uploadMetadata();
    m = azContainer.getMetadata();
    keys(m)
    ans =
      1x1 cell array
        {'key1'}
 
    % to set multiple metadata values
    myKeys = {'key1','key2'};
    myVals = {'val1','val2'};
    cMap = containers.Map(myKeys, myVals);
    azContainer.setMetadata(cMap);
    azContainer.uploadMetadata();
    m = azContainer.getMetadata();



```
### @CloudBlobContainer/uploadMetadata.m
```notalanguage
  UPLOADMETADATA Uploads the container's metadata
  See also: setMetadata()



```
### @CloudBlobContainer/uploadPermissions.m
```notalanguage
  UPLOADPERMISSIONS Upload a permission set to control container access
  Use this method to set permissions on a container.
 
    perm = azure.storage.blob.BlobContainerPermissions;
 
  Set one of the below as appropriate
    perm.AccessType = 'BLOB';       % Blob level public access
    perm.AccessType = 'CONTAINER';  % Container-level public access
    perm.AccessType = 'OFF';        % Turn off public access
 
  Upload the permissions to Azure using:
 
    azContainer.uploadPermissions(perm);



```

------


## @CloudBlobDirectory

### @CloudBlobDirectory/CloudBlobDirectory.m
```notalanguage
  CLOUDBLOBDIRECTORY Represents a virtual directory of blobs
  Directory of blobs are designated by a delimiter character. Containers,
  which are encapsulated as CloudBlobContainer objects, hold directories,
  and directories hold block blobs and page blobs. Directories can also
  contain sub-directories. CloudBlobDirectory object are generally created as
  outputs of other function calls.
 
  Constructors:
    CloudBlobDirectory(container, name)
    CloudBlobDirectory(uri, prefix, client, container)
    CloudBlobDirectory(AzureSDKJavaClassCloudBlobDirectory)
 
    Where prefix is the directory name



```
### @CloudBlobDirectory/getContainer.m
```notalanguage
  GETCONTAINER returns the container object of a CloudBlobDirectory



```
### @CloudBlobDirectory/getParent.m
```notalanguage
  GETPARENT returns the parent CloudBlobDirectory of a CloudBlobDirectory



```
### @CloudBlobDirectory/getPrefix.m
```notalanguage
  GETPREFIX returns the prefix of the a CloudBlobDirectory



```
### @CloudBlobDirectory/isValid.m
```notalanguage
  ISVALID Method to check if a given object is properly initialized
  This method tests if the object has been created and initialized
  correctly.
 
    az = azure.storage.CloudStorageAccount;
    az.loadConfigurationSettings();
    az.connect();
 
    client = azure.storage.blob.CloudBlobClient(az);
    container = azure.storage.blob.CloudBlobContainer(client,'mycontainer');
    myDir = CloudBlobDirectory(container, 'MyDirectoryName');
 
  The validity of the object is checked using:
    flag = myDir.isValid();



```
### @CloudBlobDirectory/listBlobs.m
```notalanguage
  LISTBLOBS Returns a list of blob items for the directory
  This method will list all the blobs for the directory. The resulting cell
  array of blobs are of type CloudBlockBlob and CloudBlobDirectory and can
  be used to manipulate the blobs or blob directories. Other blob types are not
  supported.
 
    % Connect to an Azure Cloud Storage Account
    az = azure.storage.CloudStorageAccount;
    az.loadConfigurationSettings();
    az.connect();
 
    % Create a client Object
    client = azure.storage.blob.CloudBlobClient(az);
    % Create a container
    container = azure.storage.blob.CloudBlobContainer(client,'mycontainername');
    flag = azContainer.createIfNotExists();
 
    myCloudBlobDirectory = container.getDirectoryReference('mydirname')
    % List the contents of the CloudBlobDirectory, this should return an empty
    % cell array as the container has just been created
    blobs = myCloudBlobDirectory.listBlobs()
 
    % Create a blob and upload it to the container in the directory
    filename = 'SampleData.mat';
    sampleData = rand(100,100);
    save(filename, 'sampleData');
    blob = azure.storage.blob.CloudBlockBlob(container, [myCloudBlobDirectory.Name, filename], which(filename));
    blob.upload();
 
    % List the blobs again, this time blobs{1} should contain a CloudBlockBlob
    % with a name of 'mydirname/SampleData.mat'
    blobs = myCloudBlobDirectory.listBlobs();



```

------


## @CloudBlockBlob

### @CloudBlockBlob/CloudBlockBlob.m
```notalanguage
  CLOUDBLOCKBLOB Class to represent an Azure CloudBlockBlob object
  A BlockBlob can be created in several ways. In the first example a
  container handle is provided along with the name of the BloblBlob
  once uploaded. A CloudBlockBlob object does not
  guarantee a file exists, for example a BlockBlob may be downloadable
  rather than uploadable i.e. it exists in Azure but not locally.
  In the second A local file path is provided that the file blob maps to.
 
  Examples:
  Create blob based on a blob name of SampleData.mat
    blob = azure.storage.blob.CloudBlockBlob(azContainer, 'SampleData.mat');
 
  A blob based on a local file:
    blob = azure.storage.blob.CloudBlockBlob(azContainer, ...
              'SampleData.mat', './my/local/path/SampleData.mat');
 
  A blob can be uploaded with a name other than its filename as follows:
    blob = azure.storage.blob.CloudBlockBlob(azContainer, ...
              'mydir/mynewblobname.mat', which('SampleData.mat'));
  Note virtual directory hierarchy in the uploaded blob can be introduced
  by prepending it to the name. This method can be used to create
  a virtual directory 'mydir' Azure will represent this as a
  CloudBlobDirectory. Empty virtual directories are not supported.
 
  A BlockBlob can also be created based on a Shared Access Signature for a
  BlockBlob
 
    blob = azure.storage.blob.CloudBlockBlob(mySAS_StorageUri);



```
### @CloudBlockBlob/deleteIfExists.m
```notalanguage
  DELETEIFEXISTS Method to delete a blockblob or collection of blockblobs
  Use this method to delete one or more blobs from a container.
 
    % delete a single blob from a cell array
    blobs = azContainer.listBlobs();
    blobs{1}.deleteIfExists();
 
  If an array (NOT a cell array) of blobs is provided then the method will act
  on each instance. An array of logical values results is returned corresponding
  to the input blockblobs. True is returned if a blockblob is deleted otherwise
  false is returned. If vectorized input is used and verbose logging is enabled
  then a progress bar of '.' is displayed for each blockblob processed.
 
   myBlobArray.deleteIfExists
   .....
 
   ans =
 
     3x1 logical array
 
      1
      1
      1



```
### @CloudBlockBlob/download.m
```notalanguage
  DOWNLOAD Method to download CloudBlockBlob(s)
  Use this method to download a CloudBlockBlob or an array of CloudBlockBlobs if
  a vector input is provided. If no argument is provided the current working
  directory will be used as the download destination and the blob name will be
  used as the filename. If a directory is provided then that directory will be
  used as the destination directory. When specifying a destination directory but
  not a destination file use a trailing delimiter. Again if a destination file
  name is not provided the blob name will be used as the filename. If vectorized
  blob inputs are provided avoid specifying a destination filename as all blobs
  will be downloaded with the same filename and so all but the last blob will be
  overwritten. A destination directory can be used in this scenario.
 
  If a blob has a virtual directory hierarchy, this hierarchy will be removed on
  download unless preserved by specifying the parameter 'useVirtualDirectory'
  as true. In which case the blob's virtual hierarchy will be appended to a
  destination directory, if specified, when creating the final download
  destination. This is a change to functionality in releases prior to 0.6.0.
 
  / & \ delimiters for virtual directories will be automatically altered to that
  used on the destination system if required. Other delimiters though supported
  by WASB will not be adjusted and in general are strongly discouraged. The
  default delimiter '/' is strongly recommended.
 
  Examples:
    % download a list of CloudBlockBlobs to the current working directory using
    % the blob names as filenames but removing any virtual directory hierarchy
    blobList = azContainer.listBlobs();
    for n=1:numel(blobList)
      if isa(blobList{n}, azure.storage.blob.CloudBlockBlob)
        blobList{n}.download()
      end
    end
 
   % download a blob called SampleData.mat from the container azContainer to the
   % current working directory
   blob = azure.storage.blob.CloudBlockBlob(azContainer, 'SampleData.mat');
   blob.download();
 
   % download a blob called SampleData.mat from the container azContainer to the
   % current working directory but retain the mydir1/mydir2 hierarchy
   % Note, if setting useVirtualDirectory and not specifying a destination directory
   % an empty directory, '', should be specified.
   blob = azure.storage.blob.CloudBlockBlob(azContainer, 'mydir1/mydir2/SampleData.mat');
   blob.download('','useVirtualDirectory',true);
 
   % download a blob called SampleData.mat from the container azContainer to the
   % directory /tmp/mydownloads/, do not retain virtual hierarchy but use the name
   % SampleData.mat, note the trailing delimiter following mydownloads/
   blob = azure.storage.blob.CloudBlockBlob(azContainer, 'mydir1/SampleData.mat');
   blob.download('/tmp/mydownloads/');
 
   % download a blob called myAzureName.txt from the container azContainer to the
   % directory /mydownloads/ within the current working directory. The blob name
   % is not used for the local download.
   blob = azure.storage.blob.CloudBlockBlob(azContainer, 'myAzureName.txt');
   blob.download(fullfile(pwd, '/mydownloads/myLocalName.txt'));
 



```
### @CloudBlockBlob/downloadAttributes.m
```notalanguage
  DOWNLOADATTRIBUTES Populates a blob's properties and metadata
  This method populates the blob's system properties and user-defined metadata.
  Before reading or modifying a blob's properties or metadata, call this method
  retrieve the latest values for the blob's properties and metadata from Azure.
 
  Example:
   % Given an existing container with a number of blobs
   azContainer = azure.storage.blob.CloudBlobContainer(azClient,'testcontainer');
   % get a list of the blobs in the container
   l = azContainer.listBlobs();
   % populate the properties and metadata
   l{1}.downloadAttributes();
   % get the metadata
   m = l{1}.getMetadata()
   m =
     Map with properties:
           Count: 1
         KeyType: char
       ValueType: char
   keys(m)
   ans =
     1x1 cell array
        {'mykey1'}



```
### @CloudBlockBlob/exists.m
```notalanguage
  EXISTS Method returns true if a blob exists, otherwise false
 
    tf = myblob.exists();
 



```
### @CloudBlockBlob/generateSharedAccessSignature.m
```notalanguage
  GENERATESHAREDACCESSSIGNATURE Returns a shared access signature (SAS) string
  Returns a shared access signature for the blob using the specified group
  policy identifier and operation context. Note this does not contain the
  leading "?". A character vector is returned.
 
  Example:
     % configure a client & connect to Azure
     az = azure.storage.CloudStorageAccount;
     az.loadConfigurationSettings();
     az.connect();
     % create a container
     azClient = azure.storage.blob.CloudBlobClient(az)
     container = azure.storage.blob.CloudBlobContainer(azClient,'mycontainer')
     container.createIfNotExists()
     % create a shared access policy
     myPolicy = azure.storage.blob.SharedAccessBlobPolicy();
     permSet(1) = azure.storage.blob.SharedAccessBlobPermissions.LIST;
     permSet(2) = azure.storage.blob.SharedAccessBlobPermissions.READ;
     myPolicy.setPermissions(permSet);
     t1 = datetime('now');
     t2 = t1 + hours(24);
     myPolicy.setSharedAccessExpiryTime(t2);
     t3 = t1 - minutes(15);
     myPolicy.setSharedAccessStartTime(t3);
     % create a blob in the container
     x = rand(10);
     save('SampleData.mat','x');
     myblob = azure.storage.blob.CloudBlockBlob(mycontainer, which('SampleData.mat'));
     myblob.upload
     % generate the signature as follows
     % blob URI + '?' + Signature string
     sas = myblob.generateSharedAccessSignature(myPolicy,'myContainerLevelAccessPolicy')
     sas =
     'sig=eqqgphDjJv0uat3v%2B%2BlPqYUpJFA7ZaXe5eaIEvFIRX4%3D&st=2018-05-09T16%3A03%3A48Z&se=2018-05-10T16%3A18%3A48Z&sv=2017-04-17&si=myContainerLevelAccessPolicy&sp=rac&sr=b'
     myUri = myblob.getUri;
     fullSas = [char(myUri.EncodedURI),'?',sas];
 



```
### @CloudBlockBlob/getContainer.m
```notalanguage
  GETCONTAINER returns the container of a CloudBlockblob
  The container is returned as a azure.storage.blob.CloudBlobContainer.
 
  container = azure.storage.blob.CloudBlobContainer(myBlockBlob);



```
### @CloudBlockBlob/getMetadata.m
```notalanguage
  GETMETADATA Returns the metadata for the blob
  Data is returned as containers.Map. If there is no metadata and empty
  containers.Map is returned.
 
  Example:
   % Given an existing container with a number of blobs
   azContainer = azure.storage.blob.CloudBlobContainer(azClient,'testcontainer');
   % get a list of the blobs in the container
   l = azContainer.listBlobs();
   % populate the properties and metadata
   l{1}.downloadAttributes();
   % get the metadata
   m = l{1}.getMetadata()
   m =
     Map with properties:
           Count: 1
         KeyType: char
       ValueType: char
   keys(m)
   ans =
     1x1 cell array
        {'mykey1'}



```
### @CloudBlockBlob/getParent.m
```notalanguage
  GETPARENT returns the parent directory of a CloudBlockBlob
  The parent is returned as a azure.storage.blob.CloudBlobDirectory.



```
### @CloudBlockBlob/getProperties.m
```notalanguage
  GETPROPERTIES Returns the properties for the blob
 



```
### @CloudBlockBlob/getUri.m
```notalanguage
  GETURI Returns the URI for a CloudBlockBlob
  The URI is returned as a matlab.net.URI, this may be used when
  constructing a shared access signature for example.
 
     % get the URI for a blob
     myblob.getUri
     ans =
     URI with properties:
 
                 Scheme: "https"
               UserInfo: [0x0 string]
                   Host: "myaccount.blob.core.windows.net"
                   Port: []
       EncodedAuthority: "myaccount.blob.core.windows.net"
                   Path: [""    "mycontainer"    "SampleData.mat"]
            EncodedPath: "/mycontainer/SampleData.mat"
                  Query: [0x0 matlab.net.QueryParameter]
           EncodedQuery: ""
               Fragment: [0x0 string]
               Absolute: 1
             EncodedURI: "https://myaccount.blob.core.windows.net/mycontainer/SampleData.mat"
 



```
### @CloudBlockBlob/setMetadata.m
```notalanguage
  SETMETADATA Sets the metadata for the blob
  Key Value pairs in char vector format can be passed as an individual pair or
  as containers.Map containing multiple Key Value pairs.



```
### @CloudBlockBlob/upload.m
```notalanguage
  UPLOAD Method to upload CloudBlockBlob(s) to WASB
  This method will upload the current CloudBlockBlob reference(s) to WASB. When
  uploading the data to a container, first create a blob handle (merely a
  reference) and then upload. The upload 'path/location' in Azure is set in
  the Container not the CloudBlockBlob, which only sets the name.
 
     blob = azContainer.getBlockBlobReference(which('SampleData.mat'));
     blob.upload();
 
  This file is now available on the WASB service. The upload mechanism is
  vectorized. A cell array of files to upload can be passed at once.
  For example, to upload a directory of files:
 
     % Get a list of files
     dirContents = dir('*.m');
     filesToUpload = {dirContents.name};
     blobs = azContainer.getBlockBlobReference(filesToUpload);
     blobs.upload;
     .................
 
  Dots are displayed as feedback for vectorized uploads if verbose logging is
  enabled.
 
  Unlike the Java Azure SDK the MATLAB Blob object stores the path of the local
  file for upload, this is set when the CloudBlockBlob is created. It is used at
  upload for the source file but the destination name the object is uploaded to
  is derived from the object Name value which is set when the MATLAB Blob object
  is constructed. These Names need not match and indeed generally do not as the
  local file object will contain path values that would not apply in WASB.
  One may commonly rely on the Container to provide the structure into which a
  Blob is uploaded using just it's file name as the Blob name, as set at Blob
  creation time.



```

------


## @SharedAccessBlobPermissions

### @SharedAccessBlobPermissions/SharedAccessBlobPermissions.m
```notalanguage
  SHAREDACCESSBLOBPERMISSIONS defines the various supported permissions
 
  Enumeration values are as follows:
 
  ADD    :  Specifies Add access granted
  CREATE :  Specifies Create access granted
  DELETE :  Specifies Delete access granted
  READ   :  Specifies Read access granted
  WRITE  :  Specifies Write access granted
  LIST   :  Specifies List access granted
            List is undocumented in the Java SDK version 8.0.0 and lower
            However it appears fully implemented in line with other languages
            and is required for use with CloudBlobContainers
 



```

------


## @SharedAccessBlobPolicy

### @SharedAccessBlobPolicy/SharedAccessBlobPolicy.m
```notalanguage
  SHAREDACCESSBLOBPOLICY class represent shared access policy parameters
  Represents a shared access policy, which specifies the start time, expiry
  time, and permissions for a shared access signature.
 
    myPolicy = azure.storage.blob.SharedAccessBlobPolicy;



```
### @SharedAccessBlobPolicy/getPermissions.m
```notalanguage
  GETPERMISSIONS Gets the permissions for a shared access signature policy
  An array of azure.storage.blob.SharedAccessAccountBlobPermissions
  enumerations are returned.
 
    % create a blob policy object
    myPolicy = azure.storage.blob.SharedAccessBlobPolicy();
    % add read and add privileges to that policy
    myPolicy.setPermissionsFromString('ra');
    % read back those permissions from the policy
    myEnumPerms = myPolicy.getPermissions
    x =
      1x2 SharedAccessBlobPermissions enumeration array
        READ    ADD
 



```
### @SharedAccessBlobPolicy/getSharedAccessExpiryTime.m
```notalanguage
  GETSHAREDACESSEXPIRYTIME Gets expiry time for shared access signatures
  The output time is of type datetime, expiryTime will be returned with a
  UTC time zone.
 
     % check the expiry time is greater than the current time
     t1 = myPolicy.getSharedAccessExpiryTime();
     t2 = datetime('now', 'TimeZone', 'UTC')
     if (t2 > t1)
         disp('Access period has expired');
     end
 



```
### @SharedAccessBlobPolicy/getSharedAccessStartTime.m
```notalanguage
  GETSHAREDACCESSSTARTTIME Gets start time for shared access signatures
  The output time is of type datetime, startTime will be returned with a
  UTC time zone.
 
     % get start time and compare with current time (UTC)
     t1 = myPolicy.getSharedAccessStartTime();
     t2 = datetime('now', 'TimeZone', 'UTC');
     if (t2 > t1)
        disp('Access period has started');
     end
 



```
### @SharedAccessBlobPolicy/permissionsToString.m
```notalanguage
  PERMISSIONSTOSTRING Converts policy permissions to a character vector
 
    permSet(1) = azure.storage.blob.SharedAccessBlobPermissions.ADD;
    permSet(2) = azure.storage.blob.SharedAccessBlobPermissions.READ;
    permSet(3) = azure.storage.blob.SharedAccessBlobPermissions.CREATE;
    myPolicy = azure.storage.blob.SharedAccessBlobPolicy();
    myPolicy.setPermissions(permSet);
    str = myPolicy.permissionsToString
    str =
        'rac'
 



```
### @SharedAccessBlobPolicy/setPermissions.m
```notalanguage
  SETPERMISSIONS Sets permissions for a shared access policy
  This policy is used for a Shared Access Signature. permSet
  should be an array of azure.storage.blob.SharedAccessBlobPermissions
  enumerations.
 
    % create an array of permissions enumerations
    permSet(1) = azure.storage.blob.SharedAccessBlobPermissions.ADD;
    permSet(2) = azure.storage.blob.SharedAccessBlobPermissions.READ;
    permSet(3) = azure.storage.blob.SharedAccessBlobPermissions.CREATE;
    % create a blob policy object
    myPolicy = azure.storage.blob.SharedAccessBlobPolicy();
    % set permissions on the policy
    myPolicy.setPermissions(permSet);
 



```
### @SharedAccessBlobPolicy/setPermissionsFromString.m
```notalanguage
  SETPERMISSIONSFROMSTRING Set permissions using specified character vector
  A String that represents the shared access permissions. The string must
  contain one or more of the following values.
 
  r: Read access
  a: Add access
  c: Create access
  w: Write access
  d: Delete access
  l: List access
 
    % create a blob policy object
    myPolicy = azure.storage.blob.SharedAccessBlobPolicy();
    % add read and add privileges to that policy
    myPolicy.setPermissionsFromString('ra');
 



```
### @SharedAccessBlobPolicy/setSharedAccessExpiryTime.m
```notalanguage
  SETSHAREDACCESSEXPIRYTIME Sets expiry time for shared access signatures
  The input time should be of type datetime
 
     % create a policy and apply an expiry time to it, in this case 24
     % hours from now
     myPolicy = azure.storage.blob.SharedAccessBlobPolicy();
     t = datetime('now');
     t = t + hours(24);
     myPolicy.setSharedAccessExpiryTime(t)
 



```
### @SharedAccessBlobPolicy/setSharedAccessStartTime.m
```notalanguage
  SETSHAREDACCESSSTARTTIME Sets start time for shared access signatures
  The input time should be of type datetime.
 
     % create a policy and set the time to the current time
     myPolicy = azure.storage.blob.SharedAccessBlobPolicy();
     t = datetime('now');
     myPolicy.setSharedAccessStartTime(t)
 
  Microsoft recommend that if setting the start time to the current time
  that this time be set 15 minutes early to allow clock variations
 
     t = datetime('now');
     t = t - minutes(15);
     myPolicy.setSharedAccessStartTime(t)



```

------


## @CloudTable

### @CloudTable/CloudTable.m
```notalanguage
  CLOUDTABLE Class to provide references to a table.
  The cloud table allows table level operations to create
  new tables, add/remove contents and change permissions.
 
      az = azure.storage.CloudStorageAccount;
      az.loadConfigurationSettings();
      az.connect();
 
      % Create a client Object
      azClient = azure.storage.table.CloudTableClient(az);
      tableH = azure.storage.table.CloudTable(Client,'MyTable');
 
  This table handle can be used to transact with the cloud-based
  table API. The name of the table can only be set at creation
  time. The name of a table must always be lowercase. Including
  an upper-case letter in a container name, it would violate the Azure
  container naming rules, and cause 400 errors (Bad Request). This
  object will convert the given name to lowercase.
 
  Alternatively one can construct a CloudTable using a StorageUri input.
  This is used if constructing a handle to Shared Access Signature (SAS),
  where the SAS URL is stored in the StorageUri.
 
       SASMatlabURI = matlab.net.URI('https://myaccount.table.core.windows.net/mbsampletable?sv=2017-04-17&si=myidentifer&tn=mbsampletable&sig=eaGeUXr4yMvww%2BVTL5zIAmhkdjYwhzBVSM7y%2FPX8bdI%3D');
       SASStorageURI = azure.storage.StorageUri(SASMatlabURI);
       tableHandle = azure.storage.table.CloudTable(SASStorageURI);
 



```
### @CloudTable/createIfNotExists.m
```notalanguage
  CREATEIFNOTEXISTS Method to create a table on the Blob Storage service
  The createIfNotExists method creates a table on the Table storage service.
 
    % Connect to the Cloud Storage account
    az = azure.storage.CloudStorageAccount;
    az.loadConfigurationSettings();
    az.connect();
 
    % Create a client Object
    client = azure.storage.table.CloudTableClient(az);
 
    % Create a blob container and name it.
    tableHandle = azure.storage.table.CloudTable(client,'MyTable');
    tableHandle.createIfNotExists();
 
  This functions returns true if table was created otherwise false



```
### @CloudTable/deleteIfExists.m
```notalanguage
  DELETEIFEXISTS Method to delete a table on the Blob Storage Service
  The deleteIfExists method deletes a table on the Blob storage service.
 
    % Connect to the Cloud Storage account
    az = azure.storage.CloudStorageAccount;
    az.loadConfigurationSettings();
    az.connect();
 
    % Create a client Object
    client = azure.storage.table.CloudTableClient(az);
 
    % Create a blob container and name it.
    tableHandle = azure.storage.table.CloudTable(client,'MyTable');
    tableHandle.deleteIfExists();
 
  This functions returns true if table was deleted otherwise false



```
### @CloudTable/execute.m
```notalanguage
  EXECUTE Method to execute a table operation on the Azure Table service
  Method to execute queries and operations on the Azure Table.



```
### @CloudTable/exists.m
```notalanguage
  EXISTS Method to check if a table exists
  Check if a table exists using this method. For example:
 
      % Connect to an Azure Cloud Storage Account
      az = azure.storage.CloudStorageAccount;
      az.loadConfigurationSettings();
      az.connect();
 
      % Create a client Object
      client = azure.storage.table.CloudTableClient(az);
      tableHandle = azure.storage.table.CloudTable(client,'MyTable');
 
      % Create a container for the blobs
      tableHandle.createIfNotExists();
 
      % Check if the container exists
      flag = container.exists();



```
### @CloudTable/generateSharedAccessSignature.m
```notalanguage
  GENERATESHAREDACCESSSIGNATURE Returns a policy string
  Returns a shared access signature for the table using the specified group
  policy identifier and operation context. Note this does not contain the
  leading "?".
 
    % First create a shared access policy, setting permissions and times
    myPolicy = azure.storage.table.SharedAccessTablePolicy();
    permSet(1) = azure.storage.table.SharedAccessTablePermissions.QUERY;
    myPolicy.setPermissions(permSet);
 
    % Allow access for the next 24 hours
    t1 = datetime('now');
    t2 = t1 + hours(24);
    myPolicy.setSharedAccessExpiryTime(t2);
 
    % Allow a margin of 15 minutes for clock variances
    t3 = t1 - minutes(15);
    myPolicy.setSharedAccessStartTime(t3);
 
    % Set row and partition restrictions
    accessPolicyIdentifier = 'myAccessPolicyIdentifier';
    startPartitionKey = 'Smith';
    startRowKey = 'John';
    endPartitionKey = 'Smith';
    endRowKey = 'John';
 
    % Generate the SAS, note the leading ? and URI are not included
    sas = tableHandle.generateSharedAccessSignature(myPolicy,accessPolicyIdentifier,startPartitionKey,startRowKey,endPartitionKey,endRowKey)
 
    sas =
 
       'sig=2wOZrXmqMQgJ6KPJXwCVK3D9hxpcY166eMJ8mxDBZdc%3D&st=2018-05-10T08%3A38%3A43Z&epk=Smith&se=2018-05-11T08%3A53%3A43Z&sv=2017-04-17&si=myAccessPolicyIdentifier&tn=sampletable&sp=r&srk=John&spk=Smith&erk=John'
 
    % build the full SAS
    myUri = tableHandle.getUri;
 
    fullSas = [char(myUri.EncodedURI),'?',sas]
 
    fullSas =
 
     'https://myaccount.table.core.windows.net/sampletable?sig=2wOZrXmqMQgJ6KPJXwCVK3D9hxpcY166eMJ8mxDBZdc%3D&st=2018-05-10T08%3A38%3A43Z&epk=Smith&se=2018-05-11T08%3A53%3A43Z&sv=2017-04-17&si=accessPolicyIdentifier&tn=sampletable&sp=r&srk=John&spk=Smith&erk=John'
 



```
### @CloudTable/getStorageUri.m
```notalanguage
  GETSTORAGEURI Returns the list of URIs for all locations
 



```
### @CloudTable/getUri.m
```notalanguage
  GETURI Returns the URI for this table
  The URI is returned as a matlab.net.URI, this may be used when
  constructing a shared access signature for example.
 
     % get the URI for a table
     mytable.getUri
     ans =
     URI with properties:
 
                 Scheme: "https"
               UserInfo: [0x0 string]
                   Host: "myaccount.table.core.windows.net"
                   Port: []
       EncodedAuthority: "myaccount.table.core.windows.net"
                   Path: [""    "mysampletable"]
            EncodedPath: "/mbsampletable"
                  Query: [0x0 matlab.net.QueryParameter]
           EncodedQuery: ""
               Fragment: [0x0 string]
               Absolute: 1
             EncodedURI: "https://myaccount.table.core.windows.net/mysampletable"
 



```
### @CloudTable/isValid.m
```notalanguage
  ISVALID Method to check if a given object is properly initialized
  This method tests if the object has been created and initialized
  correctly.
 
    az = azure.storage.CloudStorageAccount;
    az.loadConfigurationSettings();
    az.connect();
 
    client = azure.storage.table.CloudTable(az);
 
  The validity of the object is checked using:
    [FLAG] = client.isValid();



```

------


## @CloudTableClient

### @CloudTableClient/CloudTableClient.m
```notalanguage
  CLOUDTABLECLIENT Class to provide access to the cloud table client
  Creates a table client object for transacting with the Azure table storage.
 
      az = azure.storage.CloudStorageAccount;
      az.loadConfigurationSettings();
      az.connect();
 
      % Create a client Object
      client = azure.storage.table.CloudTableClient(az);
 



```
### @CloudTableClient/getTableReference.m
```notalanguage
  GETTABLEREFERENCE Method to create a reference to a Cloud Table
  This method will create handles to azure.storage.table.CloudTable objects in MATLAB
  that can be used to operate cloud based tables on the Microsoft Azure
  Storage system.
 
    tbl = tClient.getTableReference(tableName);
 
  For example:
 
    az = azure.storage.CloudStorageAccount;
    az.loadConfigurationSettings();
    az.connect();
    tClient = azure.storage.table.CloudTableClient(az);
    tbl = tClient.getTableReference('SampleTable');
 
  The table name needs to be a fully qualified string that conforms to the
  Azure naming conventions.



```
### @CloudTableClient/isValid.m
```notalanguage
  ISVALID Method to check if a given object is properly initialized
  This method tests if the object has been created correctly.
 
    az = azure.storage.CloudStorageAccount;
    az.loadConfigurationSettings();
    az.connect();
 
    client = azure.storage.table.CloudTableClient(az);
 
  The validity of the object is checked using:
    [FLAG] = client.isValid();



```
### @CloudTableClient/listTables.m
```notalanguage
  LISTTABLES Method to list all the available tables
  List all available tables for the given client
 
      % Connect to the service
      az = azure.storage.CloudStorageAccount;
      az.loadConfigurationSettings();
      az.connect();
 
      % Create a client Object
      client = azure.storage.table.CloudTableClient(az);
 
      % List all tables
      azTables = client.listTables();
      tableNames = {azTables.Name};



```

------


## @DynamicTableEntity

### @DynamicTableEntity/DynamicTableEntity.m
```notalanguage
  DYNAMICTABLEENTITY Dynamic Table Entity for use with the Table Operations
  This class specifies the entity that is used in the TableOperations with
  the Azure table storage.
 
  For details of mapping of MATLAB datatype to Table Properties see
  the TableResult class documentation.



```
### @DynamicTableEntity/getTotalEntitySize.m
```notalanguage
  GETTOTALENTITYSIZE Method to return the size of the payload for the entity
  Use this method to calculate the size of the property
 
  For example:
      % Create a batch of 100 entities
      batchSize = 100;
      for bCount = 1:batchSize
          dynamicEntity(bCount) = azure.storage.table.DynamicTableEntity;
          dynamicEntity(bCount).addprop('Name');
          dynamicEntity(bCount).Name = ['john',num2str(bCount)];
          dynamicEntity(bCount).partitionKey = 'pk';
          dynamicEntity(bCount).rowKey = ['rk',num2str(bCount),datestr(now)];
          dynamicEntity(bCount).initialize();
      end
 
  Compute the size of the payload using:
 
      dynamicEntity.getTotalSize();
 



```
### @DynamicTableEntity/table.m
```notalanguage
  TABLE Method to cast a Dynamic Table Entity into a MATLAB table
  Converts the result into a table with the appropriate types. This method
  removes the handle from the DynamicTableEntity.



```

------


## @QueryComparisons

### @QueryComparisons/QueryComparisons.m
```notalanguage
  QUERYCOMPARISONS Enumerations for the different query comparisons
  The query comparison enumerations are used to construct filter
  conditions.
 
  Example:
    queryCondition = azure.storage.table.QueryComparison;
 



```

------


## @SharedAccessTablePermissions

### @SharedAccessTablePermissions/SharedAccessTablePermissions.m
```notalanguage
  SHAREDACCESSTABLEPERMISSIONS defines the various supported permissions
 
  Enumeration values are as follows:
 
  ADD    :  Permission to add entities granted
  DELETE :  Permission to delete entities granted
  NONE   :  No shared access granted
  QUERY  :  Permission to query entities granted
  UPDATE :  Permission to modify entities granted
 



```

------


## @SharedAccessTablePolicy

### @SharedAccessTablePolicy/SharedAccessTablePolicy.m
```notalanguage
  SHAREDACCESSTABLEPOLICY class represent shared access policy parameters
  Represents a shared access policy, which specifies the start time, expiry
  time, and permissions for a shared access signature.
 
    myPolicy = azure.storage.table.SharedAccessTablePolicy;
 



```
### @SharedAccessTablePolicy/getPermissions.m
```notalanguage
  GETPERMISSIONS Gets the permissions for a shared access signature policy
  An array of azure.storage.table.SharedAccessAccountTablePermissions
  enumerations are returned.
 
    % create a table policy object
    myPolicy = azure.storage.table.SharedAccessTablePolicy();
    % add query and add privileges to that policy
    myPolicy.setPermissionsFromString('ra');
    % read back those permissions from the policy
    myEnumPerms = myPolicy.getPermissions
    x =
      1x2 SharedAccessTablePermissions enumeration array
        QUERY    ADD
 



```
### @SharedAccessTablePolicy/getSharedAccessExpiryTime.m
```notalanguage
  GETSHAREDACESSEXPIRYTIME Gets expiry time for shared access signatures
  The output time is of type datetime, expiryTime will be returned with a
  UTC time zone.
 
     % set the time to the current time and read it back
     t1 = myPolicy.getSharedAccessStartTime();
     t2 = datetime('now', 'TimeZone', 'UTC')
     if (t1 > t2)
         disp('Access period has expired');
     end



```
### @SharedAccessTablePolicy/getSharedAccessStartTime.m
```notalanguage
  GETSHAREDACCESSSTARTTIME Gets start time for shared access signatures
  The output time is of type datetime, startTime will be returned with a
  UTC time zone.
 
     % get start time and compare with current time (UTC)
     t1 = myPolicy.getSharedAccessStartTime();
     t2 = datetime('now', 'TimeZone', 'UTC');
     if (t2 > t1)
        disp('Access period has started');
     end



```
### @SharedAccessTablePolicy/permissionsToString.m
```notalanguage
  PERMISSIONSTOSTRING Converts policy permissions to a character vector
 
    permSet(1) = azure.storage.table.SharedAccessTablePermissions.QUERY;
    permSet(2) = azure.storage.table.SharedAccessTablePermissions.ADD;
    permSet(3) = azure.storage.table.SharedAccessTablePermissions.DELETE;
    myPolicy = azure.storage.table.SharedAccessTablePolicy();
    myPolicy.setPermissions(permSet);
    str = myPolicy.permissionsToString
    str =
        'rad'
 



```
### @SharedAccessTablePolicy/setPermissions.m
```notalanguage
  SETPERMISSIONS Sets permissions for a shared access policy
  This policy is used for a Shared Access Signature. permSet
  should be an array of azure.storage.table.SharedAccessTablePermissions
  enumerations.



```
### @SharedAccessTablePolicy/setPermissionsFromString.m
```notalanguage
  SETPERMISSIONSFROMSTRING Set permissions using specified character vector
  A String that represents the shared access permissions. The string must
  contain one or more of the following values, and the order that they are
  specified must be in the order of "raud".
  r: Query access
  a: Add access
  u: Update access
  d: Delete access
 
    % create a table policy object
    myPolicy = azure.storage.table.SharedAccessTablePolicy();
    % add read and add privilages to that policy
    myPolicy.setPermissionsFromString('ra');
 



```
### @SharedAccessTablePolicy/setSharedAccessExpiryTime.m
```notalanguage
  SETSHAREDACCESSEXPIRYTIME Sets expiry time for shared access signatures
  The input time should be of type datetime.
 
     % create a policy and apply an expiry time to it, in this case 24
     % hours from now
     myPolicy = azure.storage.table.SharedAccessTablePolicy();
     t = datetime('now');
     t = t + hours(24);
     myPolicy.setSharedAccessExpiryTime(t)
 



```
### @SharedAccessTablePolicy/setSharedAccessStartTime.m
```notalanguage
  SETSHAREDACCESSSTARTTIME Sets start time for shared access signatures
  The input time should be of type datetime.
 
     % create a policy and set the time to the current time
     myPolicy = azure.storage.table.SharedAccessTablePolicy();
     t = datetime('now');
     myPolicy.setSharedAccessStartTime(t)
 
  Microsoft recommend that if setting the start time to the current time
  that this time be set 15 minutes early to allow clock variations
 
     t = datetime('now');
     t = t - minutes(15);
     myPolicy.setSharedAccessStartTime(t)



```

------


## @TableOperation

### @TableOperation/TableOperation.m
```notalanguage
  TABLEOPERATION Class to perform a single operation on the Azure Cloud Table
 
  This class can be used to perform operations on tables that insert,
  update, merge, delete, replace or retrieve table entities. To execute
  a TableOperation instance, call the execute method on a CloudTableClient
  instance. A TableOperation may be executed directly or as part of a
  TableBatchOperation.
 
  If a TableOperation returns an entity result, it is stored in the
  corresponding TableResult returned by the execute method.



```
### @TableOperation/delete.m
```notalanguage
  DELETE Method to delete a table entity
  This method will use either a TableOperation or a TableBatchOperation to
  delete the elements in a table.
 
  Example:
      % Connect to an Azure Cloud Storage Account
      az = azure.storage.CloudStorageAccount;
      az.loadConfigurationSettings();
      az.connect();
 
      % Create a client Object
      client = azure.storage.table.CloudTableClient(az);
      tableHandle = azure.storage.table.CloudTable(client,'TestTable');
 
      % Create a table
      tableHandle.createIfNotExists();
 
      % Check if the table exists
      flag = tableHandle.exists();
      testCase.assertTrue(flag);
 
      % Create a number of sample entities and insert into the database
      % 100 is a hard limit (see notes below)
 
      batchSize = 100;
      for bCount = 1:batchSize
          dynamicEntity(bCount) = azure.storage.table.DynamicTableEntity;
          dynamicEntity(bCount).addprop('Name');
          dynamicEntity(bCount).Name = ['john',num2str(bCount)];
          dynamicEntity(bCount).partitionKey = 'pk';
          dynamicEntity(bCount).rowKey = ['rk',num2str(bCount),datestr(now)];
          dynamicEntity(bCount).initialize();
      end
 
      % Create a table operation to execute on the database
      tableOperation = azure.storage.table.TableOperation.delete(dynamicEntity); % vectorized
      tableHandle.execute(tableOperation);
 
  Notes:
 
  The following limitations are imposed by the service:
 
  * All entities subject to operations as part of the transaction must
    have the same PartitionKey value.
 
  * An entity can appear only once in the transaction, and only one
    operation may be performed against it.
 
  * The transaction can include at most 100 entities, and its total payload
    may be no more than 4 MB in size.
 
  * All entities are subject to the limitations described in Understanding
    the Table Service Data Model as described at:
    https://msdn.microsoft.com/en-us/library/azure/dd179338.aspx



```
### @TableOperation/insert.m
```notalanguage
  INSERT Method to insert a table entity
  This method will use either a TableOperation or a TableBatchOperation to
  insert the elements into the table. An additional flag defines whether the
  API should echo the inserted entity.
 
  Example:
      % Connect to an Azure Cloud Storage Account
      az = azure.storage.CloudStorageAccount;
      az.loadConfigurationSettings();
      az.connect();
 
      % Create a client Object
      client = azure.storage.table.CloudTableClient(az);
      tableHandle = azure.storage.table.CloudTable(client,'TestTable');
 
      % Create a table
      tableHandle.createIfNotExists();
 
      % Check if the table exists
      flag = tableHandle.exists();
      testCase.assertTrue(flag);
 
 
      % Create a number of sample entities and insert into the database
      % 100 is a hard limit (see notes below)
 
      batchSize = 100;
      for bCount = 1:batchSize
          dynamicEntity(bCount) = azure.storage.table.DynamicTableEntity;
          dynamicEntity(bCount).addprop('Name');
          dynamicEntity(bCount).Name = ['john',num2str(bCount)];
          dynamicEntity(bCount).partitionKey = 'pk';
          dynamicEntity(bCount).rowKey = ['rk',num2str(bCount),datestr(now)];
          dynamicEntity(bCount).initialize();
      end
 
      % Create a table operation to execute on the database
      tableOperation = azure.storage.table.TableOperation.insert(dynamicEntity, false); % vectorized
      tableHandle.execute(tableOperation);
 
  Notes:
 
  The following limitations are imposed by the service:
 
  * All entities subject to operations as part of the transaction must
    have the same PartitionKey value.
 
  * An entity can appear only once in the transaction, and only one
    operation may be performed against it.
 
  * The transaction can include at most 100 entities, and its total payload
    may be no more than 4 MB in size.
 
  * All entities are subject to the limitations described in Understanding
    the Table Service Data Model as described at:
    https://msdn.microsoft.com/en-us/library/azure/dd179338.aspx



```
### @TableOperation/insertOrMerge.m
```notalanguage
  INSERTORMERGE Method to insert or merge an existing entity
  This method will use either a TableOperation or a TableBatchOperation to
  insert the elements into the table.
 
  Example:
      % Connect to an Azure Cloud Storage Account
      az = azure.storage.CloudStorageAccount;
      az.loadConfigurationSettings();
      az.connect();
 
      % Create a client Object
      client = azure.storage.table.CloudTableClient(az);
      tableHandle = azure.storage.table.CloudTable(client,'TestTable');
 
      % Create a table
      tableHandle.createIfNotExists();
 
      % Check if the table exists
      flag = tableHandle.exists();
      testCase.assertTrue(flag);
 
 
      % Create a number of sample entities and insert into the database
      % 100 is a hard limit (see notes below)
 
      batchSize = 100;
      for bCount = 1:batchSize
          dynamicEntity(bCount) = azure.storage.table.DynamicTableEntity;
          dynamicEntity(bCount).addprop('Name');
          dynamicEntity(bCount).Name = ['john',num2str(bCount)];
          dynamicEntity(bCount).partitionKey = 'pk';
          dynamicEntity(bCount).rowKey = ['rk',num2str(bCount),datestr(now)];
          dynamicEntity(bCount).initialize();
      end
 
      % Create a table operation to execute on the database
      tableOperation = azure.storage.table.TableOperation.insertOrMerge(dynamicEntity); % vectorized
      tableHandle.execute(tableOperation);
 
  Notes:
 
  The following limitations are imposed by the service:
 
  * All entities subject to operations as part of the transaction must
    have the same PartitionKey value.
 
  * An entity can appear only once in the transaction, and only one
    operation may be performed against it.
 
  * The transaction can include at most 100 entities, and its total payload
    may be no more than 4 MB in size.
 
  * All entities are subject to the limitations described in Understanding
    the Table Service Data Model as described at:
    https://msdn.microsoft.com/en-us/library/azure/dd179338.aspx



```
### @TableOperation/insertOrReplace.m
```notalanguage
  INSERTORREPLACE Method to insert the table entity into the Table
  This method will use either a TableOperation or a TableBatchOperation to
  insert the elements into the table.
 
  Example:
      % Connect to an Azure Cloud Storage Account
      az = azure.storage.CloudStorageAccount;
      az.loadConfigurationSettings();
      az.connect();
 
      % Create a client Object
      client = azure.storage.table.CloudTableClient(az);
      tableHandle = azure.storage.table.CloudTable(client,'TestTable');
 
      % Create a table
      tableHandle.createIfNotExists();
 
      % Check if the table exists
      flag = tableHandle.exists();
      testCase.assertTrue(flag);
 
 
      % Create a number of sample entities and insert into the database
      % 100 is a hard limit (see notes below)
 
      batchSize = 100;
      for bCount = 1:batchSize
          dynamicEntity(bCount) = azure.storage.table.DynamicTableEntity;
          dynamicEntity(bCount).addprop('Name');
          dynamicEntity(bCount).Name = ['john',num2str(bCount)];
          dynamicEntity(bCount).partitionKey = 'pk';
          dynamicEntity(bCount).rowKey = ['rk',num2str(bCount),datestr(now)];
          dynamicEntity(bCount).initialize();
      end
 
      % Create a table operation to execute on the database
      tableOperation = azure.storage.table.TableOperation.insertOrReplace(dynamicEntity); % vectorized
      tableHandle.execute(tableOperation);
 
  Notes:
 
  The following limitations are imposed by the service:
 
  * All entities subject to operations as part of the transaction must
    have the same PartitionKey value.
 
  * An entity can appear only once in the transaction, and only one
    operation may be performed against it.
 
  * The transaction can include at most 100 entities, and its total payload
    may be no more than 4 MB in size.
 
  * All entities are subject to the limitations described in Understanding
    the Table Service Data Model as described at:
    https://msdn.microsoft.com/en-us/library/azure/dd179338.aspx



```
### @TableOperation/merge.m
```notalanguage
  MERGE Method to merge a table entity
  This method will use either a TableOperation or a TableBatchOperation to
  merge elements the elements into the table.
 
  Example:
      % Connect to an Azure Cloud Storage Account
      az = azure.storage.CloudStorageAccount;
      az.loadConfigurationSettings();
      az.connect();
 
      % Create a client Object
      client = azure.storage.table.CloudTableClient(az);
      tableHandle = azure.storage.table.CloudTable(client,'TestTable');
 
      % Create a table
      tableHandle.createIfNotExists();
 
      % Check if the table exists
      flag = tableHandle.exists();
      testCase.assertTrue(flag);
 
      % Create a number of sample entities and insert into the database
      % 100 is a hard limit (see notes below)
 
      batchSize = 100;
      for bCount = 1:batchSize
          dynamicEntity(bCount) = azure.storage.table.DynamicTableEntity;
          dynamicEntity(bCount).addprop('Name');
          dynamicEntity(bCount).Name = ['john',num2str(bCount)];
          dynamicEntity(bCount).partitionKey = 'pk';
          dynamicEntity(bCount).rowKey = ['rk',num2str(bCount),datestr(now)];
          dynamicEntity(bCount).initialize();
      end
 
      % Create a table operation to execute on the database
      tableOperation = azure.storage.table.TableOperation.merge(dynamicEntity);
      tableHandle.execute(tableOperation);
 
  Notes:
 
  The following limitations are imposed by the service:
 
  * All entities subject to operations as part of the transaction must
    have the same PartitionKey value.
 
  * An entity can appear only once in the transaction, and only one
    operation may be performed against it.
 
  * The transaction can include at most 100 entities, and its total payload
    may be no more than 4 MB in size.
 
  * All entities are subject to the limitations described in Understanding
    the Table Service Data Model as described at:
    https://msdn.microsoft.com/en-us/library/azure/dd179338.aspx



```
### @TableOperation/replace.m
```notalanguage
  REPLACE Method to replace a given table entity
  This method will use either a TableOperation or a TableBatchOperation to
  replace elements into the table.
 
  Example:
      % Connect to an Azure Cloud Storage Account
      az = azure.storage.CloudStorageAccount;
      az.loadConfigurationSettings();
      az.connect();
 
      % Create a client Object
      client = azure.storage.table.CloudTableClient(az);
      tableHandle = azure.storage.table..CloudTable(client,'TestTable');
 
      % Create a table
      tableHandle.createIfNotExists();
 
      % Check if the table exists
      flag = tableHandle.exists();
      testCase.assertTrue(flag);
 
      % Create a number of sample entities and insert into the database
      % 100 is a hard limit (see notes below)
 
      batchSize = 100;
      for bCount = 1:batchSize
          dynamicEntity(bCount) = azure.storage.table.DynamicTableEntity;
          dynamicEntity(bCount).addprop('Name');
          dynamicEntity(bCount).Name = ['john',num2str(bCount)];
          dynamicEntity(bCount).partitionKey = 'pk';
          dynamicEntity(bCount).rowKey = ['rk',num2str(bCount),datestr(now)];
          dynamicEntity(bCount).initialize();
      end
 
      % Create a table operation to execute on the database
      tableOperation = azure.storage.table.TableOperation.replace(dynamicEntity);
      tableHandle.execute(tableOperation);
 
  Notes:
 
  The following limitations are imposed by the service:
 
  * All entities subject to operations as part of the transaction must
    have the same PartitionKey value.
 
  * An entity can appear only once in the transaction, and only one
    operation may be performed against it.
 
  * The transaction can include at most 100 entities, and its total payload
    may be no more than 4 MB in size.
 
  * All entities are subject to the limitations described in Understanding
    the Table Service Data Model as described at:
    https://msdn.microsoft.com/en-us/library/azure/dd179338.aspx



```
### @TableOperation/retrieve.m
```notalanguage
  RETRIEVE Method to retrieve a table entity



```

------


## @TableQuery

### @TableQuery/TableQuery.m
```notalanguage
  TABLEQUERY Represents a query against a given table



```
### @TableQuery/where.m
```notalanguage
  WHERE Method to define the filter expression for the table query



```

------


## @TableResult

### @TableResult/TableResult.m
```notalanguage
  TABLERESULT provides an abstraction over the Azure Table Result
  EdmTypes are mapped to and from MATLAB data types as follows:
    Edm.Boolean    - logical
    Edm.Binary     - uint8
    Edm.DateTime   - datetime
    Edm.Double     - double
    Edm.Guid       - char vector (16 bytes)
    Edm.Int16      - int32
    Edm.Int32      - int32
    Edm.Int64      - int64
    Null           - logical (empty)
    Edm.String     - char vector
 
  Other Edm types e.g. Edm.Decimal are not currently support by the
  underlying Azure Java libraries.
 
  A null entity should not be returned as Azure Table does not persist them.
  If a null entity value is returned an empty array of the corresponding
  type is returned. In the case of a datetime a NaT is returned.
  Null entities cannot be created using this interface however empty
  string and character values can be used.
 
  The following Microsoft comment describes this further:
   "The Table service does not persist null values for properties. When
    querying entities, the above property types are all non-nullable. When
    writing entities, the above property types are all nullable, and any
    property with a null value is handled as if the payload did not contain
    that property."
 
  For further information see:
  https://docs.microsoft.com/en-us/rest/api/storageservices/Understanding-the-Table-Service-Data-Model
 
  A char array will be stored in concatenated form and returned as a
  char vector.
  string arrays are not supported by the Azure Table API.
  datetime values must be scalar and not empty.
  Vectors are only supported for chars and uint8.



```

------

## Misc. Related Functions
### functions/AzureShell.m
```notalanguage
  AZURESHELL Invokes the Azure Web Browser based shell
  Cloud Shell enables access to a browser-based command-line experience with
  Azure. It is an interactive, browser-accessible shell for managing Azure
  resources. The shell can be Bash or PowerShell. The system configured browser
  is used. Authentication will be requested if not already in place within the
  browser.



```
### functions/AzureStorageExplorer.m
```notalanguage
  AZURESTORAGEEXPLORER Invokes the Azure Storage Explorer
  Brings up the Azure Storage Explorer. It is possible to specify the local
  installation of the storage explorer in the configuration file.
 
  Sample json configuration file:
  {
     "DefaultEndpointsProtocol" : "https",
     "AccountKey" : "SVn<MYACCOUNTKEY>0GGw==",
     "UseDevelopmentStorage" : "false",
     "AccountName" : "myaccountname"
     "LocalPathToStorageExplorer" : "C:\\Program Files (x86)\\Microsoft Azure Storage Explorer\\StorageExplorer.exe"
  }
 
  By default the MATLAB path will be searched for a configuration file called
  cloudstorageaccount.json, however an alternative filename can be provided as
  an argument to this function.



```
### functions/Logger.m
```notalanguage
  Logger - Object definition for Logger
  ---------------------------------------------------------------------
  Abstract: A logger object to encapsulate logging and debugging
            messages for a MATLAB application.
 
  Syntax:
            logObj = Logger.getLogger();
 
  Logger Properties:
 
      LogFileLevel - The level of log messages that will be saved to the
      log file
 
      DisplayLevel - The level of log messages that will be displayed
      in the command window
 
      LogFile - The file name or path to the log file. If empty,
      nothing will be logged to file.
 
      Messages - Structure array containing log messages
 
  Logger Methods:
 
      clearMessages(obj) - Clears the log messages currently stored in
      the Logger object
 
      clearLogFile(obj) - Clears the log messages currently stored in
      the log file
 
      write(obj,Level,MessageText) - Writes a message to the log
 
  Examples:
      logObj = Logger.getLogger();
      write(logObj,'warning','My warning message')
 



```
### functions/azRoot.m
```notalanguage
  AZROOT Helper function to locate the Azure interface package.
 
  Locate the installation of the Azure interface package to allow easier construction
  of absolute paths to the required dependencies.



```



------------    

[//]: # (Copyright 2019 The MathWorks, Inc.)
