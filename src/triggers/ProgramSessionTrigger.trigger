trigger ProgramSessionTrigger on Program_Session__c (after insert) 
{
	TriggerDispatcher.MainEntry ('Program Session', trigger.isBefore, trigger.isDelete, trigger.isAfter, trigger.isInsert, trigger.isUpdate, trigger.isExecuting,
		trigger.new, trigger.newMap, trigger.old, trigger.oldMap);

}