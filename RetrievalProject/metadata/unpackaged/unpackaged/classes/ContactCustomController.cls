public class ContactCustomController {
Id Idvalue;
Contact con;
List<Contact> contacts=[SELECT Name, Id FROM contact];
List<account> accs=[SELECT Name FROM Account ];
List<Case> hosps=[SELECT Id FROM Case];

public List<Contact> getContacts(){
return contacts;
}
public List<Account> getaccs(){
return accs;
}
public List<Case> gethosps(){
return hosps;
}
public PageReference goToEdit(){
System.debug('Inside go to edit');
Idvalue = ApexPages.currentPage().getParameters().get('id');
system.debug('Id value='+Idvalue);
con=[SELECT Name FROM contact WHERE Id=:Idvalue];
return Page.ContactEditPage;
}

}