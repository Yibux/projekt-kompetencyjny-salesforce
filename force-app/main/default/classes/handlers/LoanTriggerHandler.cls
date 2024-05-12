public with sharing class LoanTriggerHandler {
    public static void increaseNumberOfLoansOnItem(List<Loan__c> loans){
        Map<Id,Item__c> items = getItems(loans);
        List<Item__c> itemsToUpdate = new List<Item__c>();
        for(Loan__c loan : loans){
            Item__c item =items.get(loan.Item__c);
            if(item.Borrowed_Items__c < item.Quantity__c){
                item.Borrowed_Items__c ++;
                itemsToUpdate.add(item);
            }else{
                loan.addError('This book has reached its maximum borrowing number');
            }
        }

        update itemsToUpdate;
    }


    private static Map<Id,Item__c> getItems(List<Loan__c> loans){
        List<Id> ids = new List<Id>();

        for(Loan__c loan : loans){
            ids.add(loan.Item__c);
        }

        return new Map<Id,Item__c>([SELECT Id,Quantity__c,Borrowed_Items__c FROM Item__c WHERE Id in : ids]);
    }
}