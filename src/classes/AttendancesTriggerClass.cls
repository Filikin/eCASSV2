/*
	Author: Eamon Kelly, Enclude
	Purpose: Need to act as a rollup on the attendance to the program session    
		Only for sessions that Attended__c to true  
		When an attendance is created or modified that is associated with an enrolment that is linked to a care plan objective, 
		create or modify the care plan step on that care plan objective
		Restrict attendance name to 30 characters 
		
	Updated by: Maeve Kerney, Enclude   
	Purpose: Add code to update related contact record with date of last contact
			 Also add code to set Attended__c value to true for Drop-in and Open Access attendances
	
	EK 19/12/2016 Added exception handling when updating the contacts due to problems with NPSP	
    MK 02/04/2019 Added code to deal with status on multiple attendances being updated simultaneously 
                  for one client (updateLastContactDate)
	Tested in testCreateAttendanceTrigger and testUpdateLastAttendedDate
	
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
				updateLastContactDate((map<Id, Attendance__c>)newMap, (map<Id, Attendance__c>)oldMap);
			}
			else
			{
				DefaultAttendanceFlagForDropInAndOpenAccess((List <Attendance__c>)newList);
			}
		}
		else if (isUpdate)
		{
			if (isAfter) 
			{
				CreateUpdateCarePlanStepOnAttendance ((Map <ID, Attendance__c>)newMap, isInsert);
				CountNumberAttended (newList);
				updateLastContactDate((map<Id, Attendance__c>)newMap, (map<Id, Attendance__c>)oldMap);
			}
		}
		else if (isDelete)
		{
			if (isAfter) CountNumberAttended (oldList);
			updateLastContactDateOnDelete((map<Id, Attendance__c>)oldMap);
		}
		system.debug('Coming out of attendance trigger.');
		system.debug('newlist: '+newlist);
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
			String newName = nameTemplate.replace('$NAME$', clientName).replace('$DATE$', attendanceDate.format()).replace('$INITIALS$', clientInitials);
			if (newName.length() > AppConfigSupport.MAX_NAME_SIZE) return newName.subString (0, AppConfigSupport.MAX_NAME_SIZE);
			else return newName;
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
						if (oneStep != null)
						{
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
	    }
	    if (newSteps.size() > 0) insert newSteps;
	    if (currentSteps.size()> 0) update currentSteps;
	}
	
	public void updateLastContactDate(Map<ID, Attendance__c> attMap, Map<ID, Attendance__c> oldMap)
	{ 
		// Create map of contact records for contacts referenced in retrieved attendance records
		
		List <Attendance__c> attList = new List <Attendance__c>(attMap.values());
		Set <ID> referencedClientSet = new Set <ID>();
		for (Attendance__c a: attlist)
		{
			referencedClientSet.add(a.Young_Person__c);
		}
		
		// Filter out the clients that the user doesn't have access to
		referencedClientSet = filterInAccessableClients (referencedClientSet);

		Map <ID, Contact> contactMap = new Map <ID, Contact> ([Select ID, Last_face_to_face_contact__c from Contact 
																	where ID in :referencedClientSet]);
		
		// If oldMap is not null, we may need to deal with records being changed from attended to not attended, so get relevant
		// existing attendance for client set.
		List <Attendance__c> allAttendancesForReferencedClients = new List <Attendance__c>();
		if (oldMap != null)
		{
			allAttendancesForReferencedClients = ([SELECT Id, Young_Person__c, Attendance_Date__c FROM Attendance__c 
													WHERE Attended__c = TRUE AND Young_Person__c in :referencedClientSet
																		ORDER BY Attendance_Date__c DESC ]);	
		}
		
		// Identify which records need to have Last contact date field updated
		Contact thisClient;
		
		List <Contact> contactsForUpdate = new List <Contact>();
		for (Attendance__c thisAttendance: attList)
		{
			thisClient = contactMap.get(thisAttendance.Young_Person__c);
			if (thisClient != null)
			{
				if (thisAttendance.Attended__c == true)
				{
                    System.debug('thisClient: '+thisClient);
                    System.debug('thisAttendance: '+thisAttendance);
					if ( (thisClient.Last_face_to_face_contact__c == null) ||
					     (thisAttendance.Attendance_Date__c > thisClient.Last_face_to_face_contact__c))
					{
						thisClient.Last_face_to_face_contact__c = thisAttendance.Attendance_Date__c;
						
						// Depending on type of attendance record, get URL or something appropriate to put into Last Contact Type
						// Do this later!!
						if (!contactsForUpdate.contains(thisClient))
                        {
                            contactsForUpdate.add(thisClient);
                        }						
                        System.debug('contactsForUpdate: '+contactsForUpdate);
					}
				}	
				else if (oldMap != null) 
				{
					// This is an update.  Need to check if previously-attended record is now marked unattended
					Attendance__c beforeUpdateAtt = oldMap.get(thisAttendance.ID);
					if ((beforeUpdateAtt != null) && (beforeUpdateAtt.Attended__c == true) &&
						(thisClient.Last_face_to_face_contact__c != null) && (thisAttendance.Attendance_Date__c == thisClient.Last_face_to_face_contact__c))
					{
						// Get new date to replace existing date, or set to null if no such date
						thisClient.Last_face_to_face_contact__c = null;
						for (Attendance__c att: allAttendancesForReferencedClients)
						{
							if (att.Young_Person__c == thisAttendance.Young_Person__c)
							{
								thisClient.Last_face_to_face_contact__c = att.Attendance_Date__c;
								break;
							}
						}								
						if (!contactsForUpdate.contains(thisClient))  //02/04/19: added if condition
                        {
                            contactsForUpdate.add(thisClient);
                        }   
					}
				}
			}
		}
		
		// Update records
		if (contactsForUpdate.size() > 0) 
		{
			try
			{
				update contactsForUpdate;
			}
			catch (Exception e)
			{
				system.debug ('Failed to update contacts ' + e.getMessage());
			} 
		}
	}		
	
	public void updateLastContactDateOnDelete(map<Id, Attendance__c> oldMap)
	{
		
		// First get a list of deleted attendances where attended was true.
		// From this list, get the set up clients referenced
		// Then get the set of all attendances for the referenced clients, in descending date order so the first record we hit for any client
		// will be the latest one. 
		// For each item in list, we only need to update the last contact details if Attended is yes and the attendance date
		// is equal to the last attended date on the contact record.
		// If the attendance date is equal to the last contact date on the contact record, we need to figure out what the last
		// attendance date was based on the other records for this contact.  Get these from the list of attendances for all referenced clients. 
		
		List<Attendance__c> deletedActualAttendances = new List <Attendance__c>();
		List<Attendance__c> deletedAttendances = oldMap.values();
		List<Contact> contactsForUpdate = new List<Contact>();
		
		Set<ID> referencedClientSet = new Set<ID>();
		
		for (Attendance__c a: deletedAttendances)
		{
			if (a.Attended__c)
			{
				deletedActualAttendances.add(a);
				referencedClientSet.add(a.Young_Person__c);
			}		
		}
			
		// Filter out the clients that the user doesn't have access to
		referencedClientSet = filterInAccessableClients (referencedClientSet);
		
		Map<ID, Contact> referencedClientMap = new Map<ID, Contact>([SELECT Id, Last_face_to_face_contact__c FROM Contact 
																	 WHERE Id in :referencedClientSet]);
																	 
		List <Attendance__c> allAttendancesForReferencedClients = new List <Attendance__c>([SELECT Id, Young_Person__c, Attendance_Date__c
																		FROM Attendance__c WHERE Attended__c = TRUE AND Young_Person__c in :referencedClientSet
																		ORDER BY Attendance_Date__c DESC ]);														 
		
		
		for (Attendance__c thisAtt: deletedActualAttendances )
		{
			// There should always be a contact for the record but just to be sure we'll check for a null from the get
			Contact thisClient = referencedClientMap.get(thisAtt.Young_Person__c);
			System.debug('thisClient: '+thisClient);
			
			if ((thisClient != null) && (thisAtt.Attendance_Date__c == thisClient.Last_face_to_face_contact__c))
			{
				// Get new date to replace existing date, or set to null if no such date
				thisClient.Last_face_to_face_contact__c = null;
				for (Attendance__c att: allAttendancesForReferencedClients)
				{
					if (att.Young_Person__c == thisAtt.Young_Person__c)
					{
						thisClient.Last_face_to_face_contact__c = att.Attendance_Date__c;
						break;
					}
				}								
				contactsForUpdate.add(thisClient);
			}
		}
		if (contactsForUpdate.size() > 0) update contactsForUpdate; 
		
	}
	
	public void DefaultAttendanceFlagForDropInAndOpenAccess(List <Attendance__c> newList)
	{  
		Id openAccessAttendanceRecordTypeID = [select Id from RecordType where DeveloperName='Open_Access_Attendance' limit 1].Id; 
		Id dropInAttendanceRecordTypeID = [select Id from RecordType where DeveloperName='Drop_In_Attendance' limit 1].Id;  
		
		for (Attendance__c att: newList)
		{
			if (att.RecordTypeID == openAccessAttendanceRecordTypeID || att.RecordTypeID == dropInAttendanceRecordTypeID) 	
			{
				att.Attended__c = true; 
				att.Status__c = 'Attended';
				system.debug('Setting attended to true');
			}	
		}
				
	}	
	
	public set <ID> filterInAccessableClients (set <ID> clientSet)
	{
		list <UserRecordAccess> accessableClientsAccess = [select RecordID from UserRecordAccess where UserId=:UserInfo.getUserId() and RecordId in :clientSet and HasEditAccess=true limit 200];
		set <ID> accessableClients = new set <ID>();
		for (UserRecordAccess oneAccess : accessableClientsAccess)
		{
			accessableClients.add (oneAccess.RecordID);
		}
		return accessableClients;
	}
		
}