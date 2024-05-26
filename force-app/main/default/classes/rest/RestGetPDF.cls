@RestResource(UrlMapping='/Item__c/getPDF/*')
global with sharing class RestGetPDF {
    @HttpPost
    global static void sendPDFForItem() {
        String requestBody = RestContext.request.requestBody.toString();
        Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(requestBody);
        Id itemId = (Id) jsonMap.get('Id');

        ContentDocumentLink contentDocumentLink = [SELECT ContentDocumentId, LinkedEntityId  FROM ContentDocumentLink where LinkedEntityId =: itemId];
        Id contentDocumentId = contentDocumentLink.ContentDocumentId;
        ContentVersion contentVersion = [SELECT Id, Title, VersionData FROM ContentVersion WHERE ContentDocumentId =: contentDocumentId];

        HttpRequest req = new HttpRequest();
        req.setEndpoint(URL.getOrgDomainUrl().toExternalForm()+'/services/data/v60.0/sobjects/ContentVersion/' + contentVersion.Id + '/VersionData');
        req.setMethod('GET');
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());

        Http http = new Http();
        HttpResponse res = http.send(req);

        if (res.getStatusCode() == 200) {
            Blob pdfBlob = res.getBodyAsBlob();
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(pdfBlob));
        }

    }
}