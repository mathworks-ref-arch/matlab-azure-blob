classdef testCloudTableClient < matlab.unittest.TestCase
    % TESTCLOUDTABLECLIENT This is a test stub for a unit testing
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
    % This tests the CloudTableClient and associated functionality.

    % Copyright 2017 The MathWorks, Inc.

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
        function testTearDown(testCase)

        end
    end

    methods (Test)

        function testConstructor(testCase)
            disp('Running testConstructor');
            % Create a table client
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();
            tc = azure.storage.table.CloudTableClient(az);

            testCase.assertClass(tc,'azure.storage.table.CloudTableClient');

        end

        function testCreateTableReferences(testCase)
            disp('Running testCreateTableReferences');
            % Create a handle to the Cloud Storage Account
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();

            % Create a client and table handle
            tClient = azure.storage.table.CloudTableClient(az);
            tbl = tClient.getTableReference('SampleTable');

            testCase.assertClass(tbl,'azure.storage.table.CloudTable');
            testCase.assertNotEmpty(tbl.Handle);

            tbls = tClient.getTableReference({'Table1','Table2'});
            testCase.assertEqual(numel(tbls),2);
            testCase.assertNotEmpty(tbls(1).Handle);
            testCase.assertNotEmpty(tbls(2).Handle);
        end

        function testExistenceChecks(testCase)
            disp('Running testExistenceChecks');
            % Connect to an Azure Cloud Storage Account
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();

            % Create a client Object
            client = azure.storage.table.CloudTableClient(az);
            tableHandle = azure.storage.table.CloudTable(client,'MyTable');

            % Create a table
            tableHandle.createIfNotExists();

            % Check if the table exists
            flag = tableHandle.exists();
            testCase.assertTrue(flag);

            % Delete the table
            flag = tableHandle.deleteIfExists();
            testCase.assertTrue(flag);
        end

        function testSingleInsertOrReplace(testCase)
            disp('Running testSingleInsertOrReplace');
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

            % Create a sample entity and insert into the database
            dynamicEntity = azure.storage.table.DynamicTableEntity;
            dynamicEntity.addprop('Name');
            dynamicEntity.Name = 'john';
            dynamicEntity.partitionKey = 'pk';
            dynamicEntity.rowKey = ['rk',datestr(now)];
            dynamicEntity.initialize();

            % Create a table operation to execute on the database
            tableOperation = azure.storage.table.TableOperation.insertOrReplace(dynamicEntity);
            tableHandle.execute(tableOperation);
        end

        function testBatchInsertOrReplace(testCase)
            disp('Running testBatchInsertOrReplace');
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

            % Create a number of sample entity and insert into the database
            batchSize = 100; % 100 is a hard limit
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
        end

        function testBatchInsertOrMerge(testCase)
            disp('Running testBatchInsertOrMerge');
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

            % Create a number of sample entity and insert into the database
            batchSize = 100; % 100 is a hard limit
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
        end

        function testBatchInsertWithAndWithoutEcho(testCase)
            disp('Running testBatchInsertWithAndWithoutEcho');
            % Connect to an Azure Cloud Storage Account
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();

            % Create a client Object
            client = azure.storage.table.CloudTableClient(az);
            tableHandleEcho = azure.storage.table.CloudTable(client,'InsertTestEchoTable');
            tableHandleNoEcho = azure.storage.table.CloudTable(client,'InsertTestNoEchoTable');
            % Create a table
            tableHandleEcho.createIfNotExists();
            tableHandleNoEcho.createIfNotExists();

            % Check if the table exists
            flag = tableHandleEcho.exists();
            testCase.assertTrue(flag);
            flag = tableHandleNoEcho.exists();
            testCase.assertTrue(flag);

            % Create a number of sample entity and insert into the database
            batchSize = 10; % 100 is a hard limit
            for bCount = 1:batchSize
                dynamicEntity(bCount) = azure.storage.table.DynamicTableEntity; %#ok<*AGROW>
                dynamicEntity(bCount).addprop('Name');
                dynamicEntity(bCount).Name = ['john',num2str(bCount)];
                dynamicEntity(bCount).partitionKey = 'pk';
                dynamicEntity(bCount).rowKey = ['rk',num2str(bCount),datestr(now)];
                dynamicEntity(bCount).initialize();
            end

            % Create a table operation to execute on the database with and
            % without the echo
            tableOperation = azure.storage.table.TableOperation.insert(dynamicEntity(1:5),true); % vectorized
            tableHandleEcho.execute(tableOperation);

            tableOperation = azure.storage.table.TableOperation.insert(dynamicEntity(6:10),false); % vectorized
            tableHandleNoEcho.execute(tableOperation);

        end

        function testBatchInsertAndDelete(testCase)
            disp('Running testBatchInsertAndDelete');
            % Connect to an Azure Cloud Storage Account
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();

            % Create a client Object
            client = azure.storage.table.CloudTableClient(az);
            tableHandleEcho = azure.storage.table.CloudTable(client,'insertdeletetable');

            % Create a table
            tableHandleEcho.createIfNotExists();

            % Check if the table exists
            flag = tableHandleEcho.exists();
            testCase.assertTrue(flag);

            % Create a number of sample entity and insert into the database
            batchSize = 10; % 100 is a hard limit
            for bCount = 1:batchSize
                dynamicEntity(bCount) = azure.storage.table.DynamicTableEntity; %#ok<*AGROW>
                dynamicEntity(bCount).addprop('Name');
                dynamicEntity(bCount).Name = ['john',num2str(bCount)];
                dynamicEntity(bCount).partitionKey = 'pk';
                dynamicEntity(bCount).rowKey = ['rk',num2str(bCount),datestr(now)];
                dynamicEntity(bCount).initialize();
            end

            % Create a table operation to execute on the database with and
            % without the echo
            tableOperation = azure.storage.table.TableOperation.insert(dynamicEntity,true); % vectorized
            tableHandleEcho.execute(tableOperation);

            % Now delete the data
            tableOperation = azure.storage.table.TableOperation.delete(dynamicEntity); % vectorized
            tableHandleEcho.execute(tableOperation);

        end

        function testMerge(testCase)
            disp('Running testMerge');
            % Connect to an Azure Cloud Storage Account
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();

            % Create a client Object
            client = azure.storage.table.CloudTableClient(az);
            tableHandle = azure.storage.table.CloudTable(client,'testdelete');

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
            tableOperation = azure.storage.table.TableOperation.insert(dynamicEntity, true); % vectorized
            tableHandle.execute(tableOperation);

            % Now let us add additional properties to each entry
            for bCount = 1:batchSize
                mergedEntity(bCount) = dynamicEntity(bCount);
                mergedEntity(bCount).addprop('Location');
                mergedEntity(bCount).Location = ['RandomCity',num2str(bCount)];
                % Don't change the rowkey or the partition key so that we
                % can merge this correctly
                mergedEntity(bCount).initialize();
            end

            % Create a table operation to execute on the database
            tableOperation = azure.storage.table.TableOperation.merge(dynamicEntity); % vectorized
            tableHandle.execute(tableOperation);

        end

        function testReplace(testCase)
            disp('Running testReplace');
            % Connect to an Azure Cloud Storage Account
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();

            % Create a client Object
            client = azure.storage.table.CloudTableClient(az);
            tableHandle = azure.storage.table.CloudTable(client,'testreplace');

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
            tableOperation = azure.storage.table.TableOperation.insert(dynamicEntity, true); % vectorized
            tableHandle.execute(tableOperation);

            % Now let us add additional properties to each entry
            for bCount = 1:batchSize
                replaceEntity(bCount) = dynamicEntity(bCount);
                replaceEntity(bCount).addprop('Location');
                replaceEntity(bCount).Location = ['RandomCity',num2str(bCount)];
                % Don't change the rowkey or the partition key so that we
                % can replace this correctly
                replaceEntity(bCount).initialize();
            end

            % Create a table operation to execute on the database
            tableOperation = azure.storage.table.TableOperation.replace(dynamicEntity); % vectorized
            tableHandle.execute(tableOperation);

            % TODO: Verify that the table has the right replaced entities
        end

        function testBasicRetrieve(testCase)
            disp('Running testBasicRetrieve');
            import java.util.UUID;

            % Use the storage account
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();

            % To create a client
            client = az.getCloudTableClient();

            % Create a tableHandle
            tableHandle = azure.storage.table.CloudTable(client,'testbasicretrieve');

            % Insert some partitioned data
            tableHandle.createIfNotExists();

            % Check if the table exists
            flag = tableHandle.exists();
            testCase.assertTrue(flag);

            % Create a unique row
            uuid = char(UUID.randomUUID());
            testSignature = ['john',uuid];
            dynamicEntity = azure.storage.table.DynamicTableEntity;
            dynamicEntity.addprop('Name');
            dynamicEntity.Name = testSignature;
            dynamicEntity.addprop('Value');
            dynamicEntity.Value = 'Sample';
            dynamicEntity.partitionKey = 'pk';
            dynamicEntity.rowKey = ['rk', uuid];
            dynamicEntity.initialize();

            % Create a table operation to execute on the database
            tableOperation = azure.storage.table.TableOperation.insert(dynamicEntity, true); % vectorized
            tableHandle.execute(tableOperation);

            % Create a dynamic resolver (return as Java HashMap)
            dResolver = com.mathworks.azure.sdk.DynamicResolver.getDynamicResolver();

            % Fetch the first inserted element
            pk = dynamicEntity.partitionKey;
            rk = dynamicEntity.rowKey;
            tableOperation = azure.storage.table.TableOperation.retrieve(pk, rk, dResolver);
            results = tableHandle.execute(tableOperation);

            % Assert the element that was fetched the one that was inserted
            testCase.assertEqual(results.Name, testSignature);
        end

        %% Test to retrieve a particular partition defined by a partionkey
        function testPartitionRetrieve(testCase)
            disp('Running testPartitionRetrieve');
            % Java import - used to create dummy data
            import java.util.UUID;

            % Use the storage account
            az = azure.storage.CloudStorageAccount;
            az.loadConfigurationSettings();
            az.connect();

            % To create a client
            client = az.getCloudTableClient();

            % Create a tableHandle
            tableHandle = azure.storage.table.CloudTable(client,'testpartition');

            % Insert some partitioned data
            tableHandle.createIfNotExists();

            % Check if the table exists
            flag = tableHandle.exists();
            testCase.assertTrue(flag);

            % Create a number of sample entities and insert into the database
            % 100 is a hard limit (see notes below)
            % Partition them appropriately modulo 20
            batchSize = 100;
            partitionSize = 20;
            for bCount = 1:batchSize
                dynamicEntity(bCount) = azure.storage.table.DynamicTableEntity;
                dynamicEntity(bCount).addprop('Name');
                dynamicEntity(bCount).Name = ['john',num2str(bCount)];
                dynamicEntity(bCount).partitionKey = ['pk', num2str(ceil(bCount/partitionSize))];
                dynamicEntity(bCount).rowKey = ['rk', char(UUID.randomUUID())];
                dynamicEntity(bCount).addprop('Value');
                dynamicEntity(bCount).Value = rand(1,1);
                dynamicEntity(bCount).initialize();
            end

            % Create a table operation to execute on the database and
            % insert the entities partition at a time since the batched
            % operation imposes that limitation that all entities need to
            % have the same partition key.
            tableOperation = azure.storage.table.TableOperation.insert(dynamicEntity(1:20), true); % vectorized
            tableHandle.execute(tableOperation);
            tableOperation = azure.storage.table.TableOperation.insert(dynamicEntity(21:40), true); % vectorized
            tableHandle.execute(tableOperation);
            tableOperation = azure.storage.table.TableOperation.insert(dynamicEntity(41:60), true); % vectorized
            tableHandle.execute(tableOperation);
            tableOperation = azure.storage.table.TableOperation.insert(dynamicEntity(61:80), true); % vectorized
            tableHandle.execute(tableOperation);
            tableOperation = azure.storage.table.TableOperation.insert(dynamicEntity(81:100), true); % vectorized
            tableHandle.execute(tableOperation);

            % Fetch the elements from the first partition
            pk = 'pk1';

            % Setup the query
            qc = azure.storage.table.QueryComparisons.EQUAL;
            filterCondition = azure.storage.table.TableQuery.generateFilterCondition('PartitionKey',qc,pk);

            % Create a new table query;
            tableQuery = azure.storage.table.TableQuery;

            % Create the return type
            finalQuery = tableQuery.where(filterCondition);

            % Query the database
            queryResults = tableHandle.execute(finalQuery);

            % Assert the element that was fetched the one that was inserted
            testCase.verifyEqual(numel(queryResults), partitionSize);

            % Cleanup
            tableHandle.deleteIfExists();
        end

        function testLogicalDataType(testCase)
            disp('Running testLogicalDataType');
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

            % Create a sample entity and insert into the database
            pk = 'Smith';
            rk = 'John';
            testValue = true;
            dynamicEntity = azure.storage.table.DynamicTableEntity;
            dynamicEntity.addprop('LogicalValue');
            dynamicEntity.partitionKey = pk;
            dynamicEntity.rowKey = rk;
            dynamicEntity.LogicalValue = testValue;
            dynamicEntity.initialize();

            % Create a table operation to execute on the database
            tableOperation = azure.storage.table.TableOperation.insertOrReplace(dynamicEntity);
            tableHandle.execute(tableOperation);

            % Retrieve a single entity
            % Create a dynamic resolver (return as Java HashMap)
            dResolver = com.mathworks.azure.sdk.DynamicResolver.getDynamicResolver();
            tableOperation = azure.storage.table.TableOperation.retrieve(pk, rk, dResolver);
            results = tableHandle.execute(tableOperation);
            resultVal = results(1).LogicalValue;
            testCase.assertEqual(resultVal, testValue);

            testValue = false;
            dynamicEntity = azure.storage.table.DynamicTableEntity;
            dynamicEntity.addprop('myLogicalValue');
            dynamicEntity.partitionKey = pk;
            dynamicEntity.rowKey = rk;
            dynamicEntity.myLogicalValue = testValue;
            dynamicEntity.initialize();

            % Create a table operation to execute on the database
            tableOperation = azure.storage.table.TableOperation.insertOrReplace(dynamicEntity);
            tableHandle.execute(tableOperation);

            % Retrieve a single entity
            % Create a dynamic resolver (return as Java HashMap)
            dResolver = com.mathworks.azure.sdk.DynamicResolver.getDynamicResolver();
            tableOperation = azure.storage.table.TableOperation.retrieve(pk, rk, dResolver);
            results = tableHandle.execute(tableOperation);
            resultVal = results(1).myLogicalValue;
            testCase.assertEqual(resultVal, testValue);
        end

        function testUUIDDataType(testCase)
            disp('Running testUUIDDataType');
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

            % Create a sample entity and insert into the database
            pk = 'Smith';
            rk = 'John';
            % 16 byte value
            testValue = '0123456789ABCDEF';
            dynamicEntity = azure.storage.table.DynamicTableEntity;
            dynamicEntity.addprop('myUUID');
            dynamicEntity.partitionKey = pk;
            dynamicEntity.rowKey = rk;
            dynamicEntity.myUUID = testValue;
            dynamicEntity.initialize();

            % Create a table operation to execute on the database
            tableOperation = azure.storage.table.TableOperation.insertOrReplace(dynamicEntity);
            tableHandle.execute(tableOperation);

            % Retrieve a single entity
            % Create a dynamic resolver (return as Java HashMap)
            dResolver = com.mathworks.azure.sdk.DynamicResolver.getDynamicResolver();
            tableOperation = azure.storage.table.TableOperation.retrieve(pk, rk, dResolver);
            results = tableHandle.execute(tableOperation);
            resultVal = results(1).myUUID;
            testCase.assertEqual(resultVal, testValue);
        end

        function testDateTimeDataType(testCase)
            disp('Running testDateTimeDataType');
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

            % Create a sample entity and insert into the database
            pk = 'Smith';
            rk = 'John';
            % a MATLAB datetime
            testValue = datetime;
            dynamicEntity = azure.storage.table.DynamicTableEntity;
            dynamicEntity.addprop('myDateTime');
            dynamicEntity.partitionKey = pk;
            dynamicEntity.rowKey = rk;
            dynamicEntity.myDateTime = testValue;
            dynamicEntity.initialize();

            % Create a table operation to execute on the database
            tableOperation = azure.storage.table.TableOperation.insertOrReplace(dynamicEntity);
            tableHandle.execute(tableOperation);

            % Retrieve a single entity
            % Create a dynamic resolver (return as Java HashMap)
            dResolver = com.mathworks.azure.sdk.DynamicResolver.getDynamicResolver();
            tableOperation = azure.storage.table.TableOperation.retrieve(pk, rk, dResolver);
            results = tableHandle.execute(tableOperation);
            resultVal = results(1).myDateTime;
            endTime = datetime;
            endTime.TimeZone = endTime.SystemTimeZone;
            % allow a 30s drift
            allowedTestDuration = duration('0:0:30');
            if endTime - resultVal < allowedTestDuration
                flag = true;
            else
                flag = false;
            end
            testCase.assertTrue(flag);
        end

        function testNullType(testCase)
            disp('Running testNullType');
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

            % Create a sample entity and insert into the database
            pk = 'Smith';
            rk = 'John';
            % a null once passed to Java
            testValue = [];
            dynamicEntity = azure.storage.table.DynamicTableEntity;
            dynamicEntity.addprop('myNull');
            dynamicEntity.partitionKey = pk;
            dynamicEntity.rowKey = rk;
            dynamicEntity.myNull = testValue;
            testCase.verifyError(@()dynamicEntity.initialize(), 'LOGGER:prefix');
