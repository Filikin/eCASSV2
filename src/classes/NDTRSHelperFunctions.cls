/*
    Author: Eamon Kelly, Enclude
    Purpose: Some static functions for the NDTRS form and report controllers
        
    Called from: NDTRS_Display_Warnings and NDTRS2016ReportController
    Tested in: TestNDTRSWarnings 
 */
public with sharing class NDTRSHelperFunctions 
{
	public static String GetAllFieldsFromClient ()
	{
		Schema.FieldSet fs1 = Schema.SObjectType.Contact.fieldSets.getMap().get('Fields_for_NDTRS_Report');
		if (fs1 == null)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'No fieldset found on contact called \"Fields_for_NDTRS_Report\"');
            ApexPages.addMessage(myMsg);
            return '';
        } 
        
        String clientFields = '';
        for (Schema.FieldSetMember oneField : fs1.getFields())
        {
           clientFields += 'Contact__r.' + oneField.getFieldPath() + ',';          
        }
        return  clientFields.subString(0,clientFields.length() - 1);
	}
	
	public static String GetAllFieldsFromClientDirect ()
	{
		Schema.FieldSet fs1 = Schema.SObjectType.Contact.fieldSets.getMap().get('Fields_for_NDTRS_Report');
		if (fs1 == null)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'No fieldset found on contact called \"Fields_for_NDTRS_Report\"');
            ApexPages.addMessage(myMsg);
            return '';
        } 
        
        String clientFields = '';
        for (Schema.FieldSetMember oneField : fs1.getFields())
        {
           clientFields += oneField.getFieldPath() + ',';          
        }
        return  clientFields.subString(0,clientFields.length() - 1);
	}
	
    public static String GetAllFieldsFromNDTRSForm ()
    {
    	String allFields = '';
        Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.NDTRS_Form_2016__c.fields.getMap();
        List<Schema.SObjectField> tempFields = fieldMap.values();
        for(Schema.SObjectField sof : tempFields)
        {
        	allFields += sof.getDescribe().getName() + ',';
        } 
        return allFields;
    }
    
}