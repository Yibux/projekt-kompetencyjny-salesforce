public without sharing class AccountJoinItemController {
    @AuraEnabled(cacheable=false)
    public static void createAccountJoinItem(Id accountId, Id itemId) {
        AccountJoinItem__c accountJoinItem = new AccountJoinItem__c(Account__c = accountId, Item__c = itemId);
        System.debug('accountJoinItem: ' + accountJoinItem);
        try{
            insert accountJoinItem;
        } catch (Exception e) {
            System.debug('Error: ' + e.getMessage());
        }
    }
}