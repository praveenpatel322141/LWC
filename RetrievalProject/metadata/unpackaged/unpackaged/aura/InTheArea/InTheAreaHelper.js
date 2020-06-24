({
                getLocalList : function(component) {
                                //var searchTerm = component.get("v.defaultSearch");
                                //var action = component.get("c.getLocal");
        var recID =  component.get("v.recordId");
        var location = component.get("v.location");
        var searchTerm = component.find("searchTerm").get("v.value");
        if(searchTerm == null){
            var searchTerm = component.get("v.defaultSearch");
        }
        location = JSON.parse(location);
        var action = component.get("c.getListByAddress");
        action.setParams({
            //"searchTerm" : searchTerm,
            //"lat" : location.coords.latitude,
            //"lon" : location.coords.longitude
            "recordID" : recID,
            "searchQuery" : searchTerm
        });
       
        /*action.setCallBack(this,function(response){
                 this.doLayout(response,component);                  
        });*/
        action.setCallback(this, function(response) {
            this.doLayout(response, component);
                                });
       
        $A.enqueueAction(action);
                },

   doLayout : function(response,component){
        //var data = JSON.parse(response.getReturnValue());
        //component.set("v.restaurantList",data.bizArray);
        console.log("Data from apex method"  + response.getReturnValue());
   }
})