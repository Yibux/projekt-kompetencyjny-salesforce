public with sharing class AccountJoinItemController {
    @AuraEnabled
    public static createAccountJoinItem(Id accountId, Id itemId) {
        return new AccountJoinItem(Account__c = accountId, Item__c = itemId, Name = accountId+itemId);
    }
}