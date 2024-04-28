public with sharing class ClientUtils {
    private static final String clientId = '3MVG9PwZx9R6_Urc_YKQTTlZrJj5zdLfb0kpmzauvRFp5jz4.JZD0xkbWoB2.SKyVCNXTDb40KoScBuNp6wyw';
    private static final String clientSecret = 'C5DAF8015E2C6BF0E47085C83B35C3FFEEC4B2258C28CE2218457E74B438AC6C';
    private static final String imageUrlTemplate = 'https://empathetic-panda-myq45y-dev-ed.my.salesforce.com/services/data/v58.0/sobjects/Item__c/{0}/richTextImageFields/Cover__c/{1}';

    public static Map<Id,Blob> getCover(List<Id> ItemsIDs){
        Map<Id,Blob> blobs = new Map<Id,Blob>();
        Map<Id,String> imageIDs = getImageIDs(ItemsIDs);
        String access_token;
        if(!Test.isRunningTest() ){
            access_token = getAccessToken();
        }
       

        for(ID ItemID : ItemsIDs){
            if(Test.isRunningTest() || imageIDs.get(ItemID) == null){
                blobs.put(ItemID,null);
            }else{
                blobs.put(ItemID,getBlob(access_token,ItemID,imageIDs.get(ItemID)));
            }
        }

        return blobs;
    }


    private static String getAccessToken(){
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://empathetic-panda-myq45y-dev-ed.my.salesforce.com/services/oauth2/token');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setBody('grant_type=client_credentials&client_id=' + clientId + '&client_secret=' + clientSecret);
    
        HttpResponse res = new Http().send(req);
        if (res.getStatusCode() == 200) {
            Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            return (String) data.get('access_token');
        } else {
            return 'ERROR';
        }
    } 

    private static Blob getBlob(String access_token,ID itemID,ID imageID){
        HttpRequest req = new HttpRequest();
        req.setEndpoint(String.format(imageUrlTemplate, new List<ID>{itemID,imageID}));
        req.setMethod('GET');
        req.setHeader('Authorization', 'Bearer ' + access_token);

        HttpResponse res = new Http().send(req);

        if (res.getStatusCode() == 200) {
            return res.getBodyAsBlob();
        } 
        return null;
    }

    private static Map<Id,String> getImageIDs(List<Id> ItemsIDs){
        Map<Id,String> IDs = new Map<Id,String>();
        List<Item__c> items = [Select ID,Cover__c From Item__c Where ID in: ItemsIDs];

        for(Item__c i : items){
            if(i.Cover__c!=null){
                IDs.put(i.ID,extractIdFromUrl(i.Cover__c));
            }else{
                IDs.put(i.ID,null);
            }
        }

        return IDs;
    }

    private static String extractIdFromUrl(String url){
        Integer refIdIndex = url.indexOf('amp;refid=');
        if (refIdIndex != -1) {
            String refIdValue = url.substring(refIdIndex+10,refIdIndex+25);
            return refIdValue;
        } 
        return '';
    }

}