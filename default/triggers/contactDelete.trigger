trigger contactDelete on Contact (before delete)
 {
 try
 {
 for (Contact c : Trigger.old)
 {
 system.debug(c.id);
 Account acct = [SELECT Name, Id FROM Account WHERE Id = :c.AccountID];
 Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
 String[] tAddresses = new String[] {'nkrishnamoorthi@gmail.com'};
 mail.setToAddresses(tAddresses);
 mail.setReplyTo('krishnasalesforce@gmail.com');
 mail.setSenderDisplayName('Salesforce Support');
 mail.setSubject('Contact Deleted: ' + c.FirstName + ' ' + c.LastName);
 mail.setUseSignature(false);
 mail.setPlainTextBody(                'Contact ' + c.FirstName + ' ' + c.LastName + ' has been deleted!\n' +                 'Contact ID: ' + c.Id + '\n\n' +                'Contact Organization: ' + acct.Name + '\n\n' +                'Organization ID: ' + acct.Id                );
 Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
 }
 }    
 catch (NullPointerException e) 
 {      
 System.debug('Exception Thrown!');        
 Exception e1 = e;    
 }
 }