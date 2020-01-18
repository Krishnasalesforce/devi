trigger AccountUpdateFollowUpTaskTrigger on Account (after update) {  

    List<Account> AccountsMarkedDeleted = new List<Account>();  
    List<Account> AccountsWithUpdatedOwners = new List<Account>();  
    Map<Id,Account> AccountsWithUpdatedOwnersMap = new Map<Id,Account>();  
    Map<Id,Id> AccountNewOldMap = new Map<Id,Id>();
    List<opportunity> OpportunitywithUpdateOwners = new List<opportunity>();
    List<opportunity> OpportunitywithUpdatecurrentmonth = new List<opportunity>();
    
    for(Integer i=0; i<Trigger.new.size();i++)  {        
        
        if(Trigger.new[i].OwnerId!=Trigger.old[i].OwnerId)    {
              AccountsWithUpdatedOwnersMap.put(Trigger.new[i].Id, Trigger.new[i]);      
              AccountsWithUpdatedOwners.add(Trigger.new[i]);    
              AccountNewOldMap.put(Trigger.new[i].OwnerId, Trigger.old[i].OwnerId);  
        }  
    }    

    OpportunitywithUpdateOwners = [select Id, AccountId, Account.OwnerId, ApplicationDate__c, CloseDate from opportunity where AccountId IN : AccountsWithUpdatedOwners];  
    integer currentmonth = (date.Today()).month();
    integer currentYear = (date.Today()).Year();
    
    for(Opportunity Opp : OpportunitywithUpdateOwners) {
        if((opp.CloseDate != null && (opp.CloseDate.month() != currentmonth ||opp.CloseDate.Year() != currentYear)) && (opp.ApplicationDate__c != null && (opp.ApplicationDate__c.month() != currentmonth ||opp.ApplicationDate__c.Year() != currentYear))) {
            opp.Description = 'opp.CloseDate.month()=' + opp.CloseDate.month()  + ', currentmonth ='+ currentmonth + ', opp.CloseDate.Year() :' + opp.CloseDate.Year() +', currentYear:'+ currentYear +',ApplicationDate__c.month:'+ opp.ApplicationDate__c.month()+ ',ApplicationDate__c.Year' + opp.ApplicationDate__c.Year();
            
            opp.OwnerId = AccountNewOldMap.get(Opp.Account.OwnerId);
            opp.Description = opp.Description + AccountNewOldMap + Opp.Account.OwnerId + opp.OwnerId;
            //Opp.Type = 'Existing Customer - Upgrade';
            OpportunitywithUpdatecurrentmonth.add(opp);
        } //else {
            //opp.Description = 'opp.CloseDate.month()=' + opp.CloseDate.month()  + ', currentmonth ='+ currentmonth + ', opp.CloseDate.Year() :' + opp.CloseDate.Year() +', currentYear:'+ currentYear +'.';
            //opp.OwnerId = AccountsWithUpdatedOwnersMap.get(Opp.AccountId).OwnerId;
            //Opp.Type = 'New Customer';
            //OpportunitywithUpdatecurrentmonth.add(opp);
        //}       
    }
    
    system.debug('inside');
    system.debug(OpportunitywithUpdatecurrentmonth);
    update OpportunitywithUpdatecurrentmonth;
}