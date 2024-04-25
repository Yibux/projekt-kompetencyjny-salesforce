@isTest
private class RestRegisterClientTest {

    @isTest
    static void testRegisterClient_NewClient() {
        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/Client__c/register/';
        request.httpMethod = 'PUT';
        RestRegisterClient.ClientWrapper clientWrapper = new RestRegisterClient.ClientWrapper();
        clientWrapper.mail = 'test@example.com';
        clientWrapper.firstName = 'John';
        clientWrapper.lastName = 'Doe';
        clientWrapper.hash = 'validHashValue';
        String requestBody = JSON.serialize(clientWrapper);
        request.requestBody = Blob.valueOf(requestBody);
        RestContext.request = request;
        
        Test.startTest();
        RestRegisterClient.registerClient();
        Test.stopTest();
        
        System.assertEquals(200, RestContext.response.statusCode);
        List<Client__c> insertedClients = [SELECT Id FROM Client__c WHERE Email__c = :clientWrapper.mail];
        System.assertEquals(1, insertedClients.size());
        Client__c insertedClient = insertedClients[0];
        System.assertEquals(clientWrapper.mail, insertedClient.Email__c);
        System.assertEquals(clientWrapper.firstName, insertedClient.First_Name__c);
        System.assertEquals(clientWrapper.lastName, insertedClient.Last_Name__c);
        System.assertEquals(clientWrapper.hash, insertedClient.Hash__c);
    }
    
    @isTest
    static void testRegisterClient_ExistingClient() {
        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/Client__c/register/';
        request.httpMethod = 'PUT';
        RestRegisterClient.ClientWrapper clientWrapper = new RestRegisterClient.ClientWrapper();
        clientWrapper.mail = 'existing@example.com';
        clientWrapper.firstName = 'Jane';
        clientWrapper.lastName = 'Doe';
        clientWrapper.hash = 'validHashValue';
        String requestBody = JSON.serialize(clientWrapper);
        request.requestBody = Blob.valueOf(requestBody);
        RestContext.request = request;
        
        Test.startTest();
        RestRegisterClient.registerClient();
        Test.stopTest();
        
        System.assertEquals(409, RestContext.response.statusCode);
        String expectedResponseBody = JSON.serialize('A user with this mail already exists');
        System.assertEquals(expectedResponseBody, RestContext.response.responseBody.toString());
    }
}