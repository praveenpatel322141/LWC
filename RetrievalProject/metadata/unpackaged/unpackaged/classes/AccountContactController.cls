public class AccountContactController{
public Account acc{get;set;}
public List<Contact> cont{get;set;}
public AccountContactController(){
    acc = new Account();
    cont = new List<Contact>();
    AddRow();

}
public void AddRow(){
    cont.add(new Contact());

}
public void save(){
    if(acc.name != null){
        insert acc;
        List<contact> con = new List<contact>();
        for(Contact c : cont){
            c.AccountId = acc.id;
            con.add(c);

        }
        if(con != null){
            insert con;
        }
    }

}}