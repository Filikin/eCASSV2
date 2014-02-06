/*
	Author: Eamon Kelly, Enclude
	Purpose: Need to act as a rollup on the attendance to the program session 
		Only for sessions that Attended__c to true
		When an attendence is created or modified that is associated with an enrolment that is linked to a care plan objective, 
		create or modify the care plan step on that care plan objective
	Tested in testCreateAttendanceTrigger 
	Called from: TriggerDispatcher
*/
public with sharing class AttendancesTriggerClass implements TriggerDispatcher.ITriggerEntry
{
	public void MainEntry (String TriggerObject, Boolean isBefore, Boolean isDelete, Boolean isAfter, Boolean isInsert, Boolean isUpdate, Boolean isExecuting,
		list<SObject> newList, Map<Id, SObject> newMap, List<SObject> oldList, Map<Id, SObject> oldMap)
	{
		if (isInsert)
		{
			if (isAfter)
			{
				ChangeName ((map<Id, Attendance__c>)newMap);
				CreateUpdateCarePlanStepOnAttendance ((Map <ID, Attendance__c>)newMap, isInsert);
				CountNumberAttended (newList);
				LogToCalendar (newList);
			}
		}
		else if (isUpdate)
		{
			if (isAfter) 
			{
				CreateUpdateCarePlanStepOnAttendance ((Map <ID, Attendance__c>)newMap, isInsert);
				CountNumberAttended (newList);
			}
		}
		else if (isDelete)
		{
			if (isAfter) CountNumberAttended (oldList);
		}
	}
	
	public void ChangeName (map<Id, Attendance__c> attMap)
	{
		String nameTemplate = TriggerDispatcher.settings.Attendance_Name_Template__c;
		list<Attendance__c>attendancesToUpdate = new list<Attendance__c>();
		for (Attendance__c oneAtt: [select ID, Name, Young_Person__c, Young_Person__r.Name, Young_Person__r.Initials__c, Attendance_Date__c from Attendance__c where ID in :attMap.keySet()])
		{
			Date attendanceDate = oneAtt.Attendance_Date__c != null ? oneAtt.Attendance_Date__c : system.today();
			String clientName = oneAtt.Young_Person__c != null ? oneAtt.Young_Person__r.Name : '';
			String clientInitials = oneAtt.Young_Person__c != null ? oneAtt.Young_Person__r.Initials__c : '';
			String newName;
			newName = nameTemplate.replace('$NAME$', clientName).replace('$DATE$', attendanceDate.format()).replace('$INITIALS$', clientInitials);
			if (newName != oneAtt.Name) 
			{
				oneAtt.Name = newName;
				attendancesToUpdate.add (oneAtt);
			}
		}
		if (attendancesToUpdate.size() > 0) update attendancesToUpdate;
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
		        e1.Status__c = oneAtt.Status__c;
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
	
	public void CreateUpdateCarePlanStepOnAttendance (Map <ID, Attendance__c> newMap, Boolean isInsert) 
	{
		// Mapping attended and comment into the care plan step
	    List <Attendance__c>attendances = [select ID, Interaction__c, Comment__c, Attended__c, Enrolment__c, Enrolment__r.Care_Plan_Objective__c, Enrolment__r.Care_Plan_Objective__r.Name, Young_Person_name__c, Care_plan_step_date__c, Care_plan_step_description__c from Attendance__c where ID in :newMap.keySet()];
	    
	    List <Care_plan_step__c>newSteps = new List<Care_plan_step__c>();
	    
	    List <Care_plan_step__c>currentSteps = [select ID, Date__c, Description__c, Reference__c from Care_plan_step__c where Reference__c in :newMap.keySet()];
	    Map <ID, Care_plan_step__c>currentStepsMap = new Map<ID, Care_plan_step__c>();
	    for (Care_plan_step__c oneStep: currentSteps)
	    {
	        currentStepsMap.put (oneStep.Reference__c, oneStep);
	    }
	            
	    for (Attendance__c oneAttendance: attendances)
	    {
	        if (oneAttendance.Enrolment__c != null)
	        {
	            if (oneAttendance.Enrolment__r.Care_Plan_Objective__c != null)
	            {
	                if (isInsert)
	                {
	                    Care_plan_step__c oneStep = new Care_plan_step__c (Care_Plan_Objective__c=oneAttendance.Enrolment__r.Care_Plan_Objective__c, Care_Plan_Objective_Name__c=oneAttendance.Enrolment__r.Care_Plan_Objective__r.Name,
	                        Date__c=oneAttendance.Care_plan_step_date__c, Description__c=oneAttendance.Care_plan_step_description__c, Reference__c=oneAttendance.id,
	                        Client_name__c=oneAttendance.Young_Person_name__c);
	                        
	                    oneStep.Status_Comment__c = '';
	                    if (oneAttendance.Comment__c != null) oneStep.Status_Comment__c = oneAttendance.Comment__c;
	                    if (oneAttendance.Comment__c != null && oneAttendance.Interaction__c != null) oneStep.Status_Comment__c += ' - ';
	                    if (oneAttendance.Interaction__c != null) oneStep.Status_Comment__c += 'Interaction: ' + oneAttendance.Interaction__c;
	                    oneStep.Status__c = oneAttendance.Attended__c ? 'Attended' : 'Did not attend';
	                    newSteps.Add(oneStep);
	                }
	                else
	                {
	                    Care_plan_step__c oneStep = currentStepsMap.get (oneAttendance.id);
	                    oneStep.Date__c=oneAttendance.Care_plan_step_date__c;
	                    oneStep.Description__c=oneAttendance.Care_plan_step_description__c;
	                    
	                    oneStep.Status_Comment__c = '';
	                    if (oneAttendance.Comment__c != null) oneStep.Status_Comment__c = oneAttendance.Comment__c;
	                    if (oneAttendance.Comment__c != null && oneAttendance.Interaction__c != null) oneStep.Status_Comment__c += ' - ';
	                    if (oneAttendance.Interaction__c != null) oneStep.Status_Comment__c += 'Interaction: ' + oneAttendance.Interaction__c;
	                    oneStep.Status__c = oneAttendance.Attended__c ? 'Attended' : 'Did not attend';
	                }
	            }
	        }       
	    }
	    if (newSteps.size() > 0) insert newSteps;
	    if (currentSteps.size()> 0) update currentSteps;
	}
}