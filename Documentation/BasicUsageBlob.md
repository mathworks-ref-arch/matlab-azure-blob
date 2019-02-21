# Basic Usage of Blob Storage

## Getting Started
Azure™ Blob storage is a service for storing large amounts of unstructured object data, such as text or binary data, that can be accessed from anywhere in the world via HTTP or HTTPS. Blob storage can be used to expose data publicly to the world, or to store application data privately.

Common uses of Blob storage include:
- Serving images or documents directly to a browser
- Storing files for distributed access
- Streaming video and audio
- Storing data for backup and restore, disaster recovery, and archiving
- Storing data for analysis by an on-premises or Azure-hosted service

### Blob Storage concepts
The Blob service contains the following components:

![Blob1](Images/Blob1.png)

*Storage Account*: All access to Azure Storage originates with a storage account. A storage account can be a general-purpose storage account or a blob storage account which is specialized for storing objects/blobs.

*Container*: A container provides a grouping of a set of blobs. All blobs must be in a container. An account can contain an unlimited number of containers. A container can store an unlimited number of blobs. Note that the container name must be lowercase.

*Blob*: A file of any type and size. Azure Storage offers three types of blobs: block blobs, page blobs, and append blobs.

Block blobs are ideal for storing text or binary files, such as documents and media files. Append blobs are similar to block blobs in that they are made up of blocks, but they are optimized for append operations, so they are useful for logging scenarios. A single block blob or append blob can contain up to 50,000 blocks of up to 4 MB each, for a total size of slightly more than 195 GB (4 MB X 50,000).

Page blobs can be up to 1TB in size, and are more efficient for frequent read/write operations. Azure Virtual Machines use page blobs as OS and data disks. Page Blobs are not currently supported by this package.

