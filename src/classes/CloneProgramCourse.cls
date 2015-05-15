/*
	Author: Eamon Kelly, Enclude
	Purpose: Create a copy of a program/course with all its enrolments
	Called from: Button on program/course page
	Tested in: TestCloneProgramCourse

Security note: This class is global so that it can be used in customisations for the client - usually via a modified Visualforce page depending on their
					definition of what fields the customer wants copied to the clone
*/
global with sharing class CloneProgramCourse 
{
	public Program_Service__c ps;
    global CloneProgramCourse(ApexPages.StandardController controller)
    {
        ps = (Program_Service__c)controller.getRecord();
    }

	global PageReference DoClone ()
	{
		Program_Service__c clonePS = ps.clone(false, true);
		insert clonePS;

		list <Enrolment__c> clonedEnrolments = new list <Enrolment__c>();
		for (Enrolment__c oldEnrolment : [select id, Name, Young_Person__c, Care_Plan_Objective__c, Date_joined_program__c from Enrolment__c where Program_Service__c = :ps.id])
		{
			Enrolment__c clonedEnrolment = oldEnrolment.clone (false, true);
			clonedEnrolment.Program_Service__c = clonePS.id;
			clonedEnrolments.add (clonedEnrolment);
		}
		
		insert clonedEnrolments;
		
        String clonePSURL = '/' + clonePS.ID + '/e?retURL=%2F' + clonePS.ID;
        PageReference clonePSPage = new PageReference(clonePSURL);
        return clonePSPage;
	}
}