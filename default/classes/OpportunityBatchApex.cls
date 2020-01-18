global class OpportunityBatchApex implements Database.Batchable<Opportunity> {
    global OpportunityBatchApex() {}
    
    global List<Opportunity> start(Database.BatchableContext BC) {

        return [Select AccountId, Amount, CloseDate, CreatedDate, CurrentGenerators__c, BatchRunDate__c
                , DeliveryInstallationStatus__c, Description, ExpectedRevenue, HasOpportunityLineItem, Id
                , IsClosed, LastModifiedDate, LeadSource, MainCompetitors__c, Name, NextStep, OrderNumber__c
                , StageName, TotalOpportunityQuantity, TrackingNumber__c, Type 
                from Opportunity
                WHERE StageName = 'Closed won'
                ];

    }
    
    global void execute(Database.BatchableContext BC, List<Opportunity> batch) {
        
        for(Opportunity Opp : batch) {
            Opp.BatchRunDate__c = DateTime.Now();
            Opp.CloseDate = Date.today();
        }    
       update batch;     
    }
    
    global void finish(Database.BatchableContext BC) {
        // Get the ID of the AsyncApexJob representing this batch job
        // from Database.BatchableContext.
        // Query the AsyncApexJob object to retrieve the current job's information.
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed
                                 , TotalJobItems, CreatedBy.Email
                          from AsyncApexJob where Id =
                          :BC.getJobId()
                          ];
        // Send an email to the Apex job's submitter notifying of job completion.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {a.CreatedBy.Email};
        mail.setToAddresses(toAddresses);
        mail.setSubject('The batch Apex job Process Notification ' + a.Status);
        mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems +
                              ' batches with '+ a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }

}