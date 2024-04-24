@isTest
public without sharing class RestChangePasswordTest {

    @TestSetup
    private static void setupData() {
        Client__c client = new Client__c(
            First_Name__c = 'Ronald',
            Last_Name__c ='McDonald',
            Email__c = 'a@a.pl',
            Hash__c = '108FD88365984CBD61CAD7F19D8135C66E68E63656F70C36AED9D685E810D423DDA316CF603A178EF9C81602201696ADF79F97F6CF339BB214E1490B41B8D937'
        );

        insert client;
    }
    
    @isTest
    static void testChangeHash_ValidHash() {
        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/Client__c/change';
        request.httpMethod = 'POST';
        String validHash = 'validHashValue';
        Client__c mockClient = [SELECT First_Name__c, Last_Name__c, Email__c, Hash__c FROM Client__c];

        request.requestBody = Blob.valueOf(JSON.serialize(mockClient));
        
        Test.startTest();
        RestChangePassword.changeHash();
        Test.stopTest();
        
        System.assertEquals(200, RestContext.response.statusCode);
        Client__c updatedClient = [SELECT First_Name__c, Last_Name__c, Email__c, Hash__c FROM Client__c];
        System.assertEquals(updatedClient.hash__c, mockClient.hash__c);
    }
    
    // @isTest
    // static void testChangeHash_InvalidHash() {
    //     RestRequest request = new RestRequest();
    //     request.requestURI = '/services/apexrest/Client__c/change/';
    //     request.httpMethod = 'POST';
    //     String invalidHash = 'short';
    //     RestChangePassword.ClientWrapper clientWrapper = new RestChangePassword.ClientWrapper();
    //     clientWrapper.hash = invalidHash;
    //     String requestBody = JSON.serialize(clientWrapper);
    //     request.requestBody = Blob.valueOf(requestBody);
    //     RestContext.request = request;
        
    //     Test.startTest();
    //     RestChangePassword.changeHash();
    //     Test.stopTest();
        
    //     System.assertEquals(400, RestContext.response.statusCode);
    //     String expectedResponseBody = JSON.serialize('Invalid hash');
    //     System.assertEquals(expectedResponseBody, RestContext.response.responseBody.toString());
    // }
    
    // @isTest
    // static void testChangeHash_InvalidClientHash() {
    //     RestRequest request = new RestRequest();
    //     request.requestURI = '/services/apexrest/Client__c/change/';
    //     request.httpMethod = 'POST';
    //     String validHash = 'validHashValue';
    //     RestChangePassword.ClientWrapper clientWrapper = new RestChangePassword.ClientWrapper();
    //     clientWrapper.hash = validHash;
    //     String requestBody = JSON.serialize(clientWrapper);
    //     request.requestBody = Blob.valueOf(requestBody);
    //     RestContext.request = request;
        
    //     Test.startTest();
    //     RestChangePassword.changeHash();
    //     Test.stopTest();
        
    //     System.assertEquals(400, RestContext.response.statusCode);
    //     String expectedResponseBody = JSON.serialize('Invalid Client hash');
    //     System.assertEquals(expectedResponseBody, RestContext.response.responseBody.toString());
    // }
}
