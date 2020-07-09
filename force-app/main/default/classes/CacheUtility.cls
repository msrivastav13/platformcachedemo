/**
 * @description       : A Sample class that shows how to cache data in apex using static variables
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 **/

public with sharing class CacheUtility {
     
    public static List<Sobject> cacheList {
        get {
            if (cacheList == null) {
                cacheList = [SELECT Name FROM Account];
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
                for (Sobject obj : dataRows) {
                    cacheMap.put((Id) obj.get('Id'), obj);
                }
            }

            return cacheMap;
        }
        set;
    }
}
// Here is how you can invoke the cached variables
// CacheUtility.cacheList
//CacheUtility.cacheMap.get('<recordId>');
