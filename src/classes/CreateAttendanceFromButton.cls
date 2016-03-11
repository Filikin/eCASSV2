/*
	Author: Eamon Kelly, Enclude
	Purpose: Button is pressed, it will launch the visualforce page "CreateXXXAttendance" where X is one of the 
		Attendance Record Types
		The new attenance page will be launched with the appropriate record type
	Tested: 
*/
public with sharing class CreateAttendanceFromButton 
{
	Id objectID;
	public CreateAttendanceFromButton (ApexPages.StandardController controller)
    {
        objectID = controller.getRecord().Id;
    }
    
	public PageReference CreateOneToOneAttendance ()
	{
		Contact client = [select ID, Name from Contact where ID=:objectID];
		Id one2oneAttendanceRecordTypeID = [select Id from RecordType where DeveloperName='One_to_One_Attendance' limit 1].Id;
		
		PageReference pageRef = new PageReference('/a02/e?CF00Nb0000007lEj8=' + client.Name + '&CF00Nb0000007lEj8_lkid=' + client.Id + '&retURL=' + client.Id + '&RecordType=' + one2oneAttendanceRecordTypeID);
        pageRef.setRedirect(true);
        return pageRef;
	} 

	public PageReference CreateOpenAccessAttendance ()
	{
		Contact client = [select ID, Name from Contact where ID=:objectID];
		Id openAccessAttendanceRecordTypeID = [select Id from RecordType where DeveloperName='Open_Access_Attendance' limit 1].Id;
		
		PageReference pageRef = new PageReference('/a02/e?CF00Nb0000007lEj8=' + client.Name + '&CF00Nb0000007lEj8_lkid=' + client.Id + '&retURL=' + client.Id + '&RecordType=' + openAccessAttendanceRecordTypeID);
        pageRef.setRedirect(true);
        return pageRef;
	} 
	
	public PageReference CreateDropInAttendance ()
	{
		Drop_in__c dropin = [select ID, Name from Drop_in__c where ID=:objectID];
		Id dropInAttendanceRecordTypeID = [select Id from RecordType where DeveloperName='Drop_In_Attendance' limit 1].Id;
		
		PageReference pageRef = new PageReference('/a02/e?CF00Nb0000007nMCC=' + dropin.Name + '&CF00Nb0000007nMCC_lkid=' + dropin.Id + '&retURL=' + dropin.Id + '&RecordType=' + dropInAttendanceRecordTypeID);
        pageRef.setRedirect(true);
        return pageRef;
	}
}