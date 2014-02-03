trigger EventTrigger on Event (before insert, after insert, after update) 
{
	TriggerDispatcher.MainEntry ('Event', trigger.isBefore, trigger.isDelete, trigger.isAfter, trigger.isInsert, trigger.isUpdate, trigger.isExecuting,
		trigger.new, trigger.newMap, trigger.old, trigger.oldMap);
}