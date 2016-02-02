@isTest
private class TestCreateAttendanceFromButton {

    static testMethod void testContactButtons() 
    {
	   	Id clientRecordTypeID = [SELECT ID FROM RecordType WHERE SobjectType='Contact' and DeveloperName='Client' limit 1].id;
    	Contact youngPerson = new Contact (LastName = 'Kelly', RecordTypeID=clientRecordTypeID);
    	insert youngPerson;
    	
    	ApexPages.StandardController clientController = new ApexPages.StandardController(youngPerson);
        CreateAttendanceFromButton buttonController = new CreateAttendanceFromButton (clientController);

        PageReference returnUrl = buttonController.CreateOneToOneAttendance();
        system.assert (returnUrl.getUrl().contains (youngPerson.id));
    	
        PageReference returnUrl2 = buttonController.CreateOpenAccessAttendance();
        system.assert (returnUrl2.getUrl().contains (youngPerson.id));
    }

    static testMethod void testDropInButton() 
    {
    	Drop_in__c dropIn = new Drop_in__c (Name='Test DropIn');
    	insert dropIn;
    	
    	ApexPages.StandardController dropInController = new ApexPages.StandardController(dropIn);
        CreateAttendanceFromButton buttonController = new CreateAttendanceFromButton (dropInController);

        PageReference returnUrl = buttonController.CreateDropInAttendance();
        system.assert (returnUrl.getUrl().contains (dropIn.id));
    }
}