/*
	Author: Eamon Kelly, Enclude
	Purpose: List all the clients who were due to attend a session so that they can be marked as attended and comments added. 
	Security note: This class is global so that it can be used in customisations for the client
	Called from: ProgramSessionAttendancePage
	This version uses profiles control the fields that are displayed in the ProgramSessionAttendancePage
	Test notes: This class is tested in testCreateAttendanceTrigger 
	
	27/1/2014 - adding CRUD support
	20/11/2014 - adding Status field to list of fields retrieved (MK)
	02/03/2016 - Allowing fields to be selected using a field set - other than the standard fields to avoid problems with existing installations
*/
global with sharing class ProgramAttendanceListView 
{
	global List<Schema.FieldSetMember> extraAttendanceFields {get;set;}
	private Program_Session__c session = null;
	private Attendance__c [] attendances = null;
	global Boolean userCanUpdate {get;set;}
	
	global ProgramAttendanceListView (ApexPages.StandardController controller)
	{
		session = (Program_Session__c)controller.getRecord();
		Initialise ();
	}
	
    global ProgramAttendanceListView (Program_Session__c sess)
    {
    	session = sess;
	  	Initialise ();
    }
    
    private void Initialise ()
    {
    	userCanUpdate = Schema.sObjectType.Attendance__c.isUpdateable();
	   	extraAttendanceFields = getFields (Schema.SObjectType.Attendance__c.fieldSets.getMap().get(AppConfigSupport.PackagePrefix+'ExtraFields'));
		attendances = database.query (getSelectStatement (extraAttendanceFields));
    }
    
    global Attendance__c [] getAttendanceList ()
    {
    	return attendances;
    }
    
    global PageReference submit ()
    {
    	update attendances;
    	String theId = ApexPages.currentPage().getParameters().get('id');
 
    	// Redirect the user back to the original page
        PageReference pageRef = new PageReference('/' + theId);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    private List<Schema.FieldSetMember> getFields(Schema.FieldSet fs1) 
    {
        if (fs1 == null)
        {
            system.debug ('No fieldset found for ' + fs1); // may not be an issue
            return new list <Schema.FieldSetMember> ();
        } 
        
        List<Schema.FieldSetMember> allFields = fs1.getFields();
        List<Schema.FieldSetMember> returnFields = new List<Schema.FieldSetMember>();
        
        for (Integer i=0; i<allFields.size(); i++)
        {
            returnFields.add (allFields[i]);            
        }
        return returnFields;
    }
    
    private String getSelectStatement (List<Schema.FieldSetMember> fieldList)
    {
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : fieldList) 
        {
            query += f.getFieldPath() + ', ';
        }
        query += 'Name, id, Young_Person_Name__c, young_person__c, attended__c, Status__c, Interaction__c,comment__c, Duration_in_minutes__c from Attendance__c where Program_Session__c = \'' + session.id + '\'';        
		system.debug ('Query is: ' + query);
        return query;
    }
    
}