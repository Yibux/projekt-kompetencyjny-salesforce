public with sharing class LoanWrapper {
    public LoanWrapper(Loan__c loan) {
        this.loanId = loan.Id;
        this.title = loan.Item__r.Name;
        this.authors = null;
        this.genre = loan.Item__r.Genre__c;
        this.dateDue = loan.End_Date__c;
        this.cover = null;
        this.description = loan.Item__r.Description__c;
        this.itemId = loan.Item__r.Id;
    }

    public LoanWrapper(Loan__c loan,Blob cover) {
        this.loanId = loan.Id;
        this.title = loan.Item__r.Name;
        this.authors = null;
        this.genre = loan.Item__r.Genre__c;
        this.dateDue = loan.End_Date__c;
        this.cover = cover;
        this.description = loan.Item__r.Description__c;
        this.itemId = loan.Item__r.Id;
    }

    public LoanWrapper(Loan__c loan,List<String> authors,Blob cover) {
        this.loanId = loan.Id;
        this.title = loan.Item__r.Name;
        this.authors = authors;
        this.genre = loan.Item__r.Genre__c;
        this.dateDue = loan.End_Date__c;
        this.cover = cover;
        this.description = loan.Item__r.Description__c;
        this.itemId = loan.Item__r.Id;
    }

    public Id loanId;
    public Id itemId;
    public String title;
    public List<String> authors;
    public String genre;
    public Date dateDue;
    public Blob cover;
    public String description;
}