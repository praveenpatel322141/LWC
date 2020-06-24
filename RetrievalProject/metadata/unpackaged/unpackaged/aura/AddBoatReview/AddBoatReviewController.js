({
    doInit : function(component, event, helper) {
        helper.onInit(component, event, helper);  
    },
    
    onSave : function(component, event, helper) {
        component.find("service").saveRecord($A.getCallback(function (saveResult){
            	
                if (saveResult.state == 'ERROR') 
                {
                    console.log('Error saving review record: ' + component.get('v.recordError'));
                } 
                else {
                    
                    var toastEvent = $A.get('e.force:showToast');  
                    if (toastEvent) {
                        toastEvent.setParams({
                            title: 'Success!',
                            message: 'Your review has been saved successfully'
                        });
                        toastEvent.fire();
                    } else {
                        alert (message);
                    }
                    helper.onInit(component, event, helper);
                    component.getEvent('BoatReviewAdded').fire();
                }
            }));
        
    },
    
    onRecordUpdated: function(component, event, helper){
        
    }
})