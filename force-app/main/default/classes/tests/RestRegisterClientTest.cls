@isTest
private class RestRegisterClientTest {
    @TestSetup
    static void makeData(){
        Client__c client = new Client__c(
            First_Name__c = 'Ronald',
            Last_Name__c ='McDonald',
            Email__c = 'a@a.pl',
            Hash__c = '108FD88365984CBD61CAD7F19D8135C66E68E63656F70C36AED9D685E810D423'
        );
        insert client;
    }

    @isTest
    static void testRegisterClient_Success() {
        // Create a mock request
        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/Client__c/register';
        request.httpMethod = 'PUT';
        request.requestBody = Blob.valueOf('{"mail": "test@example.com", "firstName": "John", "lastName": "Doe", "hash": "A08FD88365984CBD61CAD7F19D8135C66E68E63656F70C36AED9D685E810D423"}');

        RestContext.request = request;
        RestContext.response = new RestResponse();

        RestRegisterClient.registerClient();

        System.assertEquals(200, RestContext.response.statusCode, 'Expected status code 200');
    }

    @isTest
    static void testRegisterClientExists() {
        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/Client__c/register';
        request.httpMethod = 'PUT';
        request.requestBody = Blob.valueOf('{"mail": "a@a.pl", "firstName": "Jane", "lastName": "Doe", "hash": "108FD88365984CBD61CAD7F19D8135C66E68E63656F70C36AED9D685E810D423"}');

        RestContext.request = request;
        RestContext.response = new RestResponse();

        Test.startTest();
        RestRegisterClient.registerClient();
        Test.stopTest();

        System.assertEquals(409, RestContext.response.statusCode, 'Expected status code 409');
    }
}