public class Pagination {
    private integer totalRecs{get;set;}
    public integer offsetSize{get;set;}
    private integer limitSize{get;set;}
    public integer pageNo{get;set;}
    private integer total_Pages{get;set;}
    
    public Pagination(ApexPages.StandardController controller) {
        totalRecs = 0;
        offsetSize = 0;
        LimitSize= 6;
        totalRecs = [select count() from Contact];
        pageNo = 1;
        transient Integer remainder = Math.mod(totalRecs, LimitSize);
        transient Integer quotient = totalRecs/ LimitSize;
        total_Pages = remainder == 0 ? quotient  : quotient + 1;
    }

    public List<Contact> getacclist() {
        List<Contact> contact = Database.Query('SELECT Name, Email FROM Contact LIMIT :LimitSize OFFSET :OffsetSize');
        System.debug('Values are ' + contact );
        return contact;
    }
    
    public List<Contact> getContactlist() {
        List<Contact> contact = Database.Query('SELECT Name, Email FROM Contact LIMIT :LimitSize OFFSET :OffsetSize');
        System.debug('Values are ' + contact);
        return contact;
    }


    public void FirstPage() {
        OffsetSize = 0;
        pageNo = 1;
    }
    
    public void previousPage() {
        OffsetSize = OffsetSize - LimitSize;
        pageNo = pageNo - 1 ;
    }

    public void nextPage() {
        OffsetSize = OffsetSize + LimitSize;
        pageNo = pageNo + 1 ;
    }

    public void LastPage() {
        transient Integer rem = Math.mod(totalRecs,LimitSize);
        transient Integer quo = totalRecs/LimitSize;
        if(totalRecs<=LimitSize){
            OffsetSize = 0;
        } else if(rem == 0) {
            OffsetSize = ((totalRecs/LimitSize)-1)*LimitSize ;
        } else {
            OffsetSize = quo*LimitSize;
        }
        pageNo = total_Pages;
    }

    public boolean getprev() {
        if(OffsetSize == 0) {
            return true;
        } else { 
            return false;
        }
    }

    public boolean getnxt() {
        if((OffsetSize + LimitSize) > totalRecs -1) {
            return true;
        } else {
            return false;
        }
    }

}