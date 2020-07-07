public with sharing class ObjectListCache implements Cache.CacheBuilder{
    public Object doLoad(String key) {
        List<OrgBrowserController.Options> objectNames = new List<OrgBrowserController.Options>();
        for(EntityDefinition obj: [SELECT  QualifiedApiName, Label FROM EntityDefinition order by Label LIMIT 200]) {
            objectNames.add(new OrgBrowserController.Options(obj.Label, obj.QualifiedApiName));
        }
        return objectNames;
    }
}
