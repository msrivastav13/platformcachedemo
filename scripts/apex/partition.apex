Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
Cache.OrgPartition orgPartition = Cache.Org.getPartition('metadata');
orgPartition.put('objectlists', schemaMap, 300);
System.debug(orgPartition.get('objectlists'));