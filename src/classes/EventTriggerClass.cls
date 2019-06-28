/*
    Author: Eamon Kelly, Enclude
    Purpose: When an event is created that is related to a client, create a corresponding one to one attendance
    Note: if the event is already linked to another object, don't break that link by changing WhatID
    In Summer 2014 we might get the ability to add lookup fields to activities, then we can have one dedicated to attendances
    In the meantime use a hyperlink - 23/4/2014 - Related_Attendance__c
    17/7/2014 using a field set to copy user defined fields from the event to the attendance - the names of the fields must match exactly (including any package prefix)    
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
        set <id>contactsSet = new set <id>(); 
        for (Event oneEvent: evtList)
        {
            contactsSet.add (oneEvent.WhoId);
        }
        map <Id, Contact> clients = new map <Id, Contact>([select Id, Name, Initials__c from Contact where RecordType.DeveloperName = 'Client' and Id in :contactsSet]);
        
        // now create the attendances
        Id one2oneAttendanceRecordTypeID = [select Id from RecordType where DeveloperName='One_to_One_Attendance' limit 1].Id;
        for (Event oneEvent: evtList)
        {
            system.debug ('Event: ' + oneEvent);
            if (oneEvent.IsRecurrence == false && oneEvent.WhoId != null) // looks like if IsRecurrence is true then recurring events will be generated with this as false, otherwise get an extra attendance
            {
                Contact thisClient = clients.get (oneEvent.WhoId);
                if (thisClient != null)
                {
                    String attendanceName = AttendancesTriggerClass.newAttendanceName (oneEvent.ActivityDateTime.Date(), thisClient.Name, thisClient.Initials__c);
                    
                    Attendance__c one2one = new Attendance__c (Name=attendanceName, Young_Person__c = thisClient.id, Duration_in_minutes__c = oneEvent.DurationInMinutes, Reason_for_Attending__c=oneEvent.Subject, Date_and_time_of_attendance__c=oneEvent.ActivityDateTime, Put_in_my_calendar__c=false, RecordTypeId=one2oneAttendanceRecordTypeID);
                    one2one.Programme__c = oneEvent.Programme__c;
                    one2one.Activity_Type__c = oneEvent.Activity_Type__c;
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
                        try
                        {
                            oneEvent.Related_Attendance_ID__c = attendancesToCreate[attendanceNumber].Id;
                            oneEvent.Related_Attendance_Name__c = attendancesToCreate[attendanceNumber].Name;
                            CopyFieldsFromEventToAttendance (oneEvent, attendancesToCreate[attendanceNumber]);
                       }
                        catch (Exception e)
                        {
                            // ignore failures
                        }
                        attendanceNumber++;
                    }
                }
            }
            update attendancesToCreate;
        }
    }
    
    // if the attendance is linked to an event and the status of the event has changed, update the status of the attendance
    public void UpdateAttendances (List<Event> evtList, Map<Id, sObject>oldMap)
    {
        list<Attendance__c> attendancesToUpdate = new list <Attendance__c>();
        
        set <id>attendanceSet = new set <id>(); 
        for (Event oneEvent: evtList)
        {
            if (oneEvent.Related_Attendance_ID__c != null && oneEvent.Status__c != ((Event)oldMap.get(oneEvent.id)).Status__c)
            {
                attendanceSet.add (oneEvent.Related_Attendance_ID__c);
            }
        }
        
        map <Id, Attendance__c> attendances = new map <Id, Attendance__c>([select Id, Status__c from Attendance__c where Id in :attendanceSet]);        
        
        // now update the attendances
        for (Event oneEvent: evtList)
        {
            if (attendances.containsKey (oneEvent.Related_Attendance_ID__c))
            {
                Attendance__c relatedAttendance = attendances.get (oneEvent.Related_Attendance_ID__c);
                CopyFieldsFromEventToAttendance (oneEvent, relatedAttendance);
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
//        if (clientsCarePlanObjectives.size()>0) update clientsCarePlanObjectives.values(); -- EK 27/09/2018 I can't see the point in this line and it is causing an exception if the user only has read access to the objective
    }
    
    public void CopyFieldsFromEventToAttendance (Event oneEvent, Attendance__c oneAttendance)
    // the field name must match exactly between the event and the attendance
    {
        Schema.fieldset fs1 = Schema.SObjectType.Event.fieldSets.getMap().get(AppConfigSupport.PackagePrefix+'Fields_to_copy_to_attendances');
        if (fs1 == null) return; // field set not available
        
        List<Schema.FieldSetMember> allFields = fs1.getFields();                   // 1. Gather all fields interested into list.
        for(Schema.FieldSetMember oneField: allFields)                             // 2. Loop through all fields in list
        {
            String fieldName = oneField.getFieldPath();
            Schema.DisplayType fieldType = oneField.getType();
            
            try
            {
                if (fieldType == DisplayType.Date)
                {
                   if (isValidDate((Date)(oneEvent.get(fieldName))))  
                   {
                       oneAttendance.put(fieldName, (Date)(oneEvent.get(fieldName)));     
                   }   
                }
                else if (fieldType == DisplayType.Double || fieldType == DisplayType.Currency) 
                {
                    if (isValidDecimal((Decimal)(oneEvent.get(fieldName))))
                    {
                        oneAttendance.put(fieldName, (Decimal)(oneEvent.get(fieldName)));
                    }
                }
                else if (fieldType == DisplayType.Boolean)
                {
                    if((Boolean)(oneEvent.get(fieldName))== true)
                    {
                        oneAttendance.put(fieldName, true);
                    }
                }
                else if (fieldType == DisplayType.Datetime) 
                {
                    if(isValidDatetime((Datetime)(oneEvent.get(fieldName))))
                    {  
                        oneAttendance.put(fieldName, (Datetime)(oneEvent.get(fieldName)));                                                     
                    }    
                }                                                                                                       
                else 
                {
                     if(isValid ((String)(oneEvent.get(fieldName)))) 
                     {
                        oneAttendance.put(fieldName, (String)(oneEvent.get(fieldName)));
                     }   
                }
            }
            catch (Exception e)
            {
                system.debug ('Error in fieldName ' + fieldName + ' while iterating through field set: ' + e.getMessage());
                oneEvent.addError ('Error in fieldName ' + fieldName + ' while iterating through field set: ' + e.getMessage());
            }
        }
    }
    
    // VALIDATION METHODS: For all data types of fields used in fieldset
    
    public static boolean isValid (String text)                 // String is a catch-all, including address fields.
    {
        if (text <> null && text <> '' && text <> '[not provided]') return true;
        else return false;
    }
    public static boolean isValidDecimal (Decimal text)         // Checkboxes Boolean 
    {
        if (text <> null) return true;
        else return false;
    }
    public static boolean isValidDate (Date text)   
    {
        if (text <> null) return true;
        else return false;
    }    
    public static boolean isValidDatetime (Datetime text)       // Date/Time - Check
    {
        if (text <> null) return true;
        else return false;
    }
}