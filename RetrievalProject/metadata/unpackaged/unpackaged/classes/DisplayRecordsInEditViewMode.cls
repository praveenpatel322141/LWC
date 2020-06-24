public class DisplayRecordsInEditViewMode {
    @AuraEnabled
    public static list<Account> getMyAccount(){
        List<Account> accountList = [select Id, Name, Description from Account];
        return accountList;
    }    
}