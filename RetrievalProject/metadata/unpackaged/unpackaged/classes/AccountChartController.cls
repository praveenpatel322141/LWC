global with sharing class AccountChartController {
     
    @RemoteAction
    global static List<AggregateResult> getAccountData(){
        List<AggregateResult> accGroupList = [Select BillingCountry Country, Count(Id) NumberOfAccounts
                                              From Account Where BillingCountry != null
                                              Group By BillingCountry];
        return accGroupList;
    }
}