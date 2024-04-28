public with sharing class LoanWrapper {
    public LoanWrapper(Loan__c loan) {
        this.loanId = loan.Id;
        this.title = loan.Item__r.Name;
        // this.author = loan.Item__r.Author__r.Name;
        this.genre = loan.Item__r.Genre__c;
        this.dateDue = loan.End_Date__c;
        this.cover = null;
    }

    public LoanWrapper(Loan__c loan,Blob cover) {
        this.loanId = loan.Id;
        this.title = loan.Item__r.Name;
        // this.author = loan.Item__r.Author__r.Name;
        this.genre = loan.Item__r.Genre__c;
        this.dateDue = loan.End_Date__c;
        this.cover = cover;
    }

    public Id loanId;
    public String title;
    public String author;
    public String genre;
    public Date dateDue;
    public Blob cover;
}