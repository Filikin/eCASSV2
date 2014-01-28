/*
	Author: Eamon Kelly, Enclude
	Purpose: Need to act as a rollup on the attendance to the program session 
		Only for sessions that Attended__c to true
	Called from: TriggerDispatcher
*/
public with sharing class AttendancesTriggerClass implements TriggerDispatcher.ITriggerEntry
{
	public void MainEntry (String TriggerObject, Boolean isBefore, Boolean isDelete, Boolean isAfter, Boolean isInsert, Boolean isUpdate, Boolean isExecuting,
		list<SObject> newList, Map<Id, SObject> newMap, List<SObject> oldList, Map<Id, SObject> oldMap)
	{
		if (trigger.isInsert)
		{
			CountNumberAttended (newList);
			if (isAfter) LogToCalendar (newList);
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

	public void LogToCalendar (List<Attendance__c> attList)
	{
		list <Event>newEvents = new list <Event>();
		for (Attendance__c oneAtt: attList)
		{
			if (oneAtt.Put_in_my_calendar__c && oneAtt.Date_and_time_of_attendance__c != null)
			{
		        Event e1 = new Event (WhoID=oneAtt.Young_Person__c, OwnerID=UserInfo.getUserId(), WhatID=oneAtt.Id, Subject=oneAtt.Reason_for_Attending__c, StartDateTime=oneAtt.Date_and_time_of_attendance__c);
		        if (oneAtt.Duration_in_minutes__c != null) e1.DurationInMinutes = (Integer)oneAtt.Duration_in_minutes__c;
		        else e1.DurationInMinutes = 60;
		        newEvents.add (e1);
			}
		}
		if (newEvents.size() > 0) insert newEvents;
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