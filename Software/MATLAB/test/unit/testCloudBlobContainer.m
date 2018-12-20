classdef testCloudBlobContainer < matlab.unittest.TestCase
    % TESTCLOUDBLOBCONTAINER This is a test stub for a unit testing
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

    % Copyright 2016 The MathWorks, Inc.

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
        function testConstructor(testCase)
            disp('Running testConstructor');
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();

            % Create a client Object
            client = azure.storage.blob.CloudBlobClient(az);
            contanerName = ['unittestcontainer', char(javaMethod('randomUUID','java.util.UUID'))];
            container = azure.storage.blob.CloudBlobContainer(client,contanerName);

            % Check that the blob container is created as expected.
            testCase.verifyTrue(container.isValid());
            testCase.verifyEqual(container.Name, contanerName); % check if the lower is functional
            testCase.verifyClass(container.Name, 'char');
            % Clean up
            % container not created so should not exist
            flag = container.deleteIfExists();
            testCase.verifyFalse(flag);
            client.delete();
        end

        function testGetContainerReference(testCase)
            disp('Running testGetContainerReference');
            % Create a client
            az = azure.storage.CloudStorageAccount;
            az.UseDevelopmentStorage = false;
            az.loadConfigurationSettings();
            az.connect();
            azClient = azure.storage.blob.CloudBlobClient(az);

            % Create a container
            uniqName = ['unittestcontainer', char(javaMethod('randomUUID','java.util.UUID'))];
            azContainer = azure.storage.blob.CloudBlobContainer(azClient,uniqName);
            flag = azContainer.createIfNotExists();
            testCase.verifyTrue(flag);

            % Create via Reference
            azContainerRef = azClient.getContainerReference(uniqName);
            testCase.verifyTrue(azContainerRef.isValid());
            testCase.verifyClass(azContainerRef.Name, 'char');
            testCase.verifyEqual(azContainerRef.Name, char(uniqName));
            % this should return false as the container should already
            % exist based on the previous call
            flag = azContainerRef.createIfNotExists();
            testCase.verifyFalse(flag);

            % Clean up
            flag = azContainer.deleteIfExists();
            testCase.verifyTrue(flag);
            flag = azContainerRef.deleteIfExists();
            testCase.verifyFalse(flag);
            azClient.delete();

        end


        %% TESTCASE: Create containers,
        % also tests exists method
        function testCreateDestroyContainer(testCase)
            disp('Running testCreateDestroyContainer');
            % Connect to the service
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();

            % Create a client Object
            client = azure.storage.blob.CloudBlobClient(az);
            uniqName = ['unittestcontainer', char(javaMethod('randomUUID','java.util.UUID'))];
            container = azure.storage.blob.CloudBlobContainer(client,uniqName);

            % Create a container for the blobs
            flag = container.createIfNotExists();

            % Verification
            testCase.verifyTrue(flag);

            % Check if it exists
            testCase.verifyTrue(container.exists());

            % Create a container for the blobs
            flag = container.deleteIfExists();

            % Check if it no longer exists
            testCase.verifyFalse(container.exists());

            % Verification
            testCase.verifyTrue(flag);

        end

        %% TESTCASE: List content of containers
        function testListContainers(testCase)
            disp('Running testListContainers');
            import matlab.unittest.constraints.IsGreaterThan

            % Connect to the service
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();

            % Create a client Object
            azClient = azure.storage.blob.CloudBlobClient(az);

            % Create a container
            uniqName = ['unittestcontainer', char(javaMethod('randomUUID','java.util.UUID'))];
            azContainer = azure.storage.blob.CloudBlobContainer(azClient,uniqName);
            flag = azContainer.createIfNotExists();
            testCase.verifyTrue(flag);

            % List the containers
            containers = azClient.listContainers();
            testCase.verifyEqual(class(containers),'azure.storage.blob.CloudBlobContainer');
            % Test assumes it is running in an account with more than one
            % container and may need changes if running in a storage
            % account with no other containers in which case listContainers
            % will return just one value
            testCase.verifyThat(numel(containers), IsGreaterThan(1));

            % check that the uniqName container exists and that it is
            % unique
            foundContainer = false;
            ctr = 0;
            for n = 1:numel(containers)
                if strcmp(containers(n).Name,uniqName)
                    foundContainer = true;
                    ctr = ctr + 1;
                end
            end
            testCase.verifyTrue(foundContainer);
            testCase.verifyEqual(ctr, 1);

            % Clean up
            flag = azContainer.deleteIfExists();
            testCase.verifyTrue(flag);
            azClient.delete();
        end

        %% TESTCASE: Upload blob to a container
        function testUploadBlobToContainer(testCase)
            disp('Running testUploadBlobToContainer');
            % Connect to the service
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();
            % Create a client Object
            azClient = azure.storage.blob.CloudBlobClient(az);

            % Create a container
            uniqName = ['unittestcontainer', char(javaMethod('randomUUID','java.util.UUID'))];
            azContainer = azure.storage.blob.CloudBlobContainer(azClient,uniqName);
            flag = azContainer.createIfNotExists();
            testCase.verifyTrue(flag);

            % Create some sample data & upload them
            filename = 'SampleData.mat';
            sampleData = rand(100,100); %#ok<NASGU>
            save(filename, 'sampleData');
            blob = azContainer.getBlockBlobReference(which(filename));
            blob.upload();

            % list the blob and check the filename matches
            % there should be only one blob in this container
            blobList = azContainer.listBlobs();
            testCase.verifyEqual(blobList{1}.Name,filename);
            testCase.verifyEqual(class(blobList{1}),'azure.storage.blob.CloudBlockBlob');

            % Clean up
            flag = azContainer.deleteIfExists();
            testCase.verifyTrue(flag);
            azClient.delete();
            delete(filename);
        end

        %% TESTCASE: Download content of containers
        function testDownloadBlobToContainer(testCase)
            disp('Running testDownloadBlobToContainer');
            % Connect to the service
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();
            % Create a client Object
            azClient = azure.storage.blob.CloudBlobClient(az);

            % Create a container
            uniqName = ['unittestcontainer', char(javaMethod('randomUUID','java.util.UUID'))];
            azContainer = azure.storage.blob.CloudBlobContainer(azClient,uniqName);
            flag = azContainer.createIfNotExists();
            testCase.verifyTrue(flag);

            % Create some sample data & upload them
            filename1 = 'SampleData1.mat';
            filename2 = 'SampleData2.mat';
            sampleData = rand(100,100);
            save(filename1, 'sampleData');
            save(filename2, 'sampleData');
            blob = azContainer.getBlockBlobReference(which(filename1));
            blob.upload();
            blob = azContainer.getBlockBlobReference(which(filename2));
            blob.upload();

            % delete the uploaded files
            delete(filename1);
            delete(filename2);
            % check they are gone
            testCase.verifyEqual(exist(filename1,'file'), 0);
            testCase.verifyEqual(exist(filename2,'file'), 0);

            % get a list of the blobs
            blobList = azContainer.listBlobs();
            % download the blobs
            for n=1:numel(blobList)
                blobList{n}.download();
            end

            % check they are back
            testCase.verifyEqual(exist(filename1,'file'), 2);
            testCase.verifyEqual(exist(filename2,'file'), 2);

            % take a copy of our random data and clear it, then reload from
            % the downloaded blob and check they match
            testData = sampleData;
            clear sampleData;
            load(filename1,'sampleData');
            matches = (testData == sampleData);
            % should get a logical '1' i.e. non zero for each of the 10000 values
            testCase.verifyEqual(nnz(matches),10000);

            flag = azContainer.deleteIfExists();
            testCase.verifyTrue(flag);
            azClient.delete();
            delete(filename1);
            delete(filename2);
        end

        %% TESTCASE: Delete content from a container
        function testDeleteBlobFromContainer(testCase)
            disp('Running testDeleteBlobFromContainer');
            % Connect to the service
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();
            % Create a client Object
            azClient = azure.storage.blob.CloudBlobClient(az);

            % Create a container
            uniqName = ['unittestcontainer', char(javaMethod('randomUUID','java.util.UUID'))];
            azContainer = azure.storage.blob.CloudBlobContainer(azClient,uniqName);
            flag = azContainer.createIfNotExists();
            testCase.verifyTrue(flag);

            % Create some sample data & upload them
            filename = 'SampleData.mat';
            sampleData = rand(100,100); %#ok<NASGU>
            save(filename, 'sampleData');
            blob = azContainer.getBlockBlobReference(which(filename));
            blob.upload();

            % list the blob and check the filename matches
            % there should be only one blob in this container
            blobList = azContainer.listBlobs();
            for n=1:numel(blobList)
                testCase.verifyEqual(blobList{n}.Name,filename);
                testCase.verifyEqual(class(blobList{n}),'azure.storage.blob.CloudBlockBlob');
            end

            % check that all got deleted
            for n=1:numel(blobList)
                results(n) = blobList{n}.deleteIfExists(); %#ok<AGROW>
            end
            testCase.verifyTrue(results(n,1));

            % list the container again, checking that it is empty
            blobList = azContainer.listBlobs();
            testCase.verifyEmpty(blobList);

            azClient.delete();
            delete(filename);
        end

        %% TESTCASE: Set permissions for a given container
        % also test downloadPermissions
        function testSetPermissions(testCase)
            disp('Running testSetPermissions');
            % Connect to the service
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();

            % Create a client Object
            azClient = azure.storage.blob.CloudBlobClient(az);

            % Create a container
            uniqName = ['unittestcontainer', char(javaMethod('randomUUID','java.util.UUID'))];
            azContainer = azure.storage.blob.CloudBlobContainer(azClient,uniqName);
            flag = azContainer.createIfNotExists();
            testCase.verifyTrue(flag);

            permDown = azContainer.downloadPermissions();
            % by default this should be 'OFF'
            testCase.verifyEqual(permDown.AccessType, 'OFF');

            permUp = azure.storage.blob.BlobContainerPermissions;
            permUp.AccessType = 'CONTAINER';
            azContainer.uploadPermissions(permUp);

            permDown = azContainer.downloadPermissions();
            % by default this should now be 'CONTAINER'
            testCase.verifyEqual(permDown.AccessType, 'CONTAINER');

            % cleanup
            flag = azContainer.deleteIfExists();
            testCase.verifyTrue(flag);
            azClient.delete();
        end

        function testBlobContainerPermissions(testCase)
            disp('Running testBlobContainerPermissions');
            % Basic class and assignment test
            blob = azure.storage.blob.BlobContainerPermissions;
            blob.AccessType = 'BLOB';       % Blob level public access
            blob.AccessType = 'CONTAINER';  % Container-level public access
            blob.AccessType = 'OFF';        % Turn off public access

            testCase.verifyEqual(class(blob),'azure.storage.blob.BlobContainerPermissions');
        end


        %% TESTCASE: Set and get metadata for a given container
        function testSetGetMetadata(testCase)
            disp('Running testSetGetMetadata');
            % Connect to the service
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();
            % Create a client Object
            azClient = azure.storage.blob.CloudBlobClient(az);

            % Create a container
            uniqName = ['unittestcontainer', char(javaMethod('randomUUID','java.util.UUID'))];
            azContainer = azure.storage.blob.CloudBlobContainer(azClient,uniqName);
            flag = azContainer.createIfNotExists();
            testCase.verifyTrue(flag);

            azContainer.setMetadata('key1','val1');
            azContainer.uploadMetadata();
            m = azContainer.getMetadata();
            k = keys(m);
            testCase.verifyEqual(k{1}, 'key1');
            v = values(m);
            testCase.verifyEqual(v{1}, 'val1');

            myKeys = {'key1','key2'};
            myVals = {'val1','val2'};
            cMap = containers.Map(myKeys, myVals);
            azContainer.setMetadata(cMap);
            azContainer.uploadMetadata();
            m = azContainer.getMetadata();
            k = keys(m);
            testCase.verifyEqual(k{1}, 'key1');
            testCase.verifyEqual(k{2}, 'key2');
            v = values(m);
            testCase.verifyEqual(v{1}, 'val1');
            testCase.verifyEqual(v{2}, 'val2');

            % cleanup
            flag = azContainer.deleteIfExists();
            testCase.verifyTrue(flag);
            azClient.delete();
        end
    end

end
