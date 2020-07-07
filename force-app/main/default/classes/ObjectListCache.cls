public with sharing class ObjectListCache implements Cache.CacheBuilder{
    public Object doLoad(String key) {
        List<ObjectPickerController.Options> objectNames = new List<ObjectPickerController.Options>();
        for(EntityDefinition obj: [SELECT  QualifiedApiName, Label FROM EntityDefinition order by Label LIMIT 200]) {
            objectNames.add(new ObjectPickerController.Options(obj.Label, obj.QualifiedApiName));
        }
        return objectNames;
    }
}
