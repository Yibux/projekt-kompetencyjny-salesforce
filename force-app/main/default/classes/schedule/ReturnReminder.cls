public with sharing class ReturnReminder implements Schedulable, Database.Batchable<SObject>, Database.Stateful{
    public static final Integer DAYS_TO_RETURN = 1;
    public static final String JOB_NAME = 'Notification to return an Item';
    public static final String SUBJECT = 'Return Item Reminder';
    public static final String BORROW_STATUS = 'borrowed';
    public static final String RETURN_NOTIFICATION = 'Following items will be returned tomorrow:';
    public static final String RETURN_NOTIFICATION_DATE = 'In following date: ';
    public static final String ERROR_MESSAGE = 'Error sending return reminder';

    public static final String CRON_TIME = '0 12 14 * * ?';


    @TestVisible
    private static Boolean shouldForceException = false;
    @TestVisible
    private final Map<String, List<String>> errorToAddress = new Map<String, List<String>>();
    
    public static Id scheduleMe() {
        ReturnReminder schedule = new ReturnReminder();
        return System.schedule(
          JOB_NAME,
          CRON_TIME,
          schedule
        );
      }

      public void execute(SchedulableContext context) {
        Database.executeBatch(new ReturnReminder(), 100);
      }

      public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
          [
            SELECT 
                Id, Client__r.Email__c, Item__r.Name
            FROM Loan__c
            WHERE
                End_Date__c = :Date.today().addDays(DAYS_TO_RETURN)
          ]
        );
      }

      public void execute(Database.BatchableContext bc, List<Loan__c> rentals) {
        Map<String, List<String>> emailToItems = generateEmailToItemsMap(rentals);
        Date endOfRentalDate = Date.today().addDays(DAYS_TO_RETURN);

        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();

        for (String email : emailToItems.keySet()) {
          Messaging.SingleEmailMessage newEmail = EmailManager.createSingleEmail(
              email,
              RETURN_NOTIFICATION + '\n' +
              String.join(emailToItems.get(email), '\n') + '\n' +
              RETURN_NOTIFICATION_DATE + endOfRentalDate.format(),
            SUBJECT
            );
    
          mails.add(newEmail);
        }
        List<Messaging.SendEmailResult> emailResults = Messaging.sendEmail(
          mails,
          false
        );
    
        for (Integer i = 0; i < emailResults.size(); i++) {
          if (!emailResults[i].isSuccess()) {
            String statusCode = emailResults[i]
              .getErrors()
              .get(0)
              .getStatusCode()
              .name();
            if (!errorToAddress.containsKey(statusCode)) {
              errorToAddress.put(statusCode, new List<String>());
            }
            errorToAddress.get(statusCode).add(mails[i].toAddresses[0]);
          }
        }
      }
    
      public void finish(Database.BatchableContext bc) {
        if (errorToAddress.size() > 0) {
          String body = String.format(
            ERROR_MESSAGE,
            new List<String>{
              Date.today().format(),
              EmailManager.createEmailContent(errorToAddress)
            }
          );
    
          EmailManager.sendErrorMessage(
            ERROR_MESSAGE,
            body
          );
        }
      }
    
      private static Map<String, List<String>> generateEmailToItemsMap(List<Loan__c> loans) {
        Map<String, List<String>> emailToItems = new Map<String, List<String>>();
    
        for (Loan__c loan : loans) {
          if (!emailToItems.containsKey(loan.Client__r.Email__c)) {
            emailToItems.put(
                loan.Client__r.Email__c,
                new List<String>()
            );
          }
          emailToItems.get(loan.Client__r.Email__c).add(loan.Item__r.Name);
        }
    
        return emailToItems;
      }
}