%             dynamicEntity.initialize();
%
%             % Create a table operation to execute on the database
%             tableOperation = azure.storage.table.TableOperation.insertOrReplace(dynamicEntity);
%             tableHandle.execute(tableOperation);
%
%             % Retrieve a single entity
%             % Create a dynamic resolver (return as Java HashMap)
%             dResolver = com.mathworks.azure.sdk.DynamicResolver.getDynamicResolver();
%             tableOperation = azure.storage.table.TableOperation.retrieve(pk, rk, dResolver);
%             results = tableHandle.execute(tableOperation);
%             % test that no property is set
%             testCase.assertFalse(isprop(results,'myNull'));
        end

        function testInt64Type(testCase)
            disp('Running testInt64Type');
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

            % Create a sample entity and insert into the database
            pk = 'Smith';
            rk = 'John';
            % a null once passed to Java
            testValue = int64(99);
            dynamicEntity = azure.storage.table.DynamicTableEntity;
            dynamicEntity.addprop('myInt64');
            dynamicEntity.partitionKey = pk;
            dynamicEntity.rowKey = rk;
            dynamicEntity.myInt64 = testValue;
            dynamicEntity.initialize();

            % Create a table operation to execute on the database
            tableOperation = azure.storage.table.TableOperation.insertOrReplace(dynamicEntity);
            tableHandle.execute(tableOperation);

            % Retrieve a single entity
            % Create a dynamic resolver (return as Java HashMap)
            dResolver = com.mathworks.azure.sdk.DynamicResolver.getDynamicResolver();
            tableOperation = azure.storage.table.TableOperation.retrieve(pk, rk, dResolver);
            results = tableHandle.execute(tableOperation);
            resultVal = results(1).myInt64;
            testCase.assertTrue(isa(resultVal,'int64'));
            testCase.assertEqual(resultVal,int64(99));
        end

        function testInt32Type(testCase)
            disp('Running testInt32Type');
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

            % Create a sample entity and insert into the database
            pk = 'Smith';
            rk = 'John';
            % a null once passed to Java
            testValue = int32(99);
            dynamicEntity = azure.storage.table.DynamicTableEntity;
            dynamicEntity.addprop('myInt32');
            dynamicEntity.partitionKey = pk;
            dynamicEntity.rowKey = rk;
            dynamicEntity.myInt32 = testValue;
            dynamicEntity.initialize();

            % Create a table operation to execute on the database
            tableOperation = azure.storage.table.TableOperation.insertOrReplace(dynamicEntity);
            tableHandle.execute(tableOperation);

            % Retrieve a single entity
            % Create a dynamic resolver (return as Java HashMap)
            dResolver = com.mathworks.azure.sdk.DynamicResolver.getDynamicResolver();
            tableOperation = azure.storage.table.TableOperation.retrieve(pk, rk, dResolver);
            results = tableHandle.execute(tableOperation);
            resultVal = results(1).myInt32;
            testCase.assertTrue(isa(resultVal,'int32'));
            testCase.assertEqual(resultVal,int32(99));
        end

        function testInt16Type(testCase)
            disp('Running testInt16Type');
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

            % Create a sample entity and insert into the database
            pk = 'Smith';
            rk = 'John';
            % a null once passed to Java
            testValue = int16(99);
            dynamicEntity = azure.storage.table.DynamicTableEntity;
            dynamicEntity.addprop('myInt16');
            dynamicEntity.partitionKey = pk;
            dynamicEntity.rowKey = rk;
            dynamicEntity.myInt16 = testValue;
            dynamicEntity.initialize();

            % Create a table operation to execute on the database
            tableOperation = azure.storage.table.TableOperation.insertOrReplace(dynamicEntity);
            tableHandle.execute(tableOperation);

            % Retrieve a single entity
            % Create a dynamic resolver (return as Java HashMap)
            dResolver = com.mathworks.azure.sdk.DynamicResolver.getDynamicResolver();
            tableOperation = azure.storage.table.TableOperation.retrieve(pk, rk, dResolver);
            results = tableHandle.execute(tableOperation);
            resultVal = results(1).myInt16;
            testCase.assertTrue(isa(resultVal,'int32'));
            testCase.assertEqual(resultVal,int32(99));
        end

        function testBinaryType(testCase)
            disp('Running testBinaryType');
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

            % Create a sample entity and insert into the database
            pk = 'Smith';
            rk = 'John';
            % a null once passed to Java
            testValue = uint8('abcdefg');
            dynamicEntity = azure.storage.table.DynamicTableEntity;
            dynamicEntity.addprop('myBinary');
            dynamicEntity.partitionKey = pk;
            dynamicEntity.rowKey = rk;
            dynamicEntity.myBinary = testValue;
            dynamicEntity.initialize();

            % Create a table operation to execute on the database
            tableOperation = azure.storage.table.TableOperation.insertOrReplace(dynamicEntity);
            tableHandle.execute(tableOperation);

            % Retrieve a single entity
            % Create a dynamic resolver (return as Java HashMap)
            dResolver = com.mathworks.azure.sdk.DynamicResolver.getDynamicResolver();
            tableOperation = azure.storage.table.TableOperation.retrieve(pk, rk, dResolver);
            results = tableHandle.execute(tableOperation);
            resultVal = results(1).myBinary;
            testCase.assertTrue(isa(resultVal,'uint8'));
            testCase.assertEqual(char(resultVal),'abcdefg');
        end

        function testEmptyStr(testCase)
            disp('Running testEmptyStr');
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

            % Create a sample entity and insert into the database
            pk = 'Smith';
            rk = 'John';
            % a null once passed to Java
            testValue = '';
            dynamicEntity = azure.storage.table.DynamicTableEntity;
            dynamicEntity.addprop('myEmptyStr');
            dynamicEntity.partitionKey = pk;
            dynamicEntity.rowKey = rk;
            dynamicEntity.myEmptyStr = testValue;
            dynamicEntity.initialize();

            % Create a table operation to execute on the database
            tableOperation = azure.storage.table.TableOperation.insertOrReplace(dynamicEntity);
            tableHandle.execute(tableOperation);

            % Retrieve a single entity
            % Create a dynamic resolver (return as Java HashMap)
            dResolver = com.mathworks.azure.sdk.DynamicResolver.getDynamicResolver();
            tableOperation = azure.storage.table.TableOperation.retrieve(pk, rk, dResolver);
            results = tableHandle.execute(tableOperation);
            resultVal = results(1).myEmptyStr;
            testCase.assertEmpty(resultVal);
            testCase.assertTrue(ischar(resultVal));
        end


        function testEmptyStrs(testCase)
            disp('Running testEmptyStrs');
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

            % Create a sample entity and insert into the database
            pk = 'Smith';
            rk = 'John';
            % a null once passed to Java
            testValue = ['','',''];
            dynamicEntity = azure.storage.table.DynamicTableEntity;
            dynamicEntity.addprop('myEmptyStrs');
            dynamicEntity.partitionKey = pk;
            dynamicEntity.rowKey = rk;
            dynamicEntity.myEmptyStrs = testValue;
            dynamicEntity.initialize();

            % Create a table operation to execute on the database
            tableOperation = azure.storage.table.TableOperation.insertOrReplace(dynamicEntity);
            tableHandle.execute(tableOperation);

            % Retrieve a single entity
            % Create a dynamic resolver (return as Java HashMap)
            dResolver = com.mathworks.azure.sdk.DynamicResolver.getDynamicResolver();
            tableOperation = azure.storage.table.TableOperation.retrieve(pk, rk, dResolver);
            results = tableHandle.execute(tableOperation);
            resultVal = results(1).myEmptyStrs;
            testCase.assertEmpty(resultVal);
            testCase.assertTrue(ischar(resultVal));
        end

        function testDateTimeArray(testCase)
            disp('Running testDateTimeArray');
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

            % Create a sample entity and insert into the database
            pk = 'Smith';
            rk = 'John';
            % a null once passed to Java
            testValue1 = datetime;
            testValue2 = datetime;
            testValue = [testValue1, testValue2];
            dynamicEntity = azure.storage.table.DynamicTableEntity;
            dynamicEntity.addprop('myDatetimes');
            dynamicEntity.partitionKey = pk;
            dynamicEntity.rowKey = rk;
            dynamicEntity.myDatetimes = testValue;
            testCase.verifyError(@()dynamicEntity.initialize(), 'LOGGER:prefix');
        end

        function testStrArray(testCase)
            disp('Running testStrArray');
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

            % Create a sample entity and insert into the database
            pk = 'Smith';
            rk = 'John';
            % a null once passed to Java
            testValue = ["ABC", "DE"];
            dynamicEntity = azure.storage.table.DynamicTableEntity;
            dynamicEntity.addprop('myStrArray');
            dynamicEntity.partitionKey = pk;
            dynamicEntity.rowKey = rk;
            dynamicEntity.myStrArray = testValue;
            testCase.verifyError(@()dynamicEntity.initialize(), 'LOGGER:prefix');
        end

    end % methods


end % class
