/*
	Author: Eamon Kelly, Enclude
	Purpose: Passes control to the Trigger Dispatcher. 
*/
trigger CarePlanReview on Care_Plan_Review__c (before insert)  
{ 
	TriggerDispatcher.MainEntry ('CarePlanReview', trigger.isBefore, trigger.isDelete, trigger.isAfter, trigger.isInsert, trigger.isUpdate, trigger.isExecuting,
		trigger.new, trigger.newMap, trigger.old, trigger.oldMap);
}