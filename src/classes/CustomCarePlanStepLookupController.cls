// Taken from http://blog.jeffdouglas.com/2011/08/12/roll-your-own-salesforce-lookup-popup-window/
/*
	Author: Eamon Kelly, Enclude
	Purpose: Display a list of care plan steps and that are associated with this client so that one can be selected
	Called from: Override of the lookup Button on care plan review page
	Tested in: TestCarePlanReview
*/
global with sharing class CustomCarePlanStepLookupController 
{ 
	global List<Care_plan_step__c> results{get;set;} // search results
	global string searchString{get;set;} // search keyword
	private String clientID;
	private String attendancePrefix;
  
	global CustomCarePlanStepLookupController() 
	{
		attendancePrefix = Attendance__c.sObjectType.getDescribe().getKeyPrefix() + '%';

	  	// get the current search string and the client ID from the URL
  		searchString = System.currentPageReference().getParameters().get('lksrch');
  		clientID = System.currentPageReference().getParameters().get('clientID');
  		runSearch();  
	}
   
	// performs the keyword search
	global PageReference search() 
	{
	    runSearch();
		return null;
	}
  
	// prepare the query and issue the search command
	private void runSearch() 
	{
  		// TODO prepare query string for complex searches & prevent injections
	    results = performSearch(searchString);               
	} 
  
	// run the search and return the records found. 
	private List<Care_plan_step__c> performSearch(string searchString) 
	{
	    String soql = 'select id, name, description__c, Care_Plan_Objective__c, What_step_needs_to_happen_first__c from Care_Plan_Step__c where Care_Plan_Objective__r.Client__c = :clientID and (not ((Reference__c like :attendancePrefix) or Step_Records_Attendance__c=true))';
		if(searchString != '' && searchString != null)
		{
			soql = soql +  ' and name LIKE \'%' + searchString +'%\' ';
			soql = soql + ' order by Care_Plan_Objective__r.Area__c, Name';
		}
		soql = soql + ' limit 200';
		System.debug(soql);
		return database.query(soql); 
	}
  
	// used by the visualforce page to send the link to the right dom element
	public string getFormTag() 
	{
	    return System.currentPageReference().getParameters().get('frm');
	}
    
	// used by the visualforce page to send the link to the right dom element for the text box
	public string getTextBox() 
	{
		return System.currentPageReference().getParameters().get('txt');
	}
}