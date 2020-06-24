public Class AccountController{

    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts(){
        return [Select Id,Name from Account Limit 10];
    }
    
    @AuraEnabled
    public static Account getAccountRecord(Id accountId){
        return [Select Id,Name from Account where Id=:accountId Limit 1];
    }

}