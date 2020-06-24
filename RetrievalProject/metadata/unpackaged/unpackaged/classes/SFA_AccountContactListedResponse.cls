global class SFA_AccountContactListedResponse{
 //Wrapper class to warp the various  List as Super wrapper
 global class supersobjectWrapper{
    List<Account> Accounts=new List<Account>();//A list to hold the Accounts
    List<Contact> Contacts=new List<Contact>();//A list to hold the Contacts  
 }
//This method will be called as the http get request
 public static supersobjectWrapper makeResponseString(){  
    List<Account>  lstacc=new List<Account>();
    List<Contact> lstcontacts=new List<Contact>();
    lstacc = (List<Account>)[Select Id,CreatedDate,LastModifiedDate,Isdeleted from Account ];
    lstcontacts=[Select id,CreatedDate,LastModifiedDate,Isdeleted from Contact];
    supersobjectWrapper superWrap=new supersobjectWrapper();//Instantiating thesuperclass
    superWrap.Contacts= lstcontacts ;
    superWrap.Accounts= lstacc;
    return superWrap;
 }
}