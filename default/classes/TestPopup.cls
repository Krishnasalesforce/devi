public with sharing class TestPopup {

    public Boolean displayPopup {get;set;}

    public TestPopup(ApexPages.StandardController controller) {

    }
    
    public void showPopup()
    {
        
    displayPopup = true;

    
    }
    
    public void closePopup() {
        displayPopup = false;
        
    }
    
    public PageReference redirectPopup()
    {
    displayPopup = false;
        //Please uncomment below 3 statements and replace YourObjectId
       // PageReference p=new Pagereference('/'+YourObjectId);
       //  p.setRedirect(true);
       return null;
        
    }
    


}