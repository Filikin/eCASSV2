/*
	Author: Eamon Kelly, Enclude
	Purpose: Provide centralised access to the custom settings and make a copy available in test
	Copied from Advanced Apex Programming by Dan Appleman
*/
public with sharing class AppConfigSupport {
	private static eCASS_settings__c testconfig = null;
	
	public static eCASS_settings__c GeteCASSSettings()
	{
		if(Test.isRunningTest() && testconfig!=null) return testconfig;
		
		eCASS_settings__c theobject = eCASS_settings__c.getOrgDefaults();
		if(theobject==null || Test.isRunningTest()) 
		{
			theobject = new eCASS_settings__c();
			theobject.name = 'default';
			if(!Test.isRunningTest()) Database.Insert(theobject);
			else // set default test values (can be different from default values) 
			{
				theobject.Attendance_Name_Template__c = 'Att-$NAME$-$DATE$';
				theobject.Care_Plan_Overview_Print_Page__c = 'CarePlanOverviewPrint';
				theobject.Care_Plan_Print_Page__c = 'CarePlanPrintPage';
				theobject.Create_past_attendances__c = false;
				theobject.Default_attendance_duration__c = 60;
				theobject.Disable_Triggers__c = false;
				theobject.Enrolment_Name_Template__c = 'Enr-$NAME$-$DATE$';
				theobject.HRB_Form_Name_Template__c = 'HRB-$NAME$-$DATE$';
				theobject.Organisation_Name__c = 'Test';
				theobject.Rules_on__c = true;
				testconfig = theobject;
			}
		}
		return theobject;
	}

	public static String AttendanceNameTemplate
	{
		get
		{
			return GeteCASSSettings().Attendance_Name_Template__c;
		}
	}
	
	public static String EnrolmentNameTemplate
	{
		get
		{
			return GeteCASSSettings().Enrolment_Name_Template__c;
		}
	}
	
	public static String HRBFormNameTemplate
	{
		get
		{
			return GeteCASSSettings().HRB_Form_Name_Template__c;
		}
	}
	
	public static String CarePlanPrintPage
	{
		get
		{
			return GeteCASSSettings().Care_Plan_Print_Page__c;
		}
	}
	
	public static String CarePlanOverviewPrintPage
	{
		get
		{
			return GeteCASSSettings().Care_Plan_Overview_Print_Page__c;
		}
	}

	public static Boolean CreatePastAttendances
	{
		get
		{
			return GeteCASSSettings().Create_past_attendances__c;
		}
	}
	
	public static Integer DefaultAttendanceDuration
	{
		get
		{
			return (Integer)GeteCASSSettings().Default_attendance_duration__c;
		}
	}
	
	public static Boolean TriggersDisabled
	{
		get
		{
			return GeteCASSSettings().Disable_Triggers__c;
		}
	}
}