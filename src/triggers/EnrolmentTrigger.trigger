trigger EnrolmentTrigger on Enrolment__c (after delete, after insert, after update, before insert) 
{
	TriggerDispatcher.MainEntry ('Enrolment', trigger.isBefore, trigger.isDelete, trigger.isAfter, trigger.isInsert, trigger.isUpdate, trigger.isExecuting,
		trigger.new, trigger.newMap, trigger.old, trigger.oldMap);
}