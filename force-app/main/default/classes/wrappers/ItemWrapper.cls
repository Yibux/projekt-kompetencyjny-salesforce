public with sharing class ItemWrapper {
    public String id;
    public String bookName;
    public String author;
    public String publisher;
    public String genre;
    public String title;
    public Decimal quantity;

    public ItemWrapper(Item__c item) {
        this.id = item.Id;
        this.bookName = item.Name;
        this.author = item.Author__r.Name;
        this.publisher = item.Publisher__r.Name;
        this.genre = item.Genre__c;
        this.title = item.Title__c;
        this.quantity = item.Quantity__c;
    }
}