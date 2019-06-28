({
	partialAddress : function(component, event, helper) 
    {
        var countyEntered = component.find('county').get("v.value");
        var streetEntered = component.find('street').get("v.value");
        if (streetEntered.length > 5)
        {
            var action = component.get("c.getPickListValuesIntoList");
            action.setParams({
                street: streetEntered,
                county: countyEntered,
            });
            action.setCallback(this, function(response) {
                var list = response.getReturnValue();
                component.set("v.streetAddresses", list);
		        if (!list[0].startsWith("Error"))
                {
                    helper.getSingleArea (component, list[0]);
                }
          })
            $A.enqueueAction(action);
        }
    },
    displaySmallArea : function(cmp, event, helper) 
    {
        var streetSelected = cmp.find('addresses').get("v.value");
        helper.getSingleArea (cmp, streetSelected);
    },
    saveRecord : function (cmp, event, helper)
    {
        var tempRec = cmp.find("forceRecord");
		tempRec.saveRecord($A.getCallback(function(result) 
        {
    		console.log(result.state);
    		var resultsToast = $A.get("e.force:showToast");
    		if (result.state === "SUCCESS") 
            {
      		resultsToast.setParams({
            		"title": "Saved",
            		"message": "The small area was saved on the client record."
        		});
        		resultsToast.fire();                
   			} 
            else if (result.state === "ERROR") 
        	{
        		console.log('Error: ' + JSON.stringify(result.error));
    		resultsToast.setParams({
            		"title": "Error",
            		"message": "There was an error saving the record: " + JSON.stringify(result.error)
        		});
        		resultsToast.fire();
    		}
            else
            {
        		console.log('Unknown problem, state: ' + result.state + ', error: ' + JSON.stringify(result.error));
    		}
		}));

    }
})