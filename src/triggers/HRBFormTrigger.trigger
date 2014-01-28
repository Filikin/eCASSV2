/*
	Author: Eamon Kelly, Enclude
	Purpose: Passes control to the Trigger Dispatcher. 
*/
trigger HRBFormTrigger on HRB_Form__c (after delete, after insert, after update) 
{
	TriggerDispatcher.MainEntry ('HRB Form', trigger.isBefore, trigger.isDelete, trigger.isAfter, trigger.isInsert, trigger.isUpdate, trigger.isExecuting,
		trigger.new, trigger.newMap, trigger.old, trigger.oldMap);
}