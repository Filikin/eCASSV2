/*
	Author: Eamon Kelly, Enclude
	Purpose: Create a copy of a program/course with all its enrolments
	Called from: Button on program/course page
*/
@isTest
private class TestCloneProgramCourse 
{
	static void addClientToCourse (Program_Service__c course, integer count)
	{
    	Contact client = new Contact (LastName='Test '+count);
    	insert client;
      	Enrolment__c en = new Enrolment__c (Name='Session '+count, Program_Service__c=course.id, Young_Person__c=client.id);
    	insert en;
	}

    static testMethod void TestProgramCourseClone() 
    {
    	Program_Service__c ps = new Program_Service__c (Name='Course');
    	insert ps;
    	
    	addClientToCourse (ps, 1);
    	addClientToCourse (ps, 2);
    	
    	ApexPages.StandardController programController = new ApexPages.StandardController(ps);
    	CloneProgramCourse cpc = new CloneProgramCourse (programController);
    	
    	cpc.DoClone();
    	
    	list <Enrolment__c> enrolmentsCreated = [select id from Enrolment__c];
    	system.assertEquals (4, enrolmentsCreated.size());
    }
}