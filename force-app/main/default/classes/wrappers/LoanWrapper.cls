public with sharing class LoanWrapper {
    public LoanWrapper(Loan__c loan) {
        this.loanId = loan.Id;
        this.title = loan.Item__r.Name;
        this.authors = null;
        this.genre = loan.Item__r.Genre__c;
        this.dateDue = loan.End_Date__c;
        this.cover = null;
        this.Description = loan.Item__r.Description__c;
    }

    public LoanWrapper(Loan__c loan,Blob cover) {
        this.loanId = loan.Id;
        this.title = loan.Item__r.Name;
        this.authors = null;
        this.genre = loan.Item__r.Genre__c;
        this.dateDue = loan.End_Date__c;
        this.cover = cover;
        this.Description = loan.Item__r.Description__c;
    }

    public LoanWrapper(Loan__c loan,List<String> authors,Blob cover) {
        this.loanId = loan.Id;
        this.title = loan.Item__r.Name;
        this.authors = authors;
        this.genre = loan.Item__r.Genre__c;
        this.dateDue = loan.End_Date__c;
        this.cover = cover;
        this.Description = loan.Item__r.Description__c;
    }

    public Id loanId;
    public String title;
    public List<String> authors;
    public String genre;
    public Date dateDue;
    public Blob cover;
    public String Description;
}