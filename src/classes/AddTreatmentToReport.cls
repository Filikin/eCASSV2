/*
	Author: Eamon Kelly, Enclude
	Purpose: Test the treatments to make sure they pass the validation rules by adding a pointer to the HRB Report object
	Called from: AddTreatmentToReport page which is called from a button on the HRB Report page
	Tested in: TestAddTreatmentToReport

	EK 22/09/2015 To avoid XSRF issues, the list of treatments to be added is displayed first and then added to the report when a button is clicked
	EK 29/01/2016 Changing to update the treatments all in one go (needed for end of year)
	EK 9/11/2016 changing to use Q21a Date this treatment started instead of Q16 Date of assessment as the criteria to select the forms
*/
public with sharing class AddTreatmentToReport 
{
	public class TreatmentMessages
	{
		public ID treatmentID {get;set;}
		public String errorMsg {get;set;}
		public TreatmentMessages (HRB_Form__c treat, String msg)
		{
			treatmentID = treat.Id;
			errorMsg = msg;
		}	
	}
	
    public HRB_Form__c[] TreatmentsWithClientsList {get;Set;} // these are the HRB forms
    public HRB_Report__c reportParams {get;set;} // this will be the object with the date range (last year, q1 etc)
	public list<TreatmentMessages> passed {get;set;}
	public list<TreatmentMessages> failed {get; set;}
	public Integer TreatmentsListSize {get;set;}
	public Integer TreatmentsToProcess {get;set;}
	public Boolean showResults {get; Set;}
	
	public AddTreatmentToReport (ApexPages.StandardController controller)
	{
		showResults = false;
		passed = new list<TreatmentMessages>();
		failed = new list<TreatmentMessages>();
		this.reportParams = (HRB_Report__c)controller.getRecord();
	}
	
	public void Initialise ()
	{
		reportParams = [select id, Name, Period__c, Year__c, Type_of_report__c from HRB_Report__c where id = :reportParams.id];
        Integer year = reportParams.Year__c.intValue();
        String startMonthDay = '-01-01';
        String endMonthDay = '-12-31';
        if (reportParams.Period__c == 'Quarter 1')
        {
            endMonthDay = '-03-31';
        }
        else if (reportParams.Period__c == 'Quarter 2')
        {
            startMonthDay = '-04-01';
            endMonthDay = '-06-30';
        }
        else if (reportParams.Period__c == 'Quarter 3')
        {
            startMonthDay = '-07-01';
            endMonthDay = '-09-30';
        }
        else if (reportParams.Period__c == 'Quarter 4')
        {
            startMonthDay = '-10-01';
        }
        String startReportPeriod = String.valueOf(year) + startMonthDay;
        String endReportPeriod = String.valueOf(year) + endMonthDay;
 
 		String queryString = 'select id, Name, Contact__c, X16_Date_of_Assessment__c, X21a_Date_This_treatment_started__c, HRB_Report__c, Contact_Record_Valid__c, Main_Intervention_Valid__c, Drug_Validation__c, Treatment_Type_Check__c from HRB_Form__c where HRB_Report__c != \'' + reportParams.Id + '\' and ';
 		
 		 if (reportParams.Type_of_report__c == 'Clients who entered during the report period') 
         {
            queryString += 'X21a_Date_This_treatment_started__c >= ' + startReportPeriod + ' and X21a_Date_This_treatment_started__c <= ' + endReportPeriod;
         }
         else
         {
            queryString += 'ExitDate__c >= ' + startReportPeriod + ' and ExitDate__c <= ' + endReportPeriod + ' and X21a_Date_This_treatment_started__c < ' + startReportPeriod;
         }
         
         TreatmentsWithClientsList = Database.query(queryString);
         TreatmentsListSize = TreatmentsWithClientsList.size();
         TreatmentsToProcess = math.min (TreatmentsListSize, Limits.getLimitDmlRows());
         if (TreatmentsToProcess < TreatmentsListSize)
         {
         	queryString += ' limit ' + TreatmentsToProcess;
         	TreatmentsWithClientsList = Database.query(queryString);
         }
         system.debug ('Number of possible treatments: ' + TreatmentsWithClientsList.size());
     }

	 public void ProcessTreatments ()
	 {
         list<HRB_Form__c> TreatmentsToUpdate = new list<HRB_Form__c>(); // these are the HRB forms
         for (HRB_Form__c oneTreatment: TreatmentsWithClientsList)
         {
         	system.debug ('Treatment limits rows: ' + Limits.getLimitDmlRows() + ' queries: ' + Limits.getLimitQueries());
			if (oneTreatment.Contact_Record_Valid__c != 'HRB OK') 
			{
				failed.add (new TreatmentMessages(oneTreatment, oneTreatment.name + ' Failed because client record error: ' + oneTreatment.Contact_Record_Valid__c));
			}
			else if (oneTreatment.Main_Intervention_Valid__c != 'HRB OK')
			{
				failed.add (new TreatmentMessages(oneTreatment, oneTreatment.name + ' Failed because: ' + oneTreatment.Main_Intervention_Valid__c));
			}
			else if (oneTreatment.Treatment_Type_Check__c != 'HRB OK')
			{
				failed.add (new TreatmentMessages(oneTreatment, oneTreatment.name + ' Failed because: ' + oneTreatment.Main_Intervention_Valid__c));
			}
			else if (oneTreatment.Drug_Validation__c != 'HRB OK')
			{
				failed.add (new TreatmentMessages(oneTreatment, oneTreatment.name + ' Failed because: ' + oneTreatment.Main_Intervention_Valid__c));
			}
			else
			{
				oneTreatment.HRB_Report__c = reportParams.id;
				try
				{
	 				TreatmentsToUpdate.add (oneTreatment);
		            passed.add (new TreatmentMessages(oneTreatment, oneTreatment.name + ' Attached'));
		            system.debug ('Treatment added ' + oneTreatment.name);
				}
			    catch (Exception e)
			    {
			    	system.debug ('Treatment failed ' + e.getMessage());
			    	string errorMsg = e.getMessage().subString (e.getMessage().indexOf ('first error:'));
			       	failed.add (new TreatmentMessages(oneTreatment, oneTreatment.name + ' Failed ' + errorMsg));
			    }
			}
         }
         if (TreatmentsToUpdate.size() > 0) update TreatmentsToUpdate;
		 showResults = true;
	}
}