public class CurrencyLayer {
    
    @AuraEnabled
    public static List < String > getselectOptions(sObject objObject, string fld) {
        system.debug('objObject --->' + objObject);
        system.debug('fld --->' + fld);
        List < String > allOpts = new list < String > ();
        // Get the object type of the SObject.
        Schema.sObjectType objType = objObject.getSObjectType();
        
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        
        // Get a map of fields for the SObject
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        
        // Get the list of picklist values for this field.
        list < Schema.PicklistEntry > values =
            fieldMap.get(fld).getDescribe().getPickListValues();
        
        // Add these values to the selectoption list.
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        system.debug('allOpts ---->' + allOpts);
        allOpts.sort();
        return allOpts;
    }
    // Pass in the endpoint to be used using the string url
    @AuraEnabled
    public static Map < String,Object > getUpdatedCurrencyRate(String url) {
 
        // Instantiate a new http object
        Http h = new Http();
 
        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');
 
        // Send the request, and return a response
        HttpResponse res = h.send(req);
        System.debug('response:--> ' + res.getBody());
 
        // Deserialize the JSON string into collections of primitive data types.
        Map < String,
        Object > resultsMap = (Map < String, Object > ) JSON.deserializeUntyped(res.getBody());
        system.debug('resultsMap-->' + resultsMap);
 
        return resultsMap;
    }
}