A good introduction to WASB can be found here:    
* [https://docs.microsoft.com/en-us/azure/storage/common/storage-introduction](https://docs.microsoft.com/en-us/azure/storage/common/storage-introduction)    

For more information on blobs see:    
* [https://docs.microsoft.com/en-us/azure/storage/blobs/storage-blobs-introduction](https://docs.microsoft.com/en-us/azure/storage/blobs/storage-blobs-introduction)

## The MATLAB Interface for Windows Azure Storage Blob
This package is used to enable the use of the Azure Table Storage service with MATLAB®. In the Software/MATLAB directory run the *startup.m* to make the software available in the MATLAB environment.

### Create and configure a storage account
If this is the first time using the interface, as a one-time operation per session (assuming only one storage account is in use), setup the the Cloud Storage Account. This is done using:
```
% Create a handle to the storage account
az = azure.storage.CloudStorageAccount;
```

The storage account will need to be configured to work with an Azure account or the development emulator. By default the UseDevelopmentStorage flag is set to *true* and so the emulator running on localhost will be used. For details of the development emulator see here: [https://docs.microsoft.com/en-us/azure/storage/storage-use-emulator](https://docs.microsoft.com/en-us/azure/storage/storage-use-emulator). To use Azure itself, disable this setting as follows:
```
az.UseDevelopmentStorage = false;
```

The Azure environment being connected to may well to be configured to support only https based access, this is enabled as follows:
```
az.DefaultEndpointsProtocol = 'https';
```

Specify the following credentials for the Azure storage account of choice. The AccountName value is the name of the storage account to access and the AccountKey is the associated Key. In the Azure portal select the Storage account then Settings then AccessKeys and then the Key. Normally the *Key1* value is used.
```
az.AccountName = 'myaccountname'
az.AccountKey  = 'SVn445qMEABafld3k225l*****[REDACTED_FOR_SECURITY]****RfIhAQtvYzAQr0328/d030GGw=='
```

This can be provisioned in the [Azure Portal<sup>1</sup>](https://portal.azure.com):

![Portal](Images/AzureStorageKeys.png)

Rather than configuring the storage account credentials in code which requires the sensitive account key to be embedded in code it and other related settings can be loaded from a file which is more readily protected.
```
az.loadConfigurationSettings();
```
Storing the settings in a file also allows for more simple management of multiple storage accounts. The file is a short json file stored in the *Software/MATLAB/config* directory by default, the template for which is as follows:
```
{
	"DefaultEndpointsProtocol" : "https",
	"AccountKey" : "SVn<MYACCOUNTKEY>0GGw==",
	"UseDevelopmentStorage" : "false",
	"AccountName" : "myaccountname"
	"LocalPathToStorageExplorer" : "C:\\Program Files (x86)\\Microsoft Azure Storage Explorer\\StorageExplorer.exe"
}
```
By default a configuration file named *credentials.json* on the MATLAB path is searched for. An alternate filename can be passed as an argument to *loadConfigurationSettings()*. This can be useful if more than one account is needed at the same time for example if one file corresponds to a Cosmos DB account and another for blob storage.
```
az.loadConfigurationSettings('myBlobStorageAccount.json');
```

The CloudStorageAccount is now ready to connect. When fully configured this looks like:
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
Note, the storage account key is similar to the root password for the storage account. Always be careful to protect the account key. Avoid distributing it to other users, hard-coding it, or saving it anywhere in plain text that is accessible to others. Regenerate the account key using the Azure portal if may have been compromised.


### Create a Client
With a fully configured connection get a handle to a client that allows uploading and downloading of data from the blob storage.
```
azClient = azure.storage.blob.CloudBlobClient(az)

azClient =
  CloudBlobClient with properties:
    DirectoryDelimiter: '/'
```
Windows Azure blob storage can now be accessed from MATLAB. Shown below are a few of the common operations for the Blob Storage service.

See [Logging](Logging.md) for details of enabling verbose output during development and testing.

### Create a container
It is possible to create a container for the configured client as follows:
```
azContainer = azure.storage.blob.CloudBlobContainer(azClient,'testcontainer');
azContainer.createIfNotExists()

ans =

  logical

   1
```
Idiomatically the more normal way to create a container is as follows:
```
azContainer = azClient.getContainerReference('testcontainer');
azContainer.createIfNotExists();
```


### List existing containers
This operation lists all existing containers in the storage account by returning an array of MATLAB objects.
```
containers = azClient.listContainers()

containers =

  CloudBlobContainer with properties:

    Parent: [1x1  azure.storage.blob.CloudBlobClient]
      Name: "testcontainer"
```
List the names of the containers as follows:
```
containerNames = {containers.Name};
```

### Configure container permissions
To configure a container for public access set the permissions on a container (which is set to private by default) to allow public, read-only access for all users on the Internet. Public permissions can be set on per-container, or per-blob or set to OFF. To do this, create a permission object and *upload* it to the appropriate container.

```
perm = azure.storage.blob.BlobContainerPermissions;
% Set one of the below as appropriate
perm.AccessType = 'BLOB'; % Blob level public access
perm.AccessType = 'CONTAINER';  % Container-level public access
perm.AccessType = 'OFF';        % Turn off public access
```
The permission set can then be uploaded to a container using:
```
azContainer.uploadPermissions(perm);
```
This change is reflected in the Access Policy for the given container<sup>1</sup>:

![Permissions](Images/permissions.png)

### Uploading a blob into a container
Blobs can be content of any nature. To generate some data in MATLAB and save it to newly created container as follows:
```
sampleData = rand(1000,1000);    % Approx 7MB
save SampleData sampleData;
```
Uploading the data to a previously created container, create a blob handle (merely a reference) and upload.
```
blob = azContainer.getBlockBlobReference(which('SampleData.mat'));
blob.upload();
```
This file is now available on the Windows Azure Blob Storage service.

To upload with an alternate name, for example one containing virtual directories, do as follows<sup>1</sup>:
```
blob = azContainer.getBlockBlobReference('SampleData.mat', 'mydir1/mydir2/mynewfilname.mat');
blob.upload();
```


![StorageBlob](Images/SampleStorage.png)

The upload mechanism is vectorized. It is possible to pass a full cell array of files to upload and upload it once. For example, to upload a directory of files:
```
% Get a list of files
dirContents = dir('*.m');
filesToUpload = {dirContents.name};
blobs = azContainer.getBlockBlobReference(filesToUpload);
blobs.upload;
.................
```
A simple progress bar is implemented with each "." representing a single file passed to the service, if verbose logging is enabled when uploading multiple blobs.


## Saving variables directly to a blob

save() will save variables to a .mat (or other supported format) file on WASB. It can be used very much like the functional form of the built-in save command with three caveats:
* The '-append' option is not supported.
* An entire workspace cannot be saved i.e. azContainer.save('mymatblob.mat') because the Azure WASB objects are not serializable. The workspace variables of interest should be listed explicitly to overcome this.
* Only the formal functional form interface, i.e. save(<my-arguments>), is supported.

```
x = rand(10);
y = rand(10);
azContainer.save('mymatblob.mat', 'x', 'y');
```
Save will overwrite blobs and create parent virtual directories if required.


### List all blobs in a container
It is possible to list all the blobs in a container. The resulting cell array of blobs
are of type CloudBlockBlob and CloudBlobDirectory and can be used to manipulate the blob. For example:
```
blobList = azContainer.listBlobs()

blobList =

  1x2 cell array

    {1x1 azure.storage.blob.CloudBlockBlob}    {1x1 azure.storage.blob.CloudBlockBlob}
```

Each of these blobs has a Name property that can be used to describe the contents of the blob:
```
myName = blobList{1}.Name

myName =

    'SampleData1.mat'
```

### Download a blob from a container
The output of listBlobs, as above, is a cell array that may contain CloudBlockBlobs or CloudBlobDirectories, hence it is returned as a cell array. Thus to act on the cell array, for example to download the CloudBlockBlobs, it is simplest to iterate through it as follows:
```
for n=1:numel(blobList)
  if isa(blobList{n}, azure.storage.blob.CloudBlockBlob)
    blobList{n}.download()
  end
end
```

An optional argument to download allows specification of the download location, in this case the <current directory>/tmp, otherwise the current directory is used.
```
blobList{n}.download(fullfile(pwd,'tmp',filesep))
```
If the destination is a directory rather than a file then a trailing file separator is required.

If an array of only CloudBlockBlobs is built then a vectorized download can be called:
```
blockBlobArray.download()
.....
```

To download a blob called SampleData.mat from the container azContainer to the directory */tmp/mydownloads/*, while not retaining virtual hierarchy and using use the name SampleData.mat, note the trailing delimiter following *mydownloads/*.
```
blob = azure.storage.blob.CloudBlockBlob(azContainer, 'mydir1/SampleData.mat');
blob.download('/tmp/mydownloads/');
```

Download a blob called SampleData.mat from the container azContainer to the current working directory but retain the mydir1/mydir2 directory hierarchy
```
blob = azure.storage.blob.CloudBlockBlob(azContainer, 'mydir1/mydir2/SampleData.mat');
blob.download('useVirtualDirectory',true);
```

## Retrieving variables directly from a blob

The load function loads variables from an Azure WASB blob into a struct. Load can be used very much like the functional form of the built-in load command.
```
myVars = azContainer.load('mymatblob.mat');
```

Alternatively load specific variables as follows:
```
myVars = azContainer.load('mymatblob.mat', 'x', 'y');
```
Note, as the entire mat file must be downloaded from WASB in each case, the latter approach may not save a significant amount of time.


### Delete a blob from a container
A method is provided to delete a blob from a container. In this case the cell array element blobList{n} must be of type azure.storage.blob.CloudBlockBlob.
```
blobList{n}.deleteIfExists();
```

If an array of CloudBlockBlobs is provided it can be invoked in vectorized form:

```
blockBlobArray.deleteIfExists()

.....

ans =

  5x1 logical array

   1
   1
   1
   1
   1

```

### Delete a container
Deleting a container will delete the container and all its contents.
```
azContainer.deleteIfExists();
```

### Working with a Virtual Directory
WASB is an object store rather than a conventional filesystem one way this manifests itself is in the handling of directories. WASB does not support *true* directories but rather *virtual directories* which are in effect a side effect of delimited object names. One cannot create an empty directory one can only create a directory by uploading an object with a directory structure in its name. Similarly if one deletes the last remaining object in a directory then the directory too is removed. The following example shows how one can create a directory hierarchy by uploading an object with a name that specifies that structure.

```
% create file with some random data
sampleData = rand(1000,1000);
save SampleData sampleData;

% create a blob for the file with a destination name that includes the required directory hierarchy
blob = azContainer.getBlockBlobReference('SampleData.mat', 'mydir1/mydir2/mynewfilname.mat');
% upload the blob to Azure
blob.upload();
```

The key is the *getBlockBlobReference* call. This results in the file in question SampleData.mat being uploaded with an alternate name in this case but that is optional. In doing so it creates the levels mydir1 and mydir2. Note there is no leading '/' in the specified path. This path is relative to the container in question, azContainer in this case. This call support vectorised inputs. Azure WASB does not support a straightforward mechanism for the upload and download of complete directories. This must be accomplished by looping over the directory contents. Locking of objects during this process is not supported. Directory hierarchy can be specified as a prefix when listing container contents.


### Generating a Shared Access Signature
Shared Access Signatures (SAS) allow granular access to tables, queues, blob containers, and blobs. A SAS provides a way to grant limited access to objects in a storage account to third parties, without exposing the account key. This is the key point of using shared access signatures in applications, a SAS is a secure way to share storage resources without compromising account keys. A SAS token can be configured to provide specific access rights, i.e. add, create, read, delete, etc. to a specific blob; for a specified time period or without any limit. The SAS token appears as part of the resource’s URI as a series of query parameters, e.g.:    
<https://myaccountname.blob.core.windows.net/mycontainer/SampleData.mat? <https://myaccountname.table.core.windows.net/mbsampletable?sv=2017-04-17&si=myidentifer&tn=mbsampletable&sig=eaGeUXr4yMvww%2BVTL5zIAmhkdjYwhzBVSM7y%2FPX8bdI%3D>   

Note, because the URL provides access to the blob Cloud Storage Account authentication is not needed and the associated access is via the SAS URL. Currently Service SASs are supported, as described. Account SASs are not currently supported.

The following example:
1. Creates a container
2. Creates a SAS access policy
3. Creates a blob in the container
4. Generates a SAS for the blob using the policy

```
% configure account & connect to Azure as previously shown
az = azure.storage.CloudStorageAccount;
az.loadConfigurationSettings();
az.connect();

% create a client and container
azClient = azure.storage.blob.CloudBlobClient(az);
azContainer = azure.storage.blob.CloudBlobContainer(azClient,'mycontainer');
azContainer.createIfNotExists();

% create a shared access policy
myPolicy = azure.storage.blob.SharedAccessBlobPolicy();
permSet(1) = azure.storage.blob.SharedAccessBlobPermissions.LIST;
permSet(2) = azure.storage.blob.SharedAccessBlobPermissions.READ;
myPolicy.setPermissions(permSet);
% allow access for the next 24 hours
t1 = datetime('now');
t2 = t1 + hours(24);
myPolicy.setSharedAccessExpiryTime(t2);
% allow a margin of 15 minutes for clock variances
t3 = t1 - minutes(15);
myPolicy.setSharedAccessStartTime(t3);

% create a blob in the container from some random data
x = rand(10);
save('SampleData.mat','x');
myblob = azContainer.getBlockBlobReference(which('SampleData.mat'));
myblob.upload();

% generate the signature as follows: blob URI + '?' + Signature string
% ff there is no container level policy in use then this can be set to ''

sas = myblob.generateSharedAccessSignature(myPolicy,'myContainerLevelAccessPolicy')

sas =

    'sig=eqqgphDjJv0uat3v%2B%2BlPqYUpJFA7ZaXe5eaIEvFIRX4%3D&st=2018-05-09T16%3A03%3A48Z&se=2018-05-10T16%3A18%3A48Z&sv=2017-04-17&si=myContainerLevelAccessPolicy&sp=rac&sr=b'   

myUri = myblob.getUri;
fullSas = [char(myUri.EncodedURI),'?',sas]   

fullSas =

        'https://myaccountname.blob.core.windows.net/mycontainer/SampleData.mat?sig=eqqgphDjJv0uat3v%2B%2BlPqYUpJFA7ZaXe5eaIEvFIRX4%3D&st=2018-05-09T16%3A03%3A48Z&se=2018-05-10T16%3A18%3A48Z&sv=2017-04-17&si=myContainerLevelAccessPolicy&sp=rac&sr=b'

```

### Accessing a Container via a SAS
Access to a container may be provided via a SAS. In which create a container object based on that SAS rather than first authenticating and creating a client as shown previously. The following example takes a SAS URL which has been provided by some means, creates a StorageUri object from that and then uses that to create a container. The container can then be accessed in the normal way e.g. to list or download. This is provided the SAS provides the required level of access.
```
% create an azure.storage.StorageURI
SASURL = 'https://myaccountname.blob.core.windows.net/mywasbtestcontainer?st=2018-08-15T17%3<REDACTED>WvIIzQ%3D';
SASStorageUri = azure.storage.StorageUri(matlab.net.URI(SASURL));
% create a container using the StorageUri
SASContainer = azure.storage.blob.CloudBlobContainer(SASStorageUri);
% access the blobs as normal
mylist = SASContainer.listBlobs()

mylist =

  1x3 cell array

    {1x1 azure.storage.blob.CloudBlockBlob}    {1x1 azure.storage.blob.CloudBlobDirectory}    {1x1 azure.storage.blob.CloudBlockBlob}
mylist{3}.download;
```


## Notes:
* [Microsoft® Azure Storage Explorer](https://azure.microsoft.com/en-us/features/storage-explorer/) is a free, standalone app from Microsoft that a GUI for Azure Storage data on Windows®, macOS®, and Linux.
When installed, it is possible to bring this up from MATLAB using the *AzureStorageExplorer* command. For more information, please see: https://docs.microsoft.com/en-us/azure/vs-azure-tools-storage-manage-with-storage-explorer

* <sup>1</sup>Used with permission from Microsoft.

----------------

[//]: #  (Copyright 2017, The MathWorks, Inc.)
