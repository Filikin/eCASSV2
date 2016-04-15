/*
	Author: Eamon Kelly, Enclude
	Purpose: Create a step
	Called from: Override of new step 
	Tested in: TestCarePlanStepCreation
*/
global with sharing class CarePlanStepCreation 
{
	global List<Schema.FieldSetMember> stepFields {get;set;}
	private ApexPages.StandardController stepsc;
	global Care_Plan_Step__c step {get;Set;}
	global String careplanstepPrefix {get;Set;}
	global ID clientID {get; set;}

	global CarePlanStepCreation(ApexPages.StandardController stdController) 
	{
		careplanstepPrefix = Care_plan_step__c.sObjectType.getDescribe().getKeyPrefix();
    	step = (Care_Plan_Step__c)stdController.getRecord();
    	String goalID = apexpages.currentpage().getParameters().get('PARENT');
    	clientID = apexpages.currentpage().getParameters().get('CLIENT');
    	step.Care_Plan_Objective__c = goalID;
     	stepFields = getFields (AppConfigSupport.PackagePrefix+'Review_Fields');
	}

	// the default save needs to be overridden to avoid returning to the view page	
	global pageReference Save ()
	{
		insert step;
		return null;
	} 

	global List<Schema.FieldSetMember> getFields(String fieldSetName) 
    {
        Schema.FieldSet fs1 = Schema.SObjectType.Care_Plan_Step__c.fieldSets.getMap().get(fieldSetName);
        if (fs1 == null)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'No fieldset found for ' + fieldSetName);
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
}