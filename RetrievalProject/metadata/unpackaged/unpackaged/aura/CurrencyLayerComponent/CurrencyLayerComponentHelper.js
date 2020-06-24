({
    getResponse: function(component, source, currencies) {
        // create a server side action.       
        var action = component.get("c.getUpdatedCurrencyRate");
        // set the url parameter for getUpdatedCurrencyRate method (to use as endPoint) 
        action.setParams({
            "url": 'http://apilayer.net/api/live?access_key=e4cda9a51c3e06714eef96518c8f5695&source=' + source + '&currencies=' + currencies + '&format=1'
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                // set the response(return Map<String,object>) to response attribute.      
                component.set("v.response", response.getReturnValue());
 
                // get the all quotes from map by using key              
                var getAllRates = component.get("v.response")['quotes'];
                var CurrencyList = [];
                // play a loop on rates object 
                for (var key in getAllRates) {
                    // push all rates with there Name in CurrencyList variable.        
                    CurrencyList.push(key + ' = ' + getAllRates[key]); // i.e : INR = 67.919  
                }
                // set the CurrencyList to ListOfCurrency attribute on component.           
                component.set("v.ListOfCurrency", CurrencyList);
            }
        });
 
        $A.enqueueAction(action);
    },
    fetchPickListVal: function(component, fieldName,targetAttribute) {
      // call the apex class method and pass fieldApi name and object type 
        var action = component.get("c.getselectOptions");
        action.setParams({
            "objObject": component.get("v.objInfo"),
            "fld": fieldName
        });
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
                component.set("v."+targetAttribute, opts);
            }else{
                alert('Callback Failed...');
            }
        });
        $A.enqueueAction(action);
    },
})