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
        	if (isBefore)
        	{
        		CalculateMaxInterventionCommencementDate (newList);
        		CountNumberOfFormsStartedThisYear (newList);
        	}
            else if (isAfter) 
            {
            	ChangeName ((map<Id, HRB_Form__c>)newMap);
            	CountNumber (newList);
            }
        }
        else if (isUpdate)
        {
        	if (isBefore) CalculateMaxInterventionCommencementDate (newList);
        	else if (isAfter) CountNumber (newList);
        }
        else if (isDelete)
        {
            if (isAfter) CountNumber (oldList);
        }
    }

	public void ChangeName (map<Id, HRB_Form__c> frmMap)
	{
		String nameTemplate = AppConfigSupport.HRBFormNameTemplate;
		list<HRB_Form__c>fromsToUpdate = new list<HRB_Form__c>();
		for (HRB_Form__c oneForm: [select ID, Name, Contact__c, Contact__r.Name, Contact__r.Initials__c, X16_Date_of_Assessment__c from HRB_Form__c where ID in :frmMap.keySet()])
		{
			Date formDate = oneForm.X16_Date_of_Assessment__c != null ? oneForm.X16_Date_of_Assessment__c : system.today();
			String clientName = oneForm.Contact__c != null ? oneForm.Contact__r.Name : '';
			String clientInitials = oneForm.Contact__c != null ? oneForm.Contact__r.Initials__c : '';
			String newName;
			newName = nameTemplate.replace('$NAME$', clientName).replace('$DATE$', formDate.format()).replace('$INITIALS$', clientInitials);
			if (newName != oneForm.Name) 
			{
				oneForm.Name = newName;
				fromsToUpdate.add (oneForm);
			}
		}
		if (fromsToUpdate.size() > 0) update fromsToUpdate;
	}

// this needs to go into eCASSV1
  	public void CountNumberOfFormsStartedThisYear (List<HRB_Form__c> frmList)
 	{
 		set<ID> clientSet = new set<ID>();
 		for (HRB_Form__c oneForm: frmList)
 		{
 			clientSet.add (oneForm.Contact__c);
 		}
 		Integer this_year = system.today().year();
 		map <ID, Contact> clients = new map <ID, Contact>([SELECT ID, (SELECT Id FROM HRB_Forms__r where CALENDAR_YEAR(X16_Date_of_Assessment__c) = :this_year) FROM Contact where ID in :clientSet]);
 		
 		for (HRB_Form__c oneForm: frmList)
 		{
 			oneForm.X20_Number_times_started_this_year__c = clients.get(oneForm.Contact__c).HRB_Forms__r.size() + 1;
 		}
 		
 	}
 	
	public void CalculateMaxInterventionCommencementDate (List<HRB_Form__c> newList)
	{
        for (HRB_Form__c oneForm: newList)
        {
        	oneForm.Date_latest_intervention_commenced__c = Date.valueOf('2011-1-1');
        	if (oneForm.X33b1_Date_Commenced__c > oneForm.Date_latest_intervention_commenced__c) oneForm.Date_latest_intervention_commenced__c = oneForm.X33b1_Date_Commenced__c;
         	if (oneForm.X33b12_Date_Commenced__c > oneForm.Date_latest_intervention_commenced__c) oneForm.Date_latest_intervention_commenced__c = oneForm.X33b12_Date_Commenced__c;
        	if (oneForm.X33b13_Date_Commenced__c > oneForm.Date_latest_intervention_commenced__c) oneForm.Date_latest_intervention_commenced__c = oneForm.X33b13_Date_Commenced__c;
        	if (oneForm.X33b14_Date_Commenced__c > oneForm.Date_latest_intervention_commenced__c) oneForm.Date_latest_intervention_commenced__c = oneForm.X33b14_Date_Commenced__c;
        	if (oneForm.X33b15_Date_Commenced__c > oneForm.Date_latest_intervention_commenced__c) oneForm.Date_latest_intervention_commenced__c = oneForm.X33b15_Date_Commenced__c;
        	if (oneForm.X33b16_Date_Commenced__c > oneForm.Date_latest_intervention_commenced__c) oneForm.Date_latest_intervention_commenced__c = oneForm.X33b16_Date_Commenced__c;
        	if (oneForm.X33b17_Date_Commenced__c > oneForm.Date_latest_intervention_commenced__c) oneForm.Date_latest_intervention_commenced__c = oneForm.X33b17_Date_Commenced__c;
        	if (oneForm.X33b18_Date_Commenced__c > oneForm.Date_latest_intervention_commenced__c) oneForm.Date_latest_intervention_commenced__c = oneForm.X33b18_Date_Commenced__c;
        	if (oneForm.X33b19_Date_Commenced__c > oneForm.Date_latest_intervention_commenced__c) oneForm.Date_latest_intervention_commenced__c = oneForm.X33b19_Date_Commenced__c;
        	if (oneForm.X33b20_Date_Commenced__c > oneForm.Date_latest_intervention_commenced__c) oneForm.Date_latest_intervention_commenced__c = oneForm.X33b20_Date_Commenced__c;
        	if (oneForm.X33b21_Date_Commenced__c > oneForm.Date_latest_intervention_commenced__c) oneForm.Date_latest_intervention_commenced__c = oneForm.X33b21_Date_Commenced__c;
        	if (oneForm.X33b23_Date_Commenced__c > oneForm.Date_latest_intervention_commenced__c) oneForm.Date_latest_intervention_commenced__c = oneForm.X33b23_Date_Commenced__c;
        }
	}
	
	// not sure this is required any more
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