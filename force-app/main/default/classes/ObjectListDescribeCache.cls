public with sharing class ObjectListDescribeCache implements Cache.CacheBuilder{

    public Object doLoad(String key) {
        List<OrgBrowserController.Options> objectNames = new List<OrgBrowserController.Options>();
        // Instantiate partition
        Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        for(String objectName : schemaMap.keySet()) {
            objectNames.add(new OrgBrowserController.Options(schemaMap.get(objectName).getDescribe(SObjectDescribeOptions.DEFERRED).getLabel(), objectName));
        }
        return objectNames;
    }
}
