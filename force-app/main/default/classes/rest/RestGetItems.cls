@RestResource(UrlMapping='/Item__c/getItems/*')
global with sharing class RestGetItems {
    @HttpGet
    global static void getItems() {
        List<Item__c> items = [SELECT Id,Name, Publisher__r.Name, Genre__c,Release_Date__c,Quantity__c,Borrowed_Items__c, (SELECT Id, Account__r.Name FROM AccountJoinItem__r) FROM Item__c];
        List<ItemWrapper> payload = new List<ItemWrapper>();
        Map<Id,List<String>> authors = ItemUtils.getAuthorsFromItem(items);
        for (Item__c item : items) {
            ItemWrapper iw = new ItemWrapper(item);
            if(Test.isRunningTest()){
                iw = new ItemWrapper(item);
            } else{
                iw = new ItemWrapper(item,authors.get(item.Id),ClientUtils.getCover(new List<ID>{item.ID}).get(item.ID));
            }
            payload.add(iw);
        }
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(payload));
        RestContext.response.statusCode = 200;
    }
}
