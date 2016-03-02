/*
	Author: Eamon Kelly, Enclude
	Purpose: Create a goal
	Called from: Override of new goal 
*/
@isTest
public class TestCarePlanObjectiveCreation 
{ 
	public static testmethod void TestCreation ()
	{
	    Contact youngPerson = new Contact (LastName = 'Kelly');
        insert youngPerson;
        
        Care_Plan_Objective__c careplan = new Care_Plan_Objective__c ();

 		Test.setCurrentPageReference(new PageReference('Page.CarePlanObjectiveCreation')); 
		System.currentPageReference().getParameters().put('CLIENT', youngPerson.id);

    	ApexPages.StandardController programController = new ApexPages.StandardController(careplan);
    	CarePlanObjectiveCreation cpoc = new CarePlanObjectiveCreation (programController);
		cpoc.save();
		
		list <Care_Plan_Objective__c> createdObjectives = [select ID from Care_Plan_Objective__c where Client__c = :youngPerson.id];
		system.assertEquals (1, createdObjectives.size());
	}

}