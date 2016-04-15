/*
	Author: Eamon Kelly, Enclude
	Purpose: Display a client calendar based on the attendance records linked to the client
	Taken from http://www.codebycody.com/2013/06/create-calendar-view-in-salesforcecom.html
	Docs for the FullCalendar plugin are at http://fullcalendar.io/
	Called from: Button on a contact
	Tested in: TestClientCalendar
*/
global with sharing class CalendarController
{
	//Class to hold calendar event data
    global class calEvent
	{
        global String title {get;set;}
        global Boolean allDay {get;set;}
        global String startString {get;set;}
        global String endString {get;set;}
        global String url {get;set;}
        global String className {get;set;}
		global ID id {get;set;}
		global Boolean editable {get;set;}
    }

    //The calendar plugin is expecting dates is a certain format. We can use this string to get it formated correctly
//    String dtFormat = 'EEE, d MMM yyyy HH:mm:ss z';
    String dtFormat = 'yyyy-MM-dd HH:mm:ssZ'; // 2015-10-25T22:34:51Z
 	global Contact client {get;set;}
    global transient list<calEvent> events {get;set;}

	@RemoteAction
	global static String attendanceMoved (String attendanceID, String starttime, String endtime) 
	{
		Attendance__c attToUpdate = [select Id, Date_and_time_of_attendance__c, Date_and_Time_client_entered__c, Date_and_Time_client_left__c, RecordType.DeveloperName from Attendance__c where id = :attendanceID];
		if (attToUpdate != null)
		{
			if (attToUpdate.RecordType.DeveloperName == 'One_to_One_Attendance')
			{
				attToUpdate.Date_and_time_of_attendance__c =  Datetime.valueOf(starttime);
				update attToUpdate;
			}
			else if (attToUpdate.RecordType.DeveloperName == 'Open_Access_Attendance')
			{
				attToUpdate.Date_and_Time_client_entered__c =  Datetime.valueOf(starttime);
				attToUpdate.Date_and_Time_client_left__c =  Datetime.valueOf(endtime);
				update attToUpdate;
			}
		}
		return 'Hi';
	}

	@RemoteAction
	global static String attendanceDurationChanged (String attendanceID, String duration, String endtime) 
	{
		system.debug ('Duration is: ' + duration);
		Attendance__c attToUpdate = [select Id, Duration_in_minutes__c, Date_and_Time_client_left__c, RecordType.DeveloperName from Attendance__c where id = :attendanceID];
		if (attToUpdate != null)
		{
			if (attToUpdate.RecordType.DeveloperName == 'One_to_One_Attendance')
			{
				attToUpdate.Duration_in_minutes__c =  attToUpdate.Duration_in_minutes__c + Integer.valueOf(duration);
				update attToUpdate;
			}
			else if (attToUpdate.RecordType.DeveloperName == 'Open_Access_Attendance')
			{
				attToUpdate.Date_and_Time_client_left__c =  Datetime.valueOf(endtime);
				update attToUpdate;
			}
		}
		return 'Hi';
	}

	global CalendarController(ApexPages.StandardController controller)
    {
        client = [select Id, Full_name__c from Contact where ID = :controller.getID()];
    }

	global pageReference pageLoad ()
	{
		events = new list<calEvent>();
		for (Attendance__c oneAtt : [select id, RecordType.DeveloperName, RecordType.Name, Comment__c, Activity_Type__c, Programme__c, Drop_in__r.Name, Course__c,
			Attendance_Date__c, Date_and_time_of_attendance__c, Duration_in_minutes__c, Date_and_Time_client_entered__c, Date_and_Time_client_left__c
			from Attendance__c where Young_Person__c = :client.Id and Attendance_Date__c != null limit 999])
		{
            calEvent attEvent = new calEvent();
            attEvent.id = oneAtt.Id;
            attEvent.url = '/' + oneAtt.Id;
            attEvent.className = oneAtt.RecordType.DeveloperName;
			if (oneAtt.RecordType.DeveloperName == 'One_to_One_Attendance' && oneAtt.Date_and_time_of_attendance__c != null)
			{
				attEvent.startString = oneAtt.Date_and_time_of_attendance__c.format(dtFormat);
				attEvent.endString = oneAtt.Date_and_time_of_attendance__c.addMinutes ((Integer)oneAtt.Duration_in_minutes__c).format(dtFormat);
		        attEvent.allDay = false;
				attEvent.editable = true;
			}
			else if (oneAtt.RecordType.DeveloperName == 'Open_Access_Attendance' && oneAtt.Date_and_Time_client_entered__c != null)
			{
				attEvent.startString = oneAtt.Date_and_Time_client_entered__c.format(dtFormat);
				attEvent.endString = oneAtt.Date_and_Time_client_left__c != null ? oneAtt.Date_and_Time_client_left__c.format(dtFormat) : oneAtt.Date_and_Time_client_entered__c.addMinutes (60).format(dtFormat);
		        attEvent.allDay = false;
				attEvent.editable = true;
			}
			else
			{
				DateTime startDT = datetime.newInstance(oneAtt.Attendance_Date__c.Year(),oneAtt.Attendance_Date__c.Month(), oneAtt.Attendance_Date__c.Day());
				attEvent.startString = startDT.format(dtFormat);
				attEvent.endString = '';
				attEvent.allDay = true;
				attEvent.editable = false;
			}
			if (oneAtt.RecordType.DeveloperName == 'One_to_One_Attendance' || oneAtt.RecordType.DeveloperName == 'Open_Access_Attendance')
			{
				attEvent.title = SetEventTitle (oneAtt.Programme__c, oneAtt.Activity_Type__c, oneAtt.RecordType.Name);
			}
			else if (oneAtt.RecordType.DeveloperName == 'Drop_In_Attendance')
			{
				attEvent.title = oneAtt.Drop_in__r.Name;
			}
			else if (oneAtt.RecordType.DeveloperName == 'Course_Attendance')
			{
				attEvent.title = oneAtt.Course__c;
			}
            events.add(attEvent);
		}

		return null;
	}

	private string SetEventTitle (String bit1, String bit2, String RecordTypeName)
	{
		String title = RecordTypeName;
		if (bit1 != null) 
		{
			if (bit2 != null)
			{
				title = bit1 + ' - ' + bit2;
			}
			else
			{
				title = bit1;
			}
		}
		else if (bit2 != null)
		{
			title = bit2;
		}
		return title;
	}
}