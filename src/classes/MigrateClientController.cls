/*
	Author: Eamon Kelly, Enclude
	Purpose: Move values in the client from HRB pre 2016 to NDTRS 2016 value
*/
public with sharing class MigrateClientController {
	Contact client;
    public MigrateClientController(ApexPages.StandardController controller) {
        client = (Contact)controller.getRecord();
    }
    public void DoMigration (){
    	if (client.X4_Gender__c == 'Male'){
    		client.X4_Gender__c = '1. Male';
    	} else if (client.X4_Gender__c == 'Female'){
    		client.X4_Gender__c = '2. Female';
    	}
		client.X5_Living_with_whom__c = client.X7a_Living_with_whom__c;
		if (client.X7b_Livin_Where__c == '2. Institution(prison/residential care/halfway house)'){
			client.X7_Living_Where__c = '1. Stable Accommodation';
		} else {
			client.X7_Living_Where__c = client.X7b_Livin_Where__c;
		}
		if (client.X12b_Education_highest_level__c == '6. Special needs education' || client.X12b_Education_highest_level__c == '8. Still in education' || client.X12b_Education_highest_level__c == null || client.X12b_Education_highest_level__c == ''){
			client.X9a_Education_highest_level__c = '9. Not known';
		} else {
			client.X9a_Education_highest_level__c = client.X12b_Education_highest_level__c;
		}
		client.X9b_Age_left_primary_school__c = client.X12a_Age_left_primary_school__c;
		if (client.X11_Employement_Status__c == '3. Fas/training course'){
			client.X10_Employement_Status__c = '3. Training course';
		} else {
			client.X10_Employement_Status__c = client.X11_Employement_Status__c; 
		}
		client.X10_8_Specify_other_employment_status__c = client.X11_Employement_Status_other__c;
		client.X11b_Ethnic_cultural_background__c = client.X10b_Ethnic_Background__c;

    	List<Schema.FieldSetMember> fieldsToZero = SObjectType.Contact.FieldSets.Fields_to_initialise_during_migration.getFields();
		for(Schema.FieldSetMember f : fieldsToZero) {
            client.put(f.getFieldPath(),0);
	    }
    }
    public pageReference ConfirmChanges (){
    	ID ndtrsClientID = [select id from RecordType where sObjectType='Contact' and DeveloperName='NDTRS_Client'].id;
    	client.RecordTypeID = ndtrsClientID; 
	    update client;
		return new PageReference ('/' + client.id);    	
    }
}