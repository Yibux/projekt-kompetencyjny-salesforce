@RestResource(UrlMapping='/Client__c/login/*')
global with sharing class RestLoginClient {
    @HttpPost //change to get after creating an outside endpoint
    global static void loginClient() {
        String jsonBody = RestContext.request.requestBody.toString();

        ClientWrapper client = (ClientWrapper) JSON.deserialize(jsonBody, ClientWrapper.class);

        Id clientId = getClientId(client.hash);
        if(clientId == null) {
            RestContext.response.statusCode = 400;
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize('Invalid Client hash'));
            return;
        }

        payload(clientId);
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

    private static void payload(Id clientId) {
        List<Loan__c> loans = [SELECT Id, End_Date__c,Item__r.ID,Item__r.Description__c,Item__r.Genre__c, Item__r.Name FROM Loan__c WHERE Client__c =: clientId];
        Map<Id,List<String>> authors = getAuthorsFromItem(loans);
        List<LoanWrapper> payload = new List<LoanWrapper>();

        for (Loan__c loan : loans) {
            LoanWrapper lw;
            if(Test.isRunningTest()){
                 lw = new LoanWrapper(loan);
            } else{
                 lw = new LoanWrapper(loan,authors.get(loan.Item__c),ClientUtils.getCover(new List<ID>{loan.Item__r.ID}).get(loan.Item__r.ID));
            }
            payload.add(lw);
        } 

        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(payload));
    }

    private static Map<Id,List<String>> getAuthorsFromItem(List<Loan__c> loans){
        List<ID> IDs = new List<Id>();

        for(Loan__c loan : loans){
            IDs.add(loan.Item__c);
        }

        return ItemUtils.getAuthorsFromItem([SELECT Id,Name, Publisher__r.Name, Genre__c,Release_Date__c, Quantity__c, (SELECT Id, Account__r.Name FROM AccountJoinItem__r) FROM Item__c where ID in : IDs]);
    }
}