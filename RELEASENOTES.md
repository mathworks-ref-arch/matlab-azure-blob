# MATLAB Interface *for Windows Azure Storage Blob*
# Release Notes

## Release 0.8.1 March 5th 2020
* Updated security notice
* Updated license

## Release 0.8.0 July 23rd 2019
* Added Queue support
* Improved documentation
* Added security notice
* Fixed bug in StorageUri constructor

## Release 0.7.4 April 18th 2019
* Improved Table API handling of nulls
* Improved Table API handling of empty results
* Improved unit tests

## Release 0.7.3 April 4th 2019
* Improved SAS generation calls
* Documentation improvements
* Added SAS unit tests
* Improved Table unit tests

## Release 0.7.2 April 2nd 2019
* Renamed azRoot function to distinguish from other Azure interfaces
* Added CloudAppendBlob support
* Improved BlobProperties support

## Release 0.7.1 February 18th 2019
* Improved logging infrastructure
* Improved documentation
* Fixed a bug when creating a CloudBlockBlob using a StorageUri
* Fixed a bug in getSharedAccessExpiryTime()
* Fixed a bug in DynamicTableEntity where storing vectors (not supported) could silently fail
* Added SharedAccessBlobPermissions LIST support
* Made object Name properties consistently char vectors
* Added CloudBlobContainer.generateSharedAccessSignature() method

## Release 0.7.0 December 20th 2018
* Improved Table data type support
* Minor bug fixes and documentation improvements
* Added CloudBlobDirectory.isValid() method
* Improved unit tests
* Removed SDK level from directory tree
* Removed scripts level from directory tree
* Relocated jar file
* Removed CloudStorageAccount initialize, getHandle & uninitialize methods *Changes are not backwardly compatible in all cases*
* Updated unit tests
* Changed license

## Release 0.6.1 November 9nd 2018
* Documentation fixes and improvements

## Release 0.6.0 November 2nd 2018
* Improved the functionality of CloudBlobckBlob.download(), *Changes are not backwardly compatible in all cases*
* Added CloudBlobContainer.load() and save() methods
* Documentation improvements and fixes
    * Improved CloudBlobBlob() help
    * Improved support and documentation for deploying in .exe and .ctf files
    * Added documentation for virtual directory handling
* Added prefix support to listBlobs()
* Updated CloudBlobContainer.getMetadata() to return a containers.Map
* Added CloudBlobContainer.setMetadata(), uploadMetadata() & downloadAttributes()
* Added CloudBlockBlob.getMetadata() & setMetadata()
* Added a BlobProperties Class and Methods
* Added a BlobContainerProperties Class and Methods
* Added capability for Storage Explorer path to be returned in non default configuration files

## Release 0.5.3 October 11th 2018
* Minor documentation updates

## Release 0.5.2 September 27th 2018
* Fix to add missing markdown version of documentation

## Release 0.5.0 September 21st 2018
* Split Azure Data Lake functionality into a separate package, this package retains only WASB support
* Documentation updates
* Removed demos pending updates

## Release 0.4.0 August 15th 2018
* *MAY REQUIRE UPDATES TO EXISTING CODE*
* Syntax fix in Data Lake End user credentials file and associated documentation
* Significant and wide ranging WASB documentation improvements
* Updated unit tests
* CloudBlobClient Class
    * Added getDirectoryDelimiter() & setDirectoryDelimiter()
    * Removed Parent property
    * listContainers(), bug fix
* CloudBlobContainer Class
    * Moved Parent property to a method, getParent()
    * Added ServiceClient property
    * Converter Name property to character vector type
    * getBlockBlobReference(), added specified blob name support
    * getDirectoryReference, bug fix
    * Enabled getStorageUri()
    * listBlobs(), bug fixes
    * Added a StorageUri constructor for SAS support
* CloudBlobDirectory Class
    * Moved Parent property to a method, getParent()
    * Added getContiner() & getPrefix()
    * Constructor bug fix
    * listBlobs(), bug fixes
    * Change to trailing delimiter behavior
* CloudBlockBlob Class
    * Constructor bug fix
    * Moved Parent property to a method, getParent()
    * download(), changed delimiter handling
    * Added getContainer()

## Release 0.3.5 August 9th 2018
* Data Lake Store documentation improvements
* CloudBlobContainer documentation improvements
* Improved CloudBlobClient.getContainerReference implementation
* Fix to CloudBlobDirectory constructor
* Minor fix to CloudStorageAccount
* Improved documentation

## Release 0.3.4 June 19th 2018
* Fix to Data Lake client constructor and initialize documentation
* Added support for alternate Data Lake configuration files
* Added End-user authentication for Data Lake
* Improved Data Lake documentation

## Release 0.3.3 June 7th 2018
* Added Data Lake upload method
* Added Data Lake download method
* Improved documentation
* Minor bug fixes

## Release 0.3.2 May 10th 2018
* Added verbose mode support to logging functionality
* Documentation improvements
* Minor bug fixes
* Added Blob SAS functionality
* Improved Table SAS functionality

## Release 0.3.1 May 2nd 2018
* Added blob exists() method
* Added blob triggered azure function demo

## Release 0.3.0 May 1st 2018
* The following calls are not backwardly compatible and require minor code changes, please review the relevant documentation listBlobs() download() upload() *REQUIRES UPDATES TO EXISTING CODE*
* Improved unit tests
* Added CloudBlobDirectory support
* Improved documentation
* Added basic SAS support

## Release 0.2.0 February 16th 2018
* Refactored object hierarchy to closer match MS SDK, *REQUIRES UPDATES TO EXISTING CODE*
* Added further ADL and Table functionality
* Improved documentation
* Added integration to Storage Explorer and Cloud Shell
* Moved main test environment to R2017b
* Added initial demo scripts in SDK/public

## Release 0.1.5 December 22nd 2017
* Fixed jar build to allow for Java 1.8 manifest handling
* Improved automated document generation
* Added preliminary Data Lake functionality
* Added preliminary Table functionality

## Release 0.1.4 December 8th 2017
* Added initial Table support classes
* Moved to logger based messages
* Improved documentation

## Release 0.1.3 November 27th 2017
* Added initial Data Lake support
* Documentation updates
* Automated pdf generation

## Release 0.1.2 November 14th 2017
* Reorganized directory structure

## Release 0.1.1 November 10th 2017
* Added proxy support and documentation for Blob Storage

## Release 0.1.0 October 18th 2017
* Initial release with support for Blob Storage

------------

[//]: #  (Copyright 2017, The MathWorks, Inc.)
