@isTest
public with sharing class testSalesData {
	
 static testMethod void runTests() {
    
    SalesData ctrl= new SalesData();
    List<Selectoption> countries=ctrl.getCountries();
    List<Selectoption> years=ctrl.getYears();
    List<Selectoption> types=ctrl.getItems();
    
    ctrl.addressParameter=null;
    List<String> sales=ctrl.getSales();
    ctrl.addressParameter='1301 Hoch Drive,Lawrence,KS,66045,USA'; //add any existing Address with search_opportunities false 
    sales=ctrl.getSales();
    ctrl.addressParameter='Schulstrasse 4,Bad Oyenhausen,North Rhine-Westphal,32547,Germany';  //add any existing Address with search_opportunities false
    sales=ctrl.getSales();
    
    
    //by default city is USA
    ctrl.state='KS';
    ctrl.city='Lawrence';
    set<String> address=ctrl.getSalesAddress();
   
    ctrl.country='Germany';
    ctrl.state='North Rhine-Westphal';
    ctrl.city='Bad Oyenhausen';
    address=ctrl.getSalesAddress();
    
    PageReference ref=ctrl.refreshData();
    string[] type=ctrl.getType();
    ctrl.settype(type);
    ctrl.Search();
    
 }
 
}