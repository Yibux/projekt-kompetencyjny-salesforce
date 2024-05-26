trigger LoanTrigger on Loan__c (before insert) {

    if(Trigger.isBefore && Trigger.isInsert){
        LoanTriggerHandler.increaseNumberOfLoansOnItem(Trigger.new);
    }

}