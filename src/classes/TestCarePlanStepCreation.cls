/*
	Author: Eamon Kelly, Enclude
	Purpose: Create a step
	Called from: Override of new step 
*/
@isTest
public class TestCarePlanStepCreation 
{ 
	public static testmethod void TestCreation ()
	{
	    Contact youngPerson = new Contact (LastName = 'Kelly');
        insert youngPerson;
        
        Care_Plan_Objective__c careplan = new Care_Plan_Objective__c (Area__c='Health', Name='Improve welbeing', Client__c=youngPerson.id);
        insert careplan;
 
		Care_Plan_Step__c step = new Care_plan_step__c ();

 		Test.setCurrentPageReference(new PageReference('Page.CarePlanStepCreation')); 
		System.currentPageReference().getParameters().put('PARENT', careplan.id);

    	ApexPages.StandardController programController = new ApexPages.StandardController(step);
    	CarePlanStepCreation cpsc = new CarePlanStepCreation (programController);
		cpsc.save();
		
		list <Care_plan_step__c> createdSteps = [select ID from Care_plan_step__c where Care_Plan_Objective__c = :careplan.id];
		system.assertEquals (1, createdSteps.size());
	}
}