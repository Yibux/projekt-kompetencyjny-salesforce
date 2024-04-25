public with sharing class LoanWrapper {
    public LoanWrapper(Loan__c loan) {
        this.loanId = loan.Id;
        this.title = loan.Item__r.Title__c;
        this.author = loan.Item__r.Author__r.Name;
        this.genre = loan.Item__r.Genre__c;
        this.dateDue = loan.End_Date__c;
    }

    public Id loanId;
    public String title;
    public String author;
    public String genre;
    public Date dateDue;
}