package com.mathworks.azure.sdk;
/**
* Dynamic Entity resolver for use with MATLAB
*
*
*/

// Copyright 2018 The MathWorks, Inc.

// Azure Imports
import com.microsoft.azure.storage.table.EntityResolver;
import com.microsoft.azure.storage.table.EntityProperty;

// Java Imports
import java.util.HashMap;
import java.util.Date;
import java.util.Map;
import java.util.Map.Entry;

/* Dynamic Resolver */
public class DynamicResolver
{
  public static EntityResolver getDynamicResolver()
  {
    // Create an entity resolver for HashMap type
    EntityResolver<HashMap<String, EntityProperty>> resolver = new EntityResolver<HashMap<String, EntityProperty>>() {

      // Implement the resolve method
      public HashMap<String, EntityProperty> resolve(String partitionkey, String rowKey, Date timeStamp, HashMap<String, EntityProperty> properties, String etag) {

        // Create a new HashMap
        HashMap<String, EntityProperty> returnedHash = new HashMap<String, EntityProperty>();

        // Loop over each entry in the set
        for (Entry<String, EntityProperty> entry : properties.entrySet()) {

          // Extract the key
          String key = entry.getKey();

          // Store the value into the hash
          returnedHash.put(key, entry.getValue());
        }
        return returnedHash;
      }
    };

    return resolver;
  }
}
