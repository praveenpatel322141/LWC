public class InTheArea {
  @AuraEnabled
  public static String getLocal (String searchTerm, Decimal lat, Decimal lon) {
      String url = 'https://th-yelp-locator.herokuapp.com/search?address=' + lat +','+ lon + '&term=' + EncodingUtil.urlEncode(searchTerm, 'UTF-8');
      String resultList = getHttp(url);
      return resultList;  
  }
   
  private static String getHttp (String url) {
      HttpRequest req = new HttpRequest();
      Http http = new Http();
      req.setMethod('GET');   
      req.setEndpoint(url);
      HTTPResponse res = http.send(req);
      return res.getBody();
  }

   @AuraEnabled
   public static string getListByAddress(ID recordID, String searchQuery){
        try{
            String conLocation = contactSelect(recordID);
            String url = 'https://th-yelp-locator.herokuapp.com/search?address=' + EncodingUtil.urlEncode(conLocation, 'UTF-8') + '&term=' + EncodingUtil.urlEncode(searchQuery, 'UTF-8');
                 String resultList = getHttp(url);
                 return resultList;
        }
        catch(Exception ex){
          return '{"error": "' + ex.getMessage() + '"}';
        }
    }
   
    private static string contactSelect(ID recordID){
         Contact contact = [SELECT MailingStreet, MailingCity, MailingState,MailingCountry FROM Contact WHERE Id=: recordId];
         String conLocation = contact.MailingStreet + ',' + contact.MailingCity + ',' + contact.MailingState + ',' + contact.MailingCountry;
         //String conlocation = contact.MailingCountry;// + ',' + contact.MailingCity + ',' + contact.MailingState;
                 return conLocation;
       
    }

}