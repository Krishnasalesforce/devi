trigger AccountUpdateFollowUpTaskTrigger1 on Account (after update) 
{
    List<Contact> ContactsToMarkDeleted = new List<Contact>();
    List<Account> AccountsMarkedDeleted = new List<Account>();
    List<Account> AccountsWithUpdatedOwners = new List<Account>();
    Map<Id,Account> AccountsWithUpdatedOwnersMap = new Map<Id,Account>();
    List<Task> TasksWithUpdatedOwners = new List<Task>();
    Map<Id,Id> AccountNewOldOwnersMap = new Map<Id,Id>();
    List<opportunity> OpportunitywithUpdateOwners = new List<opportunity>();
    List<opportunity> OpportunitywithUpdatecurrentmonth = new List<opportunity>();
    
    for(Integer i=0; i<Trigger.new.size();i++)
    {       
        //if(Trigger.new[i].Active_Dealer__c !=true)
        {
            AccountsMarkedDeleted.add(Trigger.new[i]);
        }
        
        if(Trigger.new[i].OwnerId!=Trigger.old[i].OwnerId)
        {
            AccountsWithUpdatedOwnersMap.put(Trigger.new[i].Id, Trigger.new[i]);
            AccountsWithUpdatedOwners.add(Trigger.new[i]);  
            AccountNewOldOwnersMap.put(Trigger.new[i].OwnerId, Trigger.old[i].OwnerId); 
        }
    }
    
    ContactsToMarkDeleted = [Select Id from Contact where AccountId in :AccountsMarkedDeleted];
    
    for(Contact con :ContactsToMarkDeleted)
    {
        //con.Deleted__c = true;
    }
    
    TasksWithUpdatedOwners = [Select Id, OwnerId,WhatId from Task where IsClosed=false and WhatId in :AccountsWithUpdatedOwners];
    
    for(Task T :TasksWithUpdatedOwners)
    {
        T.OwnerId = AccountsWithUpdatedOwnersMap.get(T.WhatId).OwnerId;
    }
    
    OpportunitywithUpdateOwners = [select Id, AccountId, Account.OwnerId, ApplicationDate__c, CloseDate from opportunity where AccountId IN : AccountsWithUpdatedOwners];  
    integer currentmonth = (date.Today()).month();
    integer currentYear = (date.Today()).Year();
    
    for(Opportunity Opp : OpportunitywithUpdateOwners) 
    {
        if((opp.CloseDate != null && (opp.CloseDate.month() != currentmonth ||opp.CloseDate.Year() != currentYear)) && (opp.ApplicationDate__c != null && (opp.ApplicationDate__c.month() != currentmonth ||opp.ApplicationDate__c.Year() != currentYear))) 
        {
            opp.OwnerId = AccountNewOldOwnersMap.get(Opp.Account.OwnerId);
            OpportunitywithUpdatecurrentmonth.add(opp);
        }       
    }

    update ContactsToMarkDeleted;
    
    update TasksWithUpdatedOwners;
    
    if(OpportunitywithUpdatecurrentmonth != null && OpportunitywithUpdatecurrentmonth.size() >0)    
        update OpportunitywithUpdatecurrentmonth;     
}