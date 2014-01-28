/*
	Author: Eamon Kelly, Enclude
	Purpose: Dispatcher for triggers 
	Called from: CarePlanObjectiveTrigger, AttendancesTriggerClass, NeedlesExchangeTriggerClass
	Test notes: This class is tested in testCarePlanEventTrigger 
*/
public class TriggerDispatcher 
{
	public static Boolean InTrigger = false;
	public interface ITriggerEntry 
	{
		void MainEntry (String TriggerObject, Boolean isBefore, Boolean isDelete, Boolean isAfter, Boolean isInsert, Boolean isUpdate, Boolean isExecuting,
			List<SObject> newList, Map<Id, SObject> newMap, List<SObject> oldList, Map<Id, SObject> oldMap);
	}
	
	public static ITriggerEntry activeFunction = null;
	
	public static void MainEntry (String TriggerObject, Boolean isBefore, Boolean isDelete, Boolean isAfter, Boolean isInsert, Boolean isUpdate, Boolean isExecuting,
		List<SObject> newList, Map<Id, SObject> newMap, List<SObject> oldList, Map<Id, SObject> oldMap)
	{
		if (TriggerObject == 'CarePlanObjective')
		{
			InTrigger = true;
			activeFunction = new CreateUpdateCarePlanClass();
			activeFunction.MainEntry (TriggerObject, isBefore, isDelete, isAfter, isInsert, isUpdate, isExecuting, newList, newMap, oldList, oldMap);
			InTrigger = false;
		}
		else if (TriggerObject == 'Attendance' && !InTrigger) // don't want a trigger on an event creating an attendance
		{
			InTrigger = true;
			activeFunction = new AttendancesTriggerClass();
			activeFunction.MainEntry (TriggerObject, isBefore, isDelete, isAfter, isInsert, isUpdate, isExecuting, newList, newMap, oldList, oldMap);
			InTrigger = false;
		}
		else if (TriggerObject == 'Enrolment')
		{
			InTrigger = true;
			activeFunction = new EnrolmentsTriggerClass();
			activeFunction.MainEntry (TriggerObject, isBefore, isDelete, isAfter, isInsert, isUpdate, isExecuting, newList, newMap, oldList, oldMap);
			InTrigger = false;
		}
		else if (TriggerObject == 'HRB Form')
		{
			InTrigger = true;
			activeFunction = new HRBFormsTriggerClass();
			activeFunction.MainEntry (TriggerObject, isBefore, isDelete, isAfter, isInsert, isUpdate, isExecuting, newList, newMap, oldList, oldMap);
			InTrigger = false;
		}
		else if (TriggerObject == 'Needle Exchange')
		{
			InTrigger = true;
			activeFunction = new NeedlesExchangeTriggerClass();
			activeFunction.MainEntry (TriggerObject, isBefore, isDelete, isAfter, isInsert, isUpdate, isExecuting, newList, newMap, oldList, oldMap);
			InTrigger = false;
		}
	}
}