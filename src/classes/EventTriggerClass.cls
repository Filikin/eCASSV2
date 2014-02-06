/*
	Author: Eamon Kelly, Enclude
	Purpose: When an event is created that is related to a client, create a corresponding one to one attendance
	Note: if the event is already linked to another object, don't break that link by changing WhatID
	In Summer 2014 we might get the ability to add lookup fields to activities, then we can have one dedicated to a ttendances
	Called from: TriggerDispatcher
*/
public with sharing class EventTriggerClass implements TriggerDispatcher.ITriggerEntry
{
	public void MainEntry (String TriggerObject, Boolean isBefore, Boolean isDelete, Boolean isAfter, Boolean isInsert, Boolean isUpdate, Boolean isExecuting,
		list<SObject> newList, Map<Id, SObject> newMap, List<SObject> oldList, Map<Id, SObject> oldMap)
	{
		if (isInsert)
		{
			if (isBefore) CreateAttendances (newList);
			else if (isAfter) CreateOrUpdateCarePlanStep (newMap, isInsert);
		}
		else if (isUpdate)
		{
			if (isAfter)
			{
				UpdateAttendances (newList, oldMap);
				CreateOrUpdateCarePlanStep (newMap, isInsert);
			}
		}
	}
	
	public void CreateAttendances (List<Event> evtList)
	{
		list<Attendance__c> attendancesToCreate = new list <Attendance__c>();
		
		// first make sure the contact is a client
    	Id clientRecordTypeID = [SELECT ID FROM RecordType WHERE SobjectType='Contact' and DeveloperName='Client'].id;
		set <id>contactsSet = new set <id>(); 
		for (Event oneEvent: evtList)
		{
			contactsSet.add (oneEvent.WhoId);
		}
		map <Id, Contact> clients = new map <Id, Contact>([select Id from Contact where RecordTypeId = :clientRecordTypeId and Id in :contactsSet]);
		
		// now create the attendances
		Id one2oneAttendanceRecordTypeID = [select Id from RecordType where sObjectType='Attendance__c' and DeveloperName='One_to_One_Attendance'].Id;
		for (Event oneEvent: evtList)
		{
			system.debug ('Event: ' + oneEvent);
			if (oneEvent.IsRecurrence == false && oneEvent.WhoId != null) // looks like if IsRecurrence is true then recurring events will be generated with this as false, otherwise get an extra attendance
			{
				Contact thisClient = clients.get (oneEvent.WhoId);
				if (thisClient != null)
				{
					Attendance__c one2one = new Attendance__c (Name='FromEvent', Young_Person__c = thisClient.id, Duration_in_minutes__c = oneEvent.DurationInMinutes, Reason_for_Attending__c=oneEvent.Subject, Date_and_time_of_attendance__c=oneEvent.ActivityDateTime, Put_in_my_calendar__c=false, RecordTypeId=one2oneAttendanceRecordTypeID);
					attendancesToCreate.add (one2one);					
				}
			}
		}		
		if (attendancesToCreate.size() > 0) 
		{
			insert attendancesToCreate;
			// now link the event to the attendance - I am going to assume they are in the same order
			Integer attendanceNumber = 0; 
			for (Event oneEvent: evtList)
			{
				if (oneEvent.WhoId != null)
				{
					Contact thisClient = clients.get (oneEvent.WhoId);
					if (thisClient != null)
					{
						if (oneEvent.WhatId == null) // don't break previous links
						{
							try{
								oneEvent.WhatId = attendancesToCreate[attendanceNumber].Id;
							}
							catch (Exception e)
							{
								// ignore failures
							}
						}
						attendanceNumber++;
					}
				}
			}
		}
	}
	
	// if the attendance is linked to an event and the status of the event has changed, update the status of the attendance
	public void UpdateAttendances (List<Event> evtList, Map<Id, sObject>oldMap)
	{
		list<Attendance__c> attendancesToUpdate = new list <Attendance__c>();
		
		set <id>attendanceSet = new set <id>(); 
		for (Event oneEvent: evtList)
		{
			if (oneEvent.WhatId != null && oneEvent.Status__c != ((Event)oldMap.get(oneEvent.id)).Status__c)
			{
				attendanceSet.add (oneEvent.WhatId);
			}
		}
		
		map <Id, Attendance__c> attendances = new map <Id, Attendance__c>([select Id, Status__c from Attendance__c where Id in :attendanceSet]);		
		
		// now update the attendances
		for (Event oneEvent: evtList)
		{
			if (attendances.containsKey (oneEvent.WhatId))
			{
				Attendance__c relatedAttendance = attendances.get (oneEvent.WhatId);
				relatedAttendance.Status__c = oneEvent.Status__c;
				attendancesToUpdate.add (relatedAttendance);
			}
		}		
		if (attendancesToUpdate.size() > 0) 
		{
			update attendancesToUpdate;
		}
	}
	
/*
	Author: Eamon Kelly, Enclude
	Purpose: When a calendar event is created or modified that is associated with a care plan objective, 
		create or modify the care plan step on that care plan objective
	Tested from CreateUpdateCarePlanClass 
*/
	public void CreateOrUpdateCarePlanStep (Map<Id, sObject>newMap, Boolean isInsert)
	{
	    // need to know what a care plan objective looks like, if none, then we can leave
 	   String carePlanObjectiveIdentifier='';
    	List<Care_Plan_Objective__c>cpo = new List<Care_Plan_Objective__c>();
    	cpo = [select id from Care_Plan_Objective__c limit 1];
    	if (cpo.size() > 0) carePlanObjectiveIdentifier=((String)(cpo[0].id)).substring(0,3);
    	else return;
    
    	List <Event>events = [select ID, WhoID, WhatID, StartDateTime, ActivityDateTime, IsRecurrence, Care_plan_step_text__c, Status__c, Status_Comment__c, Person_Responsible_for_Step__c, Related_Organisation__c from Event where ID in :newMap.keySet()];

 	   	List <Care_plan_step__c>newSteps = new List<Care_plan_step__c>();
    
    	List <Care_plan_step__c>currentSteps = [select ID, Date__c, Description__c, Reference__c, Status__c, Status_Comment__c, Person_Responsible_for_Action__c, Related_Organisation__c, Care_Plan_Objective__c from Care_plan_step__c where Reference__c in :newMap.keySet()];
	    Map <ID, Care_plan_step__c>currentStepsMap = new Map<ID, Care_plan_step__c>();
    	for (Care_plan_step__c oneStep: currentSteps)
    	{
        	currentStepsMap.put (oneStep.Reference__c, oneStep);
    	}
        
    	Set <ID> clientsSet = new Set <ID>();
    	for (Event oneEvent: events)
			clientsSet.add (oneEvent.WhoID);    
    
    	Map <ID, Care_Plan_Objective__c> clientsCarePlanObjectives = new Map <ID, Care_Plan_Objective__c> ([select ID, Client__c from Care_Plan_Objective__c where Client__c in :clientsSet]);         
	    for (Event oneEvent: events)
    	{
       	if (oneEvent.IsRecurrence == false && oneEvent.WhatId != null && ((String)(oneEvent.WhatId)).startsWith (carePlanObjectiveIdentifier))
        	{
        		// the care plan objective must belong to the client
	        	if (clientsCarePlanObjectives.get(oneEvent.whatID) == null)
    	    	{
        			((Event)newMap.get(oneEvent.id)).whatID.addError ('Care plan objective must be for this client');
        		} 
	        	else if (isInsert || currentStepsMap.get (oneEvent.id) == null)
  		        {
                	Care_plan_step__c oneStep = new Care_plan_step__c (Care_Plan_Objective__c=oneEvent.whatID,
                    	Date__c=oneEvent.ActivityDateTime.Date(), Description__c=oneEvent.Care_plan_step_text__c, Reference__c=oneEvent.id,
                    	Status__c=oneEvent.Status__c, Status_Comment__c=oneEvent.Status_Comment__c, Person_Responsible_for_Action__c=oneEvent.Person_Responsible_for_Step__c, Related_Organisation__c=oneEvent.Related_Organisation__c);
	                newSteps.Add(oneStep);
    	        }
        	    else
            	{
                	Care_plan_step__c oneStep = currentStepsMap.get (oneEvent.id);
	                oneStep.Care_Plan_Objective__c = oneEvent.WhatId; // just in case it has changed
    	            oneStep.Date__c=oneEvent.ActivityDateTime.Date();
        	        oneStep.Description__c=oneEvent.Care_plan_step_text__c;
            	    oneStep.Status__c=oneEvent.Status__c;
                	oneStep.Status_Comment__c=oneEvent.Status_Comment__c;
                	oneStep.Person_Responsible_for_Action__c=oneEvent.Person_Responsible_for_Step__c;
                	oneStep.Related_Organisation__c=oneEvent.Related_Organisation__c;
            	}
        	}       
    	}
    	if (newSteps.size() > 0) insert newSteps;
    	if (currentSteps.size()> 0) update currentSteps;
    	if (clientsCarePlanObjectives.size()>0) update clientsCarePlanObjectives.values();
	}
}