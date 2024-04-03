@RestResource(UrlMapping='/Client__c/register/*')
global with sharing class RestRegisterClient {
    @HttpPut
    global static void registerClient() {
        String jsonBody = RestContext.request.requestBody.toString();

        ClientWrapper.ClientWrapper client = (ClientWrapper.ClientWrapper) JSON.deserialize(jsonBody, ClientWrapper.class);

        if(!checkIfMailExists(client.mail)) {
            createNewClient(client);

            RestContext.response.statusCode = 200;
        } else {
            errorClientExists();
        }
    }




    private boolean checkIfMailExists(String mail) {
        List<Client__c> existingClients = [SELECT Id FROM Client__c WHERE Email__c = :mail LIMIT 1];
        return !existingClients.isEmpty();
    }

    private void createNewClient(ClientWrapper.ClientWrapper client) {
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
    
    private void errorClientExists() {
        RestContext.response.statusCode = 409;
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize('A user with this mail already exists'));
    }

    private boolean isHashValid(String hash) {
        return hash.length() == 64;
    }

    private void insertClient(ClientWrapper.ClientWrapper) {
        Client__c newClient = new Client__c();
        newClient.Email__c = client.Mail;
        newClient.First_Name__c = client.First_Name;
        newClient.Last_Name__c = client.Last_Name;
        newClient.Hash__c = client.Hash;

        insert newClient;
    }
}
