/*
	Author: Eamon Kelly, Enclude
	Purpose: When a client is enrolled in a course if Create_past_attendances__c is true in the settings, then create attendances for them in the previous sessions
	Tested in testCreateAttendanceTrigger 
*/
trigger CreateSessionsOnNewEnrolment on Enrolment__c (before insert) 
{
	private List<Attendance__c> attendanceList = new List<Attendance__c>{};
	Boolean createPastAttendances = false; // turning the default from true to false EK 3/7/13 
	if (trigger.new.size() < 10) // not required for mass import
	{
		eCASS_settings__c settings = eCASS_settings__c.getOrgDefaults();
		if (settings != null && settings.Create_past_attendances__c != null)
			createPastAttendances = settings.Create_past_attendances__c;
			
		for (Enrolment__c oneEnroll: Trigger.new)
		{
			// get list of sessions and add an attendance record for each one
			// TODO - for services that run forever, this would create too many past attendances, we need to decide how far back to go
			for (Program_Session__c sess: [select id, Session_Date__c from Program_Session__c where Program_Service__c = :oneEnroll.Program_Service__c])
			{
				if (sess.Session_Date__c < system.today() && createPastAttendances == false) continue;
				Attendance__c oneAttendance = new Attendance__c (Program_Session__c=sess.id, Young_Person__c = oneEnroll.Young_Person__c, Enrolment__c=oneEnroll.id);
				attendanceList.Add(oneAttendance);
			}
		}
		insert attendanceList;
	}
}