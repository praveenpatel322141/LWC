({
    calloutCtrl : function(component, event, helper) {
        // Rates are quoted against the Euro by default. 
        // Quote against a different currency by setting the base parameter in your request.        
        var source = 'USD';
        var currencies = component.get("v.selectedSkillsItems");
        helper.getResponse(component, source, currencies);
    },
    initialize: function(component, event, helper) {
       // call the fetchPickListVal helper function,
       // and pass (component, Field_API_Name, target_Attribute_Name_For_Store_Value)   
        helper.fetchPickListVal(component, 'CurrencyType__c', 'listSkillsOptions');
    },
    handleChange: function (component, event) {
       // get the updated/changed values   
        var selectedOptionsList = event.getParam("value");
       // get the updated/changed source  
        var targetName = event.getSource().get("v.name");
       
        // update the selected itmes  
        if(targetName == 'Skills'){ 
            component.set("v.selectedSkillsItems" , selectedOptionsList);
        }
        
    },
    getSelectedItems : function(component,event,helper){
       // get selected items on button click 
        alert(component.get("v.selectedSkillsItems"));
    },
    doInit : function(component) {
        var action = component.get("c.getPickListValuesIntoList");
        action.setParams({
            objectType: component.get("v.sObjectName"),
            selectedField: component.get("v.fieldName")
        });
        action.setCallback(this, function(response) {
            var list = response.getReturnValue();
            component.set("v.picklistValues", list);
        })
        $A.enqueueAction(action);
    }
 
})