public class DocumentsClass{
    List<DocumentWrapper> documentList = new List<DocumentWrapper>();
    List<SSP_Document__c> selectedSSPDocuments = new List<SSP_Document__c>();


    public DocumentsClass(ApexPages.StandardController controller) {

    }

    public List<DocumentWrapper> getSSPDocuments() {
        for(SSP_Document__c d : [select Id, Name from SSP_Document__c ORDER BY CREATEDDATE limit 20])
        documentList.add(new DocumentWrapper(d));
        return documentList;
    }

    public PageReference getSelected() {
        selectedSSPDocuments.clear();
        for(DocumentWrapper docWrapper : documentList)
        if(docWrapper.selected == true)
        selectedSSPDocuments.add(docWrapper.doc);
        return null;
    }

    public List<SSP_Document__c> GetSelectedSSPDocuments() {
        if(selectedSSPDocuments.size()>0) {
            return selectedSSPDocuments;
        } else {
            return null;
        }
    }    

    public class DocumentWrapper {
        public SSP_Document__c doc{get; set;}
        public Boolean selected {get; set;}
        public DocumentWrapper(SSP_Document__c d) {
            doc = d;
            selected = false;
        }
    }
}