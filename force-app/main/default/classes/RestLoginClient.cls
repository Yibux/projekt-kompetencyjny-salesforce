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
        List<Loan__c> loans = [SELECT End_Date__c, Item__r.Genre__c, Item__r.Author__c, Item__r.Title__c FROM Loan__c WHERE Client__c =: clientId];

        List<LoanWrapper> payload = new List<LoanWrapper>();

        for (Loan__c loan : loans) {
            LoanWrapper lw = new LoanWrapper();
            lw.title = loan.Item__r.Title__c;
            lw.author = loan.Item__r.Author__c;
            lw.genre = loan.Item__r.Genre__c;
            lw.dateDue = loan.End_Date__c;
            payload.add(lw);
        }

        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(payload));
    }
}