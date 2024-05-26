
@RestResource(UrlMapping='/Item__c/borrow/*')
global with sharing class BorrowItem {
    @HttpPost
    global static void changeHash() {
        Item__c item = null;
        ID clientId = null;
        String jsonBody = RestContext.request.requestBody.toString();

        Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(jsonBody);
        Id itemID = (Id) data.get('Id');
        String hash = (String) data.get('Hash');

        try{
            item = [SELECT Id,Quantity__c,Borrowed_Items__c FROM Item__c WHERE Id =: itemID];
        }catch (QueryException e){
            RestContext.response.statusCode = 404;
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize('There is no item with ID '+itemID));
            return;
        }

        if(item.Quantity__c <= item.Borrowed_Items__c) {
            RestContext.response.statusCode = 404;
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize('Item is no available'));
            return;
        }


        clientId = getClientId(hash);
        if(clientId == null){
            RestContext.response.statusCode = 404;
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize('There is no client with hash '+hash));
            return;
        }

        try {
            insert new Loan__c(Client__c = clientId,Item__c = item.Id,Start_Date__c = Date.today(),End_Date__c = Date.today().addDays(3));
        }catch (Exception e){
            RestContext.response.statusCode = 404;
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(e.getMessage()));
            return;
        }

        RestContext.response.statusCode = 200;
    }

    private static Id getClientId(String hash) {
        List<Client__c> clients = [SELECT Hash__c FROM Client__c];
        for (Client__c client : clients) {
            if (client.Hash__c == hash) {
                return client.Id;
            }
        }
        return null;
    }
}