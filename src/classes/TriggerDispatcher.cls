/*
	Author: Eamon Kelly, Enclude
	Purpose: Dispatcher for triggers 
	Called from: CarePlanObjectiveTrigger, AttendancesTriggerClass, NeedlesExchangeTriggerClass
	Test notes: This class is tested in testCarePlanEventTrigger 
*/
public class TriggerDispatcher 
{
	public static Boolean InTrigger = false;
	public static Boolean InAttendanceTrigger = false;
	public static Boolean InEnrolmentTrigger = false;
	public static Boolean InHRBFormTrigger = false;
	public static eCASS_settings__c settings = eCASS_settings__c.getOrgDefaults();
	
	public interface ITriggerEntry 
	{
		void MainEntry (String TriggerObject, Boolean isBefore, Boolean isDelete, Boolean isAfter, Boolean isInsert, Boolean isUpdate, Boolean isExecuting,
			List<SObject> newList, Map<Id, SObject> newMap, List<SObject> oldList, Map<Id, SObject> oldMap);
	}
	
	public static ITriggerEntry activeFunction = null;
	
	public static void MainEntry (String TriggerObject, Boolean isBefore, Boolean isDelete, Boolean isAfter, Boolean isInsert, Boolean isUpdate, Boolean isExecuting,
		List<SObject> newList, Map<Id, SObject> newMap, List<SObject> oldList, Map<Id, SObject> oldMap)
	{
		if (settings != null && settings.Disable_Triggers__c == true) return;
		
		if (TriggerObject == 'CarePlanObjective')
		{
			InTrigger = true;
			activeFunction = new CreateUpdateCarePlanClass();
			activeFunction.MainEntry (TriggerObject, isBefore, isDelete, isAfter, isInsert, isUpdate, isExecuting, newList, newMap, oldList, oldMap);
			InTrigger = false;
		}
		else if (TriggerObject == 'Attendance' && !InAttendanceTrigger) // not going round in circles because when an event creates an attendance, the "Put in my calendar" checkbox is not ticked, so it doesn't attempt to create an event 
		{
			InTrigger = true;
			InAttendanceTrigger = true; // attendances update their own name
			activeFunction = new AttendancesTriggerClass();
			activeFunction.MainEntry (TriggerObject, isBefore, isDelete, isAfter, isInsert, isUpdate, isExecuting, newList, newMap, oldList, oldMap);
			InTrigger = false;
			InAttendanceTrigger = false;
		}
		else if (TriggerObject == 'Enrolment' && !InEnrolmentTrigger)
		{
			InTrigger = true;
			InEnrolmentTrigger = true;
			activeFunction = new EnrolmentsTriggerClass();
			activeFunction.MainEntry (TriggerObject, isBefore, isDelete, isAfter, isInsert, isUpdate, isExecuting, newList, newMap, oldList, oldMap);
			InEnrolmentTrigger = false;
			InTrigger = false;
		}
		else if (TriggerObject == 'HRB Form' && !InHRBFormTrigger)
		{
			InTrigger = true;
			InHRBFormTrigger = true;
			activeFunction = new HRBFormsTriggerClass();
			activeFunction.MainEntry (TriggerObject, isBefore, isDelete, isAfter, isInsert, isUpdate, isExecuting, newList, newMap, oldList, oldMap);
			InHRBFormTrigger = false;
			InTrigger = false;
		}
		else if (TriggerObject == 'Needle Exchange')
		{
			InTrigger = true;
			activeFunction = new NeedlesExchangeTriggerClass();
			activeFunction.MainEntry (TriggerObject, isBefore, isDelete, isAfter, isInsert, isUpdate, isExecuting, newList, newMap, oldList, oldMap);
			InTrigger = false;
		}
		else if (TriggerObject == 'Program Session')
		{
			InTrigger = true;
			activeFunction = new ProgramSessionTrigger();
			activeFunction.MainEntry (TriggerObject, isBefore, isDelete, isAfter, isInsert, isUpdate, isExecuting, newList, newMap, oldList, oldMap);
			InTrigger = false;
		}
		else if (TriggerObject == 'Event' && !InTrigger) // don't want a trigger on an attendance creating an event
		{
			InTrigger = true;
			activeFunction = new EventTriggerClass();
			activeFunction.MainEntry (TriggerObject, isBefore, isDelete, isAfter, isInsert, isUpdate, isExecuting, newList, newMap, oldList, oldMap);
			InTrigger = false;
		}
	}
}