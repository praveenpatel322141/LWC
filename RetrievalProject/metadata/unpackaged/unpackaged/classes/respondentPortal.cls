@RestResource(urlMapping='/respondentPortal/*')
global class respondentPortal 
{
    
    
    //simple wrapper response class. Makes it so all replies via this API have the same basic structure
    //including a boolean success flag, a message, any sObjects affected and some debugging params.
    global class restResponseWrapper
    {
        string message = 'run successful';
        boolean success = true;
        list<string> params = new list<string>();       
        list<sobject> sObjects = new list<sobject>();
        string requestURI = RestContext.request.requestURI;
    }
    
    class applicationException extends Exception {}
    
    //can run queries. This one doesn't except an /objectType/Id as the other methods do. This one just takes a query as specified in the
    //?query= param of the url. It will return all the objects in the sObjects property of the returned object.
    @HttpGet
    global static void doGet() 
    {                     
        restResponseWrapper thisResponse = new restResponseWrapper();
        
        //since all requests to this service will be get, since we are operating using JSONP, we first need to figure out what they actually want to do.
        thisResponse.params = getRestParams(thisResponse.requestURI);     
        string httpVerb = thisResponse.params[1].toLowerCase();

        try
        {      
              
            if(RestContext.request.params.get('authToken') == null)
            {
                throw new applicationException('No auth token provided. Please provide one with ?authToken= in the request url');
            }
            long authToken = getAuthToken();
            long providedToken = long.valueOf(RestContext.request.params.get('authToken'));
            
            //check the auth token, provide a 20 second range where it is valid (+10 seconds, -10 seconds)
            if(providedToken == null || providedToken < authToken - 10000 || providedToken > authToken + 10000)
            {
                throw new applicationException('Invalid auth token');
            }
                     
            if(httpVerb == 'get')
            {               
                String query = RestContext.request.params.get('query');
                thisResponse.sObjects = runQuery(EncodingUtil.urlDecode(query,'UTF-8'));  
                 
            }
            else if(httpVerb == 'post')
            {
                thisResponse.sObjects.add(saveSObject(thisResponse.params[2],null,RestContext.request.params));
            }
            else if(httpVerb == 'put')
            {
                thisResponse.sObjects.add(saveSObject(thisResponse.params[2],thisResponse.params[3],RestContext.request.params));
            } 
            else if(httpVerb == 'delete')
            {
                Schema.sObjectType objectDef = Schema.getGlobalDescribe().get(thisResponse.params[2]).getDescribe().getSObjectType();     
                sObject obj = objectDef.newSobject(thisResponse.params[3]);     
                database.delete(obj);  
            }   
            else
            {
                thisResponse.success = false;
                thisResponse.message = 'method ' + httpVerb + ' not implimented';                
            }          
        } 
        catch(exception e)
        {
            thisResponse.success = false;
            thisResponse.message = e.getMessage();
        }     
        

        RestContext.response.addHeader('Content-Type', 'text/plain');
        RestContext.response.responseBody = formatResponse(thisResponse);                    

    }

    
    
    //take a query string and run it. Yeah, I know SOQL injection possible here, but whatever. This
    //whole thing is inherently insecure. It's like worrying about wet floors on the titanic.
    public static list<sobject> runQuery(string queryString)
    {
        list<sobject> objs = new list<sobject>();
        objs = database.query(queryString);
        return objs;
    }
    
    //returns rest params (things after the main url, separated by /)
    //in an easy to use list. The name of the class should be element 0, the 
    //type of object should be element 1 and the id of the object should be element 2
    global static list<string> getRestParams(string url)
    {
        list<string> returnParams = new list<string>();
        integer endOfUrl = url.indexOf('?');
        if(endOfUrl == -1)
        {
            endOfUrl = url.length();
        }
        //clean up the url, make sure we are only dealing with the section we want to. After the host name, before the ? mark.
        //i've seen in come in with the full host name, and also just the relative portion, so we gotta make sure it's exactly the same
        //from here on in, or else the array it returns could get all messed up.
        if(url.indexOf('/apexrest/') > 0)
        {   
            url = url.substring(url.indexOf('/apexrest/')+10,endOfUrl);
        }  
        else
        {
            url = url.substring(1,endOfUrl);
        }            
        list<String> URLParams = url.split('/'); 
         
        for(integer i =0; i < 4; i++)
        {
            if(i<urlParams.size())
            {
                returnParams.add(EncodingUtil.urlDecode(urlParams[i], 'UTF-8'));
            }
            else
            {
                returnParams.add(' ');
            }
        }   
        
        return returnParams;           
    }
    
    
    //so for the record, I really dislike this method. I wish I could just take the pure json data and deserialize it into
    //an sobject type defined at runtime, but as far as I know, you cannot do that (at least I couldn't find the syntax for it).
    //so instead this iterates over the keys of the sobject known from the global describe, finds matching keys in the JSON data
    //and assignes the value from the JSON to the sObject.
    public static sObject saveSObject(string objectType, string recordid, Map<String, Object> sObjectData)
    {
        //create a generic sObject to contain the update values.
        sObject updateObj;      
                
        //get the describe object for the type of object passed in (its just passed in as a string from the URL)
        Schema.sObjectType objectDef = Schema.getGlobalDescribe().get(objectType).getDescribe().getSObjectType();
        
        //find all the fields for this object type
        Map<String, Schema.SobjectField> ObjectFieldsMap = objectDef.getDescribe().fields.getMap();
        
 
        //this method can handle updates or inserts. If a record ID was passed in, 
        //cast the object as the type represented by the ID. If not, just create a
        //new object of the type found in the object describe.
        if(recordId != null)
        {
            updateObj = objectDef.newSobject(recordid);
        }
        else
        {
            updateObj = objectDef.newSobject();
        }    
        // populate the object's fields by looping over all the params in the rest request.
        for (String key : sObjectData.keySet())
        {
            // only add params if they are valid field on the object
            if (ObjectFieldsMap.containsKey(key))
            {
                //figure out the type of this field so we can cast it to the correct type
                string fieldType = ObjectFieldsMap.get(key).getDescribe().getType().name().ToLowerCase();
                
                //since I don't know how to do, or if it's even possible to do dynamic casting we need a 
                //series of if statments to handle the casting to numeric types. I think all the others should
                //be fine if left as a string. Dates might explode, not sure.
                
                
                if(fieldType == 'currency' || fieldType == 'double' || fieldType == 'percent' || fieldType == 'decimal' )
                {
                    updateObj.put(key, decimal.valueOf(string.valueOf(sObjectData.get(key)).trim())); 
                }
                else if(fieldType == 'boolean')
                {
                    updateObj.put(key, Boolean.valueOf(sObjectData.get(key))); 
                }                   
                else if(fieldType == 'date')
                {
                    updateObj.put(key, date.valueOf(sObjectData.get(key))); 
                }                
                else
                {
                    updateObj.put(key, sObjectData.get(key));
                }
            }
            else
            {
                system.debug('Invalid field: '+ key + ' for object type ' + objectType);
            }
        }
        //update/insert the object
        upsert updateObj;
        
        //return the saved object.
        return updateObj;
        
    }
        
    //take one of those wrapper objects and format it by wrapping it in a callback if needed, and serializing 
    //the result into json.    
    public static blob formatResponse(restResponseWrapper responseData)
    {
        string response;
        String callback = RestContext.request.params.get('callback');
        if(callback != null)
        {
            response = callback + '(' + JSON.serialize(responseData) + ');';
        }    
        else
        {
            response = JSON.serialize(responseData);
        }
        return blob.valueOf(response);
    }
    
    //just put some random mathemtical expression here that will only be known by the client application and 
    //this class. I know it's not super secure, but it's better than nothing. Will at least stop super novice
    //script kiddies.
    public static long getAuthToken()
    {
        return DateTime.Now().getTime() - 42131 / 3 * 8;
    }
    
   
}