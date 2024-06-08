@RestResource(urlMapping='/Client__c/getClient/*')
global with sharing class RestClient {
    @HttpPost
    global static void getClinet(String email) {
        Client__c client = [SELECT Id, Email__c, First_Name__c, Last_Name__c FROM Client__c WHERE Email__c = :email];

        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(client));
        RestContext.response.statusCode = 200;
    }
}