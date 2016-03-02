/*
	Author: Eamon Kelly, Enclude
	Purpose: When a new care plan review is started for a client, set all the previous reviews to completed
		When the user looks at a completed review, it will be readonly and not show the current objectives or steps 
	Called from: Trigger dispatcher
*/
public with sharing class CarePlanReviewTrigger implements TriggerDispatcher.ITriggerEntry
{
	public void MainEntry (String TriggerObject, Boolean isBefore, Boolean isDelete, Boolean isAfter, Boolean isInsert, Boolean isUpdate, Boolean isExecuting,
		List<SObject> newList, Map<Id, SObject> newMap, List<SObject> oldList, Map<Id, SObject> oldMap)
	{
		if (trigger.isInsert)
		{
			CarePlanReviewBeingInserted (newList);
		}
	}

	// this is before the review is inserted, so we can get all the other reviews for this client and mark them as complete
	public void CarePlanReviewBeingInserted (list <Care_Plan_Review__c> reviews)
	{
		set <Id> clientSet = new set <Id>();
		for (Care_Plan_Review__c oneReview : reviews)
		{
			clientSet.add (oneReview.Client__c);
		}
		list <Care_Plan_Review__c> openReviews = [select Id, Review_Completed__c from Care_Plan_Review__c where Review_Completed__c = false and Client__c in :clientSet];
		for (Care_Plan_Review__c oneReview : openReviews)
		{
			oneReview.Review_Completed__c = true;
		}
		update openReviews;
	}
}