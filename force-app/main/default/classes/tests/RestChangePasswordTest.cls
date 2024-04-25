@isTest
public without sharing class RestChangePasswordTest {

    @TestSetup
    private static void setupData() {
        Client__c client = new Client__c(
            First_Name__c = 'Ronald',
            Last_Name__c ='McDonald',
            Email__c = 'a@a.pl',
            Hash__c = '108FD88365984CBD61CAD7F19D8135C66E68E63656F70C36AED9D685E810D423'
        );

        insert client;
    }
    
    @isTest
    static void testChangeHash_ValidHash() {
        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/Client__c/change';
        request.httpMethod = 'POST';
        RestResponse response = new RestResponse();

        String newHash = 'A08FD88365984CBD61CAD7F19D8135C66E68E63656F70C36AED9D685E810D423';
        Client__c mockClient = [SELECT First_Name__c, Last_Name__c, Email__c, Hash__c FROM Client__c where Email__c = 'a@a.pl'];
        ClientWrapper clientWrapper = new ClientWrapper();

        clientWrapper.hash = newHash;
        clientWrapper.oldHash = mockClient.Hash__c;
        clientWrapper.mail = mockClient.Email__c;
        clientWrapper.firstName = mockClient.First_Name__c;
        clientWrapper.lastName = mockClient.Last_Name__c;

        request.requestBody = Blob.valueOf(JSON.serialize(clientWrapper));

        RestContext.request = request;
        RestContext.response = response;
        
        Test.startTest();
        RestChangePassword.changeHash();
        Test.stopTest();
        Client__c updatedClient = [SELECT First_Name__c, Last_Name__c, Email__c, Hash__c FROM Client__c];



        System.assertEquals(200, RestContext.response.statusCode);
        System.assertEquals(newHash, updatedClient.hash__c);
    }

    @isTest
    static void testChangePasswordWithInvalidNewHash() {
        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/Client__c/change';
        request.httpMethod = 'POST';
        RestResponse response = new RestResponse();

        String newHash = 'A08FD88365984CBD61CAD7F19D8135C66E68E63656F70C36AED9D685E810D423';
        Client__c mockClient = [SELECT First_Name__c, Last_Name__c, Email__c, Hash__c FROM Client__c where Email__c = 'a@a.pl'];
        ClientWrapper clientWrapper = new ClientWrapper();

        clientWrapper.hash = newHash;
        clientWrapper.oldHash = newHash;
        clientWrapper.mail = mockClient.Email__c;
        clientWrapper.firstName = mockClient.First_Name__c;
        clientWrapper.lastName = mockClient.Last_Name__c;

        request.requestBody = Blob.valueOf(JSON.serialize(clientWrapper));

        RestContext.request = request;
        RestContext.response = response;
        
        Test.startTest();
        RestChangePassword.changeHash();
        Test.stopTest();
        Client__c updatedClient = [SELECT First_Name__c, Last_Name__c, Email__c, Hash__c FROM Client__c];


        System.assertEquals(400, RestContext.response.statusCode);
        System.assertEquals('Invalid Client hash', RestContext.response.responseBody.toString().remove('"'));
    }

    @isTest
    static void testChangePasswordClientDoesNotExist() {
        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/Client__c/change';
        request.httpMethod = 'POST';
        RestResponse response = new RestResponse();

        String newHash = 'a';
        Client__c mockClient = [SELECT First_Name__c, Last_Name__c, Email__c, Hash__c FROM Client__c where Email__c = 'a@a.pl'];
        ClientWrapper clientWrapper = new ClientWrapper();

        clientWrapper.hash = newHash;
        clientWrapper.oldHash = mockClient.Hash__c;
        clientWrapper.mail = mockClient.Email__c;
        clientWrapper.firstName = mockClient.First_Name__c;
        clientWrapper.lastName = mockClient.Last_Name__c;

        request.requestBody = Blob.valueOf(JSON.serialize(clientWrapper));

        RestContext.request = request;
        RestContext.response = response;
        
        Test.startTest();
        RestChangePassword.changeHash();
        Test.stopTest();
        Client__c updatedClient = [SELECT First_Name__c, Last_Name__c, Email__c, Hash__c FROM Client__c];


        System.assertEquals(400, RestContext.response.statusCode);
        System.assertEquals('Invalid new hash', RestContext.response.responseBody.toString().remove('"'));
    }
    
}
