public class TominsConstants {
    public static Boolean accountContactRelationTriggerFlag {
    public get {
        
            accountContactRelationTriggerFlag  = [select IsEnabled__c from TriggerEnableDisable__mdt where TriggerName__c = 'AccountContactRelationTrigger' Limit 1 ].IsEnabled__c; 
        return accountContactRelationTriggerFlag ;
    } 
    public set; 
    
    }
    
}