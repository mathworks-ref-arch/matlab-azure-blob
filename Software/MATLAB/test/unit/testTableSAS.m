classdef testTableSAS < matlab.unittest.TestCase
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

        function testTableSASGen(testCase)
            disp('Running testTableSASGen');
            % Connect to an Azure Cloud Storage Account
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();
            % Create a client Object
            client = azure.storage.table.CloudTableClient(az);
            tableHandle = azure.storage.table.CloudTable(client,'WASBInterfaceUnitTestTableSASGen');
            % Create a table
            tableHandle.createIfNotExists();
            % Check if the table exists
            flag = tableHandle.exists();
            testCase.assertTrue(flag);

            % Create a sample entity and insert into the database
            dynamicEntity = azure.storage.table.DynamicTableEntity;
            dynamicEntity.addprop('Name');
            dynamicEntity.Name = 'John';
            dynamicEntity.partitionKey = 'Smith';
            dynamicEntity.rowKey = 'John';
            dynamicEntity.addprop('Value');
            dynamicEntity.Value = 3.14;
            dynamicEntity.initialize();

            % Create a table operation to execute on the database
            tableOperation = azure.storage.table.TableOperation.insertOrReplace(dynamicEntity);
            tableHandle.execute(tableOperation);


            % First create a shared access policy, setting permissions and times
            myPolicy = azure.storage.table.SharedAccessTablePolicy();
            permSet(1) = azure.storage.table.SharedAccessTablePermissions.QUERY;
            myPolicy.setPermissions(permSet);

            % Allow access for the next 24 hours
            % Allow a margin of 15 minutes for clock variances
            t1 = datetime('now','TimeZone','UTC') + hours(24);
            myPolicy.setSharedAccessExpiryTime(t1);
            t2 = datetime('now','TimeZone','UTC') - minutes(15);
            myPolicy.setSharedAccessStartTime(t2);

            % set a partition and row key
            pk = 'Smith';
            rk = 'John';

            % Set row and partition restrictions
            accessPolicyIdentifier = '';
            startPartitionKey = pk;
            startRowKey = rk;
            endPartitionKey = pk;
            endRowKey = rk;

            % Generate the SAS, note the leading ? and URI are not included
            sas = tableHandle.generateSharedAccessSignature(myPolicy,accessPolicyIdentifier,startPartitionKey,startRowKey,endPartitionKey,endRowKey);
            % build the full SAS
            myUri = tableHandle.getUri;
            fullSas = [char(myUri.EncodedURI),'?',sas];

            SASTableURI = matlab.net.URI(fullSas);
            % Create a StorageURI object based on this
            SASStorageURI = azure.storage.StorageUri(SASTableURI);

            % Create a CloudTable object via the StorageURI object
            sasTableHandle = azure.storage.table.CloudTable(SASStorageURI);

            % Return the name of the table
            nameValue = sasTableHandle.Name;
            testCase.verifyTrue(strcmp(nameValue, tableHandle.Name));

            % As before build a Table Operation
            dResolver = com.mathworks.azure.sdk.DynamicResolver.getDynamicResolver();
            tableOperation = azure.storage.table.TableOperation.retrieve(pk, rk, dResolver);
            % Query the table using the handle and operation
            results = sasTableHandle.execute(tableOperation);
            testCase.verifyEqual(results.Value, 3.14);
            testCase.verifyTrue(strcmp(results.Name, dynamicEntity.Name));

            % Cleanup
            flag = tableHandle.deleteIfExists();
            testCase.assertTrue(flag);
            % wait to allow time for all the previous delete operations to
            % complete before the test might run again
            % TODO consider adding UID to table names
            pause(60);
            client.delete();
        end
    end %methods
end %class
