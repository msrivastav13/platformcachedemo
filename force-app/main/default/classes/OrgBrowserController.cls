public with sharing class OrgBrowserController {
    public static final String CACHE_PARTITION_NAME = 'metadata';

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
    public static List<Options> fetchObjectNamesFromCache() {
        List<Options> objectNames = new List<Options>();
        // Instantiate partition
        try {
            Cache.OrgPartition orgPartition = Cache.Org.getPartition(
                CACHE_PARTITION_NAME
            );
            if (
                orgPartition != null &&
                orgPartition.get(ObjectListCache.class, 'objectlist') != null
            ) {
                objectNames = (List<Options>) orgPartition.get('objectlist');
            } else {
                List<OrgBrowserController.Options> objectNamesFromSOQL = new List<OrgBrowserController.Options>();
                for (EntityDefinition obj : [
                    SELECT QualifiedApiName, Label
                    FROM EntityDefinition
                    ORDER BY Label
                    LIMIT 200
                ]) {
                    objectNamesFromSOQL.add(
                        new OrgBrowserController.Options(
                            obj.Label,
                            obj.QualifiedApiName
                        )
                    );
                }
                orgPartition.put(
                    'objectlistfromdescribe',
                    objectNamesFromSOQL,
                    300,
                    Cache.Visibility.ALL,
                    true
                );
            }
        } catch (exception e) {
            throw new AuraHandledException(e.getMessage());
        }

        return objectNames;
    }

    @AuraEnabled(cacheable=true)
    public static List<Options> fetchObjectNamesUsingGlobalDescribe() {
        List<Options> objectNames = new List<Options>();
        try {
            // Instantiate partition
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            for (String objectName : schemaMap.keySet()) {
                Schema.DescribeSObjectResult describeResult = schemaMap.get(objectName).getDescribe(SObjectDescribeOptions.DEFERRED);
                if(describeResult.isQueryable()) {
                    objectNames.add(
                        new Options(
                            describeResult.getLabel(),
                            objectName
                        )
                    );
                }
            }
        } catch (exception e) {
            throw new AuraHandledException(e.getMessage());
        }

        return objectNames;
    }

    @AuraEnabled(cacheable=true)
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
                    objectNames = (List<Options>) orgPartition.get('objectlistfromdescribe'
                    );
                } else {
                    List<OrgBrowserController.Options> objectNamesViaDescribe = new List<OrgBrowserController.Options>();
                    // Instantiate partition
                    Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
                    for (String objectName : schemaMap.keySet()) {
                        Schema.DescribeSObjectResult describeResult = schemaMap.get(objectName).getDescribe(SObjectDescribeOptions.DEFERRED);
                        if(describeResult.isQueryable()) {
                            objectNamesViaDescribe.add(
                                new OrgBrowserController.Options(
                                    describeResult
                                        .getLabel(),
                                    objectName
                                )
                            );
                        }
                    }
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

    public class Options {
        @AuraEnabled
        public String label { get; set; }
        public String value { get; set; }

        public Options(String label, String apiName) {
            this.label = label;
            this.value = value;
        }
    }
}
