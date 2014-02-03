/*
    Author: Eamon Kelly, Enclude
    Purpose: Need to act as a rollup on the treatment to the contact to count number of HRB Forms 
    Called from: TriggerDispatcher
*/
public with sharing class HRBFormsTriggerClass implements TriggerDispatcher.ITriggerEntry
{

    public void MainEntry (String TriggerObject, Boolean isBefore, Boolean isDelete, Boolean isAfter, Boolean isInsert, Boolean isUpdate, Boolean isExecuting,
        List<SObject> newList, Map<Id, SObject> newMap, List<SObject> oldList, Map<Id, SObject> oldMap)
    {
        if (isInsert)
        {
            if (isAfter) CountNumber (newList);
        }
        else if (isUpdate)
        {
            if (isAfter) CountNumber (newList);
        }
        else if (isDelete)
        {
            if (isAfter) CountNumber (oldList);
        }
    }

    public void CountNumber (List<HRB_Form__c> attList)
    {
        set<id>clients = new set<id>();
        for (HRB_Form__c oneAtt: attList)
        {
            clients.add (oneAtt.Contact__c);
        }
        // need to count all the attendances on these sessions
        list<Contact> contacts = [SELECT Number_of_completed_Treatments__c, (SELECT Id FROM HRB_Forms__r where not(X37_Date_of_Final_Discharge__c = null)) FROM Contact where ID in :clients];
        for (Contact oneClient: contacts)
        {
            oneClient.Number_of_completed_Treatments__c = oneClient.HRB_Forms__r.size();
        }       
        update contacts;
    }
}