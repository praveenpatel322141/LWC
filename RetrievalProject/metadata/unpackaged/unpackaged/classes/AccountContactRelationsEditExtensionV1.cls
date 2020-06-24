public class AccountContactRelationsEditExtensionV1 {
    private ApexPages.StandardController std;
     
    // the associated accountContactRelations
   public List<AccountContactRelation> accountContactRelations;
      
    // the chosen contact id - used when deleting a contact
    public Id chosenAccountContactRelationId {get; set;}
     
    public AccountContactRelationsEditExtensionV1(ApexPages.StandardController stdCtrl)
    {
     std = stdCtrl;
    }
     
    public Contact getContact()
    {
     return (Contact) std.getRecord();
    }
 
    private boolean updateAccountContactRelations()
    {
        boolean result = true;
        if (null != accountContactRelations)
           {
           List<Contact> updConts = new List<Contact>();
              Savepoint sp = Database.setSavepoint();
              
               //update accountContactRelations;
               Database.SaveResult[] srList = Database.update(accountContactRelations,false);
                for (Database.SaveResult sr : srList) {
                    if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully inserted contact. Contact ID: ' + sr.getId());
                    } else {
                        // Operation failed, so get all errors
                        Database.RollBack(sp);
                        for(Database.Error err : sr.getErrors()) {
                            System.debug('The following error has occurred.');
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('Contact fields that affected this error: ' + err.getFields());
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, err.getMessage()));
                            
                             result = false;
                        }
                    }
                }
           }
            
           return result;
    }
     
    public PageReference saveAndExit()
    {
     boolean result = true;
    result = updateAccountContactRelations();
      
     if (result)
     {
        // call standard controller save
        return std.save();
     }
     else
     {
      return null;
     }
    }
     
    public PageReference save()
    {
     Boolean result=true;
     PageReference pr = Page.ContactsAccountContactRelationsEditPage;
     if (null != getContact().id)
     {
      result = updateAccountContactRelations();
     }
     else
     {
      pr.setRedirect(true);
     }
      
     if (result)
     {
        // call standard controller save, but don't capture the return value which will redirect to view page
        std.save();
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Changes saved'));
     }
        pr.getParameters().put('id', getContact().id);
      
     return pr;
    }
 
    public PageReference newAccountContactRelation()
    {
       /*if (updateAccountContactRelations())
       {
          AccountContactRelation accountContactRelation = new AccountContactRelation( ContactId = getContact().id, AccountId = getContact().AccountId );
          insert accountContactRelation;
         
          // null the accountContactRelations list so that it is rebuilt
          accountContactRelations=null;
       }*/
       transient Id tempId = getContact().id;
       PageReference leadPage = new PageReference('/07k/e?retURL=%2F' + tempId  + '&conid=' + tempId );
      leadPage.setRedirect(true);
      return leadPage;
    }
     
    public void deleteAccountContactRelation()
    {
       if (updateAccountContactRelations())
       {
          if (null != chosenAccountContactRelationId )
          {
             AccountContactRelation accountContactRelation=new AccountContactRelation(Id = chosenAccountContactRelationId);
              delete accountContactRelation;
        
           // null the accountaccountContactRelationRelations list so that it is rebuilt
              accountContactRelations = null;
              chosenAccountContactRelationId = null;
          }
       }
    }
     
   public List<AccountContactRelation> getaccountContactRelations()
    {
       if ( (null != getContact().id) && (accountContactRelations == null) )
       {
           accountContactRelations=[SELECT Id, ContactId, Account.Name,IsDirect,Roles,SSP_User__c,SSP_Role__c 
                         FROM accountContactRelation 
                         WHERE ContactId = : getContact().ID
                         ORDER BY CreatedDate];
       }
                           
       return accountContactRelations;
    }
}