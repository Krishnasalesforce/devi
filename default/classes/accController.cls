public with sharing class accController {
    public string accCount { get; set; }
    public accController() {
        Integer accTotal = [SELECT Count() FROM Account Where LastModifiedDate = LAST_N_DAYS:7];
        accCount = string.valueOf(accTotal);
    }
    
}