public with sharing class CacheUtility {
    
    public static List<Sobject> cacheList {
         get {
              if (cacheList == null) {
                   cacheList = [
                        SELECT Name
                        FROM Account
                   ];
              }

              return cacheList;
         }
         set;
    }

    public static Map<Id, Sobject> cacheMap {
         get {
              if (cacheMap == null) {
                   cacheMap = new Map<Id, Sobject>();
                   List<Sobject> dataRows = new List<Sobject>();
                   for (Sobject obj: dataRows) {
                        cacheMap.put((Id)obj.get('Id'), obj);
                   }
              }

              return cacheMap;
         }
         set;
    }
}

//CacheUtility.cacheMap.get('<rceordId>');