@RestResource(UrlMapping='/Item__c/*')
global with sharing class RestGetItems {
    @HttpGet
    global static void getItems() {
        List<Item__c> items = [SELECT Id, Name, Author__r.Name, Publisher__r.Name, Genre__c, Title__c, 	Release_Date__c, Quantity__c FROM Item__c];
        List<ItemWrapper> payload = new List<ItemWrapper>();
        for (Item__c item : items) {
            ItemWrapper iw = new ItemWrapper(item);
            payload.add(iw);
        }
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(payload));
        RestContext.response.statusCode = 200;
    }
}
