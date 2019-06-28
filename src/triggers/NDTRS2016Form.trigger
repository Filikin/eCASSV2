/*
	Author: Eamon Kelly, Enclude
	Purpose: Passes control to the Trigger Dispatcher. 
*/
trigger NDTRS2016Form on NDTRS_Form_2016__c (after delete, after insert, after update, before delete, before insert, before update) 
{
	TriggerDispatcher.MainEntry ('NDTRS 2016 Form', trigger.isBefore, trigger.isDelete, trigger.isAfter, trigger.isInsert, trigger.isUpdate, trigger.isExecuting,
		trigger.new, trigger.newMap, trigger.old, trigger.oldMap);

}