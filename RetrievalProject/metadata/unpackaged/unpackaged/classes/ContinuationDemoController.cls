public class ContinuationDemoController {  
    
    public String result {get;set;} 
    private static final String CALLOUT_URL = 
        'https://node-count.herokuapp.com/'; 
    public String apiCount {get;set;}   
    public String callBackHandlerName {get;set;}
    String continuationState = '' ;
    public ContinuationDemoController(){
        result = '';
    } 
    
    public Object startRequest() {   
      return constructCallout(callBackHandlerName,CALLOUT_URL, apiCount);
    } 
      
    public Object callout1Response() {  
        HttpResponse response = Continuation.getResponse(continuationState);  
        result = result + 'API'+ apiCount +' processing completed' ;  
        return null; 
    }    
      

    private Continuation constructCallout(String callbackMethodName,String endpointURL, String apiCount){
        Continuation chainedContinuation = null;  
        chainedContinuation = new Continuation(60); 
        chainedContinuation.continuationMethod=callbackMethodName; 
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint(endpointURL+apiCount); 
        continuationState = chainedContinuation.addHttpRequest(req); 
        return chainedContinuation;  
    }
}