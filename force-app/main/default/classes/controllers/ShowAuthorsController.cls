/**
 * Created by Kamcioszek on 20.05.2024.
 */

public with sharing class ShowAuthorsController {
    @AuraEnabled(Cacheable=true)
    public static List<AccountJoinItem__c> getAllItemsAccounts(Id itemId) {
        return [select Id, Account__r.Name from AccountJoinItem__c where Item__c =: itemId];
    }
}