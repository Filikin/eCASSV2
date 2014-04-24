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
				LogToCalendar ((map<Id, Attendance__c>)newMap);
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
		list<Attendance__c>attendancesToUpdate = new list<Attendance__c>();
		for (Attendance__c oneAtt: [select ID, Name, Young_Person__c, Young_Person__r.Name, Young_Person__r.Initials__c, Attendance_Date__c from Attendance__c where ID in :attMap.keySet()])
		{
			String newName = newAttendanceName (oneAtt.Attendance_Date__c, oneAtt.Young_Person__r.Name, oneAtt.Young_Person__r.Initials__c);
			if (newName != null && newName != oneAtt.Name) 
			{
				oneAtt.Name = newName;
				attendancesToUpdate.add (oneAtt);
			}
		}
		if (attendancesToUpdate.size() > 0) update attendancesToUpdate;
	}
	
	public static String newAttendanceName (Date attDate, String clientName, String clientInitials)
	{
		String nameTemplate = AppConfigSupport.AttendanceNameTemplate;
		if (nameTemplate != null)
		{
			Date attendanceDate = attDate != null ? attDate : system.today();
			return nameTemplate.replace('$NAME$', clientName).replace('$DATE$', attendanceDate.format()).replace('$INITIALS$', clientInitials);
		}
		else return null;
	}
	
	public void LogToCalendar (map<Id, Attendance__c> attMap)
	{
		list <Event>newEvents = new list <Event>();
		list<Attendance__c>attendancesToUpdate = new list<Attendance__c>();
		for (Attendance__c oneAtt: [select ID, Name, Put_in_my_calendar__c, Date_and_time_of_attendance__c, Young_Person__c, Reason_for_Attending__c, Duration_in_minutes__c, Status__c, Programme__c, Activity_Type__c, Calendar_Event_Name__c, Calendar_Event_ID__c from Attendance__c where ID in :attMap.keySet()])
		{
			if (oneAtt.Put_in_my_calendar__c && oneAtt.Date_and_time_of_attendance__c != null)
			{
		        Event e1 = new Event (WhoID=oneAtt.Young_Person__c, OwnerID=UserInfo.getUserId(), Related_Attendance_ID__c=oneAtt.Id, Related_Attendance_Name__c=oneAtt.Name, Subject=oneAtt.Reason_for_Attending__c, StartDateTime=oneAtt.Date_and_time_of_attendance__c);
		        if (oneAtt.Duration_in_minutes__c != null) e1.DurationInMinutes = (Integer)oneAtt.Duration_in_minutes__c;
		        else e1.DurationInMinutes = AppConfigSupport.DefaultAttendanceDuration;
		        e1.Status__c = oneAtt.Status__c;
		        e1.Programme__c = oneAtt.Programme__c;
		        e1.Activity_Type__c = oneAtt.Activity_Type__c;
		        newEvents.add (e1);
				attendancesToUpdate.add (oneAtt); // so that the reference to the event may be added
			}
		}
		if (newEvents.size() > 0) 
		{
			insert newEvents;
			for (Integer i=0; i<newEvents.size(); i++)
			{
		        attendancesToUpdate[i].Calendar_Event_Name__c = newEvents[i].Subject;
				attendancesToUpdate[i].Calendar_Event_ID__c = newEvents[i].id;
			}
			update attendancesToUpdate;
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