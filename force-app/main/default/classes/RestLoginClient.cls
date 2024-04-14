@RestResource(UrlMapping='/Client__c/login/*')
global with sharing class RestLoginClient {
    @HttpPost //change to get after creating an outside endpoint
    global static void loginClient() {
        String jsonBody = RestContext.request.requestBody.toString();

        ClientWrapper client = (ClientWrapper) JSON.deserialize(jsonBody, ClientWrapper.class);

        if(checkCredentials(client.hash)) {
            RestContext.response.statusCode = 200;
            //Co mam zwrócić dokładnie?
            //trzebaby dodać metodę w stylu payload(client.hash) czy coś zwracającą to co ma być tam
        } else {
            RestContext.response.statusCode = 400;
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize('Invalid hash'));
        }
    }

    private static boolean checkCredentials(String hash) {
        List<Client__c> clients = [SELECT Hash__c FROM Client__c];
        for (Client__c client : clients) {
            if (client.Hash__c == hash) {
                return true;
            }
        }
        return false;
    }

    private static void payload(String hash) {
        RestContext.response.responseBody =  Blob.valueOf(JSON.serialize('Przykładowa zawartość bibiloteki, czy coś'));
    }
}