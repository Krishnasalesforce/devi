public with sharing class salesData {

    public PageReference refreshData() {
        return null;
    }

   public String country{get; set;}
   public String state{get; set;}
   public String city{get; set;}
   public integer b_year{get; set;}
   public integer e_year{get; set;}
   public String[] type= new String[]{};
   public integer size_low{get;set;}
   public integer size_high{get;set;}
   public string addressParameter{get;set;}
   
   public String[] gettype() { 
        return type;
   }

   public void settype(String[] type) {
        this.type = type;
   }
  
   public List<SelectOption> getcountries() {  //this function gives list of countries from country__c object
         
            List<SelectOption> options = new List<SelectOption>();
            
            for(country__c country :[SELECT name FROM country__c])
              options.add(new selectOption(country.name,country.Name));
              
            return options;
        }
    
    public List<SelectOption> getYears() {
        List<SelectOption> options = new List<SelectOption>();
        for(integer i=2012;i>1974;i--)
         options.add(new selectOption(string.valueof(i),string.valueof(i)));
        return options;
    }

    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('residential','Residential'));
        options.add(new SelectOption('commercial','Commercial'));
        options.add(new SelectOption('utility','Utility'));

        return options;
    }

  
    public List<String> getSales() { //this function returns sales data for a particilar location,called on marker click
        string[] sales= new String[]{};
        country__c Search_opportunity;
        string myquery,flag;
        string streetName,cityName,stateName,countryName;
        if(addressParameter==null || addressParameter=='')
          return null;
        else
        {
          List<String> parts = addressParameter.split(',');
      
          streetName=parts[0];
          cityName=parts[1];
          stateName=parts[2];
          countryName=parts[4]; //parts[3] is zipcode
       
          try{
          Search_opportunity=[SELECT search_opportunities__c from country__c where name=:countryName];
          flag=Search_opportunity.search_opportunities__c; //to determine which object to search
          } catch (Exception e) {
        
           Apexpages.addMessage( new ApexPages.Message (ApexPages.Severity.ERROR, 'No Data Found for default display,Please Enter some Data. '));
           return null;}
      
          //create query
          if(flag.equals('True'))
            myquery='SELECT Id,Account.Name,closeDate,size__c,type from opportunity where account.Billingstreet=:streetName AND account.Billingcity=:cityName AND account.Billingstate=:stateName AND account.Billingcountry=:countryName';
          else
            myquery='Select Id,account_name__c,Delivery_Date__c,size__c,type__c from salesOrder__c where street__c=:streetName AND city__c=:cityName AND state__c=:stateName AND country__c=:countryName';
      
            //evaluate query
            if(flag.equals('True'))
            { 
              for(Opportunity o:database.query(myquery))
                sales.add(o.Id+'-'+o.account.name+'-'+String.valueOf(o.CloseDate.year())+'-'+o.size__c+'-'+o.type);
            }
            else
            {
              for(salesOrder__c s:database.query(myquery))
                sales.add(s.Id+'-'+s.account_name__c+'-'+String.valueOf(s.Delivery_Date__c.year())+'-'+s.size__c+'-'+s.type__c);
            }
        
        return sales;
        }
    }
 
    public set<String> getSalesAddress() { //this function returns sddresses to put markers on
        string myquery,flag;
        country__c Search_opportunity; 
        set<string> salesAddress= new set<String>{}; //set is used to return Distinct addresses
        
        //initialize
        if(country==null)
          this.country='USA'; //for default display
        if(state==null)
          this.state='';
        if(city==null)
          this.city='';
        if(b_year==null)
          this.b_year=1975;
        if(e_year==null)
          this.e_year=2012;
        if(size_low==null)
          this.size_low=0;
        if(size_high==null)
          this.size_high=250;
        
        //If no type is checked type filter is not applied i.e. all types are added   
        if(type.size()==0)
          {
          this.type.add('Residential');
          this.type.add('Commercial');
          this.type.add('Utility');
          }
        
        try {

        Search_opportunity=[SELECT search_opportunities__c from country__c where name=:country];
        flag=Search_opportunity.search_opportunities__c; //to determine which object to search
        
        } catch (Exception e) {
        
        Apexpages.addMessage( new ApexPages.Message (ApexPages.Severity.ERROR, 'No Data Found for default display,Please Enter some Data. '));
        return null;}
        
        if(flag.equals('True'))
          {myquery='SELECT Account.BillingStreet,Account.BillingCity,Account.BillingState,Account.BillingPostalcode,Account.BillingCountry from opportunity where Account.BillingCountry=:country';
           if(state!='')
               myquery=myquery+' AND Account.BillingState=:state';
           if(city!='')
               myquery=myquery+' AND Account.BillingCity=:city';
           //apply filters    
               myquery=myquery+' AND size__c>=:size_low AND size__c<=:size_high AND CALENDAR_YEAR(CloseDate)>=:b_year AND CALENDAR_YEAR(CloseDate)<=:e_year AND type in(';
         }
        else
          {myquery='SELECT street__c,city__c,state__c,zipcode__c,country__c from SalesOrder__c where country__c=:country';
           if(state!='')
               myquery=myquery+' AND state__c=:state';
           if(city!='')
               myquery=myquery+' AND city__c=:city';
           //apply filters    
               myquery=myquery+' AND size__c>=:size_low AND size__c<=:size_high AND CALENDAR_YEAR(Delivery_Date__c)>=:b_year AND CALENDAR_YEAR(Delivery_Date__c)<=:e_year AND type__c in(';
          }
         
         
          //apply type filter
          for(integer i=0;i<type.size();i++)
            { 
              if(i!=type.size()-1)
               myquery=myquery+'\''+type[i]+'\',';
              else
               myquery=myquery+'\''+type[i]+'\')';
             }
        
        //evaluating query 
        
        if(flag.equals('True'))
         { 
          for(Opportunity o:database.query(myquery))
               salesAddress.add(o.account.BillingStreet+','+o.account.BillingCity+','+o.account.BillingState+','+o.account.BillingPostalcode+','+o.account.BillingCountry);
         }
        else
         {
          for(salesOrder__c s:database.query(myquery))
               salesAddress.add(s.Street__c+','+s.City__c+','+s.State__c+','+s.ZipCode__c+','+s.Country__c);
         }
        
        return salesAddress;
    }

      
    Public void Search(){
    }
} //controller ends