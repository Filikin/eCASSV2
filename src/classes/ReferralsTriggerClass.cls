/*
	Author: Eamon Kelly, Enclude
	Purpose: Change the name of the referral based on the template
	Tested in testCreateReferralTrigger 
*/
public with sharing class ReferralsTriggerClass implements TriggerDispatcher.ITriggerEntry
{
	public void MainEntry (String TriggerObject, Boolean isBefore, Boolean isDelete, Boolean isAfter, Boolean isInsert, Boolean isUpdate, Boolean isExecuting,
		List<SObject> newList, Map<Id, SObject> newMap, List<SObject> oldList, Map<Id, SObject> oldMap)
	{
		if (isInsert)
		{
			if (isAfter)
			{
				ChangeName ((map<Id, Referral__c>)newMap);
			}
		}
	}

	public void ChangeName (map<Id, Referral__c> refMap)
	{
		String nameTemplate = AppConfigSupport.ReferralNameTemplate;
		list<Referral__c>referralsToUpdate = new list<Referral__c>();
		for (Referral__c oneRef: [select ID, Name, Client__c, Client__r.Name, Client__r.Initials__c, Date_of_Referral__c from Referral__c where ID in :refMap.keySet()])
		{
			Date refDate = oneRef.Date_of_Referral__c != null ? oneRef.Date_of_Referral__c : system.today();
			String clientName = oneRef.Client__c != null ? oneRef.Client__r.Name : '';
			String clientInitials = oneRef.Client__c != null ? oneRef.Client__r.Initials__c : '';
			String newName = nameTemplate.replace('$NAME$', clientName).replace('$DATE$', refDate.format()).replace('$INITIALS$', clientInitials).subString (0, AppConfigSupport.MAX_NAME_SIZE);
			if (newName != oneRef.Name) 
			{
				oneRef.Name = newName;
				referralsToUpdate.add (oneRef);
			}
		}
		if (referralsToUpdate.size() > 0) update referralsToUpdate;
	}
}