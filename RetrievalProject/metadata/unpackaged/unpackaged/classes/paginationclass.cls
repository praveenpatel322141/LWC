public with sharing class paginationclass {


    Public Boolean conlst{get;set;}
    Public String selected {get;set;}
    Public List<selectoption> lst {get;set;}
    Public Boolean hasPrevious {get;set;}
    Public Boolean hasNext {get;set;}
    Public Integer pageno {get;set;}
    Public List<Account> acc {get;set;}
    Public List<contact> con {get;set;}
    Public List<Contact> lstacc {get;set;}
    Public Integer count {get;set;}
    Public Account aname {get;set;}
    public Integer pageSize {get;set;}
    
    
    
    
    public paginationclass(ApexPages.StandardController controller) {
        conlst=false;
        lst=new List<Selectoption>();
        lst.add(new Selectoption('','------------- Select Account --------------'));
        acc=[select id,name,phone,fax,rating from Account ];   
        for(Account a:acc)
        lst.add(new Selectoption(a.id,a.name));
        pageSize = 2;
    }

    Public PageReference change(){
        System.debug('---------------------------->'+selected);
        if(selected != '' || selected != null)
        aname= new Account();
        aname=[Select id,name from Account where id=:selected];
        con=[select id,lastname,phone,Fax,Birthdate from Contact where accountid=:selected];
        lstacc= new List<Contact>();
        if(con.size()>0)
        {
            conlst=true;
            count=con.size();
            hasPrevious =false;
            hasNext=true;
            pageno=1;
            for(integer i=0; i<pageSize;i++) { 
                lstacc.add(con[i]);
            }
        }
            
        return null;
    }

    Public void first() {
        hasNext=true;
        lstacc .clear();
        hasPrevious=false;
        pageno =1;
        for(integer i=0;i<pageSize;i++)
        {
            lstacc .add(con[i]);  
        }
    }
     
    Public void previous() {    
        hasNext=true;
        lstacc .clear();
        if(pageno  !=1) {
            pageno  = pageno  - 1;
            If(pageno  ==1 ) {
                hasPrevious=false;
            }
            for(integer i=(pageno -1)*pageSize;i<(pageno *pageSize);i++ ) {
                lstacc .add(con[i]); 
                System.debug('--------------------SIZE OF PAGINATION LIST---------------------'+lstacc .size()+' RECORDS '+con[i]);
            }
        }                           
        else {
            hasPrevious=false;
            for(integer i=(pageno -1)*pageSize;i<(pageno *pageSize);i++ ) {
                lstacc .add(con[i]); 
                System.debug('--------------------SIZE OF PAGINATION LIST---------------------'+lstacc .size()+' RECORDS '+con[i]);         
            }
        }
    }

    Public void next() {
        pageno  = pageno +1;
        integer pgno;
        lstacc .clear();
        if(math.mod(con.size(),pageSize)==0)
        { 
            pgno=con.size()/pageSize;
        } else {
            pgno=(con.size()/pageSize) +1; 
        }
        if(pageno ==pgno) { 
            hasNext=false;
            for(integer i=(pageno -1)*pageSize;i<con.size();i++ ) {
                lstacc .add(con[i]); 
                System.debug('--------------------SIZE OF PAGINATION LIST---------------------'+lstacc .size()+' RECORDS '+con[i]);
            }
        } else {            
            for(integer i=(pageno -1)*pageSize;i<(pageno *pageSize);i++ ) {
                lstacc .add(con[i]); 
                System.debug('--------------------SIZE OF PAGINATION LIST---------------------'+lstacc .size()+' RECORDS '+con[i]);
            }
        }
        hasPrevious=true;
        System.debug('---------------------------- LIST SIZE OF TEMPLIST ---------------------'+con.size());
    }

    Public void last() {  
        System.debug('---------------------------------------------- LAST METHOD IS CALLING ----------------------');
        hasPrevious=true;
        lstacc .clear();
        hasNext=false;
        if( math.mod(con.size(),pageSize)==0)
         pageno =con.size()/pageSize;
        else {
            pageno =(con.size()/pageSize) +1; 
        }
        for(integer i=(pageno -1)*pageSize;i<con.size();i++)
        {
          lstacc .add(con[i]);  
        }
    }
}