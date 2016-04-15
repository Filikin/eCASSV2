/*
	Author: Eamon Kelly, Enclude
	Purpose: Display a care plan and allow steps and reviews to be created
	Called from: Button on Client
*/
@isTest
public class TestCarePlanReview 
{ 
	public static testmethod Care_Plan_Review__c TestReviewCreation ()
	{
	    Contact youngPerson = new Contact (LastName = 'Kelly');
        insert youngPerson;

        Care_Plan_Objective__c careplan = new Care_Plan_Objective__c (Client__c=youngPerson.id, Area__c='Legal', Name='Test');
		insert careplan;

		Care_Plan_Step__c attstep = new Care_plan_step__c (Care_Plan_Objective__c=careplan.id, Step_Records_Attendance__c=true);
		insert attstep;

		Care_Plan_Step__c taskstep = new Care_plan_step__c (Care_Plan_Objective__c=careplan.id, Step_Records_Attendance__c=false);
		insert taskstep;

 		Test.setCurrentPageReference(new PageReference('Page.CarePlanReview')); 
		System.currentPageReference().getParameters().put('retURL', '/' + youngPerson.id);

		Care_Plan_Review__c careplanreview = new Care_Plan_Review__c (Client__c=youngPerson.Id);
		ApexPages.StandardController programController = new ApexPages.StandardController(careplanreview);
    	CarePlanReviewController cprc = new CarePlanReviewController (programController);
		cprc.SaveReview();

		list <Care_Plan_Review__c> cprs = [select ID, Client__c from Care_Plan_Review__c where Client__c = :youngPerson.Id];
		system.assertEquals (1, cprs.size());
		return cprs[0];
	}

	public static testmethod void TestReviewEditting ()
	{
		Care_Plan_Review__c cpr = TestReviewCreation ();

		ApexPages.StandardController programController = new ApexPages.StandardController(cpr);
    	CarePlanReviewController cprc = new CarePlanReviewController (programController);
		cprc.SaveReview();

		list <Care_Plan_Review__c> cprs = [select ID from Care_Plan_Review__c];
		system.assertEquals (1, cprs.size());

	}

	public static testmethod void TestLookupController ()
	{
		Care_Plan_Review__c cpr = TestReviewCreation ();

 		Test.setCurrentPageReference(new PageReference('Page.CustomCarePlanStepLookup')); 
		System.currentPageReference().getParameters().put('clientID', cpr.Client__c);
		System.currentPageReference().getParameters().put('lksrch', 'CPS');

		CustomCarePlanStepLookupController lookup = new CustomCarePlanStepLookupController ();
		lookup.Search ();

		system.assertEquals (1, lookup.results.size());
	}
}