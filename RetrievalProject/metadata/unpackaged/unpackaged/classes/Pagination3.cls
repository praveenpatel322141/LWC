public class Pagination3 {
    
    private integer totalRecs = 0;
    private integer OffsetSize = 0;
    private integer LimitSize= 3;

    public Pagination3() {
        totalRecs = [select count() from Contact];
    }

    public List<Contact> getContactlist() {
        List<Contact> contact = Database.Query('SELECT Name  FROM Contact LIMIT :LimitSize OFFSET :OffsetSize');
        System.debug('Values are ' + contact);
        return contact;
    }

    public void FirstPage() {
        OffsetSize = 0;
    }

    
    public void previousPage() {
        OffsetSize = OffsetSize - LimitSize;
    }

    public void nextPage() {
        OffsetSize = OffsetSize + LimitSize;
    }

    public void LastPage() {
        OffsetSize = (totalrecs - math.mod(totalRecs,LimitSize))-LimitSize;
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