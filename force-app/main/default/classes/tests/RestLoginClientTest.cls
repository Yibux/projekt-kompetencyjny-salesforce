@isTest
private class RestLoginClientTest {

    @TestSetup
    static void makeData(){
        Client__c client = new Client__c(
            First_Name__c = 'Ronald',
            Last_Name__c ='McDonald',
            Email__c = 'a@a.pl',
            Hash__c = '108FD88365984CBD61CAD7F19D8135C66E68E63656F70C36AED9D685E810D423'
        );
        insert client;

        Publisher__c publisher = new Publisher__c(
            Name = 'Test Publisher'
        );
        insert publisher;
        
        Item__c mockItem = new Item__c(
            Name='W pustyni i w puszczy', Genre__c = 'fantasy', Publisher__c = publisher.Id, Quantity__c = 1, Release_Date__c = Date.today()
        );
        insert mockItem;

        Loan__c mockLoan = new Loan__c(
            Client__c = client.Id, Item__c = mockItem.Id, End_Date__c = Date.today() + 7, Start_Date__c = Date.today()
        );
        insert mockLoan;
    }
    

    @isTest
    static void testLoginClient_ValidHash() {
        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/Client__c/login';
        request.httpMethod = 'POST';
        RestResponse response = new RestResponse();

        Client__c mockClient = [SELECT First_Name__c, Last_Name__c, Email__c, Hash__c FROM Client__c where Email__c = 'a@a.pl'];
        ClientWrapper clientWrapper = new ClientWrapper();

        clientWrapper.hash = mockClient.Hash__c;
        clientWrapper.mail = mockClient.Email__c;
        clientWrapper.firstName = mockClient.First_Name__c;
        clientWrapper.lastName = mockClient.Last_Name__c;

        request.requestBody = Blob.valueOf(JSON.serialize(clientWrapper));

        RestContext.request = request;
        RestContext.response = response;
        
        Test.startTest();
        RestLoginClient.loginClient();
        Test.stopTest();
        
        System.assertEquals(200, RestContext.response.statusCode);

        List<LoanWrapper> responseBody = (List<LoanWrapper>)JSON.deserialize(RestContext.response.responseBody.toString(), List<LoanWrapper>.class);
        List<Loan__c> loans = [SELECT Id, End_Date__c, Item__r.Genre__c FROM Loan__c where Item__r.Name = 'W pustyni i w puszczy'];

        for (Integer i = 0; i < loans.size(); i++) {
            Loan__c loan = loans[i];
            LoanWrapper loanWrapper = responseBody[i];
            System.assertEquals(loan.Id, loanWrapper.loanId);
            System.assertEquals(loan.End_Date__c, loanWrapper.dateDue);
            System.assertEquals(loan.Item__r.Genre__c, loanWrapper.genre);
        }

    } 
    
    @isTest
    static void testLoginClientInValidHash() {
        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/Client__c/login';
        request.httpMethod = 'POST';
        RestResponse response = new RestResponse();
        String badHash =' as';

        Client__c mockClient = [SELECT First_Name__c, Last_Name__c, Email__c, Hash__c FROM Client__c where Email__c = 'a@a.pl'];
        ClientWrapper clientWrapper = new ClientWrapper();

        clientWrapper.hash = badHash;
        clientWrapper.oldHash = ' ';
        clientWrapper.mail = mockClient.Email__c;
        clientWrapper.firstName = mockClient.First_Name__c;
        clientWrapper.lastName = mockClient.Last_Name__c;

        request.requestBody = Blob.valueOf(JSON.serialize(clientWrapper));

        RestContext.request = request;
        RestContext.response = response;
        
        Test.startTest();
        RestLoginClient.loginClient();
        Test.stopTest();
        
        
        System.assertEquals('Invalid Client hash', RestContext.response.responseBody.toString().remove('"'));
        System.assertEquals(400, RestContext.response.statusCode);
    }
}