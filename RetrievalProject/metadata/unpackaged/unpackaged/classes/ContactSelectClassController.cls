public class ContactSelectClassController{

 
    //Our collection of the class/wrapper objects wrapContact 
    public List<wrapContact> wrapContactList {get; set;}
    public List<Contact> selectedContacts{get;set;}
    public ContactSelectClassController(ApexPages.StandardController controller) {
          if(wrapContactList == null) {
            wrapContactList = new List<wrapContact>();
            for(Contact contact: [select Id, Name, Email from Contact ]) {
                // As each Contact is processed we create a new wrapContact object and add it to the wrapContactList
                wrapContactList.add(new wrapContact(contact));
            }
        }
    }

     
    public ContactSelectClassController(){
       
    }
 
    public void processSelected() {
    selectedContacts = new List<Contact>();
 
        for(wrapContact wrapContactObj : wrapContactList) {
            if(wrapContactObj.selected == true) {
                selectedContacts.add(wrapContactObj.cntct);
            }
        }
    }
 
 
    // This is our wrapper/container class. A container class is a class, a data structure, or an abstract data type whose instances are collections of other objects. In this example a wrapper class contains both the standard salesforce object Contact and a Boolean value
    public class wrapContact {
        public Contact cntct {get; set;}
        public Boolean selected {get; set;}
 
        //This is the contructor method. When we create a new wrapContact object we pass a Contact that is set to the cntct property. We also set the selected value to false
        public wrapContact(Contact contact) {
            cntct = contact;
            selected = false;
        }
    }
}