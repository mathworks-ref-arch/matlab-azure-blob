# MATLAB Interface *for Windows Azure Storage Blob*

This is a MATLAB® interface that connects to the Windows Azure™ Storage Blob (WASB) service.
This is a low-level, general interface that can be customized if the higher-level interface as provided in MATLAB does not support your needs.
see here [https://www.mathworks.com/help/matlab/import_export/work-with-remote-data.html](https://www.mathworks.com/help/matlab/import_export/work-with-remote-data.html) for more details on what is provided in MATLAB.

## Requirements
### MathWorks products
* Requires MATLAB release R2017a or later

### 3rd party products
To build a required JAR file:
* Maven™
* JDK 8
* Microsoft® Azure Blob Storage SDK for Java®

## Getting Started

Please refer to the documents in the [Documentation](Documentation/README.md) folder to get started.
In particular, the [Basic Usage](Documentation/BasicUsageBlob.md) provides an overview of using this interface.

This package is used to enable the use of the Azure Table Storage service with MATLAB.
In the Software/MATLAB directory run the *startup.m* to make the software available in the MATLAB environment.

### Create and configure a storage account
If this is the first time using the interface, as a one-time operation per session (assuming only one storage account is being used), setup the the Cloud Storage Account. This is done using:
```
% Create a handle to the storage account
az = azure.storage.CloudStorageAccount;
```

The storage account will need to be configured to work with the Azure account or the development emulator. By default the UseDevelopmentStorage flag is set to *true* and so the emulator running on localhost will be used. For details of the development emulator see here: [https://docs.microsoft.com/en-us/azure/storage/storage-use-emulator](https://docs.microsoft.com/en-us/azure/storage/storage-use-emulator). To use Azure itself, disable this setting as follows:
```
az.UseDevelopmentStorage = false;
```

An organization's Azure environment may well to be configured to support only https based access, this is enabled as follows:
```
az.DefaultEndpointsProtocol = 'https';
```

The following allows one to specify the credentials for the Azure storage account of choice. The AccountName value is the name of the storage account to access and the AccountKey is the associated Key. In the Azure portal select the Storage account then Settings then AccessKeys and then the Key. Normally the *Key1* value is used.
```
az.AccountName = 'myaccountname'
az.AccountKey  = 'SVn445qMEABafld3k225l*****[REDACTED_FOR_SECURITY]****RfIhAQtvYzAQr0328/d030GGw=='
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
Note, your storage account key is similar to the root password for the storage account. Always be careful to protect the account key. Avoid distributing it to other users, hard-coding it, or saving it anywhere in plain text that is accessible to others. Regenerate the account key using the Azure portal if you believe it may have been compromised.


### Create a client
With a fully configured connection get a handle to a client that allows uploading and downloading from the blob storage.
```
azClient = azure.storage.blob.CloudBlobClient(az)

azClient =
  CloudBlobClient with properties:
    DirectoryDelimiter: '/'
```
Windows Azure blob storage can now be accessed from within MATLAB. Shown below are a few of the common operations for the Blob Storage service.

### Create a container
To create a container for the configured client one can:
```
azContainer = azure.storage.blob.CloudBlobContainer(azClient,'testcontainer');
azContainer.createIfNotExists()
```

### Uploading a blob into a container
Blobs can be content of any nature. To generate some data in MATLAB and save it to newly created container is simple.
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

## Supported Products

MathWorks Products (http://www.mathworks.com)
1.  MATLAB (R2017a or later)
2.  MATLAB Compiler and Compiler SDK (R2017a or later)
3.  MATLAB Production Server (R2017a or later)
4.  MATLAB Parallel Server (R2017a or later)   

This package is primarily tested on Ubuntu™ 16.04 and Windows™ 10.

## License
The license for the MATLAB Interface for Windows Azure Storage Blob is available in the [LICENSE.TXT](LICENSE.TXT) file in this GitHub repository. This package uses certain third-party content which is licensed under separate license agreements. See the [pom.xml](Software/Java/pom.xml) file for third-party software downloaded at build time.

## Enhancement Request
Provide suggestions for additional features or capabilities using the following link:   
https://www.mathworks.com/products/reference-architectures/request-new-reference-architectures.html

## Support
Email: `mwlab@mathworks.com`

------------

[//]: #  (Copyright 2017 The MathWorks, Inc.)
