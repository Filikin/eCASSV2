/*
	Author: Eamon Kelly, Enclude
	Purpose: Create a standard care plan by copying all and care plan objective templates and steps and associating them with the client
	Called from: Button on client launches StandardCarePlan.page  
	Tested in: TestStandardCarePlanCreation
*/
global class StandardCarePlanControllerUsingMetaData 
{ 
	global string currentGoal {get; set;}
	global string currentStep {get; set;}
	global class stepWrapper
	{
		global Boolean bIncludeThisStep {get;set;}
		global CPS_Template__mdt thisStep {get;set;}
		global stepWrapper (CPS_Template__mdt aStep)
		{
			thisStep = aStep;
			bIncludeThisStep = thisStep.Include_this__c;
		}
	}

	global class goalWrapper
	{
		global Boolean bIncludeThisGoal {get;set;}
		global CPO_Template__mdt thisGoal {get;set;}
		global list <stepWrapper> stepList {get;set;}
		global goalWrapper (CPO_Template__mdt aGoal)
		{
			thisGoal = aGoal;
			bIncludeThisGoal = thisGoal.Include_this__c;
			stepList = new list<stepWrapper>();
		}
	}
	map <String, goalWrapper> goalWrapperMap = new map <String, goalWrapper>();
	
	private Map<String, Schema.sObjectField> goalFields {get;set;}
	private Map<String, Schema.sObjectField> stepFields {get;set;}
	private Contact client;
	global transient list <goalWrapper> goalList {get;Set;}
	
	private map<id, CPS_Template__mdt> stepsSelected=new map<id, CPS_Template__mdt>();
	private map<id, CPO_Template__mdt> goalsSelected=new map<id, CPO_Template__mdt>();

	global void AddStep ()
	{
		ID stepTemplateID = currentStep;
		if (stepsSelected.get(stepTemplateID) == null) // user has ticked the checkbox
		{
			CPS_Template__mdt oneStep = [select Id, DeveloperName, MasterLabel, Care_Plan_Obj_Template__c, Include_this__c, Description__c, What_step_needs_to_happen_first__c, Status__c, Obsolete__c 
				from CPS_Template__mdt where Id=:stepTemplateID]; 
			system.debug ('One step: ' + oneStep);
			stepsSelected.put (oneStep.id, oneStep);
		}
		else // user has unticked the checkbox
		{
			stepsSelected.remove (stepTemplateID);
		}
	}

	global PageReference AddGoal ()
	{
		ID goalTemplateID = currentGoal;
		if (goalsSelected.get(goalTemplateID) == null) // user has ticked the checkbox
		{
			CPO_Template__mdt oneGoal = [select Id, DeveloperName, MasterLabel, Area__c, Include_this__c, Objective_Note__c, Objective_Status__c, Priority__c, Obsolete__c
            from CPO_Template__mdt where ID = :goalTemplateID];
			goalsSelected.put (oneGoal.id, oneGoal);
		}
		else // user has unticked the checkbox
		{
			goalsSelected.remove (goalTemplateID);
		}
		return null;
	}

	private map <String, ID> nameOfStepToID;
	global StandardCarePlanControllerUsingMetaData(ApexPages.StandardController stdController) 
	{
		client = (Contact)stdController.getRecord();
    	goalFields = Schema.SObjectType.CPO_Template__mdt.fields.getMap();
    	stepFields = Schema.SObjectType.CPS_Template__mdt.fields.getMap();
    	createGoalList ();
		createStepList ();
	}

	private void createGoalList ()
	{
        list<CPO_Template__mdt> goals = [select Id, DeveloperName, MasterLabel, Area__c, Include_this__c, Objective_Note__c, Objective_Status__c, Priority__c, Obsolete__c
            from CPO_Template__mdt order by Area__c];
		goalList = new list<goalWrapper>();
		for (CPO_Template__mdt oneGoal : goals)
		{
            if (!oneGoal.Obsolete__c) 
            {
            	goalWrapper oneGoalWrapper = new goalWrapper (oneGoal);
            	goalList.add (oneGoalWrapper);
            	goalWrapperMap.put (oneGoal.DeveloperName, oneGoalWrapper);
	            if (oneGoal.Include_this__c) // this goal is already ticked
	            {
					goalsSelected.put (oneGoal.id, oneGoal);
	            }
            }
		}
        system.debug ('Goal list size: ' + goalList.size());
	}
	
	private void createStepList ()
	{
        list <CPS_Template__mdt> steps = [select Id, DeveloperName, MasterLabel, Care_Plan_Obj_Template__c, Include_this__c, Description__c, What_step_needs_to_happen_first__c, Status__c, Obsolete__c 
            from CPS_Template__mdt order by Care_Plan_Obj_Template__c, Creation_Order__c]; 
		nameOfStepToID = new map <String, ID> ();
		for (CPS_Template__mdt oneStep : steps)
		{
            if (!oneStep.Obsolete__c)
            {
            	goalWrapper stepsGoal = goalWrapperMap.get (oneStep.Care_Plan_Obj_Template__c);
            	if (stepsGoal != null)
            	{
					nameOfStepToID.put (oneStep.DeveloperName, oneStep.id);
					stepsGoal.stepList.add (new stepWrapper (oneStep));
		            if (oneStep.Include_this__c) // this step is already ticked
		            {
						stepsSelected.put (oneStep.id, oneStep);
		            }
            	}
			}
		}
   }
	
	global PageReference CreateCarePlan ()
	{
		AddObjectives ();
		return GoToReview ();
	}

	global PageReference AddObjectives ()
	{
		list <Care_plan_step__c> stepsToCreate = new list <Care_plan_step__c>();
		for (CPO_Template__mdt oneGoal : goalsSelected.values())
		{
			// clone this objective as it has been selected
			Care_Plan_Objective__c newObjective = new Care_Plan_Objective__c (Client__c=client.id, Name=oneGoal.MasterLabel);
			for(Schema.sObjectField f : goalFields.values()) 
			{
                if (f.getDescribe().isCustom() && f.getDescribe().getName() != AppConfigSupport.PackagePrefix+'Include_this__c' && f.getDescribe().getName() != AppConfigSupport.PackagePrefix+'Obsolete__c')
				{
					newObjective.put(f.getDescribe().getName(), oneGoal.get(f.getDescribe().getName()));
		        }
			}
			insert newObjective; // there will never be more than five or six standard care plan objectives, so safe to do an insert here

			// Now clone the steps selected
			for (CPS_Template__mdt oneStep : stepsSelected.values())
			{
				if (oneStep.Care_Plan_Obj_Template__c == oneGoal.DeveloperName)
				{
					Care_Plan_Step__c newStep = new Care_Plan_Step__c (Care_Plan_Objective__c = newObjective.Id, ID_of_template__c=oneStep.Id, ID_of_What_Needs_Template__c = nameOfStepToID.get (oneStep.What_step_needs_to_happen_first__c)); 
					for(Schema.sObjectField f : stepFields.values()) 
					{
						if (f.getDescribe().isCustom() && f.getDescribe().getName() != AppConfigSupport.PackagePrefix+'Include_this__c' 
							&& f.getDescribe().getName() != AppConfigSupport.PackagePrefix+'Care_Plan_Obj_Template__c' && f.getDescribe().getName() != AppConfigSupport.PackagePrefix+'Creation_Order__c' 
                            && f.getDescribe().getName() != AppConfigSupport.PackagePrefix+'What_step_needs_to_happen_first__c'
                            && f.getDescribe().getName() != AppConfigSupport.PackagePrefix+'Obsolete__c')
						{
							if (f.getDescribe().getName().Contains ('Description') && oneStep.get(f.getDescribe().getName()) == null) // if the description is blank, use the master label
							{
								newStep.put(f.getDescribe().getName(), oneStep.get('MasterLabel'));
							}
							else
							{
								newStep.put(f.getDescribe().getName(), oneStep.get(f.getDescribe().getName()));
							}
						}						
				    }
					stepsToCreate.add (newStep);
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
}