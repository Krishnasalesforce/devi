global class OpportunityBatchApexScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        OpportunityBatchApex b = new OpportunityBatchApex();
        database.executebatch(b, 1);
    }
}