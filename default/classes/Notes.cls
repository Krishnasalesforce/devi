public with sharing class Notes {
    public string ContactId;
    
    
    public Notes() {
    
    }
    
    public string getContactId() {
        if(ContactId == null || ContactId == '')
            ContactId = ApexPages.currentPage().getParameters().get('contactId');
        return ContactId;
    }
    public void setContactId(string val) {
        ContactId = val;
    }
    
    public pagereference Save() {
        return null;
    }
    
    public pagereference cancel() {
        return null;    
    }
    
}