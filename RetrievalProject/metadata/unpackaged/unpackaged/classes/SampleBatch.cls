global class SampleBatch implements Database.Batchable<sObject> {

  private String query;
  
  global SampleBatch (String soql){
    query = soql;
  }
  
  // The batch job starts
  global Database.Querylocator start(Database.BatchableContext bc){
    //String query = 'SELECT Id, Name FROM Account';
    System.debug('>>>> start ' + query);
    return Database.getQuerylocator(query);
  } 
  
  // The batch job executes and operates on one batch of records
  global void execute(Database.BatchableContext bc, List<Task> scope){
    System.debug('>>>> execute ' + scope.size());
    Map<String,ContactTraceRecord__c> mapContactIdToCTR = new Map<String,ContactTraceRecord__c>();
    List<ContactTraceRecord__c> listCTR = [select Id,ContactId__c,PreviousContactId__c,NextContactId__c,Previous_CTR__c,Next_CTR__c  from ContactTraceRecord__c where ContactId__c!=null ];
        if(!listCTR.isEmpty()){
            for(ContactTraceRecord__c ctr : listCTR){
                for(Task t: scope){
                    if(ctr.ContactId__c.equals(t.CallObject)){
                        t.AC_Contact_Trace_Record__c=ctr.Id;
                    }
                }
                mapContactIdToCTR.put(ctr.ContactId__c,ctr);
            }
            
            update scope;
            
             for(ContactTraceRecord__c ctr : listCTR){
                for(ContactTraceRecord__c ctrForMatching : mapContactIdToCTR.values()){
                    if(ctr.PreviousContactId__c.equals(ctrForMatching.ContactId__c)){
                        ctr.Previous_CTR__c=mapContactIdToCTR.get(ctr.ContactId__c).Id;
                    }
                    if(ctr.NextContactId__c.equals(ctrForMatching.ContactId__c)){
                        ctr.Next_CTR__c=mapContactIdToCTR.get(ctr.ContactId__c).Id;
                    }
                }
                
            }
            update listCTR;
        }


  }
  // The batch job finishes
  global void finish(Database.BatchableContext bc){
    AsyncApexJob job = [SELECT Id, Status FROM AsyncApexJob WHERE Id = :bc.getJobId()]; 
    System.debug('>>>> finish ' + job.Status);
  }
}