({
	smallAreaFromJSON : function(healthAtlasResponse) 
    {
		var parsed = JSON.parse(healthAtlasResponse);
        return parsed.sa_no;
	},
	CHOFromJSON : function(healthAtlasResponse) 
    {
		var parsed = JSON.parse(healthAtlasResponse);
        return parsed.cho;
	},
	DEDFromJSON : function(healthAtlasResponse) 
    {
		var parsed = JSON.parse(healthAtlasResponse);
        return parsed.ed_no.toString();
	},
    getSingleArea : function (component, streetSelected)
    {
	    var action = component.get("c.getSingleAddress");
        action.setParams({
            street: streetSelected,
        });
        action.setCallback(this, function(response) {
            var jsonResponse = response.getReturnValue();
            component.set("v.clientRecord.Small_Area__c", this.smallAreaFromJSON(jsonResponse));
            component.set("v.clientRecord.CHO__c", this.CHOFromJSON(jsonResponse));
            component.set("v.clientRecord.DED__c", this.DEDFromJSON(jsonResponse));
        })
        $A.enqueueAction(action);
	}
})