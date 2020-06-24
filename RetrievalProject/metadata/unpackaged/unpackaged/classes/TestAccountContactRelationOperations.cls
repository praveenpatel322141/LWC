@isTest(SeeAllData=false)
private class TestAccountContactRelationOperations {
    
    @testSetup static void setup() {
        
               
    }

    @isTest static void testsendEmails() {
    
        User u = new User(
         ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
         LastName = 'last',
         Email = 'puser000@amamama.com',
         Username = 'puser000@amamama.com' + System.currentTimeMillis(),
         CompanyName = 'TEST',
         Title = 'title',
         Alias = 'alias',
         TimeZoneSidKey = 'America/Los_Angeles',
         EmailEncodingKey = 'UTF-8',
         LanguageLocaleKey = 'en_US',
         LocaleSidKey = 'en_US'
        );
        
        System.runAs(u){
            TominsConstants.accountContactRelationTriggerFlag =  true;
            Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Client').getRecordTypeId();
            Account a = new Account(Name='Test', RecordTypeId = RecordTypeId );
            insert a;
            Account a2 = new Account(Name='Test2', RecordTypeId = RecordTypeId);
            insert a2;
            Account a3 = new Account(Name='Test3', RecordTypeId = RecordTypeId);
            insert a3;
            Contact c = new Contact( FirstName = 'John' , LastName = 'Test', AccountId=a.id, Email = 'puser000@amamama.com' );
            insert c;
           
            AccountContactRelation acr = new AccountContactRelation(AccountId = a2.id, ContactId = c.id,   IsActive = true,   SSP_User__c=false );
            insert acr;
            AccountContactRelation acr2 = new AccountContactRelation(AccountId = a3.id, ContactId = c.id,   IsActive = true,   SSP_User__c=false );
            insert acr2;
            acr.SSP_User__c=true;
            acr.SSP_Role__c = 'Super Admin';
            update acr;
            acr2.SSP_User__c=true;
            acr2.SSP_Role__c = 'Team Member';
            update acr2;
        }
    }
}