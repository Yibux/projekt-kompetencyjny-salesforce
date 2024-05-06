public with sharing class ItemWrapper {
    public String id;
    public List<String> authors;
    public String publisher;
    public String genre;
    public String title;
    public Decimal quantity;
    public Blob cover;

    public ItemWrapper(Item__c item) {
        this.id = item.Id;
        this.title = item.Name;
        this.authors = null;
        this.publisher = item.Publisher__r.Name;
        this.genre = item.Genre__c;
        this.quantity = item.Quantity__c;
        this.cover = null;
    }
    public ItemWrapper(Item__c item,List<String> authors,Blob cover) {
        this.id = item.Id;
        this.title = item.Name;
        this.publisher = item.Publisher__r.Name;
        this.genre = item.Genre__c;
        this.quantity = item.Quantity__c;
        this.cover = cover;
        this.authors = authors;
    }
}