/*
	Author: Eamon Kelly, Enclude
	Purpose: Need to act as a rollup on the attendance to the program session 
		Only for sessions that Attended__c to true
	Called from: TriggerDispatcher
*/
public with sharing class AttendancesTriggerClass implements TriggerDispatcher.ITriggerEntry
{
	public void MainEntry (String TriggerObject, Boolean isBefore, Boolean isDelete, Boolean isAfter, Boolean isInsert, Boolean isUpdate, Boolean isExecuting,
		List<SObject> newList, Map<Id, SObject> newMap, List<SObject> oldList, Map<Id, SObject> oldMap)
	{
		if (trigger.isInsert)
		{
			CountNumberAttended (newList);
		}
		else if (trigger.isUpdate)
		{
			CountNumberAttended (newList);
		}
		else if (trigger.isDelete)
		{
			CountNumberAttended (oldList);
		}
	}

	public void CountNumberAttended (List<Attendance__c> attList)
	{
		set<id>sessions = new set<id>();
		for (Attendance__c oneAtt: attList)
		{
			sessions.add (oneAtt.Program_Session__c);
		}
		// need to count all the attendances on these sessions
		list<Program_Session__c> progSessions = [SELECT Attendances__c, (SELECT Attended__c FROM Attendances__r where Attended__c = true) FROM Program_Session__c where ID in :sessions];
		for (Program_Session__c oneSession: progSessions)
		{
			oneSession.Attendances__c = oneSession.Attendances__r.size();
		}		
		update progSessions;
	}
}