@isTest
private class RestLoginClientTest {
    
    @isTest
    static void testLoginClient_ValidHash() {
        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/Client__c/login/';
        request.httpMethod = 'POST';
        String validHash = 'validHashValue';
        RestLoginClient.ClientWrapper clientWrapper = new RestLoginClient.ClientWrapper();
        clientWrapper.hash = validHash;
        String requestBody = JSON.serialize(clientWrapper);
        request.requestBody = Blob.valueOf(requestBody);
        RestContext.request = request;
        
        Client__c mockClient = new Client__c(Hash__c = validHash);
        insert mockClient;
        
        Item__c mockItem = new Item__c(Genre__c = 'Test Genre', Title__c = 'Test Title');
        insert mockItem;
        Loan__c mockLoan = new Loan__c(Client__c = mockClient.Id, Item__c = mockItem.Id);
        insert mockLoan;
        
        Test.startTest();
        RestLoginClient.loginClient();
        Test.stopTest();
        
        System.assertEquals(200, RestContext.response.statusCode);
        List<RestLoginClient.LoanWrapper> responseBody = (List<RestLoginClient.LoanWrapper>)JSON.deserialize(RestContext.response.responseBody.toString(), List<RestLoginClient.LoanWrapper>.class);
        System.assertNotEquals(null, responseBody);
        System.assertEquals(1, responseBody.size());
        RestLoginClient.LoanWrapper loan = responseBody[0];
        System.assertEquals(mockLoan.Id, loan.id);
        System.assertEquals(mockLoan.End_Date__c, loan.end_date);
        System.assertEquals(mockItem.Genre__c, loan.genre);
        System.assertEquals(mockItem.Title__c, loan.title);
    }
    
    @isTest
    static void testLoginClient_InvalidHash() {
        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/Client__c/login/';
        request.httpMethod = 'POST';
        String invalidHash = 'invalidHashValue';
        RestLoginClient.ClientWrapper clientWrapper = new RestLoginClient.ClientWrapper();
        clientWrapper.hash = invalidHash;
        String requestBody = JSON.serialize(clientWrapper);
        request.requestBody = Blob.valueOf(requestBody);
        RestContext.request = request;
        
        Test.startTest();
        RestLoginClient.loginClient();
        Test.stopTest();
        
        System.assertEquals(400, RestContext.response.statusCode);
        String expectedResponseBody = JSON.serialize('Invalid Client hash');
        System.assertEquals(expectedResponseBody, RestContext.response.responseBody.toString());
    }
}
