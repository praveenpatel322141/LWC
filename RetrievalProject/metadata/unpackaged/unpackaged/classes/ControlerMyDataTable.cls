public class ControlerMyDataTable {

    private List<Account> myAccountList;
    
    /**
    
    * Access Controller to launch the visualforce page: MonTableauDeDonnees
    
    * account list myAccountList is implemented with a list of accounts
    
    * The fields recovered below are integrated in the visualforce page :
    
    * Name,AccountNumber,Industry,Type. */
    
    public ControlerMyDataTable (){
    
        myAccountList = [SELECT id,name,AccountNumber,Industry,Type FROM Account];
    
    }
    
    /**
    
    * getmyAccountList recovers accounts on the visualforce page
    
    * Write this {!myAccountList} on visualforce page.*/
    
    public List<Account> getmyAccountList(){
    
        return myAccountList; 
    }

    /**

    * Method to export the account table in Excel.

    * Redirect to a visualforce page for EXCEL export

    */

    public PageReference exportToExcel(){

        PageReference retURLExcel = new PageReference('/apex/MyDataTable_Excel');
        
        return retURLExcel;
    
    }

    /** * Method to export the account table to PDF.

    * Redirect to a visualforce page for PDF export */

    public PageReference exportToPDF(){

        PageReference retURLPDF = new PageReference('/apex/MyDataTable_PDF');
        
        return retURLPDF;
        
    }
    
}