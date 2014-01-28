/*
	Author: Eamon Kelly, Enclude
	Purpose: Passes control to the Trigger Dispatcher. 
*/
trigger AttendanceTrigger on Attendance__c (after delete, after insert, after update) 
{
	TriggerDispatcher.MainEntry ('Attendance', trigger.isBefore, trigger.isDelete, trigger.isAfter, trigger.isInsert, trigger.isUpdate, trigger.isExecuting,
		trigger.new, trigger.newMap, trigger.old, trigger.oldMap);

}