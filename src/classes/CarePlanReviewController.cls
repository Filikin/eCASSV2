/*
	Author: Eamon Kelly, Enclude
	Purpose: Display a care plan and allow steps and reviews to be created
	Called from: Button on Client
	Tested in: TestCarePlanReview
*/
global with sharing class CarePlanReviewController 
{
	global List<Schema.FieldSetMember> goalHeaderFields {get;set;}
	global List<Schema.FieldSetMember> goalFields {get;set;}
	private List<Schema.FieldSetMember> allGoalFields {get;set;}
	private List<Schema.FieldSetMember> allStepFields {get;set;}
	global List<Schema.FieldSetMember> stepTaskFields {get;set;}
	global List<Schema.FieldSetMember> stepAttendanceFields {get;set;}
	private ApexPages.StandardController cpsc;
	private Boolean calledFromStandardPage=false;
	global Contact client {get; set;}
	global Care_Plan_Review__c review {get;set;}
	private list <Care_Plan_Objective__c> internalGoalList; 
	global String attendancePrefix {get;Set;}
	global String careplanstepPrefix {get;Set;}
	global Boolean showAttendanceSteps {get;Set;}
	global list <Care_Plan_Objective__c> goalList 
	{
		get 
		{
			return internalGoalList;
		} 
		set;
	}

	global CarePlanReviewController(ApexPages.StandardController stdController) 
	{
		Initialise ();
		try // to get hold of the client - maybe this is launched from the "New" button on the Care Plan Review home page
		{	        
 			if (apexpages.currentpage().getParameters().get('retURL') != null)
			{
	    		review = (Care_Plan_Review__c)stdController.getRecord();
	    		system.debug ('retURL: ' + apexpages.currentpage().getParameters().get('retURL'));
				String clientID = apexpages.currentpage().getParameters().get('retURL').substring (1,16);
	    		client = [select ID, Name from Contact where Id=:clientID];
			}
			else
			{
				review = [select ID, Name, Client__c, Client_present_at_review__c, Summary__c, Next_Review_Date__c, Review_Date__c from Care_Plan_Review__c where id=:stdController.getID()];
	    		client = [select ID, Name from Contact where Id=:review.Client__c];
			}
		}
		catch (Exception e)
		{
			client = null;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, Label.Care_Plan_Review_without_Client);
            ApexPages.addMessage(myMsg);
		}

		if (apexpages.currentpage().getParameters().get('PRINT') != null)
		{
			if (apexpages.currentpage().getParameters().get('showAttendanceSteps') != null)
			{
				showAttendanceSteps = apexpages.currentpage().getParameters().get('showAttendanceSteps') == 'true';
			} 
			getClientCarePlan ();
		}
     	cpsc = stdController;
    	
	}

	private void Initialise ()
	{
	   	goalHeaderFields = getFields (Schema.SObjectType.Care_Plan_Objective__c.fieldSets.getMap().get(AppConfigSupport.PackagePrefix+'Review_Header_Fields'));
    	goalFields = getFields (Schema.SObjectType.Care_Plan_Objective__c.fieldSets.getMap().get(AppConfigSupport.PackagePrefix+'Review_Fields'));
		allGoalFields = goalHeaderFields.clone();
		allGoalFields.addAll (goalFields);
    	stepTaskFields = getFields (Schema.SObjectType.Care_plan_step__c.fieldSets.getMap().get(AppConfigSupport.PackagePrefix+'Review_Fields'));
    	stepAttendanceFields = getFields (Schema.SObjectType.Care_plan_step__c.fieldSets.getMap().get(AppConfigSupport.PackagePrefix+'Attendance_Review_Fields'));
		allStepFields = mergeFieldSetLists (stepTaskFields, stepAttendanceFields);
		attendancePrefix = Attendance__c.sObjectType.getDescribe().getKeyPrefix();
		careplanstepPrefix = Care_plan_step__c.sObjectType.getDescribe().getKeyPrefix();
		showAttendanceSteps = false;
		if (ApexPages.currentpage().getParameters().get('FromStandardPage') != null)
		{
			calledFromStandardPage = true;
		}
	}

	global PageReference getClientCarePlan ()
	{
		if (client != null)
		{
    		internalGoalList = getObjectives (allGoalFields, allStepFields, client.id);
			if (internalGoalList.size() > 0)
			{
				CountNumberOfEachTypeOfStep (internalGoalList);
			}
			else if (calledFromStandardPage == false)
			{
//				PageReference creationPage = Page.StandardCarePlan;
				PageReference creationPage = Page.StandardCarePlanUsingMetaData;
				creationPage.getParameters().putAll (apexpages.currentpage().getParameters());
				creationPage.getParameters().put('ID', client.id);
				return creationPage;
			}
		}
		return null;
	}

	global PageReference launchStandardCarePlan ()
	{
//		PageReference creationPage = Page.StandardCarePlan;
		PageReference creationPage = Page.StandardCarePlanUsingMetaData;
		creationPage.getParameters().putAll (apexpages.currentpage().getParameters());
	    creationPage.getParameters().put('ID', client.id);
		return creationPage;
	}

	private List<Schema.FieldSetMember> mergeFieldSetLists (List<Schema.FieldSetMember> listA, List<Schema.FieldSetMember> listB)
	{
		Set<Schema.FieldSetMember> mergedSet = new Set<Schema.FieldSetMember>(listA);
		for (Schema.FieldSetMember oneMember : listB)
		{
			Boolean inlistA = false;
			for (Schema.FieldSetMember AMember : listA)
			{
				if (AMember.getFieldPath() == oneMember.getFieldPath()) inlistA = true;
			}
			if (!inlistA)
			{
				mergedSet.add (oneMember);
			}
		}
		return new List<Schema.FieldSetMember>(mergedSet);
	}

	// the default save - just used when launched from the New button on the Care Plan Review home page
	global pageReference Save ()
	{
		cpsc.save();
		client = [select ID, Name from Contact where Id=:review.Client__c];
		getClientCarePlan();
		return null;
	} 

	global pageReference SaveReview ()
	{
		cpsc.save();
		if (internalGoalList != null)
		{
			update internalGoalList;
			UpdateSteps (internalGoalList);
		}
    	internalGoalList = getObjectives (allGoalFields, allStepFields, client.id);
		CountNumberOfEachTypeOfStep (internalGoalList);
   		ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, Label.Care_Plan_Review_Saved);
        ApexPages.addMessage(myMsg);
		return null;
	} 

	private void UpdateSteps (list <Care_Plan_Objective__c> glList)
	{
		list <Care_Plan_Step__c> stepsToUpdate = new list <Care_Plan_Step__c>();
		for (Care_Plan_Objective__c oneGoal: glList)
		{
			stepsToUpdate.addAll (oneGoal.Care_Plan_Steps__r);
		}
		update stepsToUpdate;
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

    private List<Care_Plan_Objective__c> getObjectives (List<Schema.FieldSetMember> needsFields, List<Schema.FieldSetMember> stepsFields, ID clientID)
    {
        String soql = getSelectStatement (needsFields);
        String stepSoql = getSelectStatement (stepsFields);
        soql += ', Area__c, Number_of_Task_Steps__c, Number_of_Attendance_Steps__c, (' + stepSoql + ' , Description__c, Reference__c, Step_Records_Attendance__c, What_step_needs_to_happen_first__c from Care_plan_steps__r where Status__c != \'Completed\' order by Date__c asc, Name)';
        soql += ' from Care_Plan_Objective__c where Client__c=:clientID and Objective_Status__c != \'Closed\' order by Area__c, Date_objective_set__c asc';
        
        List<Care_Plan_Objective__c> allObjectives = database.query(soql);
        
        return allObjectives;
    }
    
    private static String getSelectStatement (List<Schema.FieldSetMember> fieldList)
    {
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : fieldList) 
        {
            query += f.getFieldPath() + ', ';
        }
        query += 'Name, ID ';
        return query;
    }

	global void ShowAttSteps ()
	{
		showAttendanceSteps = true;
	}

	global void HideAttSteps ()
	{
		showAttendanceSteps = false;
	}

	private void CountNumberOfEachTypeOfStep (List<Care_Plan_Objective__c> goals)
	{
		for (Care_Plan_Objective__c oneGoal : goals)
		{
			oneGoal.Number_of_Task_Steps__c = 0;
			oneGoal.Number_of_Attendance_Steps__c = 0;
			for (Care_plan_step__c oneStep : oneGoal.Care_plan_steps__r)
			{
				if (oneStep.Reference__c != null && oneStep.Reference__c.startsWith (attendancePrefix)) 
				{
					oneGoal.Number_of_Attendance_Steps__c++;
					oneStep.Step_Records_Attendance__c = true;
				}
				else 
				{
					oneGoal.Number_of_Task_Steps__c++;
					oneStep.Step_Records_Attendance__c = false;
				}
			}
		}
	}
}