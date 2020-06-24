({
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
    }
})