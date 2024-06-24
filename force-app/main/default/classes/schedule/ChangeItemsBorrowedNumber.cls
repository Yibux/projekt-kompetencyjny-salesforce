public with sharing class ChangeItemsBorrowedNumber implements Schedulable {
    public void execute(SchedulableContext sc) {
        List<Item__c> itemsToUpdate = new List<Item__c>();
        
        for (Item__c item : [
            SELECT Id, Borrowed_Items__c, (SELECT Id FROM Loans__r WHERE Start_Date__c >= TODAY AND End_Date__c <= TODAY)
            FROM Item__c
        ]) {
            Integer loanCount = item.Loans__r.size();
            
            item.Borrowed_Items__c = loanCount;
            itemsToUpdate.add(item);
        }
        
        if (!itemsToUpdate.isEmpty()) {
            update itemsToUpdate;
        }
    }
}