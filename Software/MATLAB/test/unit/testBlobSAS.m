classdef testBlobSAS < matlab.unittest.TestCase
    % TESTCLOUDBLOCKBLOB This is a test stub for a unit testing
    % The assertions that you can use in your test cases:
    %
    %    assertTrue
    %    assertFalse
    %    assertEqual
    %    assertFilesEqual
    %    assertElementsAlmostEqual
    %    assertVectorsAlmostEqual
    %    assertExceptionThrown
    %
    %   A more detailed explanation goes here.
    %
    % Notes:

    % Copyright 2019 The MathWorks, Inc.

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Please add your test cases below
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties
        logObj
    end

    methods (TestMethodSetup)
        function testSetup(testCase)
            testCase.logObj = Logger.getLogger();
            testCase.logObj.DisplayLevel = 'verbose';
        end
    end

    methods (TestMethodTeardown)
        function testTearDown(testCase) %#ok<MANU>

        end
    end

    methods (Test)

        function testSASBlockBlobDownload(testCase)
            % configure a client & connect to Azure
            az = azure.storage.CloudStorageAccount;
            az.UseDevelopmentStorage = false;
            az.loadConfigurationSettings();
            az.connect();

            % create a container
            azClient = azure.storage.blob.CloudBlobClient(az);
            uniqName = ['unittestcontainer', char(javaMethod('randomUUID','java.util.UUID'))];
            azContainer = azure.storage.blob.CloudBlobContainer(azClient,uniqName);
            flag = azContainer.createIfNotExists();
            testCase.verifyTrue(flag);

            % create a shared access policy
            myPolicy = azure.storage.blob.SharedAccessBlobPolicy();
            permSet(1) = azure.storage.blob.SharedAccessBlobPermissions.LIST;
            permSet(2) = azure.storage.blob.SharedAccessBlobPermissions.READ;
            myPolicy.setPermissions(permSet);

            t1 = datetime('now','TimeZone','UTC') + hours(24);
            myPolicy.setSharedAccessExpiryTime(t1);
            t2 = datetime('now','TimeZone','UTC') - minutes(15);
            myPolicy.setSharedAccessStartTime(t2);

            % create a blob in the container
            x = rand(10);
            filename1 = 'SampleData1.mat';
            save(filename1,'x');
            uploadBlob = azure.storage.blob.CloudBlockBlob(azContainer, filename1, which(filename1'));
            uploadBlob.upload();

            % generate the signature as follows: blob URI + '?' + Signature string
            sas = uploadBlob.generateSharedAccessSignature(myPolicy);
            myUri = uploadBlob.getUri();
            fullSas = [char(myUri.EncodedURI),'?',sas];

            % get a blob object based on the SAS URL
            downloadBlob = azure.storage.blob.CloudBlockBlob(azure.storage.StorageUri(matlab.net.URI(fullSas)));
            % download it using a different filename
            filename2 = 'SampleData2.mat';
            downloadBlob.download(filename2);
            downloadStruct = load(filename2);
            testCase.verifyEqual(x, downloadStruct.x);

            flag = azContainer.deleteIfExists();
            testCase.verifyTrue(flag);
            azClient.delete();
            delete(filename1);
            delete(filename2);
        end

        function testSASAppendBlobDownload(testCase)
            % configure a client & connect to Azure
            az = azure.storage.CloudStorageAccount;
            az.UseDevelopmentStorage = false;
            az.loadConfigurationSettings();
            az.connect();

            % create a container
            azClient = azure.storage.blob.CloudBlobClient(az);
            uniqName = ['unittestcontainer', char(javaMethod('randomUUID','java.util.UUID'))];
            azContainer = azure.storage.blob.CloudBlobContainer(azClient,uniqName);
            flag = azContainer.createIfNotExists();
            testCase.verifyTrue(flag);

            % create a shared access policy
            myPolicy = azure.storage.blob.SharedAccessBlobPolicy();
            permSet(1) = azure.storage.blob.SharedAccessBlobPermissions.LIST;
            permSet(2) = azure.storage.blob.SharedAccessBlobPermissions.READ;
            myPolicy.setPermissions(permSet);

            t1 = datetime('now','TimeZone','UTC') + hours(24);
            myPolicy.setSharedAccessExpiryTime(t1);
            t2 = datetime('now','TimeZone','UTC') - minutes(15);
            myPolicy.setSharedAccessStartTime(t2);

            % create a blob in the container
            x = rand(10);
            filename1 = 'SampleData1.mat';
            save(filename1,'x');
            uploadBlob = azure.storage.blob.CloudAppendBlob(azContainer, filename1, which(filename1'));
            uploadBlob.upload();

            % generate the signature as follows: blob URI + '?' + Signature string
            sas = uploadBlob.generateSharedAccessSignature(myPolicy);
            myUri = uploadBlob.getUri();
            fullSas = [char(myUri.EncodedURI),'?',sas];

            % get a blob object based on the SAS URL
            downloadBlob = azure.storage.blob.CloudAppendBlob(azure.storage.StorageUri(matlab.net.URI(fullSas)));
            % download it using using a different filename
            filename2 = 'SampleData2.mat';
            downloadBlob.download(filename2);
            downloadStruct = load(filename2);
            testCase.verifyEqual(x, downloadStruct.x);

            flag = azContainer.deleteIfExists();
            testCase.verifyTrue(flag);
            azClient.delete();
            delete(filename1);
            delete(filename2);
        end


        function testSASContainerList(testCase)
            % configure a client & connect to Azure
            az = azure.storage.CloudStorageAccount;
            az.UseDevelopmentStorage = false;
            az.loadConfigurationSettings();
            az.connect();

            % create a container
            azClient = azure.storage.blob.CloudBlobClient(az);
            uniqName = ['unittestcontainer', char(javaMethod('randomUUID','java.util.UUID'))];
            azContainer = azure.storage.blob.CloudBlobContainer(azClient,uniqName);
            flag = azContainer.createIfNotExists();
            testCase.verifyTrue(flag);

            % create a blob in the container
            x = rand(10);
            filename1 = 'SampleData1.mat';
            save(filename1,'x');
            uploadBlob = azure.storage.blob.CloudBlockBlob(azContainer, filename1, which(filename1'));
            uploadBlob.upload();

            % create a shared access policy
            myPolicy = azure.storage.blob.SharedAccessBlobPolicy();
            permSet(1) = azure.storage.blob.SharedAccessBlobPermissions.LIST;
            permSet(2) = azure.storage.blob.SharedAccessBlobPermissions.READ;
            myPolicy.setPermissions(permSet);

            t1 = datetime('now','TimeZone','UTC') + hours(24);
            myPolicy.setSharedAccessExpiryTime(t1);
            t2 = datetime('now','TimeZone','UTC') - minutes(15);
            myPolicy.setSharedAccessStartTime(t2);

            % generate the signature as follows: blob URI + '?' + Signature string
            % if there is no container level policy in use then omit it
            % sas = container.generateSharedAccessSignature(myPolicy,'myContainerLevelAccessPolicy')
            sas = azContainer.generateSharedAccessSignature(myPolicy);
            myUri = azContainer.getUri;
            fullSas = [char(myUri.EncodedURI),'?',sas];
            SASStorageUri = azure.storage.StorageUri(matlab.net.URI(fullSas));
            SASContainer = azure.storage.blob.CloudBlobContainer(SASStorageUri);

            blobList = SASContainer.listBlobs();
            testCase.verifyNumElements(blobList, 1);
            downloadBlob = blobList{1};
            % download it using using a different filename
            filename2 = 'SampleData2.mat';
            downloadBlob.download(filename2);
            downloadStruct = load(filename2);
            testCase.verifyEqual(x, downloadStruct.x);

            delete(filename1);
            flag = azContainer.deleteIfExists();
            testCase.verifyTrue(flag);
            azClient.delete();
        end
    end %methods
end %class
