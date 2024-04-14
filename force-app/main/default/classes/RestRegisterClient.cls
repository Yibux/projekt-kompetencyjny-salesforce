@RestResource(UrlMapping='/Client__c/register/*')
global with sharing class RestRegisterClient {
    @HttpPut
    global static void registerClient() {
        String jsonBody = RestContext.request.requestBody.toString();

        ClientWrapper client = (ClientWrapper) JSON.deserialize(jsonBody, ClientWrapper.class);

        if(!checkIfMailExists(client.mail)) {
            createNewClient(client);

            RestContext.response.statusCode = 200;
        } else {
            errorClientExists();
        }
    }

    private static boolean checkIfMailExists(String mail) {
        List<Client__c> existingClients = [SELECT Id FROM Client__c WHERE Email__c =: mail LIMIT 1];
        return !existingClients.isEmpty();
    }

    private static void createNewClient(ClientWrapper client) {
        if(isHashValid(client.hash)) {
            try {
                insertClient(client);
            } catch (DmlException e) {
                RestContext.response.statusCode = 400;
                RestContext.response.responseBody = Blob.valueOf(JSON.serialize('Error while inserting new client. Check if your data is valid. Error: ' + e.getMessage()));
            }
        } else {
            RestContext.response.statusCode = 400;
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize('Invalid hash'));
        }
    }
    
    private static void errorClientExists() {
        RestContext.response.statusCode = 409;
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize('A user with this mail already exists'));
    }

    private static boolean isHashValid(String hash) {
        return hash.length() == 64;
    }

    private static void insertClient(ClientWrapper client) {
        Client__c newClient = new Client__c();
        newClient.Email__c = client.mail;
        newClient.First_Name__c = client.firstName;
        newClient.Last_Name__c = client.lastName;
        newClient.Hash__c = client.hash;

        insert newClient;
    }
}
