public with sharing class LoanWrapper {
    LoanWrapper(Loan__c loan) {
        lw.loanId = loan.Id;
        lw.title = loan.Item__r.Title__c;
        lw.author = loan.Item__r.Author__r.Name;
        lw.genre = loan.Item__r.Genre__c;
        lw.dateDue = loan.End_Date__c;
    }

    public Id loanId;
    public String title;
    public String author;
    public String genre;
    public Date dateDue;
}