public with sharing class ItemWrapper {
    public String id;
    public String author;
    public String publisher;
    public String genre;
    public String title;
    public Decimal quantity;
    public Blob cover;

    public ItemWrapper(Item__c item) {
        this.id = item.Id;
        this.title = item.Name;
        // this.author = item.Author__r.Name;
        this.publisher = item.Publisher__r.Name;
        this.genre = item.Genre__c;
        this.quantity = item.Quantity__c;
        this.cover = null;
    }
    public ItemWrapper(Item__c item,Blob cover) {
        this.id = item.Id;
        this.title = item.Name;
        this.publisher = item.Publisher__r.Name;
        this.genre = item.Genre__c;
        this.quantity = item.Quantity__c;
        this.cover = cover;
    }
}