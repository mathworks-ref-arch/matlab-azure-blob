classdef testBlobProperties < matlab.unittest.TestCase
    % TESTCLOUDAppendBLOB This is a test stub for a unit testing
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

        function testProperties(testCase)
            disp('Running testlistBlobsOne');
            % Test listing A blob
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

            % Create some sample data & upload as an CloudAppendBlob
            filenameAppend = 'SampleDataAppend.mat';
            sampleData = rand(100,100);
            save(filenameAppend, 'sampleData');
            blob = azContainer.getAppendBlobReference(which(filenameAppend));
            blob.upload();

            % Create some sample data & upload as an CloudBlockBlob
            filenameBlock = 'SampleDataBlock.mat';
            sampleData = rand(100,100);
            save(filenameBlock, 'sampleData');
            blob = azContainer.getBlockBlobReference(which(filenameBlock));
            blob.upload();

            % list the blobs and check the filenames match
            blobList = azContainer.listBlobs();
            testCase.verifyNumElements(blobList, 2);
            foundAppendFlag = false;
            foundBlockFlag = false;
            for n = 1:numel(blobList)
                if isa(blobList{n},'azure.storage.blob.CloudAppendBlob')
                    testCase.verifyEqual(blobList{n}.Name,filenameAppend);
                    foundAppendFlag = true;
                end
                if isa(blobList{n},'azure.storage.blob.CloudBlockBlob')
                    testCase.verifyEqual(blobList{n}.Name,filenameBlock);
                    foundBlockFlag = true;
                end
            end
            testCase.verifyTrue(foundBlockFlag);
            testCase.verifyTrue(foundAppendFlag);


            % SET THE MD5s (to fake values)
            % an actual md5 minus the last digit that will be replaced by
            % the value of the loop iterator
            baseFakeMD5 = '80cd6bad7ed3712525419f95b3d542b';
            for n = 1:numel(blobList)
                blobList{n}.downloadAttributes();
                props = blobList{n}.getProperties();
                fakeMD5 = [baseFakeMD5,num2str(n)];
                props.setContentMD5(fakeMD5);
                blobList{n}.uploadProperties();
            end

            for n = 1:numel(blobList)
                blobList{n}.downloadAttributes();
                props = blobList{n}.getProperties();
                % check length
                length = props.getLength();
                dInfo = dir(blobList{n}.Name);
                testCase.verifyEqual(dInfo.bytes, length);
                % check md5
                md5 = props.getContentMD5();
                fakeMD5 = [baseFakeMD5,num2str(n)];
                testCase.verifyTrue(strcmp(md5, fakeMD5));

                % Check times assumes Azure will record in UTC and that the
                % test runs quickly with minimal clock drift window of 15
                % mins allowed
                createdTime = props.getCreatedTime();
                deltaT = datetime('now','TimeZone','UTC') - createdTime;
                testCase.verifyTrue(deltaT < minutes(15));
                lastModified = props.getLastModified();
                deltaT = datetime('now','TimeZone','UTC') - lastModified;
                testCase.verifyTrue(deltaT < minutes(15));

                % Validate the BlobType
                type = props.getBlobType();
                if strcmp(blobList{n}.Name, filenameAppend)
                    testCase.verifyEqual(type, azure.storage.blob.BlobType.APPEND_BLOB);
                elseif strcmp(blobList{n}.Name, filenameBlock)
                    testCase.verifyEqual(type, azure.storage.blob.BlobType.BLOCK_BLOB);
                else
                    testCase.verifyFail('Should only have two previously determined names at this point - fail')
                end
            end

            % clean up the resources created
            flag = azContainer.deleteIfExists();
            testCase.verifyTrue(flag);
            azClient.delete();
            delete(filenameAppend);
            delete(filenameBlock);
        end
    end

end
