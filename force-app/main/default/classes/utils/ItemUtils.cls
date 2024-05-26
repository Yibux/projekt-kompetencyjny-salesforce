public with sharing class ItemUtils {
    public static Map<Id,List<String>> getAuthorsFromItem(List<Item__c> items){
        Map<Id,List<String>> authors = new Map<Id, List<String>>();

        for(Item__c item : items) {
            if(!authors.containsKey(item.Id)){
                authors.put(item.Id,new List<String>());
            }
            for(AccountJoinItem__c ajItem : item.AccountJoinItem__r) {
                authors.get(item.Id).add(ajItem.Account__r.Name);
            }
        }

        return authors;
    }
}