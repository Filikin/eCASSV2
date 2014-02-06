/*
	Author: Eamon Kelly, Enclude
	Purpose: When a client is enrolled in a course if Create_past_attendances__c is true in the settings, then create attendances for them in the previous sessions
	Also used to count the enrolments in the course to avoid rollups - only active and completed
	Tested in testCreateAttendanceTrigger 
*/
public with sharing class EnrolmentsTriggerClass implements TriggerDispatcher.ITriggerEntry
{
	public void MainEntry (String TriggerObject, Boolean isBefore, Boolean isDelete, Boolean isAfter, Boolean isInsert, Boolean isUpdate, Boolean isExecuting,
		List<SObject> newList, Map<Id, SObject> newMap, List<SObject> oldList, Map<Id, SObject> oldMap)
	{
		if (isInsert)
		{
			if (isBefore) CreateSessionsOnNewEnrolment (newList);
			else if (isAfter)
			{
				ChangeName ((map<Id, Enrolment__c>)newMap);
				CountNumberEnrolled (newList);
			}
		}
		else if (isUpdate)
		{
			if (isAfter) CountNumberEnrolled (newList);
		}
		else if (trigger.isDelete)
		{
			if (isAfter) CountNumberEnrolled (oldList);
		}
	}

	public void ChangeName (map<Id, Enrolment__c> enrMap)
	{
		String nameTemplate = TriggerDispatcher.settings.Enrolment_Name_Template__c;
		list<Enrolment__c>enrolmentsToUpdate = new list<Enrolment__c>();
		for (Enrolment__c oneEnr: [select ID, Name, Young_Person__c, Young_Person__r.Name, Young_Person__r.Initials__c, Enrolment_Date__c from Enrolment__c where ID in :enrMap.keySet()])
		{
			Date enrolmentDate = oneEnr.Enrolment_Date__c != null ? oneEnr.Enrolment_Date__c : system.today();
			String clientName = oneEnr.Young_Person__c != null ? oneEnr.Young_Person__r.Name : '';
			String clientInitials = oneEnr.Young_Person__c != null ? oneEnr.Young_Person__r.Initials__c : '';
			String newName;
			newName = nameTemplate.replace('$NAME$', clientName).replace('$DATE$', enrolmentDate.format()).replace('$INITIALS$', clientInitials);
			if (newName != oneEnr.Name) 
			{
				oneEnr.Name = newName;
				enrolmentsToUpdate.add (oneEnr);
			}
		}
		if (enrolmentsToUpdate.size() > 0) update enrolmentsToUpdate;
	}

	public void CreateSessionsOnNewEnrolment (list<Enrolment__c> newList) 
	{
		Id courseAttendanceRecordTypeId = [select Id from RecordType where sObjectType='Attendance__c' and DeveloperName = 'Course_Attendance'].Id;
		List<Attendance__c> attendanceList = new List<Attendance__c>{};
		Boolean createPastAttendances = false; // turning the default from true to false EK 3/7/13 
		if (newList.size() < 10) // not required for mass import
		{
			eCASS_settings__c settings = eCASS_settings__c.getOrgDefaults();
			if (settings != null && settings.Create_past_attendances__c != null)
				createPastAttendances = settings.Create_past_attendances__c;
			
			for (Enrolment__c oneEnroll: newList)
			{
				// get list of sessions and add an attendance record for each one
				// TODO - for services that run forever, this would create too many past attendances, we need to decide how far back to go
				for (Program_Session__c sess: [select id, Session_Date__c from Program_Session__c where Program_Service__c = :oneEnroll.Program_Service__c])
				{
					if (sess.Session_Date__c < system.today() && createPastAttendances == false) continue;
					Attendance__c oneAttendance = new Attendance__c (Name='FromEnrolment', Program_Session__c=sess.id, Young_Person__c = oneEnroll.Young_Person__c, Enrolment__c=oneEnroll.id, RecordTypeId = courseAttendanceRecordTypeId);
					attendanceList.Add(oneAttendance);
				}
			}
			insert attendanceList;
		}
	}
	
	public void CountNumberEnrolled (List<Enrolment__c> enrList)
	{
		set<id>courses = new set<id>();
		for (Enrolment__c oneEnrol: enrList)
		{
			courses.add (oneEnrol.Program_Service__c);
		}
		// need to count all the enrolments on these sessions
		list<Program_Service__c> progCourses = [SELECT Total_EnrolmentsV2__c, (SELECT Status_on_Programme__c FROM Participants__r where Status_on_Programme__c = 'Active' or Status_on_Programme__c = 'Completed') FROM Program_Service__c where ID in :courses];
		for (Program_Service__c oneCourse: progCourses)
		{
			oneCourse.Total_EnrolmentsV2__c = oneCourse.Participants__r.size();
		}		
		update progCourses;
	}
	
}