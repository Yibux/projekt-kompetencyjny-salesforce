@isTest
private class RestChangePasswordTest {
    
    @isTest
    static void testChangeHash_ValidHash() {
        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/Client__c/change/';
        request.httpMethod = 'POST';
        String validHash = 'validHashValue';
        RestChangePassword.Client__c mockClient = new RestChangePassword.Client__c(Hash__c = validHash);
        RestChangePassword.ClientWrapper clientWrapper = new RestChangePassword.ClientWrapper();
        clientWrapper.hash = validHash;
        String requestBody = JSON.serialize(clientWrapper);
        request.requestBody = Blob.valueOf(requestBody);
        RestContext.request = request;
        
        Test.startTest();
        RestChangePassword.changeHash();
        Test.stopTest();
        
        System.assertEquals(200, RestContext.response.statusCode);
        RestChangePassword.Client__c updatedClient = [SELECT Hash__c FROM Client__c WHERE Hash__c = :validHash];
        System.assertNotEquals(null, updatedClient);
    }
    
    @isTest
    static void testChangeHash_InvalidHash() {
        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/Client__c/change/';
        request.httpMethod = 'POST';
        String invalidHash = 'short';
        RestChangePassword.ClientWrapper clientWrapper = new RestChangePassword.ClientWrapper();
        clientWrapper.hash = invalidHash;
        String requestBody = JSON.serialize(clientWrapper);
        request.requestBody = Blob.valueOf(requestBody);
        RestContext.request = request;
        
        Test.startTest();
        RestChangePassword.changeHash();
        Test.stopTest();
        
        System.assertEquals(400, RestContext.response.statusCode);
        String expectedResponseBody = JSON.serialize('Invalid hash');
        System.assertEquals(expectedResponseBody, RestContext.response.responseBody.toString());
    }
    
    @isTest
    static void testChangeHash_InvalidClientHash() {
        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/Client__c/change/';
        request.httpMethod = 'POST';
        String validHash = 'validHashValue';
        RestChangePassword.ClientWrapper clientWrapper = new RestChangePassword.ClientWrapper();
        clientWrapper.hash = validHash;
        String requestBody = JSON.serialize(clientWrapper);
        request.requestBody = Blob.valueOf(requestBody);
        RestContext.request = request;
        
        Test.startTest();
        RestChangePassword.changeHash();
        Test.stopTest();
        
        System.assertEquals(400, RestContext.response.statusCode);
        String expectedResponseBody = JSON.serialize('Invalid Client hash');
        System.assertEquals(expectedResponseBody, RestContext.response.responseBody.toString());
    }
}
