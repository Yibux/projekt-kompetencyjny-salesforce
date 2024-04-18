@isTest
private class EmailManagerTest {
    
    @isTest
    static void testCreateSingleEmail() {
        String testEmailAddress = 'test@example.com';
        String testEmailBody = 'This is a test email body.';
        String testEmailSubject = 'Test Email';
        
        Messaging.SingleEmailMessage testEmail = EmailManager.createSingleEmail(testEmailAddress, testEmailBody, testEmailSubject);
        
        System.assertEquals(testEmailAddress, testEmail.getToAddresses()[0]);
        System.assertEquals(testEmailSubject, testEmail.getSubject());
        System.assertEquals(testEmailBody, testEmail.getPlainTextBody());
        System.assertEquals(EmailManager.EMAIL_SENDER_NAME, testEmail.getSenderDisplayName());
    }
    
    @isTest
    static void testCreateEmailContent() {
        Map<String, List<String>> testErrorsMap = new Map<String, List<String>>();
        testErrorsMap.put('Error 1', new List<String>{ 'Value 1', 'Value 2' });
        testErrorsMap.put('Error 2', new List<String>{ 'Value 3' });
        
        String testEmailContent = EmailManager.createEmailContent(testErrorsMap);
        
        System.assertEquals('Error 1 : Value 1,Value 2\nError 2 : Value 3', testEmailContent);
    }
}
