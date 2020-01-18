trigger trg_afr_ins_pack on Pack__c (before insert,before update) 
{
    for(Pack__c pacobj : Trigger.new)
    {
        if(pacobj.Purchase__c != NULL)
        {
            Purchase__c[] purobj = [SELECT Name,Group__c,current_status__c FROM Purchase__c where id =: pacobj.Purchase__c ];
            if(purobj != null && purobj.Size() > 0)
            {
                 pacobj.Current_Status__c = purobj [0].Current_Status__c;
            }

        }
    }

}