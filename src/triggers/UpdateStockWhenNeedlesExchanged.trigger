/*
	Author: Eamon Kelly, Enclude
	Purpose: Passes control to the Trigger Dispatcher. 
*/
trigger UpdateStockWhenNeedlesExchanged on Needle_Exchange__c (after insert, after update) 
{
	TriggerDispatcher.MainEntry ('Needle Exchange', trigger.isBefore, trigger.isDelete, trigger.isAfter, trigger.isInsert, trigger.isUpdate, trigger.isExecuting,
		trigger.new, trigger.newMap, trigger.old, trigger.oldMap);
}