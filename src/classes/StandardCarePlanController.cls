/*
	Author: Eamon Kelly, Enclude
	Purpose: Create a standard care plan by copying all and care plan objective templates and steps and associating them with the client
	Called from: Button on client launches StandardCarePlan.page  
	Tested in: TestStandardCarePlanCreation
*/
global class StandardCarePlanController 
{ 
	private List<Schema.FieldSetMember> goalFields {get;set;}
	private List<Schema.FieldSetMember> stepFields {get;set;}
	private Contact client;
	global list <Care_Plan_Obj_Template__c> goalList {get;Set;}
	global StandardCarePlanController(ApexPages.StandardController stdController) 
	{
   		system.debug ('Params: ' + apexpages.currentpage().getParameters());

		client = (Contact)stdController.getRecord();
    	goalFields = getFields (Schema.SObjectType.Care_Plan_Obj_Template__c.fieldSets.getMap().get('Fields_to_be_copied'));
    	stepFields = getFields (Schema.SObjectType.Care_Plan_Step_Template__c.fieldSets.getMap().get('Fields_to_be_copied'));
		goalList = [select Id, Name, Area__c, Include_this_objective__c, 
			(select Id, Name, Include_this_step__c, Description__c, What_step_needs_to_happen_first__c from Care_Plan_Step_Templates__r order by Creation_Order__c) 
			from Care_Plan_Obj_Template__c order by Area__c];
	}

	global PageReference CreateCarePlan ()
	{
		AddObjectives ();
		return GoToReview ();
	}

	global PageReference AddObjectives ()
	{
		String soql = prepareSOQLStatement (goalFields, stepFields);
		list <Care_plan_step__c> stepsToCreate = new list <Care_plan_step__c>();
		for (Care_Plan_Obj_Template__c oneGoal : goalList)
		{
			if (oneGoal.Include_this_objective__c)
			{
				Care_Plan_Obj_Template__c oneTemplate = getObjectiveTemplate (soql, oneGoal.Id);
				// clone this objective as it has been selected
				Care_Plan_Objective__c newObjective = new Care_Plan_Objective__c (Client__c=client.id);
				for(Schema.FieldSetMember f : goalFields) 
				{
					newObjective.put(f.getFieldPath(), oneTemplate.get(f.getFieldPath()));
		        }
				insert newObjective; // there will never be more than five or six standard care plan objectives, so safe to do an insert here

				// make a map of the steps in this goal so that we can clone the ones that have been selected
				map <ID, Care_Plan_Step_Template__c> stepsInGoal = new map <Id, Care_Plan_Step_Template__c> ();
				for (Care_Plan_Step_Template__c oneStep : oneTemplate.Care_Plan_Step_Templates__r)
				{
					stepsInGoal.put (oneStep.Id, oneStep);
				}
				// Now clone the ones selected
				for (Care_Plan_Step_Template__c oneStep : oneGoal.Care_Plan_Step_Templates__r)
				{
					if (oneStep.Include_this_step__c)
					{
						Care_Plan_Step_Template__c stepToClone = stepsInGoal.get (oneStep.Id);
						Care_Plan_Step__c newStep = new Care_Plan_Step__c (Care_Plan_Objective__c = newObjective.Id, ID_of_template__c=oneStep.Id, ID_of_What_Needs_Template__c = oneStep.What_step_needs_to_happen_first__c);
						for(Schema.FieldSetMember f : stepFields) 
						{
							newStep.put(f.getFieldPath(), stepToClone.get(f.getFieldPath()));
						}
						stepsToCreate.add (newStep);
					}
				}
			}
		}
		if (stepsToCreate.size() > 0) 
		{
			insert stepsToCreate;
			// need to link the steps together
			LinkSteps (stepsToCreate);
		}
		return null;
	}

	global PageReference GoToReview ()
	{
		PageReference reviewPage = Page.CarePlanReview;
		reviewPage.getParameters().putAll (apexpages.currentpage().getParameters());
	    reviewPage.getParameters().put('ID', null);
	    reviewPage.getParameters().put('FromStandardPage', 'true');
		return reviewPage;
	}

	private void LinkSteps (list <Care_plan_step__c> stepsToLink)
	{
		// for all the steps, if the ID_of_What_Needs_Template__c is populated, then find the step that this refers to using ID_of_template__c and link it to this step
		// start with a map of the templates to the steps
		map <Id, Care_plan_step__c> templatesToStepsMap = new map <Id, Care_plan_step__c> ();
		for (Care_plan_step__c oneStep : stepsToLink)
		{
			templatesToStepsMap.put (oneStep.ID_of_template__c, oneStep);
		}
		// now go through all the steps making the connection
		for (Care_plan_step__c oneStep : stepsToLink)
		{
			if (oneStep.ID_of_What_Needs_Template__c != null)
			{
				oneStep.What_step_needs_to_happen_first__c = templatesToStepsMap.get (oneStep.ID_of_What_Needs_Template__c).Id;
			}
		}
		update stepsToLink;
	}

	private List<Schema.FieldSetMember> getFields(Schema.FieldSet fs1) 
    {
        if (fs1 == null)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'No fieldset found for ' + fs1);
            ApexPages.addMessage(myMsg);
            return new list <Schema.FieldSetMember> ();
        } 
        
        List<Schema.FieldSetMember> allFields = fs1.getFields();
        List<Schema.FieldSetMember> returnFields = new List<Schema.FieldSetMember>();
        
        for (Integer i=0; i<allFields.size(); i++)
        {
            returnFields.add (allFields[i]);            
        }
        return returnFields;
    }

	private String prepareSOQLStatement (List<Schema.FieldSetMember> needsFields, List<Schema.FieldSetMember> stepsFields)
	{
        String soql = getSelectStatement (needsFields);
        String stepSoql = getSelectStatement (stepsFields);
        soql += ', (' + stepSoql + ' from Care_Plan_Step_Templates__r )';
        soql += ' from Care_Plan_Obj_Template__c where ID = :templateID';
		return soql;
	}

    private Care_Plan_Obj_Template__c getObjectiveTemplate (String soql, ID templateID)
    {
        
        Care_Plan_Obj_Template__c oneObjective = database.query(soql);
        
        return oneObjective;
    }
    
    private static String getSelectStatement (List<Schema.FieldSetMember> fieldList)
    {
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : fieldList) 
        {
            query += f.getFieldPath() + ', ';
        }
        query += 'ID ';
        return query;
    }

}