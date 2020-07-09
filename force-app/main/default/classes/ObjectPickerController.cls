/**
 * @description       : This class has methods that shows how to fetch all objects in org using Describes, Entity Definition(200 rows only)
                        We use platform cache to showcase the performance gains
 * @author            : Mohith Shrivastava
**/
public with sharing class ObjectPickerController {

    public static final String CACHE_PARTITION_NAME = 'metadata';

    /**
     * @description Gets list of object API name and label for 200 objects using SOQL on EntityDefinition object
     * @author Mohith Shrivastava
     * @return List<Options>
     **/
    @AuraEnabled(cacheable=true)
    public static List<Options> fetchObjectNames() {
        List<Options> objectNames = new List<Options>();
        try {
            for (EntityDefinition obj : [
                SELECT QualifiedApiName, Label
                FROM EntityDefinition
                ORDER BY Label
                LIMIT 200
            ]) {
                objectNames.add(new Options(obj.Label, obj.QualifiedApiName));
            }
        } catch (exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return objectNames;
    }

    @AuraEnabled(cacheable=true)
    /**
    * @description Gets list of object API name and label for 200 objects using SOQL on EntityDefinition object.
                        This method shows how to leverage org cache and use cache builder interface for handling cache misses
    * @author Mohith Shrivastava 
    * @return List<Options> 
    **/
    public static List<Options> fetchObjectNamesFromCache() {
        List<Options> objectNames = new List<Options>();
        // Instantiate partition
        try {
            Cache.OrgPartition orgPartition = Cache.Org.getPartition(
                CACHE_PARTITION_NAME
            );
            if (orgPartition != null) {
                objectNames = (List<Options>) orgPartition.get(
                    ObjectListCache.class,
                    'objectlist'
                );
            }
        } catch (exception e) {
            throw new AuraHandledException(e.getMessage());
        }

        return objectNames;
    }

    /**
     * @description This method shows how one can fetch all object api names and labels that can be queried using globalDescribe calls.
     * @author Mohith Shrivastava
     * @return List<Options>
     **/
    @AuraEnabled(cacheable=true)
    public static List<Options> fetchObjectNamesUsingGlobalDescribe() {
        List<Options> objectNames = new List<Options>();
        try {
            // Instantiate partition
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            for (String objectName : schemaMap.keySet()) {
                Schema.DescribeSObjectResult describeResult = schemaMap.get(
                        objectName
                    )
                    .getDescribe(SObjectDescribeOptions.DEFERRED);
                if (describeResult.isQueryable()) {
                    objectNames.add(
                        new Options(describeResult.getLabel(), objectName)
                    );
                }
            }
        } catch (exception e) {
            throw new AuraHandledException(e.getMessage());
        }

        objectNames.sort();

        return objectNames;
    }

    @AuraEnabled(cacheable=true)
    /**
     * @description This method shows how one can fetch all object api names and labels using globalDescribe calls.
     * The method shows how to use org cache and handle cache miss and specify TTL
     * @author Mohith Shrivastava
     * @return List<Options>
     **/
    public static List<Options> fetchObjectNamesUsingGlobalDescribeFromCache() {
        List<Options> objectNames = new List<Options>();
        try {
            // Instantiate partition
            Cache.OrgPartition orgPartition = Cache.Org.getPartition(
                CACHE_PARTITION_NAME
            );
            if (orgPartition != null) {
                // Load from Cache
                if (orgPartition.get('objectlistfromdescribe') != null) {
                    objectNames = (List<Options>) orgPartition.get(
                        'objectlistfromdescribe'
                    );
                } else {
                    List<ObjectPickerController.Options> objectNamesViaDescribe = new List<ObjectPickerController.Options>();
                    Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
                    for (String objectName : schemaMap.keySet()) {
                        Schema.DescribeSObjectResult describeResult = schemaMap.get(
                                objectName
                            )
                            .getDescribe(SObjectDescribeOptions.DEFERRED);
                        if (describeResult.isQueryable()) {
                            objectNamesViaDescribe.add(
                                new ObjectPickerController.Options(
                                    describeResult.getLabel(),
                                    objectName
                                )
                            );
                        }
                    }
                    // put the values into the org partition
                    orgPartition.put(
                        'objectlistfromdescribe',
                        objectNamesViaDescribe,
                        300,
                        Cache.Visibility.ALL,
                        true
                    );
                    return objectNamesViaDescribe;
                }
            }
        } catch (exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return objectNames;
    }

    public class Options implements Comparable {
        @AuraEnabled
        public String label { get; set; }
        public String value { get; set; }

        public Options(String label, String apiName) {
            this.label = label;
            this.value = value;
        }

        public Integer compareTo(Object ObjToCompare) {
            return label.CompareTo(((Options) ObjToCompare).label);
        }
    }
}