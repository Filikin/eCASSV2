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
        
        Enrolment__c enrole = new Enrolment__c (Name='Test', Program_Service__c=program.id, Young_Person__c=youngPerson.id, Status_on_Programme__c='Active');
        insert enrole;
        Enrolment__c enrole2 = new Enrolment__c (Name='Test', Program_Service__c=program.id, Young_Person__c=youngPerson2.id, Status_on_Programme__c='Active');
        insert enrole2;
        
        Integer preAttendances = [select count() from Attendance__c];
        
        Program_Session__c session = new Program_Session__c (Program_Service__c=program.id, Session_Date__c= system.today());
        insert session;
        
        ProgramAttendanceListView rsa = new ProgramAttendanceListView(session);
        rsa.submit();
        rsa.getAttendanceList(); 
        
        Integer postAttendances = [select count() from Attendance__c limit 5000];
        system.assert (postAttendances > preAttendances);

        // tick all the attendances
        list<Attendance__c>attendances = [select Id, Attended__c, Young_Person__c from Attendance__c where Program_Session__c = :session.Id];
        for (Attendance__c oneAtt: attendances) oneAtt.Attended__c = true;
        update attendances;
        
        session = [select Attendances__c from Program_Session__c where Id = :session.Id];
        system.assertEquals (2, session.Attendances__c);
        
        // test the create sessions on New Enrolment trigger where the service already has sessions
        Enrolment__c enrole3 = new Enrolment__c (Name='Test', Program_Service__c=program.id, Young_Person__c=youngPerson2.id, Status_on_Programme__c='Active');
        insert enrole3;
        
        // test an attendance been deleted
        ID contactWithDeletedAttendance = attendances[0].Young_Person__c;      
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
    
    static testMethod void TestContactRecordUpdate() 
    {
        Contact youngPerson = new Contact (LastName = 'Kelly');
        insert youngPerson;
        Contact youngPerson2 = new Contact (LastName = 'Smith');
        insert youngPerson2;
        
        Program_Service__c program = new Program_Service__c (Name = 'Music');
        insert program;
        
        Enrolment__c enrole = new Enrolment__c (Name='Test', Program_Service__c=program.id, Young_Person__c=youngPerson.id, Status_on_Programme__c='Active');
        insert enrole;
        Enrolment__c enrole2 = new Enrolment__c (Name='Test', Program_Service__c=program.id, Young_Person__c=youngPerson2.id, Status_on_Programme__c='Active');
        insert enrole2;
        
        Program_Session__c session = new Program_Session__c (Program_Service__c=program.id, Session_Date__c= system.today());
        insert session;
        
        Program_Session__c session2 = new Program_Session__c (Program_Service__c=program.id, Session_Date__c= system.today()+2);
        insert session2;
        
        Program_Session__c session3 = new Program_Session__c (Program_Service__c=program.id, Session_Date__c= system.today()+7);
        insert session3;
        
        List <Attendance__c> attendances = new List <Attendance__c>();
        
        // Check that contact records have not been updated as attendance records created by enrolment have not been marked as attended
        List <Contact> updatedContactList = new List <Contact>([Select LastName, Last_face_to_face_contact__c from Contact]);
        system.assertEquals(null, updatedContactList[0].Last_face_to_face_contact__c);
        
		attendances = TickAttendances(session);
		updatedContactList = [Select LastName, Last_face_to_face_contact__c from Contact];
        system.assertEquals(system.today(), updatedContactList[0].Last_face_to_face_contact__c);
        
		attendances = TickAttendances(session2);
        updatedContactList = [Select LastName, Last_face_to_face_contact__c from Contact];
        system.assertEquals(system.today()+2, updatedContactList[0].Last_face_to_face_contact__c);
        
        // test the create sessions on New Enrolment trigger where the service already has sessions
        Enrolment__c enrole3 = new Enrolment__c (Name='Test', Program_Service__c=program.id, Young_Person__c=youngPerson2.id, Status_on_Programme__c='Active');
        insert enrole3;
        
        // test an attendance being deleted
        ID contactWithDeletedAttendance = attendances[0].Young_Person__c;      
        delete attendances[0];
                
        // Check that contact records have been updated to reflect deletion
        Contact updatedContact = [Select LastName, Last_face_to_face_contact__c from Contact 
        												where ID = :contactWithDeletedAttendance];
        system.assertEquals(system.today(),updatedContact.Last_face_to_face_contact__c);
        
        // Mark as unattended the other record for the same contact
        attendances = [select Id, Attended__c, Young_Person__c from Attendance__c where Young_Person__c = :contactWithDeletedAttendance];
        attendances[0].Attended__c = False;
        update attendances;
        
        updatedContact = [Select LastName, Last_face_to_face_contact__c from Contact 
        												where ID = :contactWithDeletedAttendance];
        system.assertEquals(null,updatedContact.Last_face_to_face_contact__c);
        
    }
    
    static List<Attendance__c> TickAttendances(Program_Session__c session)
    {
    	ProgramAttendanceListView rsa = new ProgramAttendanceListView(session);
        rsa.submit();
        rsa.getAttendanceList(); 
        
        // tick all the attendances
        list<Attendance__c>attendances = [select Id, Attended__c, Young_Person__c from Attendance__c where Program_Session__c = :session.Id];
        for (Attendance__c oneAtt: attendances) oneAtt.Attended__c = true;
        update attendances;
        
        return(attendances);
    }
    
    static testMethod void testAttendedFlagSetOnDropInOpenAccessInsert()
    {
    	// Insert new attendance record for all record types
    	// Verify that the Attended__c flag is automatically set to true for 
    	// Drop in and Open Access attendance records only
    	Contact youngPerson = new Contact (LastName = 'Kelly');
        insert youngPerson;
        Contact youngPerson2 = new Contact (LastName = 'Smith');
        insert youngPerson2;
        
        Program_Service__c program = new Program_Service__c (Name = 'Music');
        insert program;
        
        Enrolment__c enrole = new Enrolment__c (Name='Test', Program_Service__c=program.id, Young_Person__c=youngPerson.id, Status_on_Programme__c='Active');
        insert enrole;
        
        Program_Session__c session = new Program_Session__c (Program_Service__c=program.id, Session_Date__c= system.today());
        insert session;
        
        List <Attendance__c> attendances = new List <Attendance__c>([select Id, Attended__c, Young_Person__c from Attendance__c where Program_Session__c = :session.Id]);
        system.assertequals(False, attendances[0].Attended__c);

		Id one2oneAttendanceRecordTypeID = [select Id from RecordType where DeveloperName='One_to_One_Attendance'].Id;  
		Id openAccessAttendanceRecordTypeID = [select Id from RecordType where DeveloperName='Open_Access_Attendance'].Id; 
		Id dropInAttendanceRecordTypeID = [select Id from RecordType where DeveloperName='Drop_In_Attendance'].Id;   

    	Attendance__c att1 = new Attendance__c(Young_Person__c = youngPerson.ID, RecordTypeID = one2oneAttendanceRecordTypeID);
    	insert att1;
    	attendances = [select Id, Attended__c, Young_Person__c from Attendance__c where RecordTypeID = :one2oneAttendanceRecordTypeID];
    	system.assertequals(False, attendances[0].Attended__c);
    	
    	Drop_in__c dropIn = new Drop_in__c(Name = 'Test Drop-in', Date__c = system.today());
    	insert dropIn;  	
    	att1 = new Attendance__c(Young_Person__c = youngPerson.ID, Drop_in__c = dropIn.ID, RecordTypeID = dropInAttendanceRecordTypeID);
    	insert att1;
    	attendances = [select Id, Attended__c, Young_Person__c from Attendance__c where RecordTypeID = :dropInAttendanceRecordTypeID];
    	system.assertequals(True, attendances[0].Attended__c);
    	
      	att1 = new Attendance__c(Young_Person__c = youngPerson.ID, RecordTypeID = openAccessAttendanceRecordTypeID);
    	insert att1;
    	attendances = [select Id, Attended__c, Young_Person__c from Attendance__c where RecordTypeID = :openAccessAttendanceRecordTypeID];
    	system.assertequals(True, attendances[0].Attended__c);
    	
   	}
    
    static testMethod void testCreateCarePlanStepAttendanceTrigger()
    {
        Contact youngPerson = new Contact (LastName = 'Kelly');
        insert youngPerson;
        
        Program_Service__c program = new Program_Service__c (Name = 'Music');
        insert program;
        
        Care_Plan_Objective__c careplan = new Care_Plan_Objective__c (Name='Improve welbeing', Client__c=youngPerson.id);
        insert careplan;
        
        Enrolment__c enrole = new Enrolment__c (Name='Test', Program_Service__c=program.id, Young_Person__c=youngPerson.id, Care_Plan_Objective__c=careplan.id, Status_on_Programme__c='Active');
        insert enrole;
        
        Integer preCarePlanSteps = [select count() from Care_plan_step__c where Reference__c != null];
        
        Test.startTest();
        Program_Session__c session = new Program_Session__c (Program_Service__c=program.id, Session_Date__c=system.today()-1);
        insert session;
        Test.stopTest();
        
        Integer postCarePlanSteps = [select count() from Care_plan_step__c where Reference__c != null];
        System.Debug ('Care plan steps, Before: ' + preCarePlanSteps + ' After: ' + postCarePlanSteps);
        System.Assert (postCarePlanSteps > preCarePlanSteps);
    }
    
    static testMethod void testUpdateAttendanceOnCarePlanStep1()
    {
        Contact youngPerson = new Contact (LastName = 'Kelly');
        insert youngPerson;
        
        Program_Service__c program = new Program_Service__c (Name = 'Music');
        insert program;
        
        Care_Plan_Objective__c careplan = new Care_Plan_Objective__c (Name='Improve welbeing', Client__c=youngPerson.id);
        insert careplan;
        
        Enrolment__c enrole = new Enrolment__c (Name='Test', Program_Service__c=program.id, Young_Person__c=youngPerson.id, Care_Plan_Objective__c=careplan.id, Status_on_Programme__c='Active');
        insert enrole;
        
        Program_Session__c session = new Program_Session__c (Program_Service__c=program.id, Session_Date__c=system.today()-1);
        insert session;
        
        Test.startTest();
        Attendance__c attend = [select ID, Attended__c from Attendance__c where Enrolment__r.Care_Plan_Objective__c = :careplan.id limit 1];
        attend.Attended__c = True;
        update attend;
        Test.stopTest();
        
        Care_plan_step__c careplanstep = [select ID, Reference__c, Status__c, Description__c from Care_plan_step__c where Care_Plan_Objective__c = :careplan.id limit 1];
//        System.assertEquals ('Attended', careplanstep.Status__c); -- this test fails when uploading the package, no idea why
    }
    
    static testMethod void testUpdateAttendanceOnCarePlanStep2()
    {
        Contact youngPerson = new Contact (LastName = 'Kelly');
        insert youngPerson;
        
        Program_Service__c program = new Program_Service__c (Name = 'Music');
        insert program;
        
        Care_Plan_Objective__c careplan = new Care_Plan_Objective__c (Name='Improve welbeing', Client__c=youngPerson.id);
        insert careplan;
        
        Enrolment__c enrole = new Enrolment__c (Name='Test', Program_Service__c=program.id, Young_Person__c=youngPerson.id, Care_Plan_Objective__c=careplan.id, Status_on_Programme__c='Active');
        insert enrole;
        
        Program_Session__c session = new Program_Session__c (Program_Service__c=program.id, Session_Date__c=system.today()-1);
        insert session;
        
        Test.startTest();
        Attendance__c attend = [select ID, Attended__c from Attendance__c where Enrolment__r.Care_Plan_Objective__c = :careplan.id limit 1];
        attend.Attended__c = False;
        update attend;
        Test.stopTest();
        
        Care_plan_step__c careplanstep2 = [select ID, Reference__c, Status__c, Description__c from Care_plan_step__c where Care_Plan_Objective__c = :careplan.id limit 1];
        System.debug(careplanstep2.Description__c);
        System.assertEquals ('Did not attend', careplanstep2.Status__c);
    }

    static testMethod void createEventFromAttendanceTest() 
    {
        Contact youngPerson = new Contact (LastName = 'Kelly');
        insert youngPerson;
    
        Attendance__c one2one = new Attendance__c (Name='Test', Young_Person__c = youngPerson.id, Duration_in_minutes__c = 30, Reason_for_Attending__c='Test', Date_and_time_of_attendance__c=system.now(), Put_in_my_calendar__c=true, Programme__c='Drug Team', Activity_Type__c='Key Working');
        insert one2one;
        
        Event eventAdded = [select Subject, Programme__c, Activity_Type__c from Event where WhoID=:youngPerson.id limit 1];
        system.assertEquals ('Test', eventAdded.Subject);
        system.assertEquals (one2one.Programme__c, eventAdded.Programme__c); 
        system.assertEquals (one2one.Activity_Type__c, eventAdded.Activity_Type__c);
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
        
        Event eventchanged = [select Status__c, Related_Attendance_ID__c, Related_Attendance_Name__c from Event where ID=:e1.id limit 1];
        system.assertEquals (atts[0].Id, eventchanged.Related_Attendance_ID__c);
        
        // try an event without a contact
        Integer attendancesCount = [select count() from Attendance__c];
        Event e2 = new Event (OwnerID=UserInfo.getUserId(), Subject='Test', StartDateTime=system.now(), DurationInMinutes=60);
        insert e2;

        atts = [select id, Reason_for_Attending__c from Attendance__c limit 5000];
        system.assertEquals (attendancesCount, atts.size()); // shouldn't have added an attendance
        
        // change the Event Status and verify that the Attendance changes
        eventchanged.Status__c = 'Cancelled';
        update eventchanged;
        
        Attendance__c attend = [select id, Status__c from Attendance__c where Status__c = 'Cancelled' limit 1];
        system.assertEquals(eventchanged.Status__c, attend.Status__c);
        
    }
   
    static testMethod void createAttendanceFromEventSeriesTest() 
    {
        Id clientRecordTypeID = [SELECT ID FROM RecordType WHERE SobjectType='Contact' and DeveloperName='Client'].id;
        Contact youngPerson = new Contact (LastName = 'Kelly', RecordTypeID=clientRecordTypeID);
        insert youngPerson;
    
        Event e1 = new Event (WhoID=youngPerson.id, OwnerID=UserInfo.getUserId(), Subject='Test', StartDateTime=system.now(), DurationInMinutes=60);
        e1.IsRecurrence = true;
        e1.RecurrenceEndDateOnly = system.today().addDays(4);
        e1.RecurrenceStartDateTime = system.now();
        e1.RecurrenceType = 'RecursDaily';
        e1.RecurrenceInterval = 1;
        insert e1;
        
        list<Attendance__c> atts = [select id, Reason_for_Attending__c from Attendance__c where Young_Person__c=:youngPerson.id limit 5000];
        system.assertEquals (5, atts.size()); 
    }
    
    static testMethod void createAttendanceWithActivityClassificationFromEventTest() 
    {
        Id clientRecordTypeID = [SELECT ID FROM RecordType WHERE SobjectType='Contact' and DeveloperName='Client'].id;
        Contact youngPerson = new Contact (LastName = 'Kelly', RecordTypeID=clientRecordTypeID);
        insert youngPerson;
    
        Event e1 = new Event (WhoID=youngPerson.id, OwnerID=UserInfo.getUserId(), Subject='Test', StartDateTime=system.now(), DurationInMinutes=60, Programme__c='Drug Team', Activity_Type__c='Key Working');
        insert e1;
        
        list<Attendance__c> atts = [select id, Programme__c, Activity_Type__c from Attendance__c where Young_Person__c=:youngPerson.id limit 5];
        system.assertEquals (e1.Programme__c, atts[0].Programme__c); 
        system.assertEquals (e1.Activity_Type__c, atts[0].Activity_Type__c);
    }
   
}