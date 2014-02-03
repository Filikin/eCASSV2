/*

Author: Eamon Kelly, Enclude

Purpose: Test the attendances - Program Session Attendances__c should be the count of the number of ticked attendances

Called from: Test

*/
@isTest
private class testCreateAttendanceTrigger 
{
    static testMethod void createAttendanceTest() 
    {
    	Contact youngPerson = new Contact (LastName = 'Kelly');
    	insert youngPerson;
    	Contact youngPerson2 = new Contact (LastName = 'Smith');
    	insert youngPerson2;
    	
    	Program_Service__c program = new Program_Service__c (Name = 'Music');
    	insert program;
    	
    	Enrolment__c enrole = new Enrolment__c (Program_Service__c=program.id, Young_Person__c=youngPerson.id, Status_on_Programme__c='Active');
    	insert enrole;
    	Enrolment__c enrole2 = new Enrolment__c (Program_Service__c=program.id, Young_Person__c=youngPerson2.id, Status_on_Programme__c='Active');
    	insert enrole2;
    	
    	Integer preAttendances = [select count() from Attendance__c];
    	
    	Program_Session__c session = new Program_Session__c (Program_Service__c=program.id);
    	insert session;
    	
    	ProgramAttendanceListView rsa = new ProgramAttendanceListView(session);
    	rsa.submit();
    	rsa.getAttendanceList(); 
    	
    	Integer postAttendances = [select count() from Attendance__c limit 5000];
    	system.assert (postAttendances > preAttendances);

		// tick all the attendances
		list<Attendance__c>attendances = [select Id, Attended__c from Attendance__c where Program_Session__c = :session.Id];
		for (Attendance__c oneAtt: attendances) oneAtt.Attended__c = true;
		update attendances;
		
		session = [select Attendances__c from Program_Session__c where Id = :session.Id];
		system.assertEquals (2, session.Attendances__c);
		
		// test the create sessions on New Enrolment trigger where the service already has sessions
     	Enrolment__c enrole3 = new Enrolment__c (Program_Service__c=program.id, Young_Person__c=youngPerson2.id, Status_on_Programme__c='Active');
    	insert enrole3;
    	
    	// test an attendance been deleted
    	delete attendances[0];
 		session = [select Attendances__c from Program_Session__c where Id = :session.Id];
		system.assertEquals (1, session.Attendances__c);
		
		// count the enrolments in the course
		program = [select Id, Total_EnrolmentsV2__c from Program_Service__c where Id = :program.Id];
		system.assertEquals (3, program.Total_EnrolmentsV2__c);
		
		// update an enrolment
		enrole2.Status_on_Programme__c = 'Withdrawn';
		update enrole2;
		program = [select Id, Total_EnrolmentsV2__c from Program_Service__c where Id = :program.Id];
		system.assertEquals (2, program.Total_EnrolmentsV2__c);
		
		// delete an enrolment
		delete enrole;
		program = [select Id, Total_EnrolmentsV2__c from Program_Service__c where Id = :program.Id];
		system.assertEquals (1, program.Total_EnrolmentsV2__c);
    }
    
    static testMethod void testCreateCarePlanStepAttendanceTrigger()
    {
        Contact youngPerson = new Contact (LastName = 'Kelly');
        insert youngPerson;
        
        Program_Service__c program = new Program_Service__c (Name = 'Music');
        insert program;
        
        Care_Plan_Objective__c careplan = new Care_Plan_Objective__c (Name='Improve welbeing', Client__c=youngPerson.id);
        insert careplan;
        
        Enrolment__c enrole = new Enrolment__c (Program_Service__c=program.id, Young_Person__c=youngPerson.id, Care_Plan_Objective__c=careplan.id, Status_on_Programme__c='Active');
        insert enrole;
        
        Integer preCarePlanSteps = [select count() from Care_plan_step__c where Reference__c != null];
        
        Program_Session__c session = new Program_Session__c (Program_Service__c=program.id, Session_Date__c=system.today()-1);
        insert session;
        
        Integer postCarePlanSteps = [select count() from Care_plan_step__c where Reference__c != null];
 
        System.Assert (postCarePlanSteps == preCarePlanSteps + 1);
        
        Attendance__c attend = [select ID, Attended__c from Attendance__c where Enrolment__r.Care_Plan_Objective__c = :careplan.id];
        attend.Attended__c = True;
        update attend;
        
        Care_plan_step__c careplanstep = [select ID, Reference__c, Status__c, Description__c from Care_plan_step__c where Care_Plan_Objective__c = :careplan.id];
        System.debug(careplanstep.Description__c);
        System.assertEquals ('Attended', careplanstep.Status__c);

        attend.Attended__c = False;
        update attend;
        
        Care_plan_step__c careplanstep2 = [select ID, Reference__c, Status__c, Description__c from Care_plan_step__c where Care_Plan_Objective__c = :careplan.id];
        System.debug(careplanstep2.Description__c);
        System.assertEquals ('Did not attend', careplanstep2.Status__c);

    }
    
    static testMethod void createEventFromAttendanceTest() 
    {
    	Contact youngPerson = new Contact (LastName = 'Kelly');
    	insert youngPerson;
   	
    	Attendance__c one2one = new Attendance__c (Young_Person__c = youngPerson.id, Duration_in_minutes__c = 30, Reason_for_Attending__c='Test', Date_and_time_of_attendance__c=system.now(), Put_in_my_calendar__c=true);
    	insert one2one;
    	
    	Event eventAdded = [select Subject from Event where WhoID=:youngPerson.id limit 1];
    	system.assertEquals ('Test', eventAdded.Subject);
    }
    
    static testMethod void createAttendanceFromEventTest() 
    {
	   	Id clientRecordTypeID = [SELECT ID FROM RecordType WHERE SobjectType='Contact' and DeveloperName='Client'].id;
    	Contact youngPerson = new Contact (LastName = 'Kelly', RecordTypeID=clientRecordTypeID);
    	insert youngPerson;
   	
        Event e1 = new Event (WhoID=youngPerson.id, OwnerID=UserInfo.getUserId(), Subject='Test', StartDateTime=system.now(), DurationInMinutes=60);
        insert e1;
    	
    	list<Attendance__c> atts = [select id, Reason_for_Attending__c from Attendance__c where Young_Person__c=:youngPerson.id limit 5000];
    	system.assertEquals (1, atts.size()); 
    	system.assertEquals ('Test', atts[0].Reason_for_Attending__c);
    	
    	Event eventchanged = [select WhatId from Event where ID=:e1.id limit 1];
    	system.assertEquals (atts[0].Id, eventchanged.WhatId);
    	
    	// try an event without a contact
    	Integer attendancesCount = [select count() from Attendance__c];
        Event e2 = new Event (OwnerID=UserInfo.getUserId(), Subject='Test', StartDateTime=system.now(), DurationInMinutes=60);
        insert e2;

    	atts = [select id, Reason_for_Attending__c from Attendance__c limit 5000];
    	system.assertEquals (attendancesCount, atts.size()); // shouldn't have added an attendance
    }
    
}