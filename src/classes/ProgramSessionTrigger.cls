/*
	Author: Eamon Kelly, Enclude
	Purpose: When a new program session is created, find everyone who is enrolled in the course and create attendances for them in the session
	Tested in testCreateAttendanceTrigger 
*/
public with sharing class ProgramSessionTrigger implements TriggerDispatcher.ITriggerEntry
{
	public void MainEntry (String TriggerObject, Boolean isBefore, Boolean isDelete, Boolean isAfter, Boolean isInsert, Boolean isUpdate, Boolean isExecuting,
		list<SObject> newList, Map<Id, SObject> newMap, List<SObject> oldList, Map<Id, SObject> oldMap)
	{
		if (isInsert && isAfter)
		{
			CreateAttendancesOnNewSession (newList);
		}
	}
	
	public void CreateAttendancesOnNewSession (list<Program_Session__c> newSessions)
	{
		Attendance__c[] attendances = new Attendance__c[0];
    
		set <Id> servicesSet = new set <Id>();
    	for (Program_Session__c sNew: newSessions)
	    {
    		servicesSet.add (sNew.Program_Service__c);
    	}
    	map <Id, Program_Service__c> servicesMap = new map <Id, Program_Service__c>([select Id, (select Id, Young_Person__c from Participants__r where Status_on_Programme__c = 'Active') from Program_Service__c where Id in :servicesSet]);
		if (newSessions.size() < 50) // not required for mass import
		{
		    for (Program_Session__c sNew: newSessions)
		    {
		        for (Enrolment__c onePersonEnrolment: servicesMap.get(sNew.Program_Service__c).Participants__r)
	    	    {
	        	    Attendance__c oneAttended = new Attendance__c (Young_Person__c=onePersonEnrolment.Young_Person__c, Program_Session__c=sNew.id, Enrolment__c=onePersonEnrolment.id);
	            	attendances.add (oneAttended);
		        } 
		    }
	    	insert attendances;
		}
	}
}