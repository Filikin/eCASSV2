/*
	Author: Eamon Kelly, Enclude
	Author: Pedro Gonzalez, Enclude
	Purpose: Extract the fields for upload to HRB Link. 
	Security note: In practice only the administrator will have access to the NDTRS_2016_Treatment_Report page
	Called from: NDTRS_2016_Treatment_Report
	Tested in: TestNDTRSReports
*/
public with sharing class NDTRS2016ReportController 
{
    private NDTRS_Form_2016__c[] TreatmentsWithClientsList; // these are the NDTRS treatment forms
    private NDTRS_2016_Report__c reportParams; // this will be the object with the date range 
 	private static List<Schema.FieldSetMember> treatmentFieldsSectionsEtoG = new List<Schema.FieldSetMember>();
 	private static List<Schema.FieldSetMember> treatmentFieldsSectionH = new List<Schema.FieldSetMember>();
    
    public list<treatmentWrapper> treatmentWrappers {get;set;}
    public class treatmentWrapper
    {
    	public NDTRS_Form_2016__c treat {get;set;}
    	public treatmentWrapper (NDTRS_Form_2016__c oneTreatment)
    	{
    		treat = oneTreatment;
    	}
    	public string getFieldsSectionsEtoG ()
    	{
    		return getFields (NDTRS2016ReportController.treatmentFieldsSectionsEtoG);
    	}	
    	
    	public string getFieldsSectionH ()
    	{
    		return getFields (NDTRS2016ReportController.treatmentFieldsSectionH);
    	}	

    	private String getFields (list<Schema.FieldSetMember> fieldSet)
    	{
    		String fieldValues = '';
    		for (Schema.FieldSetMember oneField : fieldSet)
    		{
    			Schema.DisplayType fieldType = oneField.getType();
    			system.debug ('FieldType is: ' + fieldType);
    			system.debug ('Value is: ' + treat.get(oneField.getFieldPath()));
    			
				if (fieldType == DisplayType.Date)
                {
	    			if (treat.get(oneField.getFieldPath()) == null) fieldValues += ',';
	    			else fieldValues += ','+ ((Date)treat.get(oneField.getFieldPath())).format();
                }
                else if (fieldType == DisplayType.Double || fieldType == DisplayType.Integer) 
                {
                	if (treat.get(oneField.getFieldPath()) == null) fieldValues += ',0';
	    			else fieldValues += ','+ treat.get(oneField.getFieldPath());
                }
                else if (fieldType == DisplayType.Boolean)
                {
                    if((Boolean)(treat.get(oneField.getFieldPath()))== true) fieldValues += ',1';  
					else fieldValues += ',0';
                }    			
    			else
    			{
                	if (treat.get(oneField.getFieldPath()) == null) fieldValues += ',0';
    				else fieldValues += ','+ treat.get(oneField.getFieldPath());
    			}
    		}
    		return fieldValues;
    	}
    }
    
    public NDTRS2016ReportController (ApexPages.StandardController controller)
    {
        this.reportParams = (NDTRS_2016_Report__c)controller.getRecord();
        Initialise ();
        treatmentFieldsSectionsEtoG = ReadFieldList ('ReportFieldsSectionsEtoG');
        treatmentFieldsSectionH = ReadFieldList ('ReportFieldsSectionH');
    }
    
    private void Initialise ()
    {
        reportParams = [select id, From_Assessment_Date__c, To_Assessment_Date__c from NDTRS_2016_Report__c where id = :reportParams.id];
        
        String queryString = 'select ';
        queryString += NDTRSHelperFunctions.GetAllFieldsFromNDTRSForm ();
        queryString += NDTRSHelperFunctions.GetAllFieldsFromClient ();
        queryString += ', X21a_Main_drug__r.Item_Code__c, X22a_Drug_2__r.Item_Code__c, X23a_Drug_3__r.Item_Code__c, X24a_Drug_4__r.Item_Code__c, X25a_Drug_5__r.Item_Code__c';
        queryString += ', X13_2_Drug_specify__r.Item_Code__c';
        queryString += ' from NDTRS_Form_2016__c where NDTRS_2016_Report__c = \'' + reportParams.Id + '\'';
        System.Debug (queryString);
        TreatmentsWithClientsList = Database.query(queryString);
        
        treatmentWrappers = new list<treatmentWrapper>();
        for (NDTRS_Form_2016__c oneTreatment : TreatmentsWithClientsList)
        {
        	treatmentWrappers.add (new treatmentWrapper(oneTreatment));
        }
    }

    
    public NDTRS_Form_2016__c[] getTreatmentsWithClients()
    {
        return TreatmentsWithClientsList;
    }
    
    private list<Schema.FieldSetMember>	ReadFieldList (String fieldSetName)
    {
    	Schema.FieldSet fs1 = Schema.SObjectType.NDTRS_Form_2016__c.fieldSets.getMap().get(fieldSetName);
    	return fs1.getFields();
    }
}