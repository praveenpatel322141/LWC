@isTest private class TestControlerMyDataTable{

	private static testMethod void TestControlerMyDataTable() {

        //Create an account with Type ='Customer - Direct' and rating = 'Hot'

        Account acc0 = new Account(Name='Account0',Type='Customer - Direct',rating='Hot');

        // Create an account with Type ='Customer - Direct' and rating = 'Warm'

        Account acc1 = new Account(Name='Account1',Type='Customer - Direct',rating='Warm');

        //Create an account with rating = 'Warm'

        Account acc2 = new Account(Name='Account2',rating='Warm');

        //Create an account with Type ='Customer - Direct'

        Account acc3 = new Account(Name='Account3',Type='Customer - Direct');

        //Create a list and add all account

        List<Account> listeAcc = new List<Account>();

        listeAcc.add(acc0);

        listeAcc.add(acc1);

        listeAcc.add(acc2);

        listeAcc.add(acc3);

        //Insert account once because they’re in a list (the list avoid users to insert 4 times because we have SOQL limit (200 request max).

        insert listeAcc;

        // Start you test here

        test.startTest();

        // Instanciate your controller in order to test all method

        ControlerMyDataTable ctrl = new ControlerMyDataTable();

        // Retrieve accounts meeting different criteria

        List<Account> listeAccountFromControlleur = ctrl.getmyAccountList();

        // Result - Only 2 out of 4 accounts meet the requested criteria

        System.assertequals(listeAccountFromControlleur.size(),4);

        // Redirection to the Excel page

        String excelPage = ctrl.exportToExcel().getUrl();

        System.assertEquals('/apex/MyDataTable_Excel', excelPage);

        // Redirection to the Excel page

        String pdfPage = ctrl.exportToPDF().getUrl();

        System.assertEquals('/apex/MyDataTable_PDF', pdfPage);

        test.stopTest();

	}

}