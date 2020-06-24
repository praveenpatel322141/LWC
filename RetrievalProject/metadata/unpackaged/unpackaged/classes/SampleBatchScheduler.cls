global class SampleBatchScheduler implements Schedulable {
    
    // Execute at regular intervals
    global void execute(SchedulableContext ctx){
      String soql = 'SELECT Id, CallObject From Task where CallObject!=null';
      SampleBatch batch = new SampleBatch(soql);
      Database.executebatch(batch, 200);
    }
}