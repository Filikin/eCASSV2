/*

Author: Maeve Kerney, Enclude

Purpose: Test AttendancesTriggerClass for code added to update the last face to face contact date

Called from: Test

*/
@isTest
private class testUpdateLastAttendedDate {

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
        /*
        Enrolment__c enrole2 = new Enrolment__c (Name='Test', Program_Service__c=program.id, Young_Person__c=youngPerson2.id, Status_on_Programme__c='Active');
        insert enrole2;
        */
        
        Program_Session__c session = new Program_Session__c (Program_Service__c=program.id, Session_Date__c= system.today());
        insert session;
        
        System.debug('1.Session 1 inserted');
        
        Program_Session__c session2 = new Program_Session__c (Program_Service__c=program.id, Session_Date__c= system.today()+2);
        insert session2;
        
        System.debug('2.Session 2 inserted');
        
        Program_Session__c session3 = new Program_Session__c (Program_Service__c=program.id, Session_Date__c= system.today()+7);
        insert session3;
        
        System.debug('3.SEssion 3 inserted');
        
        List <Attendance__c> attendances = new List <Attendance__c>();
        
        // Check that contact records have not been updated as attendance records created by enrolment have not been marked as attended
        List <Contact> updatedContactList = new List <Contact>([Select LastName, Last_face_to_face_contact__c from Contact]);
        system.assertEquals(null, updatedContactList[0].Last_face_to_face_contact__c);
        
		attendances = TickAttendances(session);
		updatedContactList = [Select LastName, Last_face_to_face_contact__c from Contact];
        system.assertEquals(system.today(), updatedContactList[0].Last_face_to_face_contact__c);
        
        System.debug('4. Session 1 attendance ticked');
        
		attendances = TickAttendances(session2);
        updatedContactList = [Select LastName, Last_face_to_face_contact__c from Contact];
        system.assertEquals(system.today()+2, updatedContactList[0].Last_face_to_face_contact__c);
        
        System.debug('5. Session 2 attendance ticked');
        /*
        
        // test the create sessions on New Enrolment trigger where the service already has sessions
        Enrolment__c enrole3 = new Enrolment__c (Name='Test', Program_Service__c=program.id, Young_Person__c=youngPerson2.id, Status_on_Programme__c='Active');
        insert enrole3;
        
        */
        
        // test an attendance being deleted
        ID contactWithDeletedAttendance = attendances[0].Young_Person__c;      
        delete attendances[0];
                
        System.debug('6. Session deleted');        
                
        // Check that contact records have been updated to reflect deletion
        Contact updatedContact = [Select LastName, Last_face_to_face_contact__c from Contact 
        												where ID = :contactWithDeletedAttendance];
        system.assertEquals(system.today(),updatedContact.Last_face_to_face_contact__c);
        
        
        // Mark as unattended the other record for the same contact
        attendances = [select Id, Attended__c, Young_Person__c from Attendance__c where Young_Person__c = :contactWithDeletedAttendance];
        attendances[0].Attended__c = False;
        update attendances;
        
        System.debug('7. Session marked unattended');
        
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
   		return;
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

		Id one2oneAttendanceRecordTypeID = [select Id from RecordType where DeveloperName='One_to_One_Attendance' limit 1].Id;  
		Id openAccessAttendanceRecordTypeID = [select Id from RecordType where DeveloperName='Open_Access_Attendance' limit 1].Id; 
		Id dropInAttendanceRecordTypeID = [select Id from RecordType where DeveloperName='Drop_In_Attendance' limit 1].Id;   

    	Attendance__c att1 = new Attendance__c(Young_Person__c = youngPerson.ID, RecordTypeID = one2oneAttendanceRecordTypeID);
    	insert att1;
    	attendances = [select Id, Attended__c, Young_Person__c from Attendance__c where RecordTypeID = :one2oneAttendanceRecordTypeID];
    	system.assertequals(False, attendances[0].Attended__c);
    	
    	Drop_in__c dropIn = new Drop_in__c(Name = 'Test Drop-in', Date__c = system.today());
    	insert dropIn;  	
    	att1 = new Attendance__c(Young_Person__c = youngPerson.ID, Drop_in__c = dropIn.ID, RecordTypeID = dropInAttendanceRecordTypeID);
    	insert att1;
    	attendances = [select Id, Attended__c, Young_Person__c from Attendance__c where RecordTypeID = :dropInAttendanceRecordTypeID];
    	system.debug('Drop in attendances:'+attendances);
    	
    	system.assertequals(True, attendances[0].Attended__c);
    	    	
      	att1 = new Attendance__c(Young_Person__c = youngPerson.ID, RecordTypeID = openAccessAttendanceRecordTypeID);
    	insert att1;
    	attendances = [select Id, Attended__c, Young_Person__c from Attendance__c where RecordTypeID = :openAccessAttendanceRecordTypeID];
    	system.assertequals(True, attendances[0].Attended__c);
	    	
   	}
}