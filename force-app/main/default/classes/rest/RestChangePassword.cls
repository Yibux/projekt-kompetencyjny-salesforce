@RestResource(UrlMapping='/Client__c/change/*')
global with sharing class RestChangePassword {
    @HttpPost
    global static void changeHash() {
        String jsonBody = RestContext.request.requestBody.toString();

        ClientWrapper clientNew = (ClientWrapper) JSON.deserialize(jsonBody, ClientWrapper.class);

        if(!isHashValid(clientNew.hash)) {
            RestContext.response.statusCode = 400;
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize('Invalid new hash'));
            return;
        }

        Client__c clientOld = getClient(clientNew.oldHash);

        if(clientOld == null) {
            RestContext.response.statusCode = 400;
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize('Invalid Client hash'));
            return;
        }

        changeClientHash(clientOld, clientNew.hash);
        RestContext.response.statusCode = 200;
    }

    private static Client__c getClient(String hash) {
        List<Client__c> clients = [SELECT Hash__c FROM Client__c];
        for (Client__c client : clients) {
            if (client.Hash__c == hash) {
                return client;
            }
        }
        return null;
    }

    private static void changeClientHash(Client__c client, String hash) {
        client.Hash__c = hash;

        update client;
    }

    private static boolean isHashValid(String hash) {
        return hash.length() == 64;
    }
}