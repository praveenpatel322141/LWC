({
	forwardLPCComplaint : function(component, event, helper) {
		var LPCEvent = componrnt.get("LowPrioriyComplaintFromTownship1");
        LPCEvent.setParams("complainMessage","Township 2 is not behaving properly");
        LPCEvent.fire();
	}
})