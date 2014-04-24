@isTest
private class testCreateReferralTrigger {

    static testMethod void testAutoNamingOfReferral()
    {
        Contact youngPerson = new Contact (LastName = 'Kelly');
        insert youngPerson;
        Contact youngPerson2 = new Contact (LastName = 'Smith');
        insert youngPerson2;
 		Referral__c ref = new Referral__c (Client__c = youngPerson.id, Date_of_Referral__c=system.today(), Name='x');
 		insert ref;
 		ref = [select Name from Referral__c where ID=:ref.id];
 		system.assert (ref.Name.Contains ('Kelly'));
 	}
}