/*
	Author: Eamon Kelly, Enclude
	Purpose: Create a goal
	Called from: Override of new goal 
	Tested in: TestCarePlanObjectiveCreation
*/
global with sharing class CarePlanObjectiveCreation 
{
	global List<Schema.FieldSetMember> goalFields {get;set;}
	global List<Schema.FieldSetMember> goalHeaderFields {get;set;}
	global Care_Plan_Objective__c goal {get;Set;}
	public CarePlanObjectiveCreation(ApexPages.StandardController stdController) 
	{
    	goal = (Care_Plan_Objective__c)stdController.getRecord();
    	String clientID = apexpages.currentpage().getParameters().get('CLIENT');
    	goal.Client__c = clientID;
		goal.Number_of_Attendance_Steps__c = 0;
		goal.Number_of_Task_Steps__c= 0;
     	goalFields = getFields (AppConfigSupport.PackagePrefix+'Review_Fields');
		goalHeaderFields = getFields (AppConfigSupport.PackagePrefix+'Review_Header_Fields');
	}

	// the default save needs to be overridden to avoid returning to the view page	
	public pageReference Save ()
	{
		insert goal;
		return null;
	} 

	public List<Schema.FieldSetMember> getFields(String fieldSetName) 
    {
        Schema.FieldSet fs1 = Schema.SObjectType.Care_Plan_Objective__c.fieldSets.getMap().get(fieldSetName);
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