/**
 * @description       : An Example class that shows how to implement CacheBuilder Interface for SOQL query
 * @author            : Mohith Shrivastava
 **/

public with sharing class ObjectListCache implements Cache.CacheBuilder {
    /**
     * @description Build data to cache
     * @author Mohith Shrivastava
     * @param key
     * @return Object
     **/
    public Object doLoad(String key) {
        List<ObjectPickerController.Options> objectNames = new List<ObjectPickerController.Options>();
        for (EntityDefinition obj : [
            SELECT QualifiedApiName, Label
            FROM EntityDefinition
            ORDER BY Label
            LIMIT 200
        ]) {
            objectNames.add(
                new ObjectPickerController.Options(
                    obj.Label,
                    obj.QualifiedApiName
                )
            );
        }
        return objectNames;
    }
}
