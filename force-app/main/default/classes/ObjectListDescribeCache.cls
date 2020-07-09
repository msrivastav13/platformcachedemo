/**
 * @description       : An Example class that shows how to implement CacheBuilder Interface for Describe calls
 * @author            : Mohith Shrivastava
 **/
public with sharing class ObjectListDescribeCache implements Cache.CacheBuilder {

    public Object doLoad(String key) {
        List<ObjectPickerController.Options> objectNames = new List<ObjectPickerController.Options>();
        Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        for(String objectName : schemaMap.keySet()) {
            objectNames.add(new ObjectPickerController.Options(schemaMap.get(objectName).getDescribe(SObjectDescribeOptions.DEFERRED).getLabel(), objectName));
        }
        return objectNames;
    }
}
