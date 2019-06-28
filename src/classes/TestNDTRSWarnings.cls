/*
    Author: Eamon Kelly, Enclude
    Purpose:
        1) Implement validation rules to catch warnings (Errors will be caught on a trigger) 
    Called from: NDTRS_Display_Warnings page launched from button on NDTRS records
 */
@isTest
private class TestNDTRSWarnings
{
	@testSetup static void loadDrugsData ()
	{
    	list<sObject> drugs = test.loadData(NDTRS_Drugs__c.sObjectType, 'NDTRSDrugsTable');
	}
	
    static NDTRS_Form_2016__c createForm (Date referralDate, Date initialAssessmentDate)
    {
        Contact client = new Contact (LastName='Test', X4_Gender__c='1. Male', X9a_Education_highest_level__c = '2. Junior cert', X9b_Age_left_primary_school__c = 17, X10_Employement_Status__c = '1. In paid employment');
        insert client;
        
        NDTRS_Form_2016__c form = new NDTRS_Form_2016__c (Contact__c = client.id, X12_Date_of_Referral__c=referralDate, X13_Main_Reason_for_referral__c = '1. Alcohol',
        X15_Date_of_initial_assessment__c=initialAssessmentDate, X31a_History_of_Hepatitis_C_screening__c = '1. Never tested', X31b_History_of_Hepatitis_B_screening__c = '1. Never tested',
		X31c_History_of_HIV_screening__c = '1. Never tested');
        insert form;    
        return form;
    }

     static testMethod void TestValidationID_6_Between_Assessment_and_Referral() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X21a_Date_This_treatment_started__c = system.today()-80;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_6)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 6 not found in warnings list');
    }

    static testMethod void TestValidationID_6_Between_Assessment_and_Treatment() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-190);
    	oneForm.X21a_Date_This_treatment_started__c = system.today()-80;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_6)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 6 not found in warnings list');
    }

    static testMethod void TestValidationID_17b() 
    {
        NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
        
        Contact client = [select id from Contact where id = :oneForm.Contact__c limit 1];
        client.Birthdate = system.today().addYears (-9);
        update client;
        
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
            if (oneMsg.errorMsg == label.NDTRS_Rule_17b)
            {
                return; // warning found
            }
        }
        system.assert (false, 'Warning for 17b not found in warnings list');
    }
    
    static testMethod void TestValidationID_20() 
    {
        NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
        
        Contact client = [select id from Contact where id = :oneForm.Contact__c limit 1];
        client.X7_Living_Where__c = '5. Prison';
        update client;
        oneForm.Centre__c = '10001 - eCass Training Service 14';
        update oneForm;
        
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
            if (oneMsg.errorMsg == label.NDTRS_Rule_20)
            {
                return; // warning found
            }
        }
        system.assert (false, 'Warning for 20 not found in warnings list');
    }

    static testMethod void TestValidationID_25() 
    {
        NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
        
        Contact client = [select id from Contact where id = :oneForm.Contact__c limit 1];
        client.Birthdate = system.today().addYears (-14);
        client.X6a1_Children_under_5yrs_living_whith__c = 2;
        update client;
        
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
            if (oneMsg.errorMsg == label.NDTRS_Rule_25)
            {
                return; // warning found
            }
        }
        system.assert (false, 'Warning for 25 not found in warnings list');
    }
    
    static testMethod void TestValidationID_26a() 
    {
        NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
        
        Contact client = [select id from Contact where id = :oneForm.Contact__c limit 1];
        client.Birthdate = system.today().addYears (-65);
        client.X6a1_Children_under_5yrs_living_whith__c = 10;
        update client;
        
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
            if (oneMsg.errorMsg == label.NDTRS_Rule_26)
            {
                return; // warning found
            }
        }
        system.assert (false, 'Warning for 26 not found in warnings list');
    }
    
    static testMethod void TestValidationID_26b() 
    {
        NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
        
        Contact client = [select id from Contact where id = :oneForm.Contact__c limit 1];
        client.Birthdate = system.today().addYears (-65);
        client.X6b1_Children_under_5_yrs_living_w_other__c = 2;
        update client;
        
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
            if (oneMsg.errorMsg == label.NDTRS_Rule_26)
            {
                return; // warning found
            }
        }
        system.assert (false, 'Warning for 26 not found in warnings list');
    }
    
    static testMethod void TestValidationID_26c() 
    {
        NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
        
        Contact client = [select id from Contact where id = :oneForm.Contact__c limit 1];
        client.Birthdate = system.today().addYears (-65);
        client.X6c1_Children_under_5yrs_in_care__c = 2;
        update client;
        
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
            if (oneMsg.errorMsg == label.NDTRS_Rule_26)
            {
                return; // warning found
            }
        }
        system.assert (false, 'Warning for 26 not found in warnings list');
    }
    
    static testMethod void TestValidationID_26d() 
    {
        NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
        
        Contact client = [select id from Contact where id = :oneForm.Contact__c limit 1];
        client.Birthdate = system.today().addYears (-65);
        client.X6d1_Children_under_5yrs_living_elsewher__c = 2;
        update client;
        
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
            if (oneMsg.errorMsg == label.NDTRS_Rule_26)
            {
                return; // warning found
            }
        }
        system.assert (false, 'Warning for 26 not found in warnings list');
    }
    
    static testMethod void TestValidationID_26e() 
    {
        NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
        
        Contact client = [select id from Contact where id = :oneForm.Contact__c limit 1];
        client.Birthdate = system.today().addYears (-65);
        client.X6e1_Children_under_5yrs_living_not_know__c = 2;
        update client;
        
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
            if (oneMsg.errorMsg == label.NDTRS_Rule_26)
            {
                return; // warning found
            }
        }
        system.assert (false, 'Warning for 26 not found in warnings list');
    }
    
    static testMethod void TestValidationID_30() 
    {
        NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
        
        Contact client = [select id from Contact where id = :oneForm.Contact__c limit 1];
        client.X9a_Education_highest_level__c = '1. Primary level';
        client.X9b_Age_left_primary_school__c = 5;
        update client;
        
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
            if (oneMsg.errorMsg == label.NDTRS_Rule_30)
            {
                return; // warning found
            }
        }
        system.assert (false, 'Warning for 30 not found in warnings list');
    }
    
    static testMethod void TestValidationID_31() 
    {
        NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
        
        Contact client = [select id from Contact where id = :oneForm.Contact__c limit 1];
        client.Birthdate = system.today().addYears (-25);
        client.X9b_Age_left_primary_school__c = 88;
        update client;
        
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
            if (oneMsg.errorMsg == label.NDTRS_Rule_31)
            {
                return; // warning found
            }
        }
        system.assert (false, 'Warning for 31 not found in warnings list');
    }   
    
    static testMethod void TestValidationID_32() 
    {
        NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
        
        Contact client = [select id from Contact where id = :oneForm.Contact__c limit 1];
        client.X9a_Education_highest_level__c = '5. Never went to school';
        client.X9b_Age_left_primary_school__c = 10;
        update client;
        
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
            if (oneMsg.errorMsg == label.NDTRS_Rule_32)
            {
                return; // warning found
            }
        }
        system.assert (false, 'Warning for 32 not found in warnings list');
    }   
    
    static testMethod void TestValidationID_33() 
    {
        NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
        
        Contact client = [select id from Contact where id = :oneForm.Contact__c limit 1];
        client.X9a_Education_highest_level__c = '3. Leaving Cert';
        client.X9b_Age_left_primary_school__c = 14;
        update client;
        
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
            if (oneMsg.errorMsg == label.NDTRS_Rule_33)
            {
                return; // warning found
            }
        }
        system.assert (false, 'Warning for 33 not found in warnings list');
    }   
    
    static testMethod void TestValidationID_34() 
    {
        NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
        
        Contact client = [select id from Contact where id = :oneForm.Contact__c limit 1];
        client.X9a_Education_highest_level__c = '0. Primary Level incomplete';
        client.X9b_Age_left_primary_school__c = 30;
        update client;
        
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
            if (oneMsg.errorMsg == label.NDTRS_Rule_34)
            {
                return; // warning found
            }
        }
        system.assert (false, 'Warning for 34 not found in warnings list');
    }
    
    static testMethod void TestValidationID_35() 
    {
        NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
        
        Contact client = [select id from Contact where id = :oneForm.Contact__c limit 1];
        client.X9a_Education_highest_level__c = '4. Third Level';
        client.X9b_Age_left_primary_school__c = 10;
        update client;
        
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
            if (oneMsg.errorMsg == label.NDTRS_Rule_35)
            {
                return; // warning found
            }
        }
        system.assert (false, 'Warning for 35 not found in warnings list');
    }   
    
    static testMethod void TestValidationID_36() 
    {
        NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
        
        Contact client = [select id from Contact where id = :oneForm.Contact__c limit 1];
        client.X9a_Education_highest_level__c = '0. Primary Level incomplete';
        client.X9b_Age_left_primary_school__c = 16;
        update client;
        
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
            if (oneMsg.errorMsg == label.NDTRS_Rule_36)
            {
                return; // warning found
            }
        }
        system.assert (false, 'Warning for 36 not found in warnings list');
    }   
    
    static testMethod void TestValidationID_40() 
    {
        NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
        
        Contact client = [select id from Contact where id = :oneForm.Contact__c limit 1];
        client.X10_Employement_Status__c = '8. Other (specify)';
        client.X10_8_Specify_other_employment_status__c = null;
        update client;
        
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
            if (oneMsg.errorMsg == label.NDTRS_Rule_40)
            {
                return; // warning found
            }
        }
        system.assert (false, 'Warning for 40 not found in warnings list');
    }
    
    static testMethod void TestValidationID_42()
    {
        NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
        
        Contact client = [select id from Contact where id = :oneForm.Contact__c limit 1];
        client.Birthdate = system.today().addYears (-70);
        client.X10_Employement_Status__c = '2. Unemployed';
        update client;
        
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
            if (oneMsg.errorMsg == label.NDTRS_Rule_42)
            {
                return; // warning found
            }
        }
        system.assert (false, 'Warning for 42 not found in warnings list');
    }  
    
    static testMethod void TestValidationID_50()
    {
        NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
        oneForm.X17_Where_client_is_suitable_for_treatme__c = '9. Other (specify)';
        oneForm.X17_9_Ohter_specify__c = null;
        update oneForm;
        
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
            if (oneMsg.errorMsg == label.NDTRS_Rule_50)
            {
                return; // warning found
            }
        }
        system.assert (false, 'Warning for 50 not found in warnings list');
    }
    
     static testMethod void TestValidationID_51_1() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-180;
    	oneForm.X32b1_Date_started__c = system.today()-120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_51_1)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 51_1 not found in warnings list');
    }
    
    static testMethod void TestValidationID_51_2() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-180;
    	oneForm.X32b2_Date_started__c = system.today()-120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_51_2)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 51_2 not found in warnings list');
    }
    
    static testMethod void TestValidationID_51_3() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-180;
    	oneForm.X32b3_Date_started__c = system.today()-120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_51_3)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 51_3 not found in warnings list');
    }
    
    static testMethod void TestValidationID_51_4() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-180;
    	oneForm.X32b4_Date_started__c = system.today()-120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_51_4)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 51_4 not found in warnings list');
    }
    
    static testMethod void TestValidationID_51_5() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-180;
    	oneForm.X32b5_Date_started__c = system.today()-120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_51_5)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 51_5 not found in warnings list');
    }
    
    static testMethod void TestValidationID_51_6() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-180;
    	oneForm.X32b6_Date_started__c = system.today()-120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_51_6)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 51_6 not found in warnings list');
    }
    
    static testMethod void TestValidationID_51_7() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-180;
    	oneForm.X32b7_Date_started__c = system.today()-120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_51_7)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 51_7 not found in warnings list');
    }
    
    static testMethod void TestValidationID_51_8() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-180;
    	oneForm.X32b8_Date_started__c = system.today()-120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_51_8)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 51_8 not found in warnings list');
    }
    
    static testMethod void TestValidationID_51_9() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-180;
    	oneForm.X32b9_Date_started__c = system.today()-120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_51_9)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 51_9 not found in warnings list');
    }
    
    static testMethod void TestValidationID_51_10() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-180;
    	oneForm.X32b10_Date_started__c = system.today()-120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_51_10)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 51_10 not found in warnings list');
    }
    
    static testMethod void TestValidationID_51_11() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-180;
    	oneForm.X32b11_Date_started__c = system.today()-120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_51_11)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 51_11 not found in warnings list');
    }
    
    static testMethod void TestValidationID_51_12() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-180;
    	oneForm.X32b12_Date_started__c = system.today()-120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_51_12)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 51_12 not found in warnings list');
    }
    
    static testMethod void TestValidationID_51_13() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-180;
    	oneForm.X32b13_Date_started__c = system.today()-120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_51_13)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 51_13 not found in warnings list');
    }
    
    static testMethod void TestValidationID_51_14() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-180;
    	oneForm.X32b14_Date_started__c = system.today()-120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_51_14)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 51_14 not found in warnings list');
    }
    
    static testMethod void TestValidationID_51_15() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-180;
    	oneForm.X32b15_Date_started__c = system.today()-120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_51_15)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 51_15 not found in warnings list');
    }
    
    static testMethod void TestValidationID_51_16() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-180;
    	oneForm.X32b16_Date_started__c = system.today()-120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_51_16)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 51_16 not found in warnings list');
    }
    
    static testMethod void TestValidationID_51_17() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-180;
    	oneForm.X32b17_Date_started__c = system.today()-120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_51_17)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 51_17 not found in warnings list');
    }
    
    static testMethod void TestValidationID_51_18() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-180;
    	oneForm.X32b18_Date_started__c = system.today()-120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_51_18)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 51_18 not found in warnings list');
    }
    
    static testMethod void TestValidationID_51_19() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-180;
    	oneForm.X32b19_Date_started__c = system.today()-120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_51_19)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 51_19 not found in warnings list');
    }
    
    static testMethod void TestValidationID_51_20() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-180;
    	oneForm.X32b20_Date_started__c = system.today()-120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_51_20)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 51_20 not found in warnings list');
    }
    
    static testMethod void TestValidationID_51_21() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-180;
    	oneForm.X32b21_Date_started__c = system.today()-120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_51_21)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 51_21 not found in warnings list');
    }
    
    static testMethod void TestValidationID_51_22() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-180;
    	oneForm.X32b22_Date_started__c = system.today()-120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_51_22)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 51_22 not found in warnings list');
    }
    
    static testMethod void TestValidationID_51_23() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-180;
    	oneForm.X32b23_Date_started__c = system.today()-120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_51_23)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 51_23 not found in warnings list');
    }
    
    static testMethod void TestValidationID_51_24() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-180;
    	oneForm.X32b24_Date_started__c = system.today()-120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_51_24)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 51_24 not found in warnings list');
    }
    
    static testMethod void TestValidationID_51_25() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-180;
    	oneForm.X32b25_Date_started__c = system.today()-120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_51_25)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 51_25 not found in warnings list');
    }
    
    static testMethod void TestValidationID_51_26() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-180;
    	oneForm.X32b26_Date_started__c = system.today()-120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_51_26)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 51_26 not found in warnings list');
    }
    
    static testMethod void TestValidationID_51_27() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-180;
    	oneForm.X32b27_Date_started__c = system.today()-120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_51_27)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 51_27 not found in warnings list');
    }
    
    static testMethod void TestValidationID_51_28() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-180;
    	oneForm.X32b28_Date_started__c = system.today()-120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_51_28)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 51_28 not found in warnings list');
    }
    
    static testMethod void TestValidationID_60() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X13_Main_Reason_for_referral__c = '2. Drug (specify)';
    	oneForm.X18_Number_times_started_this_year__c = 2;
    	oneForm.X19_History_of_treatment_Drugs__c ='1. Never treated';
		oneForm.X19b_Age_first_treated_Drugs__c = 88;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_60)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 60 not found in warnings list');
    }
    
    static testMethod void TestValidationID_61() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X13_Main_Reason_for_referral__c = '1. Alcohol';
    	oneForm.X18_Number_times_started_this_year__c = 2;
    	oneForm.X19_History_of_treatment_Alcohol__c ='1. Never treated';
		oneForm.X19d_Age_first_treated_Alcohol__c = 88;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_61)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 61 not found in warnings list');
    }
    
    static testMethod void TestValidationID_62() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X13_Main_Reason_for_referral__c = '4. Other problem (specify)';
    	oneForm.X18_Number_times_started_this_year__c = 2;
    	oneForm.X19_History_of_treatment_Other__c ='1. Never treated';
		oneForm.X19b_Age_first_treated_Other__c = 88;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_62)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 62 not found in warnings list');
    }
 /*   
    static testMethod void TestValidationID_63() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X13_Main_Reason_for_referral__c = '2. Drug (specify)';
    	oneForm.X19_History_of_treatment_Drugs__c ='1. Never treated';
		oneForm.X19b_Age_first_treated_Drugs__c = 20;
		oneForm.X19_History_of_treatment_Alcohol__c = '9. Treatment status unknown';
		oneForm.X19d_Age_first_treated_Alcohol__c = 25;
		oneForm.X19_History_of_treatment_Other__c = '9. Treatment status unknown';
		oneForm.X19b_Age_first_treated_Other__c = 26;
    	oneForm.X20a_Ever_received_any_opiate_substituti__c ='1. Previously received';
		oneForm.X20b_Age_first_received_any_opiate_subst__c = 21;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_63)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 63 not found in warnings list');
    }
*/ 
    static testMethod void TestValidationID_70() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X19_History_of_treatment_Drugs__c ='2. Previously treated';
    	oneForm.X19b_Age_first_treated_Drugs__c = 10;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_70)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 70 not found in warnings list');
    }
    
    static testMethod void TestValidationID_72() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X19_History_of_treatment_Drugs__c ='2. Previously treated';
    	oneForm.X19b_Age_first_treated_Drugs__c = null;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_72)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 72 not found in warnings list');
    }
 
    static testMethod void TestValidationID_73() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X18_Number_times_started_this_year__c = 2;
    	oneForm.X19_History_of_treatment_Drugs__c ='1. Never treated';
    	oneForm.X19_History_of_treatment_Alcohol__c ='1. Never treated';
		oneForm.X19b_Age_first_treated_Drugs__c = 88;
		oneForm.X19d_Age_first_treated_Alcohol__c = 88;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_73)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 73 not found in warnings list');
    }
    
    static testMethod void TestValidationID_74() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X19d_Age_first_treated_Alcohol__c = 10;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_74)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 74 not found in warnings list');
    }
   
    static testMethod void TestValidationID_75() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X19_History_of_treatment_Alcohol__c ='2. Previously treated';
    	oneForm.X19d_Age_first_treated_Alcohol__c = null;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_75)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 75 not found in warnings list');
    }
   
    static testMethod void TestValidationID_76a() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X13_Main_Reason_for_referral__c ='4. Other problem (specify)';
    	oneForm.X19_History_of_treatment_Other__c = null;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_76a)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 76a not found in warnings list');
    }
    
    static testMethod void TestValidationID_76b() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X13_Main_Reason_for_referral__c ='4. Other problem (specify)';
    	oneForm.X19b_Age_first_treated_Other__c = null;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_76b)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 76b not found in warnings list');
    }
    
    static testMethod void TestValidationID_77() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X13_Main_Reason_for_referral__c ='4. Other problem (specify)';
    	oneForm.X13_4_Other_problem_speciify__c = null;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_77)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 77 not found in warnings list');
    }
    
    static testMethod void TestValidationID_78() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X13_Main_Reason_for_referral__c ='4. Other problem (specify)';
    	oneForm.X19b_Age_first_treated_Other__c = 10;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_78)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 78 not found in warnings list');
    }
    
    static testMethod void TestValidationID_83() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X20a_Ever_received_any_opiate_substituti__c ='1. Previously received';
    	oneForm.X20b_Age_first_received_any_opiate_subst__c = 10;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_83)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 83 not found in warnings list');
    }
    
    static testMethod void TestValidationID_88() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X21a_Main_drug__c = [select id from NDTRS_Drugs__c where item_code__c=111 limit 1].id;
    	oneForm.X21b_Route_of_Admin_Main_drug__c = '3. Eat/drink';
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_88)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 88 not found in warnings list');
    }
    
    static testMethod void TestValidationID_88_2() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
    	oneForm.X22a_Drug_2__c = [select id from NDTRS_Drugs__c where item_code__c=111 limit 1].id;
    	oneForm.X22b_Route_of_Admin_Drug2__c = '3. Eat/drink';
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_88)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 88 not found in warnings list');
    }
    
    static testMethod void TestValidationID_88_3() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
    	oneForm.X23a_Drug_3__c = [select id from NDTRS_Drugs__c where item_code__c=111 limit 1].id;
    	oneForm.X23b_Route_of_Admin_Drug3__c = '3. Eat/drink';
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_88)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 88 not found in warnings list');
    }
    
    static testMethod void TestValidationID_88_4() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
    	oneForm.X24a_Drug_4__c = [select id from NDTRS_Drugs__c where item_code__c=111 limit 1].id;
    	oneForm.X24b_Route_of_Admin_Drug4__c = '3. Eat/drink';
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_88)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 88 not found in warnings list');
    }
    
    static testMethod void TestValidationID_88_5() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
    	oneForm.X25a_Drug_5__c = [select id from NDTRS_Drugs__c where item_code__c=111 limit 1].id;
    	oneForm.X25b_Route_of_Admin_Drug5__c = '3. Eat/drink';
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_88)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 88 not found in warnings list');
    }

 	static void TestValidationID_89_to_92(Integer validationID, Integer drugCode) 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X21a_Main_drug__c = [select id from NDTRS_Drugs__c where item_code__c=:drugCode limit 1].id;
    	oneForm.X21b_Route_of_Admin_Main_drug__c = '2. Smoke';
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        String drugName = [select Name from NDTRS_Drugs__c where item_code__c=:drugCode limit 1].Name;
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg.contains (drugName)) // cannot check for label 89 directly as the drug name is in the message
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for ' + validationID + ' not found in warnings list');
    }
    
    static testMethod void TestValidationID_89() 
    {
    	TestValidationID_89_to_92 (89, 159);
    }
    
    static testMethod void TestValidationID_90() 
    {
    	TestValidationID_89_to_92 (90, 232);
    }

    static testMethod void TestValidationID_91() 
    {
    	TestValidationID_89_to_92 (91, 240);
    }

    static testMethod void TestValidationID_92() 
    {
    	TestValidationID_89_to_92 (92, 312);
    }
    
    static void TestValidationID_89_to_92D2(Integer validationID, Integer drugCode) 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
    	oneForm.X22a_Drug_2__c = [select id from NDTRS_Drugs__c where item_code__c=:drugCode limit 1].id;
    	oneForm.X22b_Route_of_Admin_Drug2__c = '2. Smoke';
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        String drugName = [select Name from NDTRS_Drugs__c where item_code__c=:drugCode limit 1].Name;
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg.contains (drugName)) // cannot check for label 89 directly as the drug name is in the message
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for ' + validationID + ' not found in warnings list');
    }
    
    static testMethod void TestValidationID_89D2() 
    {
    	TestValidationID_89_to_92D2 (89, 159);
    }
    
    static testMethod void TestValidationID_90D2() 
    {
    	TestValidationID_89_to_92D2 (90, 232);
    }

    static testMethod void TestValidationID_91D2() 
    {
    	TestValidationID_89_to_92D2 (91, 240);
    }

    static testMethod void TestValidationID_92D2() 
    {
    	TestValidationID_89_to_92D2 (92, 312);
    }
    
    static void TestValidationID_89_to_92D3(Integer validationID, Integer drugCode) 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
    	oneForm.X23a_Drug_3__c = [select id from NDTRS_Drugs__c where item_code__c=:drugCode limit 1].id;
    	oneForm.X23b_Route_of_Admin_Drug3__c = '2. Smoke';
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        String drugName = [select Name from NDTRS_Drugs__c where item_code__c=:drugCode limit 1].Name;
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg.contains (drugName)) // cannot check for label 89 directly as the drug name is in the message
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for ' + validationID + ' not found in warnings list');
    }
    
    static testMethod void TestValidationID_89D3() 
    {
    	TestValidationID_89_to_92D3 (89, 159);
    }
    
    static testMethod void TestValidationID_90D3() 
    {
    	TestValidationID_89_to_92D3 (90, 232);
    }

    static testMethod void TestValidationID_91D3() 
    {
    	TestValidationID_89_to_92D3 (91, 240);
    }

    static testMethod void TestValidationID_92D3() 
    {
    	TestValidationID_89_to_92D3 (92, 312);
    }
    
    static void TestValidationID_89_to_92D4(Integer validationID, Integer drugCode) 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
    	oneForm.X24a_Drug_4__c = [select id from NDTRS_Drugs__c where item_code__c=:drugCode limit 1].id;
    	oneForm.X24b_Route_of_Admin_Drug4__c = '2. Smoke';
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        String drugName = [select Name from NDTRS_Drugs__c where item_code__c=:drugCode limit 1].Name;
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg.contains (drugName)) // cannot check for label 89 directly as the drug name is in the message
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for ' + validationID + ' not found in warnings list');
    }
    
    static testMethod void TestValidationID_89D4() 
    {
    	TestValidationID_89_to_92D4 (89, 159);
    }
    
    static testMethod void TestValidationID_90D4()
    {
    	TestValidationID_89_to_92D4 (90, 232);
    }

    static testMethod void TestValidationID_91D4() 
    {
    	TestValidationID_89_to_92D4 (91, 240);
    }

    static testMethod void TestValidationID_92D4() 
    {
    	TestValidationID_89_to_92D4 (92, 312);
    }
    
    static void TestValidationID_89_to_92D5(Integer validationID, Integer drugCode)
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
    	oneForm.X25a_Drug_5__c = [select id from NDTRS_Drugs__c where item_code__c=:drugCode limit 1].id;
    	oneForm.X25b_Route_of_Admin_Drug5__c = '2. Smoke';
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        String drugName = [select Name from NDTRS_Drugs__c where item_code__c=:drugCode limit 1].Name;
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg.contains (drugName)) // cannot check for label 89 directly as the drug name is in the message
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for ' + validationID + ' not found in warnings list');
    }
    
    static testMethod void TestValidationID_89D5() 
    {
    	TestValidationID_89_to_92D5 (89, 159);
    }
    
    static testMethod void TestValidationID_90D5() 
    {
    	TestValidationID_89_to_92D5 (90, 232);
    }

    static testMethod void TestValidationID_91D5()
    {
    	TestValidationID_89_to_92D5 (91, 240);
    }

    static testMethod void TestValidationID_92D5() 
    {
    	TestValidationID_89_to_92D5 (92, 312);
    }
    
    static testMethod void TestValidationID_93() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X21a_Main_drug__c = [select id from NDTRS_Drugs__c where item_code__c=410 limit 1].id;
    	oneForm.X21b_Route_of_Admin_Main_drug__c = '2. Smoke';
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_93)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 93 not found in warnings list');
    }
    
    static testMethod void TestValidationID_93D2() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
    	oneForm.X22a_Drug_2__c = [select id from NDTRS_Drugs__c where item_code__c=410 limit 1].id;
    	oneForm.X22b_Route_of_Admin_Drug2__c = '2. Smoke';
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_93)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 93 not found in warnings list');
    }
    
    static testMethod void TestValidationID_93D3() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
    	oneForm.X23a_Drug_3__c = [select id from NDTRS_Drugs__c where item_code__c=410 limit 1].id;
    	oneForm.X23b_Route_of_Admin_Drug3__c = '2. Smoke';
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_93)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 93 not found in warnings list');
    }
    
    static testMethod void TestValidationID_93D4() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
    	oneForm.X24a_Drug_4__c = [select id from NDTRS_Drugs__c where item_code__c=410 limit 1].id;
    	oneForm.X24b_Route_of_Admin_Drug4__c = '2. Smoke';
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_93)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 93 not found in warnings list');
    }
    
    static testMethod void TestValidationID_93D5() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
    	oneForm.X25a_Drug_5__c = [select id from NDTRS_Drugs__c where item_code__c=410 limit 1].id;
    	oneForm.X25b_Route_of_Admin_Drug5__c = '2. Smoke';
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_93)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 93 not found in warnings list');
    }
    
    static void TestValidationID_94_to_96(Integer validationID, Integer drugCode) 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X21a_Main_drug__c = [select id from NDTRS_Drugs__c where item_code__c=:drugCode limit 1].id;
    	oneForm.X21b_Route_of_Admin_Main_drug__c = '1. Inject';
    	oneForm.X30a_Ever_injected__c = '1. Yes';
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        String drugName = [select Name from NDTRS_Drugs__c where item_code__c=:drugCode limit 1].Name;
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg.contains (drugName)) // cannot check for label 94 directly as the drug name is in the message
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for ' + validationID + ' not found in warnings list');
    }
    
    static testMethod void TestValidationID_94()
    {
    	TestValidationID_94_to_96 (94, 511);
    }
    
    static testMethod void TestValidationID_95()
    {
    	TestValidationID_94_to_96 (95, 612);
    }

    static testMethod void TestValidationID_96()
    {
    	TestValidationID_94_to_96 (96, 700);
    }
    
	static void TestValidationID_94_to_96D2(Integer validationID, Integer drugCode) 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
    	oneForm.X22a_Drug_2__c = [select id from NDTRS_Drugs__c where item_code__c=:drugCode limit 1].id;
    	oneForm.X22b_Route_of_Admin_Drug2__c = '1. Inject';
    	oneForm.X30a_Ever_injected__c = '1. Yes';
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        String drugName = [select Name from NDTRS_Drugs__c where item_code__c=:drugCode limit 1].Name;
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg.contains (drugName)) // cannot check for label 94 directly as the drug name is in the message
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for ' + validationID + ' not found in warnings list');
    }
    
    static testMethod void TestValidationID_94D2()
    {
    	TestValidationID_94_to_96D2 (94, 511);
    }
    
    static testMethod void TestValidationID_95D2()
    {
    	TestValidationID_94_to_96D2 (95, 612);
    }

    static testMethod void TestValidationID_96D2()
    {
    	TestValidationID_94_to_96D2 (96, 700);
    }
	
	static void TestValidationID_94_to_96D3(Integer validationID, Integer drugCode) 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
    	oneForm.X23a_Drug_3__c = [select id from NDTRS_Drugs__c where item_code__c=:drugCode limit 1].id;
    	oneForm.X23b_Route_of_Admin_Drug3__c = '1. Inject';
    	oneForm.X30a_Ever_injected__c = '1. Yes';
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        String drugName = [select Name from NDTRS_Drugs__c where item_code__c=:drugCode limit 1].Name;
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg.contains (drugName)) // cannot check for label 94 directly as the drug name is in the message
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for ' + validationID + ' not found in warnings list');
    }
    
    static testMethod void TestValidationID_94D3()
    {
    	TestValidationID_94_to_96D3 (94, 511);
    }
    
    static testMethod void TestValidationID_95D3()
    {
    	TestValidationID_94_to_96D3 (95, 612);
    }

    static testMethod void TestValidationID_96D3()
    {
    	TestValidationID_94_to_96D3 (96, 700);
    }
    
    static void TestValidationID_94_to_96D4(Integer validationID, Integer drugCode) 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
    	oneForm.X24a_Drug_4__c = [select id from NDTRS_Drugs__c where item_code__c=:drugCode limit 1].id;
    	oneForm.X24b_Route_of_Admin_Drug4__c = '1. Inject';
    	oneForm.X30a_Ever_injected__c = '1. Yes';
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        String drugName = [select Name from NDTRS_Drugs__c where item_code__c=:drugCode limit 1].Name;
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg.contains (drugName)) // cannot check for label 94 directly as the drug name is in the message
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for ' + validationID + ' not found in warnings list');
    }
    
    static testMethod void TestValidationID_94D4()
    {
    	TestValidationID_94_to_96D4 (94, 511);
    }
    
    static testMethod void TestValidationID_95D4()
    {
    	TestValidationID_94_to_96D4 (95, 612);
    }

    static testMethod void TestValidationID_96D4()
    {
    	TestValidationID_94_to_96D4 (96, 700);
    }
    
     static void TestValidationID_94_to_96D5(Integer validationID, Integer drugCode) 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
    	oneForm.X25a_Drug_5__c = [select id from NDTRS_Drugs__c where item_code__c=:drugCode limit 1].id;
    	oneForm.X25b_Route_of_Admin_Drug5__c = '1. Inject';
    	oneForm.X30a_Ever_injected__c = '1. Yes';
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        String drugName = [select Name from NDTRS_Drugs__c where item_code__c=:drugCode limit 1].Name;
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg.contains (drugName)) // cannot check for label 94 directly as the drug name is in the message
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for ' + validationID + ' not found in warnings list');
    }
    
    static testMethod void TestValidationID_94D5()
    {
    	TestValidationID_94_to_96D5 (94, 511);
    }
    
    static testMethod void TestValidationID_95D5()
    {
    	TestValidationID_94_to_96D5 (95, 612);
    }

    static testMethod void TestValidationID_96D5()
    {
    	TestValidationID_94_to_96D5 (96, 700);
    }
    
/*    static testMethod void TestValidationID_102_D1() Not required Q13 must be equal to Q21a
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X13_2_Drug_specify__c = [select id from NDTRS_Drugs__c where item_code__c=212 limit 1].id;
    	oneForm.X19_History_of_treatment_Drugs__c = '1. Never treated';
		oneForm.X19b_Age_first_treated_Drugs__c = 88;
    	oneForm.X21a_Main_drug__c = [select id from NDTRS_Drugs__c where item_code__c=212 limit 1].id;
    	oneForm.X22a_Drug_2__c = [select id from NDTRS_Drugs__c where item_code__c=210 limit 1].id;
    	oneForm.X23a_Drug_3__c = [select id from NDTRS_Drugs__c where item_code__c=218 limit 1].id;
    	oneForm.X24a_Drug_4__c = [select id from NDTRS_Drugs__c where item_code__c=221 limit 1].id;
    	oneForm.X25a_Drug_5__c = [select id from NDTRS_Drugs__c where item_code__c=222 limit 1].id;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_102)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 102 not found in warnings list');
    }
*/   
    static testMethod void TestValidationID_102_D2() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X13_2_Drug_specify__c = [select id from NDTRS_Drugs__c where item_code__c=212 limit 1].id;
    	oneForm.X19_History_of_treatment_Drugs__c = '1. Never treated';
		oneForm.X19b_Age_first_treated_Drugs__c = 88;
    	oneForm.X21a_Main_drug__c = [select id from NDTRS_Drugs__c where item_code__c=212 limit 1].id;
    	oneForm.X22a_Drug_2__c = [select id from NDTRS_Drugs__c where item_code__c=210 limit 1].id;
    	oneForm.X23a_Drug_3__c = [select id from NDTRS_Drugs__c where item_code__c=218 limit 1].id;
    	oneForm.X24a_Drug_4__c = [select id from NDTRS_Drugs__c where item_code__c=221 limit 1].id;
    	oneForm.X25a_Drug_5__c = [select id from NDTRS_Drugs__c where item_code__c=222 limit 1].id;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_102)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 102 not found in warnings list');
    }
    
    static testMethod void TestValidationID_102_D3() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X13_2_Drug_specify__c = [select id from NDTRS_Drugs__c where item_code__c=212 limit 1].id;
    	oneForm.X19_History_of_treatment_Drugs__c = '1. Never treated';
		oneForm.X19b_Age_first_treated_Drugs__c = 88;
    	oneForm.X21a_Main_drug__c = [select id from NDTRS_Drugs__c where item_code__c=212 limit 1].id;
    	oneForm.X22a_Drug_2__c = [select id from NDTRS_Drugs__c where item_code__c=218 limit 1].id;
    	oneForm.X23a_Drug_3__c = [select id from NDTRS_Drugs__c where item_code__c=210 limit 1].id;
    	oneForm.X24a_Drug_4__c = [select id from NDTRS_Drugs__c where item_code__c=221 limit 1].id;
    	oneForm.X25a_Drug_5__c = [select id from NDTRS_Drugs__c where item_code__c=222 limit 1].id;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_102)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 102 not found in warnings list');
    }
    
    static testMethod void TestValidationID_102_D4() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X13_2_Drug_specify__c = [select id from NDTRS_Drugs__c where item_code__c=212 limit 1].id;
    	oneForm.X19_History_of_treatment_Drugs__c = '1. Never treated';
		oneForm.X19b_Age_first_treated_Drugs__c = 88;
    	oneForm.X21a_Main_drug__c = [select id from NDTRS_Drugs__c where item_code__c=212 limit 1].id;
    	oneForm.X22a_Drug_2__c = [select id from NDTRS_Drugs__c where item_code__c=218 limit 1].id;
    	oneForm.X23a_Drug_3__c = [select id from NDTRS_Drugs__c where item_code__c=221 limit 1].id;
    	oneForm.X24a_Drug_4__c = [select id from NDTRS_Drugs__c where item_code__c=210 limit 1].id;
    	oneForm.X25a_Drug_5__c = [select id from NDTRS_Drugs__c where item_code__c=222 limit 1].id;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_102)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 102 not found in warnings list');
    }
    
    static testMethod void TestValidationID_102_D5() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X13_2_Drug_specify__c = [select id from NDTRS_Drugs__c where item_code__c=212 limit 1].id;
    	oneForm.X19_History_of_treatment_Drugs__c = '1. Never treated';
		oneForm.X19b_Age_first_treated_Drugs__c = 88;
    	oneForm.X21a_Main_drug__c = [select id from NDTRS_Drugs__c where item_code__c=212 limit 1].id;
    	oneForm.X22a_Drug_2__c = [select id from NDTRS_Drugs__c where item_code__c=218 limit 1].id;
    	oneForm.X23a_Drug_3__c = [select id from NDTRS_Drugs__c where item_code__c=221 limit 1].id;
    	oneForm.X24a_Drug_4__c = [select id from NDTRS_Drugs__c where item_code__c=222 limit 1].id;
    	oneForm.X25a_Drug_5__c = [select id from NDTRS_Drugs__c where item_code__c=210 limit 1].id;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_102)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 102 not found in warnings list');
    }
/*    
    static void TestValidationID_105_to_106(Integer validationID, Integer drugCode) 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X13_2_Drug_specify__c = [select id from NDTRS_Drugs__c where item_code__c=:drugCode limit 1].id;
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
    	oneForm.X21a_Main_drug__c = [select id from NDTRS_Drugs__c where item_code__c=:drugCode limit 1].id;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        String drugName = [select Name from NDTRS_Drugs__c where item_code__c=:drugCode limit 1].Name;
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg.contains (drugName)) // cannot check for label 105 directly as the drug name is in the message
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for ' + validationID + ' not found in warnings list');
    }
    
    static testMethod void TestValidationID_105()
    {
    	TestValidationID_105_to_106 (105, 161);
    }
    
    static testMethod void TestValidationID_106()
    {
    	TestValidationID_105_to_106 (106, 163);
    }
*/    
    static void TestValidationID_105_to_106D1(Integer validationID, Integer drugCode) 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X13_2_Drug_specify__c = [select id from NDTRS_Drugs__c where item_code__c=:drugCode limit 1].id;
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
    	oneForm.X21a_Main_drug__c = [select id from NDTRS_Drugs__c where item_code__c=:drugCode limit 1].id;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        String drugName = [select Name from NDTRS_Drugs__c where item_code__c=:drugCode limit 1].Name;
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg.contains (drugName)) // cannot check for label 105 directly as the drug name is in the message
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for ' + validationID + ' not found in warnings list');
    }
    
    static testMethod void TestValidationID_105D1()
    {
    	TestValidationID_105_to_106D1 (105, 161);
    }
    
    static testMethod void TestValidationID_106D1()
    {
    	TestValidationID_105_to_106D1 (106, 163);
    }
    
    static void TestValidationID_105_to_106D2(Integer validationID, Integer drugCode) 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
    	oneForm.X22a_Drug_2__c = [select id from NDTRS_Drugs__c where item_code__c=:drugCode limit 1].id;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        String drugName = [select Name from NDTRS_Drugs__c where item_code__c=:drugCode limit 1].Name;
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg.contains (drugName)) // cannot check for label 105 directly as the drug name is in the message
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for ' + validationID + ' not found in warnings list');
    }
    
    static testMethod void TestValidationID_105D2()
    {
    	TestValidationID_105_to_106D2 (105, 161);
    }
    
    static testMethod void TestValidationID_106D2()
    {
    	TestValidationID_105_to_106D2 (106, 163);
    }
    
    static void TestValidationID_105_to_106D3(Integer validationID, Integer drugCode) 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
    	oneForm.X23a_Drug_3__c = [select id from NDTRS_Drugs__c where item_code__c=:drugCode limit 1].id;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        String drugName = [select Name from NDTRS_Drugs__c where item_code__c=:drugCode limit 1].Name;
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg.contains (drugName)) // cannot check for label 105 directly as the drug name is in the message
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for ' + validationID + ' not found in warnings list');
    }
    
    static testMethod void TestValidationID_105D3()
    {
    	TestValidationID_105_to_106D3 (105, 161);
    }
    
    static testMethod void TestValidationID_106D3()
    {
    	TestValidationID_105_to_106D3 (106, 163);
    }
    
	static void TestValidationID_105_to_106D4(Integer validationID, Integer drugCode) 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
    	oneForm.X24a_Drug_4__c = [select id from NDTRS_Drugs__c where item_code__c=:drugCode limit 1].id;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        String drugName = [select Name from NDTRS_Drugs__c where item_code__c=:drugCode limit 1].Name;
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg.contains (drugName)) // cannot check for label 105 directly as the drug name is in the message
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for ' + validationID + ' not found in warnings list');
    }
    
    static testMethod void TestValidationID_105D4()
    {
    	TestValidationID_105_to_106D4 (105, 161);
    }
    
    static testMethod void TestValidationID_106D4()
    {
    	TestValidationID_105_to_106D4 (106, 163);
    }

	static void TestValidationID_105_to_106D5(Integer validationID, Integer drugCode) 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
    	oneForm.X25a_Drug_5__c = [select id from NDTRS_Drugs__c where item_code__c=:drugCode limit 1].id;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        String drugName = [select Name from NDTRS_Drugs__c where item_code__c=:drugCode limit 1].Name;
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg.contains (drugName)) // cannot check for label 105 directly as the drug name is in the message
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for ' + validationID + ' not found in warnings list');
    }
    
    static testMethod void TestValidationID_105D5()
    {
    	TestValidationID_105_to_106D5 (105, 161);
    }
    
    static testMethod void TestValidationID_106D5()
    {
    	TestValidationID_105_to_106D5 (106, 163);
    }

    static void TestValidationID_107_to_108D1(Integer validationID, Integer drugCode) 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X21a_Main_drug__c = [select id from NDTRS_Drugs__c where item_code__c=:drugCode limit 1].id;
    	oneForm.X19_History_of_treatment_Drugs__c = '1. Never treated';
		oneForm.X19b_Age_first_treated_Drugs__c = 88;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        String drugName = [select Name from NDTRS_Drugs__c where item_code__c=:drugCode limit 1].Name;
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg.contains (drugName)) // cannot check for label 107 directly as the drug name is in the message
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for ' + validationID + ' not found in warnings list');
    }
    
    static testMethod void TestValidationID_107D1()
    {
    	TestValidationID_107_to_108D1 (107, 161);
    }
    
    static testMethod void TestValidationID_108D1()
    {
    	TestValidationID_107_to_108D1 (108, 163);
    }
    
    static void TestValidationID_107_to_108D2(Integer validationID, Integer drugCode) 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X22a_Drug_2__c = [select id from NDTRS_Drugs__c where item_code__c=:drugCode limit 1].id;
    	oneForm.X19_History_of_treatment_Drugs__c = '1. Never treated';
		oneForm.X19b_Age_first_treated_Drugs__c = 88;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        String drugName = [select Name from NDTRS_Drugs__c where item_code__c=:drugCode limit 1].Name;
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg.contains (drugName)) // cannot check for label 107 directly as the drug name is in the message
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for ' + validationID + ' not found in warnings list');
    }
    
    static testMethod void TestValidationID_107D2()
    {
    	TestValidationID_107_to_108D2 (107, 161);
    }
    
    static testMethod void TestValidationID_108D2()
    {
    	TestValidationID_107_to_108D2 (108, 163);
    }
    
    static void TestValidationID_107_to_108D3(Integer validationID, Integer drugCode) 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X23a_Drug_3__c = [select id from NDTRS_Drugs__c where item_code__c=:drugCode limit 1].id;
    	oneForm.X19_History_of_treatment_Drugs__c = '1. Never treated';
		oneForm.X19b_Age_first_treated_Drugs__c = 88;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        String drugName = [select Name from NDTRS_Drugs__c where item_code__c=:drugCode limit 1].Name;
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg.contains (drugName)) // cannot check for label 107 directly as the drug name is in the message
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for ' + validationID + ' not found in warnings list');
    }
    
    static testMethod void TestValidationID_107D3()
    {
    	TestValidationID_107_to_108D3 (107, 161);
    }
    
    static testMethod void TestValidationID_108D3()
    {
    	TestValidationID_107_to_108D3 (108, 163);
    }
    
    static void TestValidationID_107_to_108D4(Integer validationID, Integer drugCode) 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X24a_Drug_4__c = [select id from NDTRS_Drugs__c where item_code__c=:drugCode limit 1].id;
    	oneForm.X19_History_of_treatment_Drugs__c = '1. Never treated';
		oneForm.X19b_Age_first_treated_Drugs__c = 88;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        String drugName = [select Name from NDTRS_Drugs__c where item_code__c=:drugCode limit 1].Name;
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg.contains (drugName)) // cannot check for label 107 directly as the drug name is in the message
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for ' + validationID + ' not found in warnings list');
    }
    
    static testMethod void TestValidationID_107D4()
    {
    	TestValidationID_107_to_108D4 (107, 161);
    }
    
    static testMethod void TestValidationID_108D4()
    {
    	TestValidationID_107_to_108D4 (108, 163);
    }
    
    static void TestValidationID_107_to_108D5(Integer validationID, Integer drugCode) 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X25a_Drug_5__c = [select id from NDTRS_Drugs__c where item_code__c=:drugCode limit 1].id;
    	oneForm.X19_History_of_treatment_Drugs__c = '1. Never treated';
		oneForm.X19b_Age_first_treated_Drugs__c = 88;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        String drugName = [select Name from NDTRS_Drugs__c where item_code__c=:drugCode limit 1].Name;
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg.contains (drugName)) // cannot check for label 107 directly as the drug name is in the message
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for ' + validationID + ' not found in warnings list');
    }
    
    static testMethod void TestValidationID_107D5()
    {
    	TestValidationID_107_to_108D5 (107, 161);
    }
    
    static testMethod void TestValidationID_108D5()
    {
    	TestValidationID_107_to_108D5 (108, 163);
    }
    
    static testMethod void TestValidationID_111_to_112D1() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X21a_Main_drug__c = [select id from NDTRS_Drugs__c where item_code__c= 600 limit 1].id;
    	oneForm.X21d_Age_at_1st_use__c=11;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_111)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 111 not found in warnings list');
    }
   
    static testMethod void TestValidationID_111_to_112D2() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
    	oneForm.X22a_Drug_2__c = [select id from NDTRS_Drugs__c where item_code__c= 600 limit 1].id;
    	oneForm.X22d_Age_of_1st_use__c=11;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_111)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 111 not found in warnings list');
    }
    
    static testMethod void TestValidationID_111_to_112D3() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
    	oneForm.X23a_Drug_3__c = [select id from NDTRS_Drugs__c where item_code__c= 600 limit 1].id;
    	oneForm.X23d_Age_of_1st_use__c=11;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_111)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 111 not found in warnings list');
    }
    
    static testMethod void TestValidationID_111_to_112D4() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
    	oneForm.X24a_Drug_4__c = [select id from NDTRS_Drugs__c where item_code__c= 600 limit 1].id;
    	oneForm.X24d_Age_of_1st_use__c=11;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_111)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 111 not found in warnings list');
    }
    
    static testMethod void TestValidationID_111_to_112D5() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
    	oneForm.X25a_Drug_5__c = [select id from NDTRS_Drugs__c where item_code__c= 600 limit 1].id;
    	oneForm.X25d_Age_of_1st_use__c=11;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_111)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 111 not found in warnings list');
    }
    
    static testMethod void TestValidationID_111_to_112D6() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X27_Specify_first_drug_ever_used__c = [select id from NDTRS_Drugs__c where item_code__c= 600 limit 1].id;
    	oneForm.X26_Age_first_use_any_drug__c=11;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_111)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 111 not found in warnings list');
    }
    
    static testMethod void TestValidationID_116() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X21a_Main_drug__c = [select id from NDTRS_Drugs__c where item_code__c= 700 limit 1].id;
    	oneForm.X21b_Route_of_Admin_Main_drug__c = '3. Eat/drink';
    	oneForm.X21c_Frequency_of_use_in_last_mth__c = '3. Daily';
    	oneForm.X21d_Age_at_1st_use__c = 20;
    	oneForm.X29a_Preferred_types_of_alcohol_consumed__c = null;
    	oneForm.X29b_How_many_drinks_per_occasion__c = null;
    	oneForm.X29c_Extent_of_drinking_problem__c = null;
    	oneForm.X29d_Number_of_previous_alcohol_detoxes__c = null;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_118)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 118 not found in warnings list');
    }
    
    static testMethod void TestValidationID_117() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X21a_Main_drug__c = [select id from NDTRS_Drugs__c where item_code__c= 700 limit 1].id;
    	oneForm.X21b_Route_of_Admin_Main_drug__c = '3. Eat/drink';
    	oneForm.X21c_Frequency_of_use_in_last_mth__c = '3. Daily';
    	oneForm.X21d_Age_at_1st_use__c = 20;
    	oneForm.X29a_Preferred_types_of_alcohol_consumed__c = '2. Beer';
    	oneForm.X29b_How_many_drinks_per_occasion__c = 80;
    	oneForm.X29c_Extent_of_drinking_problem__c = '2. Hazardous drinker';
    	oneForm.X29d_Number_of_previous_alcohol_detoxes__c = 1;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_117)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 117 not found in warnings list');
    }
    
    static testMethod void TestValidationID_119D1() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X21a_Main_drug__c = [select id from NDTRS_Drugs__c where item_code__c= 700 limit 1].id;
    	oneForm.X21b_Route_of_Admin_Main_drug__c = '3. Eat/drink';
    	oneForm.X21c_Frequency_of_use_in_last_mth__c = '3. Daily';
    	oneForm.X21d_Age_at_1st_use__c = 20;
    	oneForm.X29a_Preferred_types_of_alcohol_consumed__c = '2. Beer';
    	oneForm.X29b_How_many_drinks_per_occasion__c = 0;
    	oneForm.X29c_Extent_of_drinking_problem__c = '2. Hazardous drinker';
    	oneForm.X29d_Number_of_previous_alcohol_detoxes__c = 1;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_119)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 119 not found in warnings list');
    }
    
    static testMethod void TestValidationID_119D2() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
    	oneForm.X22a_Drug_2__c = [select id from NDTRS_Drugs__c where item_code__c= 700 limit 1].id;
    	oneForm.X22b_Route_of_Admin_Drug2__c = '3. Eat/drink';
    	oneForm.X22c_Frequency_of_use_in_last_mth__c = '3. Daily';
    	oneForm.X22d_Age_of_1st_use__c = 20;
    	oneForm.X29a_Preferred_types_of_alcohol_consumed__c = '2. Beer';
    	oneForm.X29b_How_many_drinks_per_occasion__c = 0;
    	oneForm.X29c_Extent_of_drinking_problem__c = '2. Hazardous drinker';
    	oneForm.X29d_Number_of_previous_alcohol_detoxes__c = 1;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_119)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 119 not found in warnings list');
    }
    
    static testMethod void TestValidationID_119D3() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
    	oneForm.X23a_Drug_3__c = [select id from NDTRS_Drugs__c where item_code__c= 700 limit 1].id;
    	oneForm.X23b_Route_of_Admin_Drug3__c = '3. Eat/drink';
    	oneForm.X23c_Frequency_of_use_in_last_mth__c = '3. Daily';
    	oneForm.X23d_Age_of_1st_use__c = 20;
    	oneForm.X29a_Preferred_types_of_alcohol_consumed__c = '2. Beer';
    	oneForm.X29b_How_many_drinks_per_occasion__c = 0;
    	oneForm.X29c_Extent_of_drinking_problem__c = '2. Hazardous drinker';
    	oneForm.X29d_Number_of_previous_alcohol_detoxes__c = 1;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_119)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 119 not found in warnings list');
    }
    
    static testMethod void TestValidationID_119D4() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
    	oneForm.X24a_Drug_4__c = [select id from NDTRS_Drugs__c where item_code__c= 700 limit 1].id;
    	oneForm.X24b_Route_of_Admin_Drug4__c = '3. Eat/drink';
    	oneForm.X24c_Frequency_of_use_in_last_mth__c = '3. Daily';
    	oneForm.X24d_Age_of_1st_use__c = 20;
    	oneForm.X29a_Preferred_types_of_alcohol_consumed__c = '2. Beer';
    	oneForm.X29b_How_many_drinks_per_occasion__c = 0;
    	oneForm.X29c_Extent_of_drinking_problem__c = '2. Hazardous drinker';
    	oneForm.X29d_Number_of_previous_alcohol_detoxes__c = 1;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_119)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 119 not found in warnings list');
    }
    
    static testMethod void TestValidationID_119D5() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
    	oneForm.X25a_Drug_5__c = [select id from NDTRS_Drugs__c where item_code__c= 700 limit 1].id;
    	oneForm.X25b_Route_of_Admin_Drug5__c = '3. Eat/drink';
    	oneForm.X25c_Frequency_of_use_in_last_mth__c = '3. Daily';
    	oneForm.X25d_Age_of_1st_use__c = 20;
    	oneForm.X29a_Preferred_types_of_alcohol_consumed__c = '2. Beer';
    	oneForm.X29b_How_many_drinks_per_occasion__c = 0;
    	oneForm.X29c_Extent_of_drinking_problem__c = '2. Hazardous drinker';
    	oneForm.X29d_Number_of_previous_alcohol_detoxes__c = 1;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_119)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 119 not found in warnings list');
    }
    
    static testMethod void TestValidationID_120D1() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X21a_Main_drug__c = [select id from NDTRS_Drugs__c where item_code__c= 700 limit 1].id;
    	oneForm.X21b_Route_of_Admin_Main_drug__c = '3. Eat/drink';
    	oneForm.X21c_Frequency_of_use_in_last_mth__c = '4. No use in past month';
    	oneForm.X21d_Age_at_1st_use__c = 20;
    	oneForm.X29a_Preferred_types_of_alcohol_consumed__c = '2. Beer';
    	oneForm.X29b_How_many_drinks_per_occasion__c = 10;
    	oneForm.X29c_Extent_of_drinking_problem__c = '2. Hazardous drinker';
    	oneForm.X29d_Number_of_previous_alcohol_detoxes__c = 1;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_120)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 120 not found in warnings list');
    }
    
    static testMethod void TestValidationID_120D2() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
    	oneForm.X22a_Drug_2__c = [select id from NDTRS_Drugs__c where item_code__c= 700 limit 1].id;
    	oneForm.X22b_Route_of_Admin_Drug2__c = '3. Eat/drink';
    	oneForm.X22c_Frequency_of_use_in_last_mth__c = '4. No use in past month';
    	oneForm.X22d_Age_of_1st_use__c = 20;
    	oneForm.X29a_Preferred_types_of_alcohol_consumed__c = '2. Beer';
    	oneForm.X29b_How_many_drinks_per_occasion__c = 10;
    	oneForm.X29c_Extent_of_drinking_problem__c = '2. Hazardous drinker';
    	oneForm.X29d_Number_of_previous_alcohol_detoxes__c = 1;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_120)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 120 not found in warnings list');
    }
    
    static testMethod void TestValidationID_120D3() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
    	oneForm.X23a_Drug_3__c = [select id from NDTRS_Drugs__c where item_code__c= 700 limit 1].id;
    	oneForm.X23b_Route_of_Admin_Drug3__c = '3. Eat/drink';
    	oneForm.X23c_Frequency_of_use_in_last_mth__c = '4. No use in past month';
    	oneForm.X23d_Age_of_1st_use__c = 20;
    	oneForm.X29a_Preferred_types_of_alcohol_consumed__c = '2. Beer';
    	oneForm.X29b_How_many_drinks_per_occasion__c = 10;
    	oneForm.X29c_Extent_of_drinking_problem__c = '2. Hazardous drinker';
    	oneForm.X29d_Number_of_previous_alcohol_detoxes__c = 1;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_120)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 120 not found in warnings list');
    }
    
    static testMethod void TestValidationID_120D4() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
    	oneForm.X24a_Drug_4__c = [select id from NDTRS_Drugs__c where item_code__c= 700 limit 1].id;
    	oneForm.X24b_Route_of_Admin_Drug4__c = '3. Eat/drink';
    	oneForm.X24c_Frequency_of_use_in_last_mth__c = '4. No use in past month';
    	oneForm.X24d_Age_of_1st_use__c = 20;
    	oneForm.X29a_Preferred_types_of_alcohol_consumed__c = '2. Beer';
    	oneForm.X29b_How_many_drinks_per_occasion__c = 10;
    	oneForm.X29c_Extent_of_drinking_problem__c = '2. Hazardous drinker';
    	oneForm.X29d_Number_of_previous_alcohol_detoxes__c = 1;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_120)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 120 not found in warnings list');
    }
    
    static testMethod void TestValidationID_120D5() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
    	oneForm.X25a_Drug_5__c = [select id from NDTRS_Drugs__c where item_code__c= 700 limit 1].id;
    	oneForm.X25b_Route_of_Admin_Drug5__c = '3. Eat/drink';
    	oneForm.X25c_Frequency_of_use_in_last_mth__c = '4. No use in past month';
    	oneForm.X25d_Age_of_1st_use__c = 20;
    	oneForm.X29a_Preferred_types_of_alcohol_consumed__c = '2. Beer';
    	oneForm.X29b_How_many_drinks_per_occasion__c = 10;
    	oneForm.X29c_Extent_of_drinking_problem__c = '2. Hazardous drinker';
    	oneForm.X29d_Number_of_previous_alcohol_detoxes__c = 1;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_120)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 120 not found in warnings list');
    }
    
    static testMethod void TestValidationID_121()
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
    	oneForm.X21a_Main_drug__c = [select id from NDTRS_Drugs__c where item_code__c= 131 limit 1].id;
    	oneForm.X21b_Route_of_Admin_Main_drug__c = '3. Eat/drink';
    	oneForm.X21c_Frequency_of_use_in_last_mth__c = '6. 4-6 days per week';
    	oneForm.X21d_Age_at_1st_use__c = 20;
    	oneForm.X22a_Drug_2__c = [select id from NDTRS_Drugs__c where item_code__c=600 limit 1].id;
    	oneForm.X22b_Route_of_Admin_Drug2__c = '3. Eat/drink';
    	oneForm.X22c_Frequency_of_use_in_last_mth__c = '6. 4-6 days per week';
    	oneForm.X22d_Age_of_1st_use__c = 20;
    	oneForm.X23a_Drug_3__c = [select id from NDTRS_Drugs__c where item_code__c=804 limit 1].id;
    	oneForm.X23b_Route_of_Admin_Drug3__c = '3. Eat/drink';
    	oneForm.X23c_Frequency_of_use_in_last_mth__c = '6. 4-6 days per week';
    	oneForm.X23d_Age_of_1st_use__c = 20;
    	oneForm.X24a_Drug_4__c = [select id from NDTRS_Drugs__c where item_code__c=843 limit 1].id;
    	oneForm.X24b_Route_of_Admin_Drug4__c = '3. Eat/drink';
    	oneForm.X24c_Frequency_of_use_in_last_mth__c = '6. 4-6 days per week';
    	oneForm.X24d_Age_of_1st_use__c = 20;
    	oneForm.X25a_Drug_5__c = [select id from NDTRS_Drugs__c where item_code__c=850 limit 1].id;
    	oneForm.X25b_Route_of_Admin_Drug5__c = '3. Eat/drink';
    	oneForm.X25c_Frequency_of_use_in_last_mth__c = '6. 4-6 days per week';
    	oneForm.X25d_Age_of_1st_use__c = 20;
    	oneForm.X29a_Preferred_types_of_alcohol_consumed__c = '2. Beer';
    	oneForm.X29b_How_many_drinks_per_occasion__c = 10;
    	oneForm.X29c_Extent_of_drinking_problem__c = '2. Hazardous drinker';
    	oneForm.X29d_Number_of_previous_alcohol_detoxes__c = 1;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_121)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 121 not found in warnings list');
    }
    
    static testMethod void TestValidationID_124() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
    	oneForm.X21a_Main_drug__c = [select id from NDTRS_Drugs__c where item_code__c= 600 limit 1].id;
    	oneForm.X21b_Route_of_Admin_Main_drug__c = '1. injected';
    	oneForm.X21c_Frequency_of_use_in_last_mth__c = '3. Daily';
    	oneForm.X21d_Age_at_1st_use__c = 50;
    	oneForm.X22a_Drug_2__c = [select id from NDTRS_Drugs__c where item_code__c=612 limit 1].id;
    	oneForm.X22b_Route_of_Admin_Drug2__c = '1. injected';
    	oneForm.X22c_Frequency_of_use_in_last_mth__c = '3. Daily';
    	oneForm.X22d_Age_of_1st_use__c = 50;
    	oneForm.X23a_Drug_3__c = [select id from NDTRS_Drugs__c where item_code__c=613 limit 1].id;
    	oneForm.X23b_Route_of_Admin_Drug3__c = '1. injected';
    	oneForm.X23c_Frequency_of_use_in_last_mth__c = '3. Daily';
    	oneForm.X23d_Age_of_1st_use__c = 50;
    	oneForm.X24a_Drug_4__c = [select id from NDTRS_Drugs__c where item_code__c=688 limit 1].id;
    	oneForm.X24b_Route_of_Admin_Drug4__c = '1. injected';
    	oneForm.X24c_Frequency_of_use_in_last_mth__c = '3. Daily';
    	oneForm.X24d_Age_of_1st_use__c = 50;
    	oneForm.X25a_Drug_5__c = [select id from NDTRS_Drugs__c where item_code__c=588 limit 1].id;
    	oneForm.X25b_Route_of_Admin_Drug5__c = '1. injected';
    	oneForm.X25c_Frequency_of_use_in_last_mth__c = '3. Daily';
    	oneForm.X25d_Age_of_1st_use__c = 50;
    	oneForm.X30a_Ever_injected__c = '1. Yes';
		oneForm.X30b_Age_first_injected__c = 20;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_124)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 124 not found in warnings list');
    }
    
    static testMethod void TestValidationID_125() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
    	oneForm.X21a_Main_drug__c = [select id from NDTRS_Drugs__c where item_code__c= 700 limit 1].id;
    	oneForm.X21b_Route_of_Admin_Main_drug__c = '3. Eat/drink';
    	oneForm.X21c_Frequency_of_use_in_last_mth__c = '3. Daily';
    	oneForm.X21d_Age_at_1st_use__c = 50;
    	oneForm.X22a_Drug_2__c = [select id from NDTRS_Drugs__c where item_code__c=600 limit 1].id;
    	oneForm.X22b_Route_of_Admin_Drug2__c = '1. injected';
    	oneForm.X22c_Frequency_of_use_in_last_mth__c = '3. Daily';
    	oneForm.X22d_Age_of_1st_use__c = 50;
    	oneForm.X23a_Drug_3__c = [select id from NDTRS_Drugs__c where item_code__c=612 limit 1].id;
    	oneForm.X23b_Route_of_Admin_Drug3__c = '1. injected';
    	oneForm.X23c_Frequency_of_use_in_last_mth__c = '3. Daily';
    	oneForm.X23d_Age_of_1st_use__c = 50;
    	oneForm.X24a_Drug_4__c = [select id from NDTRS_Drugs__c where item_code__c=613 limit 1].id;
    	oneForm.X24b_Route_of_Admin_Drug4__c = '1. injected';
    	oneForm.X24c_Frequency_of_use_in_last_mth__c = '3. Daily';
    	oneForm.X24d_Age_of_1st_use__c = 50;
    	oneForm.X25a_Drug_5__c = [select id from NDTRS_Drugs__c where item_code__c=688 limit 1].id;
    	oneForm.X25b_Route_of_Admin_Drug5__c = '1. injected';
    	oneForm.X25c_Frequency_of_use_in_last_mth__c = '3. Daily';
    	oneForm.X25d_Age_of_1st_use__c = 50;
    	oneForm.X30a_Ever_injected__c = '1. Yes';
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_125)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 125 not found in warnings list');
    }
    
    static testMethod void TestValidationID_126() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
    	oneForm.X21a_Main_drug__c = [select id from NDTRS_Drugs__c where item_code__c= 600 limit 1].id;
    	oneForm.X21b_Route_of_Admin_Main_drug__c = '1. injected';
    	oneForm.X21c_Frequency_of_use_in_last_mth__c = '3. Daily';
    	oneForm.X21d_Age_at_1st_use__c = 10;
    	oneForm.X22a_Drug_2__c = [select id from NDTRS_Drugs__c where item_code__c=612 limit 1].id;
    	oneForm.X22b_Route_of_Admin_Drug2__c = '1. injected';
    	oneForm.X22c_Frequency_of_use_in_last_mth__c = '3. Daily';
    	oneForm.X22d_Age_of_1st_use__c = 10;
    	oneForm.X23a_Drug_3__c = [select id from NDTRS_Drugs__c where item_code__c=613 limit 1].id;
    	oneForm.X23b_Route_of_Admin_Drug3__c = '1. injected';
    	oneForm.X23c_Frequency_of_use_in_last_mth__c = '3. Daily';
    	oneForm.X23d_Age_of_1st_use__c = 10;
    	oneForm.X24a_Drug_4__c = [select id from NDTRS_Drugs__c where item_code__c=688 limit 1].id;
    	oneForm.X24b_Route_of_Admin_Drug4__c = '1. injected';
    	oneForm.X24c_Frequency_of_use_in_last_mth__c = '3. Daily';
    	oneForm.X24d_Age_of_1st_use__c = 10;
    	oneForm.X25a_Drug_5__c = [select id from NDTRS_Drugs__c where item_code__c=588 limit 1].id;
    	oneForm.X25b_Route_of_Admin_Drug5__c = '1. injected';
    	oneForm.X25c_Frequency_of_use_in_last_mth__c = '3. Daily';
    	oneForm.X25d_Age_of_1st_use__c = 10;
    	oneForm.X30a_Ever_injected__c = '1. Yes';
		oneForm.X30b_Age_first_injected__c = 10;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_126)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 126 not found in warnings list');
    }
    
    static testMethod void TestValidationID_132() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X30a_Ever_injected__c = '2. No';
    	oneForm.X30c_Frequency_of_injecting__c = '99. Not Known';
    	oneForm.X30d_Ever_shared_needle_and_syringes__c = '1. Shared in the last 30 days';
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_132)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 132 not found in warnings list');
    }
    
    static testMethod void TestValidationID_141() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X30e_Ever_shared_other_drug_paraphernali__c = null;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_141)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 141 not found in warnings list');
    }
    
    static testMethod void TestValidationID_146_1() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X32b1_Date_started__c = system.today()-161;
    	oneForm.X32c1_Date_of_last_visit__c = system.today()-161;
    	oneForm.X32d1_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_146_1)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 146_1 not found in warnings list');
    }
    
    static testMethod void TestValidationID_146_1b() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X32b1_Date_started__c = system.today()-161;
    	oneForm.X32c1_Date_of_last_visit__c = system.today()-158;
    	oneForm.X32d1_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_146_1)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 146_1 not found in warnings list');
    }
    
    static testMethod void TestValidationID_146_2() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X32b2_Date_started__c = system.today()-161;
    	oneForm.X32c2_Date_of_last_visit__c = system.today()-161;
    	oneForm.X32d2_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_146_2)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 146_2 not found in warnings list');
    }
    
    static testMethod void TestValidationID_146_2b() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X32b2_Date_started__c = system.today()-161;
    	oneForm.X32c2_Date_of_last_visit__c = system.today()-158;
    	oneForm.X32d2_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_146_2)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 146_2 not found in warnings list');
    }
    
    static testMethod void TestValidationID_146_3() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X32b3_Date_started__c = system.today()-161;
    	oneForm.X32c3_Date_of_last_visit__c = system.today()-161;
    	oneForm.X32d3_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_146_3)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 146_3 not found in warnings list');
    }
    
    static testMethod void TestValidationID_146_3b() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X32b3_Date_started__c = system.today()-161;
    	oneForm.X32c3_Date_of_last_visit__c = system.today()-158;
    	oneForm.X32d3_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_146_3)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 146_3 not found in warnings list');
    }
    
    static testMethod void TestValidationID_146_4() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X32b4_Date_started__c = system.today()-161;
    	oneForm.X32c4_Date_of_last_visit__c = system.today()-161;
    	oneForm.X32d4_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_146_4)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 146_4 not found in warnings list');
    }
    
    static testMethod void TestValidationID_146_4b() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X32b4_Date_started__c = system.today()-161;
    	oneForm.X32c4_Date_of_last_visit__c = system.today()-158;
    	oneForm.X32d4_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_146_4)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 146_4 not found in warnings list');
    }
    
   static testMethod void TestValidationID_146_5() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X32b5_Date_started__c = system.today()-161;
    	oneForm.X32c5_Date_of_last_visit__c = system.today()-161;
    	oneForm.X32d5_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_146_5)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 146_5 not found in warnings list');
    }
    
    static testMethod void TestValidationID_146_5b() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X32b5_Date_started__c = system.today()-161;
    	oneForm.X32c5_Date_of_last_visit__c = system.today()-158;
    	oneForm.X32d5_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_146_5)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 146_5 not found in warnings list');
    }
    
    static testMethod void TestValidationID_146_6() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X32b6_Date_started__c = system.today()-161;
    	oneForm.X32c6_Date_of_last_visit__c = system.today()-161;
    	oneForm.X32d6_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_146_6)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 146_6 not found in warnings list');
    }
    
    static testMethod void TestValidationID_146_6b() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X32b6_Date_started__c = system.today()-161;
    	oneForm.X32c6_Date_of_last_visit__c = system.today()-158;
    	oneForm.X32d6_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_146_6)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 146_6 not found in warnings list');
    }
    
    static testMethod void TestValidationID_146_7() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X32b7_Date_started__c = system.today()-161;
    	oneForm.X32c7_Date_of_last_visit__c = system.today()-161;
    	oneForm.X32d7_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_146_7)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 146_7 not found in warnings list');
    }
    
    static testMethod void TestValidationID_146_7b() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X32b7_Date_started__c = system.today()-161;
    	oneForm.X32c7_Date_of_last_visit__c = system.today()-158;
    	oneForm.X32d7_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_146_7)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 146_7 not found in warnings list');
    }
    
    static testMethod void TestValidationID_146_8() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X32b8_Date_started__c = system.today()-161;
    	oneForm.X32c8_Date_of_last_visit__c = system.today()-161;
    	oneForm.X32d8_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_146_8)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 146_8 not found in warnings list');
    }
    
     static testMethod void TestValidationID_146_8b() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X32b8_Date_started__c = system.today()-161;
    	oneForm.X32c8_Date_of_last_visit__c = system.today()-158;
    	oneForm.X32d8_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_146_8)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 146_8 not found in warnings list');
    }
    
    static testMethod void TestValidationID_146_9() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X32b9_Date_started__c = system.today()-161;
    	oneForm.X32c9_Date_of_last_visit__c = system.today()-161;
    	oneForm.X32d9_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_146_9)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 146_9 not found in warnings list');
    }
    
    static testMethod void TestValidationID_146_9b() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X32b9_Date_started__c = system.today()-161;
    	oneForm.X32c9_Date_of_last_visit__c = system.today()-158;
    	oneForm.X32d9_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_146_9)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 146_9 not found in warnings list');
    }
    
    static testMethod void TestValidationID_146_10() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X32b10_Date_started__c = system.today()-161;
    	oneForm.X32c10_Date_of_last_visit__c = system.today()-161;
    	oneForm.X32d10_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_146_10)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 146_10 not found in warnings list');
    }
    
    static testMethod void TestValidationID_146_10b() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X32b10_Date_started__c = system.today()-161;
    	oneForm.X32c10_Date_of_last_visit__c = system.today()-158;
    	oneForm.X32d10_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_146_10)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 146_10 not found in warnings list');
    }
    
    static testMethod void TestValidationID_146_11() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X32b11_Date_started__c = system.today()-161;
    	oneForm.X32c11_Date_of_last_visit__c = system.today()-161;
    	oneForm.X32d11_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_146_11)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 146_11 not found in warnings list');
    }
    
    static testMethod void TestValidationID_146_11b() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X32b11_Date_started__c = system.today()-161;
    	oneForm.X32c11_Date_of_last_visit__c = system.today()-158;
    	oneForm.X32d11_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_146_11)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 146_11 not found in warnings list');
    }
    
    static testMethod void TestValidationID_146_12() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X32b12_Date_started__c = system.today()-161;
    	oneForm.X32c12_Date_of_last_visit__c = system.today()-161;
    	oneForm.X32d12_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_146_12)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 146_12 not found in warnings list');
    }
    
    static testMethod void TestValidationID_146_12b() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X32b12_Date_started__c = system.today()-161;
    	oneForm.X32c12_Date_of_last_visit__c = system.today()-158;
    	oneForm.X32d12_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_146_12)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 146_12 not found in warnings list');
    }
    
    static testMethod void TestValidationID_146_13() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X32b13_Date_started__c = system.today()-161;
    	oneForm.X32c13_Date_of_last_visit__c = system.today()-161;
    	oneForm.X32d13_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_146_13)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 146_13 not found in warnings list');
    }
    
        static testMethod void TestValidationID_146_13b() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X32b13_Date_started__c = system.today()-161;
    	oneForm.X32c13_Date_of_last_visit__c = system.today()-158;
    	oneForm.X32d13_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_146_13)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 146_13 not found in warnings list');
    }
    
    static testMethod void TestValidationID_146_14() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X32b14_Date_started__c = system.today()-161;
    	oneForm.X32c14_Date_of_last_visit__c = system.today()-161;
    	oneForm.X32d14_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_146_14)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 146_14 not found in warnings list');
    }
    
        static testMethod void TestValidationID_146_14b() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X32b14_Date_started__c = system.today()-161;
    	oneForm.X32c14_Date_of_last_visit__c = system.today()-158;
    	oneForm.X32d14_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_146_14)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 146_14 not found in warnings list');
    }
    
    static testMethod void TestValidationID_146_15() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X32b15_Date_started__c = system.today()-161;
    	oneForm.X32c15_Date_of_last_visit__c = system.today()-161;
    	oneForm.X32d15_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_146_15)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 146_15 not found in warnings list');
    }
    
        static testMethod void TestValidationID_146_15b() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X32b15_Date_started__c = system.today()-161;
    	oneForm.X32c15_Date_of_last_visit__c = system.today()-158;
    	oneForm.X32d15_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_146_15)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 146_15 not found in warnings list');
    }
    
    static testMethod void TestValidationID_146_16() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X32b16_Date_started__c = system.today()-161;
    	oneForm.X32c16_Date_of_last_visit__c = system.today()-161;
    	oneForm.X32d16_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_146_16)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 146_16 not found in warnings list');
    }
    
        static testMethod void TestValidationID_146_16b() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X32b16_Date_started__c = system.today()-161;
    	oneForm.X32c16_Date_of_last_visit__c = system.today()-158;
    	oneForm.X32d16_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_146_16)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 146_16 not found in warnings list');
    }
    
    static testMethod void TestValidationID_146_17() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X32b17_Date_started__c = system.today()-161;
    	oneForm.X32c17_Date_of_last_visit__c = system.today()-161;
    	oneForm.X32d17_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_146_17)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 146_17 not found in warnings list');
    }
    
    static testMethod void TestValidationID_146_17b() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X32b17_Date_started__c = system.today()-161;
    	oneForm.X32c17_Date_of_last_visit__c = system.today()-158;
    	oneForm.X32d17_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_146_17)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 146_17 not found in warnings list');
    }
    
    static testMethod void TestValidationID_146_18() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X32b18_Date_started__c = system.today()-161;
    	oneForm.X32c18_Date_of_last_visit__c = system.today()-161;
    	oneForm.X32d18_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_146_18)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 146_18 not found in warnings list');
    }
    
    static testMethod void TestValidationID_146_18b() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X32b18_Date_started__c = system.today()-161;
    	oneForm.X32c18_Date_of_last_visit__c = system.today()-158;
    	oneForm.X32d18_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_146_18)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 146_18 not found in warnings list');
    }
    
    static testMethod void TestValidationID_146_19() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X32b19_Date_started__c = system.today()-161;
    	oneForm.X32c19_Date_of_last_visit__c = system.today()-161;
    	oneForm.X32d19_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_146_19)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 146_19 not found in warnings list');
    }
    
    static testMethod void TestValidationID_146_19b() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X32b19_Date_started__c = system.today()-161;
    	oneForm.X32c19_Date_of_last_visit__c = system.today()-158;
    	oneForm.X32d19_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_146_19)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 146_19 not found in warnings list');
    }
    
    static testMethod void TestValidationID_146_20() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X32b20_Date_started__c = system.today()-161;
    	oneForm.X32c20_Date_of_last_visit__c = system.today()-161;
    	oneForm.X32d20_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_146_20)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 146_20 not found in warnings list');
    }
    
    static testMethod void TestValidationID_146_20b() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X32b20_Date_started__c = system.today()-161;
    	oneForm.X32c20_Date_of_last_visit__c = system.today()-158;
    	oneForm.X32d20_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_146_20)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 146_20 not found in warnings list');
    }
    
    static testMethod void TestValidationID_146_21() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X32b21_Date_started__c = system.today()-161;
    	oneForm.X32c21_Date_of_last_visit__c = system.today()-161;
    	oneForm.X32d21_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_146_21)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 146_21 not found in warnings list');
    }
    
    static testMethod void TestValidationID_146_21b() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X32b21_Date_started__c = system.today()-161;
    	oneForm.X32c21_Date_of_last_visit__c = system.today()-158;
    	oneForm.X32d21_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_146_21)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 146_21 not found in warnings list');
    }
    
    static testMethod void TestValidationID_146_22() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X32b22_Date_started__c = system.today()-161;
    	oneForm.X32c22_Date_of_last_visit__c = system.today()-161;
    	oneForm.X32d22_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_146_22)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 146_22 not found in warnings list');
    }
    
    static testMethod void TestValidationID_146_22b() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X32b22_Date_started__c = system.today()-161;
    	oneForm.X32c22_Date_of_last_visit__c = system.today()-158;
    	oneForm.X32d22_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_146_22)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 146_22 not found in warnings list');
    }
    
    static testMethod void TestValidationID_146_23() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X32b23_Date_started__c = system.today()-161;
    	oneForm.X32c23_Date_of_last_visit__c = system.today()-161;
    	oneForm.X32d23_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_146_23)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 146_23 not found in warnings list');
    }
    
	static testMethod void TestValidationID_146_23b() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X32b23_Date_started__c = system.today()-161;
    	oneForm.X32c23_Date_of_last_visit__c = system.today()-158;
    	oneForm.X32d23_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_146_23)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 146_23 not found in warnings list');
    }
    
    static testMethod void TestValidationID_146_24() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X32b24_Date_started__c = system.today()-161;
    	oneForm.X32c24_Date_of_last_visit__c = system.today()-161;
    	oneForm.X32d24_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_146_24)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 146_24 not found in warnings list');
    }
    
	static testMethod void TestValidationID_146_24b() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X32b24_Date_started__c = system.today()-161;
    	oneForm.X32c24_Date_of_last_visit__c = system.today()-158;
    	oneForm.X32d24_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_146_24)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 146_24 not found in warnings list');
    }
    
    static testMethod void TestValidationID_146_25() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X32b25_Date_started__c = system.today()-161;
    	oneForm.X32c25_Date_of_last_visit__c = system.today()-161;
    	oneForm.X32d25_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_146_25)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 146_25 not found in warnings list');
    }
    
	static testMethod void TestValidationID_146_25b() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X32b25_Date_started__c = system.today()-161;
    	oneForm.X32c25_Date_of_last_visit__c = system.today()-158;
    	oneForm.X32d25_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_146_25)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 146_25 not found in warnings list');
    }
    
    static testMethod void TestValidationID_146_27() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X32b27_Date_started__c = system.today()-161;
    	oneForm.X32c27_Date_of_last_visit__c = system.today()-161;
    	oneForm.X32d27_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_146_27)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 146_27 not found in warnings list');
    }
    
    static testMethod void TestValidationID_146_27b() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X32b27_Date_started__c = system.today()-161;
    	oneForm.X32c27_Date_of_last_visit__c = system.today()-158;
    	oneForm.X32d27_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_146_27)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 146_27 not found in warnings list');
    }
    
    static testMethod void TestValidationID_146_28() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X32b28_Date_started__c = system.today()-161;
    	oneForm.X32c28_Date_of_last_visit__c = system.today()-161;
    	oneForm.X32d28_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_146_28)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 146_28 not found in warnings list');
    }
    
	static testMethod void TestValidationID_146_28b() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-200, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X32b28_Date_started__c = system.today()-161;
    	oneForm.X32c28_Date_of_last_visit__c = system.today()-158;
    	oneForm.X32d28_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_146_28)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 146_28 not found in warnings list');
    }
    
    static testMethod void TestValidationID_147_1() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b1_Date_started__c = system.today()-370;
    	oneForm.X32c1_Date_of_last_visit__c = system.today()-1;
    	oneForm.X32d1_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_147_1)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 147_1 not found in warnings list');
    }
    
    
    static testMethod void TestValidationID_147_2() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b2_Date_started__c = system.today()-370;
    	oneForm.X32c2_Date_of_last_visit__c = system.today()-1;
    	oneForm.X32d2_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_147_2)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 147_2 not found in warnings list');
    }
    
    static testMethod void TestValidationID_147_3() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b3_Date_started__c = system.today()-370;
    	oneForm.X32c3_Date_of_last_visit__c = system.today()-1;
    	oneForm.X32d3_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_147_3)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 147_3 not found in warnings list');
    }
    
    static testMethod void TestValidationID_147_4() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b4_Date_started__c = system.today()-370;
    	oneForm.X32c4_Date_of_last_visit__c = system.today()-1;
    	oneForm.X32d4_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_147_4)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 147_4 not found in warnings list');
    }
    
    static testMethod void TestValidationID_147_5() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b5_Date_started__c = system.today()-370;
    	oneForm.X32c5_Date_of_last_visit__c = system.today()-1;
    	oneForm.X32d5_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_147_5)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 147_5 not found in warnings list');
    }
    
    static testMethod void TestValidationID_147_6() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b6_Date_started__c = system.today()-370;
    	oneForm.X32c6_Date_of_last_visit__c = system.today()-1;
    	oneForm.X32d6_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_147_6)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 147_6 not found in warnings list');
    }
    
    static testMethod void TestValidationID_147_7() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b7_Date_started__c = system.today()-370;
    	oneForm.X32c7_Date_of_last_visit__c = system.today()-1;
    	oneForm.X32d7_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_147_7)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 147_7 not found in warnings list');
    }
    
    static testMethod void TestValidationID_147_8() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b8_Date_started__c = system.today()-370;
    	oneForm.X32c8_Date_of_last_visit__c = system.today()-1;
    	oneForm.X32d8_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_147_8)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 147_8 not found in warnings list');
    }
    
    static testMethod void TestValidationID_147_9() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b9_Date_started__c = system.today()-370;
    	oneForm.X32c9_Date_of_last_visit__c = system.today()-1;
    	oneForm.X32d9_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_147_9)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 147_9 not found in warnings list');
    }
    
    static testMethod void TestValidationID_147_10() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b10_Date_started__c = system.today()-370;
    	oneForm.X32c10_Date_of_last_visit__c = system.today()-1;
    	oneForm.X32d10_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_147_10)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 147_10 not found in warnings list');
    }
    
    static testMethod void TestValidationID_147_11() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b11_Date_started__c = system.today()-370;
    	oneForm.X32c11_Date_of_last_visit__c = system.today()-1;
    	oneForm.X32d11_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_147_11)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 147_11 not found in warnings list');
    }
    
    static testMethod void TestValidationID_147_12() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b12_Date_started__c = system.today()-370;
    	oneForm.X32c12_Date_of_last_visit__c = system.today()-1;
    	oneForm.X32d12_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_147_12)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 147_12 not found in warnings list');
    }
    
    static testMethod void TestValidationID_147_13() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b13_Date_started__c = system.today()-370;
    	oneForm.X32c13_Date_of_last_visit__c = system.today()-1;
    	oneForm.X32d13_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_147_13)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 147_13 not found in warnings list');
    }
    
    static testMethod void TestValidationID_147_14() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b14_Date_started__c = system.today()-370;
    	oneForm.X32c14_Date_of_last_visit__c = system.today()-1;
    	oneForm.X32d14_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_147_14)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 147_14 not found in warnings list');
    }
    
    static testMethod void TestValidationID_147_15() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b15_Date_started__c = system.today()-370;
    	oneForm.X32c15_Date_of_last_visit__c = system.today()-1;
    	oneForm.X32d15_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_147_15)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 147_15 not found in warnings list');
    }
    
    static testMethod void TestValidationID_147_16() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b16_Date_started__c = system.today()-370;
    	oneForm.X32c16_Date_of_last_visit__c = system.today()-1;
    	oneForm.X32d16_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_147_16)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 147_16 not found in warnings list');
    }
    
    static testMethod void TestValidationID_147_17() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b17_Date_started__c = system.today()-370;
    	oneForm.X32c17_Date_of_last_visit__c = system.today()-1;
    	oneForm.X32d17_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_147_17)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 147_17 not found in warnings list');
    }
    
    static testMethod void TestValidationID_147_18() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b18_Date_started__c = system.today()-370;
    	oneForm.X32c18_Date_of_last_visit__c = system.today()-1;
    	oneForm.X32d18_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_147_18)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 147_18 not found in warnings list');
    }
    
    static testMethod void TestValidationID_147_19() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b19_Date_started__c = system.today()-370;
    	oneForm.X32c19_Date_of_last_visit__c = system.today()-1;
    	oneForm.X32d19_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_147_19)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 147_19 not found in warnings list');
    }
    
    static testMethod void TestValidationID_147_20() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b20_Date_started__c = system.today()-370;
    	oneForm.X32c20_Date_of_last_visit__c = system.today()-1;
    	oneForm.X32d20_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_147_20)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 147_20 not found in warnings list');
    }
    
    static testMethod void TestValidationID_147_21() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b21_Date_started__c = system.today()-370;
    	oneForm.X32c21_Date_of_last_visit__c = system.today()-1;
    	oneForm.X32d21_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_147_21)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 147_21 not found in warnings list');
    }
    
    static testMethod void TestValidationID_147_22() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b22_Date_started__c = system.today()-370;
    	oneForm.X32c22_Date_of_last_visit__c = system.today()-1;
    	oneForm.X32d22_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_147_22)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 147_22 not found in warnings list');
    }
    
    static testMethod void TestValidationID_147_23() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b23_Date_started__c = system.today()-370;
    	oneForm.X32c23_Date_of_last_visit__c = system.today()-1;
    	oneForm.X32d23_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_147_23)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 147_23 not found in warnings list');
    }
    
    static testMethod void TestValidationID_147_24() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b24_Date_started__c = system.today()-370;
    	oneForm.X32c24_Date_of_last_visit__c = system.today()-1;
    	oneForm.X32d24_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_147_24)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 147_24 not found in warnings list');
    }
    
    static testMethod void TestValidationID_147_25() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b25_Date_started__c = system.today()-370;
    	oneForm.X32c25_Date_of_last_visit__c = system.today()-1;
    	oneForm.X32d25_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_147_25)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 147_25 not found in warnings list');
    }
    
    static testMethod void TestValidationID_147_27() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b27_Date_started__c = system.today()-370;
    	oneForm.X32c27_Date_of_last_visit__c = system.today()-1;
    	oneForm.X32d27_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_147_27)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 147_27 not found in warnings list');
    }
    
    static testMethod void TestValidationID_147_28() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b28_Date_started__c = system.today()-370;
    	oneForm.X32c28_Date_of_last_visit__c = system.today()-1;
    	oneForm.X32d28_Number_of_sessions__c = 120;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_147_28)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 147_28 not found in warnings list');
    }
    
    static testMethod void TestValidationID_148_DA() //Detox Alcohol, Drug to Assist the detoxification process must be entered
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X21a_Main_drug__c = [select id from NDTRS_Drugs__c where item_code__c= 700 limit 1].id;
    	oneForm.X21b_Route_of_Admin_Main_drug__c = '3. Eat/drink';
    	oneForm.X21c_Frequency_of_use_in_last_mth__c = '3. Daily';
    	oneForm.X21d_Age_at_1st_use__c = 20;
    	oneForm.X29a_Preferred_types_of_alcohol_consumed__c = '2. Beer';
    	oneForm.X29b_How_many_drinks_per_occasion__c = 4;
    	oneForm.X29c_Extent_of_drinking_problem__c = '2. Hazardous drinker';
    	oneForm.X29d_Number_of_previous_alcohol_detoxes__c = 1;
    	oneForm.X32b17_Date_started__c = system.today()-370;
    	oneForm.X32c17_Date_of_last_visit__c = system.today()-370;
    	oneForm.X32d17_Number_of_sessions__c = 1;
    	oneForm.Assist_Alcohol_Detox1__c = null;
    	oneForm.Assist_Alcohol_Detox2__c = null;
    	oneForm.Assist_Alcohol_Detox3__c = null;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_148_DA)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 148 not found in warnings list');
    }
    
    static testMethod void TestValidationID_148_DH() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
    	oneForm.X21a_Main_drug__c = [select id from NDTRS_Drugs__c where item_code__c=111 limit 1].id;
    	oneForm.X32b18_Date_started__c = system.today()-370;
    	oneForm.X32c18_Date_of_last_visit__c = system.today()-370;
    	oneForm.X32d18_Number_of_sessions__c = 1;
    	oneForm.Assist_Heroin_Detox1__c = null; 
    	oneForm.Assist_Heroin_Detox2__c = null;
    	oneForm.Assist_Heroin_Detox3__c = null;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_148_DH)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 148 not found in warnings list');
    }
    
    static testMethod void TestValidationID_148_DM() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
    	oneForm.X21a_Main_drug__c = [select id from NDTRS_Drugs__c where item_code__c=161 limit 1].id;
    	oneForm.X32b19_Date_started__c = system.today()-370;
    	oneForm.X32c19_Date_of_last_visit__c = system.today()-370;
    	oneForm.X32d19_Number_of_sessions__c = 1;
    	oneForm.Assist_Methadone_Detox1__c = null; 
    	oneForm.Assist_Methadone_Detox2__c = null;
    	oneForm.Assist_Methadone_Detox3__c = null;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_148_DM)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 148 not found in warnings list');
    }
    
    static testMethod void TestValidationID_148_DB_1() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
    	oneForm.X21a_Main_drug__c = [select id from NDTRS_Drugs__c where item_code__c=320 limit 1].id;
    	oneForm.X32b20_Date_started__c = null;
    	oneForm.X32c20_Date_of_last_visit__c = null;
    	oneForm.X32d20_Number_of_sessions__c = 0;
    	oneForm.Assist_Benzo_Detox1__c = null; 
    	oneForm.Assist_Benzo_Detox2__c = null;
    	oneForm.Assist_Benzo_Detox3__c = null;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_148_DB)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 148 not found in warnings list');
    }
    
    static testMethod void TestValidationID_148_DB_2() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
    	oneForm.X21a_Main_drug__c = [select id from NDTRS_Drugs__c where item_code__c=320 limit 1].id;
    	oneForm.X32b20_Date_started__c = system.today()-370;
    	oneForm.X32c20_Date_of_last_visit__c = null;
    	oneForm.X32d20_Number_of_sessions__c = 0;
    	oneForm.Assist_Benzo_Detox1__c = null; 
    	oneForm.Assist_Benzo_Detox2__c = null;
    	oneForm.Assist_Benzo_Detox3__c = null;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_148_DB)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 148 not found in warnings list');
    }
    
    static testMethod void TestValidationID_148_DZ_1() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
    	oneForm.X21a_Main_drug__c = [select id from NDTRS_Drugs__c where item_code__c=318 limit 1].id;
    	oneForm.X32b21_Date_started__c = null;
    	oneForm.X32c21_Date_of_last_visit__c = null;
    	oneForm.X32d21_Number_of_sessions__c = 0;
    	oneForm.Assist_Benzo_Detox1__c = null; 
    	oneForm.Assist_Benzo_Detox2__c = null;
    	oneForm.Assist_Benzo_Detox3__c = null;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_148_DZ)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 148 not found in warnings list');
    }
    
    static testMethod void TestValidationID_148_DZ_2() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
    	oneForm.X21a_Main_drug__c = [select id from NDTRS_Drugs__c where item_code__c=318 limit 1].id;
    	oneForm.X32b21_Date_started__c = system.today()-370;
    	oneForm.X32c21_Date_of_last_visit__c = system.today()-370;
    	oneForm.X32d21_Number_of_sessions__c = 1;
    	oneForm.Assist_Benzo_Detox1__c = null; 
    	oneForm.Assist_Benzo_Detox2__c = null;
    	oneForm.Assist_Benzo_Detox3__c = null;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_148_DZ)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 148 not found in warnings list');
    }
    
    static testMethod void TestValidationID_149() // Alcohol Detox
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
		oneForm.X21a_Main_drug__c = [select id from NDTRS_Drugs__c where item_code__c=131 limit 1].id;
    	oneForm.X22a_Drug_2__c = [select id from NDTRS_Drugs__c where item_code__c=132 limit 1].id;
		oneForm.X23a_Drug_3__c = [select id from NDTRS_Drugs__c where item_code__c=133 limit 1].id;
		oneForm.X24a_Drug_4__c = [select id from NDTRS_Drugs__c where item_code__c=140 limit 1].id;
		oneForm.X25a_Drug_5__c = [select id from NDTRS_Drugs__c where item_code__c=141 limit 1].id;
    	oneForm.X32b17_Date_started__c = system.today()-370;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_149)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 149 not found in warnings list');
    }
    
/*    static testMethod void TestValidationID_149B() // Alcohol Detox B
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
		oneForm.X21a_Main_drug__c = [select id from NDTRS_Drugs__c where item_code__c=700 limit 1].id;
    	oneForm.X22a_Drug_2__c = [select id from NDTRS_Drugs__c where item_code__c=132 limit 1].id;
		oneForm.X23a_Drug_3__c = [select id from NDTRS_Drugs__c where item_code__c=133 limit 1].id;
		oneForm.X24a_Drug_4__c = [select id from NDTRS_Drugs__c where item_code__c=140 limit 1].id;
		oneForm.X25a_Drug_5__c = [select id from NDTRS_Drugs__c where item_code__c=141 limit 1].id;
    	oneForm.X32b17_Date_started__c = system.today()-370;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_149)
        	{
         system.assert (false, 'Warning for 149 found in warnings list');
       		return; // warning found
        	}
        }
    }
 */   
    static testMethod void TestValidationID_150() // Detox heroin
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
		oneForm.X21a_Main_drug__c = [select id from NDTRS_Drugs__c where item_code__c=131 limit 1].id;
    	oneForm.X22a_Drug_2__c = [select id from NDTRS_Drugs__c where item_code__c=132 limit 1].id;
		oneForm.X23a_Drug_3__c = [select id from NDTRS_Drugs__c where item_code__c=133 limit 1].id;
		oneForm.X24a_Drug_4__c = [select id from NDTRS_Drugs__c where item_code__c=140 limit 1].id;
		oneForm.X25a_Drug_5__c = [select id from NDTRS_Drugs__c where item_code__c=141 limit 1].id;
    	oneForm.X32b18_Date_started__c = system.today()-370;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_150)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 150 not found in warnings list');
    }
    
    static testMethod void TestValidationID_151() // Detox methadone
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
		oneForm.X21a_Main_drug__c = [select id from NDTRS_Drugs__c where item_code__c=843015 limit 1].id;
    	oneForm.X22a_Drug_2__c = [select id from NDTRS_Drugs__c where item_code__c=843100 limit 1].id;
		oneForm.X23a_Drug_3__c = [select id from NDTRS_Drugs__c where item_code__c=864101 limit 1].id;
		oneForm.X24a_Drug_4__c = [select id from NDTRS_Drugs__c where item_code__c=864102 limit 1].id;
		oneForm.X25a_Drug_5__c = [select id from NDTRS_Drugs__c where item_code__c=864103 limit 1].id;
    	oneForm.X32b19_Date_started__c = system.today()-370;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
            system.debug('Message: ' + oneMsg.errorMsg);
        	if (oneMsg.errorMsg == label.NDTRS_Rule_151)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 151 not found in warnings list');
    }
    
    static testMethod void TestValidationID_152() // Detox Benzodiazepines
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
		oneForm.X21a_Main_drug__c = [select id from NDTRS_Drugs__c where item_code__c=843015 limit 1].id;
    	oneForm.X22a_Drug_2__c = [select id from NDTRS_Drugs__c where item_code__c=843100 limit 1].id;
		oneForm.X23a_Drug_3__c = [select id from NDTRS_Drugs__c where item_code__c=847102 limit 1].id;
		oneForm.X24a_Drug_4__c = [select id from NDTRS_Drugs__c where item_code__c=847105 limit 1].id;
		oneForm.X25a_Drug_5__c = [select id from NDTRS_Drugs__c where item_code__c=847107 limit 1].id;
    	oneForm.X32b20_Date_started__c = system.today()-370;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_152)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 152 not found in warnings list');
    }
    
    static testMethod void TestValidationID_153() // Detox Z drugs
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
		oneForm.X21a_Main_drug__c = [select id from NDTRS_Drugs__c where item_code__c=131 limit 1].id;
    	oneForm.X22a_Drug_2__c = [select id from NDTRS_Drugs__c where item_code__c=132 limit 1].id;
		oneForm.X23a_Drug_3__c = [select id from NDTRS_Drugs__c where item_code__c=133 limit 1].id;
		oneForm.X24a_Drug_4__c = [select id from NDTRS_Drugs__c where item_code__c=140 limit 1].id;
		oneForm.X25a_Drug_5__c = [select id from NDTRS_Drugs__c where item_code__c=141 limit 1].id;
    	oneForm.X32b21_Date_started__c = system.today()-370;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_153)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 153 not found in warnings list');
    }
    
     static testMethod void TestValidationID_155() // Detox Drugs must be listed as problem drugs.
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
		oneForm.X21a_Main_drug__c = [select id from NDTRS_Drugs__c where item_code__c=131 limit 1].id;
    	oneForm.X22a_Drug_2__c = [select id from NDTRS_Drugs__c where item_code__c=132 limit 1].id;
		oneForm.X23a_Drug_3__c = [select id from NDTRS_Drugs__c where item_code__c=133 limit 1].id;
		oneForm.X24a_Drug_4__c = [select id from NDTRS_Drugs__c where item_code__c=140 limit 1].id;
		oneForm.X25a_Drug_5__c = [select id from NDTRS_Drugs__c where item_code__c=141 limit 1].id;
		oneForm.X32a22_Detox_from_other_drug_Specify__c = [select id from NDTRS_Drugs__c where item_code__c=211 limit 1].id;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_155)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 155 not found in warnings list');
    }
    
    static testMethod void TestValidationID_156() // Opiate Substitution and no opiate
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
		oneForm.X21a_Main_drug__c = [select id from NDTRS_Drugs__c where item_code__c=843015 limit 1].id;
    	oneForm.X22a_Drug_2__c = [select id from NDTRS_Drugs__c where item_code__c=843100 limit 1].id;
		oneForm.X23a_Drug_3__c = [select id from NDTRS_Drugs__c where item_code__c=847102 limit 1].id;
		oneForm.X24a_Drug_4__c = [select id from NDTRS_Drugs__c where item_code__c=847105 limit 1].id;
		oneForm.X25a_Drug_5__c = [select id from NDTRS_Drugs__c where item_code__c=847107 limit 1].id;
    	oneForm.X32b15_Date_started__c = system.today()-370;
    	oneForm.X32b16_Date_started__c = system.today()-370;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_156)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 156 not found in warnings list');
    }
    
    static testMethod void TestValidationID_157() // Opiate Substitution and Opiate Detox, Dates should run concurrently
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b15_Date_started__c = system.today()-370;
    	oneForm.X32b16_Date_started__c = system.today()-369;
    	oneForm.X32b18_Date_started__c = system.today()-368;
    	oneForm.X32b19_Date_started__c = system.today()-367;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_157)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 157 not found in warnings list');
    }
    
     static testMethod void TestValidationID_158() // Opiate Substitution and Medication Free, Dates should run concurrently
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b15_Date_started__c = system.today()-370;
    	oneForm.X32b16_Date_started__c = system.today()-369;
    	oneForm.X32b6_Date_started__c = system.today()-368;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_158)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 158 not found in warnings list');
    }
    
    static testMethod void TestValidationID_163_1() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b1_Date_started__c = system.today()-370;
    	oneForm.X32c1_Date_of_last_visit__c = system.today()-310;
    	oneForm.X32d1_Number_of_sessions__c = 1;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_163_1)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 163_1 not found in warnings list');
    }
    
    static testMethod void TestValidationID_163_2() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b2_Date_started__c = system.today()-370;
    	oneForm.X32c2_Date_of_last_visit__c = system.today()-310;
    	oneForm.X32d2_Number_of_sessions__c = 1;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_163_2)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 163_2 not found in warnings list');
    }
    
    static testMethod void TestValidationID_163_3() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b3_Date_started__c = system.today()-370;
    	oneForm.X32c3_Date_of_last_visit__c = system.today()-310;
    	oneForm.X32d3_Number_of_sessions__c = 1;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_163_3)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 163_3 not found in warnings list');
    }
    
    static testMethod void TestValidationID_163_4() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b4_Date_started__c = system.today()-370;
    	oneForm.X32c4_Date_of_last_visit__c = system.today()-310;
    	oneForm.X32d4_Number_of_sessions__c = 1;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_163_4)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 163_4 not found in warnings list');
    }
    
    static testMethod void TestValidationID_163_5() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b5_Date_started__c = system.today()-370;
    	oneForm.X32c5_Date_of_last_visit__c = system.today()-310;
    	oneForm.X32d5_Number_of_sessions__c = 1;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_163_5)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 163_5 not found in warnings list');
    }
    
    static testMethod void TestValidationID_163_6() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b6_Date_started__c = system.today()-370;
    	oneForm.X32c6_Date_of_last_visit__c = system.today()-310;
    	oneForm.X32d6_Number_of_sessions__c = 1;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_163_6)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 163_6 not found in warnings list');
    }
    
    static testMethod void TestValidationID_163_7() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b7_Date_started__c = system.today()-370;
    	oneForm.X32c7_Date_of_last_visit__c = system.today()-310;
    	oneForm.X32d7_Number_of_sessions__c = 1;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_163_7)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 163_7 not found in warnings list');
    }
    
    static testMethod void TestValidationID_163_8() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b8_Date_started__c = system.today()-370;
    	oneForm.X32c8_Date_of_last_visit__c = system.today()-310;
    	oneForm.X32d8_Number_of_sessions__c = 1;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_163_8)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 163_8 not found in warnings list');
    }
    
    static testMethod void TestValidationID_163_9() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b9_Date_started__c = system.today()-370;
    	oneForm.X32c9_Date_of_last_visit__c = system.today()-310;
    	oneForm.X32d9_Number_of_sessions__c = 1;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_163_9)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 163_9 not found in warnings list');
    }
    
    static testMethod void TestValidationID_163_10() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b10_Date_started__c = system.today()-370;
    	oneForm.X32c10_Date_of_last_visit__c = system.today()-310;
    	oneForm.X32d10_Number_of_sessions__c = 1;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_163_10)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 163_10 not found in warnings list');
    }
    
    static testMethod void TestValidationID_163_11() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b11_Date_started__c = system.today()-370;
    	oneForm.X32c11_Date_of_last_visit__c = system.today()-310;
    	oneForm.X32d11_Number_of_sessions__c = 1;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_163_11)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 163_11 not found in warnings list');
    }
    
    static testMethod void TestValidationID_163_12() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b12_Date_started__c = system.today()-370;
    	oneForm.X32c12_Date_of_last_visit__c = system.today()-310;
    	oneForm.X32d12_Number_of_sessions__c = 1;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_163_12)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 163_12 not found in warnings list');
    }
    
    static testMethod void TestValidationID_163_13() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b13_Date_started__c = system.today()-370;
    	oneForm.X32c13_Date_of_last_visit__c = system.today()-310;
    	oneForm.X32d13_Number_of_sessions__c = 1;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_163_13)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 163_13 not found in warnings list');
    }
    
    static testMethod void TestValidationID_163_14() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b14_Date_started__c = system.today()-370;
    	oneForm.X32c14_Date_of_last_visit__c = system.today()-310;
    	oneForm.X32d14_Number_of_sessions__c = 1;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_163_14)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 163_14 not found in warnings list');
    }
    
    static testMethod void TestValidationID_163_15() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b15_Date_started__c = system.today()-370;
    	oneForm.X32c15_Date_of_last_visit__c = system.today()-310;
    	oneForm.X32d15_Number_of_sessions__c = 1;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_163_15)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 163_15 not found in warnings list');
    }
    
    static testMethod void TestValidationID_163_16() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b16_Date_started__c = system.today()-370;
    	oneForm.X32c16_Date_of_last_visit__c = system.today()-310;
    	oneForm.X32d16_Number_of_sessions__c = 1;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_163_16)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 163_16 not found in warnings list');
    }
    
   static testMethod void TestValidationID_163_17() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b17_Date_started__c = system.today()-370;
    	oneForm.X32c17_Date_of_last_visit__c = system.today()-310;
    	oneForm.X32d17_Number_of_sessions__c = 1;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_163_17)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 163_17 not found in warnings list');
    } 
    
    static testMethod void TestValidationID_163_18() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b18_Date_started__c = system.today()-370;
    	oneForm.X32c18_Date_of_last_visit__c = system.today()-310;
    	oneForm.X32d18_Number_of_sessions__c = 1;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_163_18)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 163_18 not found in warnings list');
    } 
    
    static testMethod void TestValidationID_163_19() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b19_Date_started__c = system.today()-370;
    	oneForm.X32c19_Date_of_last_visit__c = system.today()-310;
    	oneForm.X32d19_Number_of_sessions__c = 1;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_163_19)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 163_19 not found in warnings list');
    } 
    
    static testMethod void TestValidationID_163_20() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b20_Date_started__c = system.today()-370;
    	oneForm.X32c20_Date_of_last_visit__c = system.today()-310;
    	oneForm.X32d20_Number_of_sessions__c = 1;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_163_20)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 163_20 not found in warnings list');
    } 
    
    static testMethod void TestValidationID_163_21() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b21_Date_started__c = system.today()-370;
    	oneForm.X32c21_Date_of_last_visit__c = system.today()-310;
    	oneForm.X32d21_Number_of_sessions__c = 1;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_163_21)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 163_21 not found in warnings list');
    } 
    
    static testMethod void TestValidationID_163_22() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b22_Date_started__c = system.today()-370;
    	oneForm.X32c22_Date_of_last_visit__c = system.today()-310;
    	oneForm.X32d22_Number_of_sessions__c = 1;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_163_22)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 163_22 not found in warnings list');
    } 
    
    static testMethod void TestValidationID_163_23() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b23_Date_started__c = system.today()-370;
    	oneForm.X32c23_Date_of_last_visit__c = system.today()-310;
    	oneForm.X32d23_Number_of_sessions__c = 1;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_163_23)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 163_23 not found in warnings list');
    } 
    
    static testMethod void TestValidationID_163_24() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b24_Date_started__c = system.today()-370;
    	oneForm.X32c24_Date_of_last_visit__c = system.today()-310;
    	oneForm.X32d24_Number_of_sessions__c = 1;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_163_24)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 163_24 not found in warnings list');
    } 
    
    static testMethod void TestValidationID_163_25() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b25_Date_started__c = system.today()-370;
    	oneForm.X32c25_Date_of_last_visit__c = system.today()-310;
    	oneForm.X32d25_Number_of_sessions__c = 1;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_163_25)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 163_25 not found in warnings list');
    } 
    
    static testMethod void TestValidationID_163_27() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b27_Date_started__c = system.today()-370;
    	oneForm.X32c27_Date_of_last_visit__c = system.today()-310;
    	oneForm.X32d27_Number_of_sessions__c = 1;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_163_27)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 163_27 not found in warnings list');
    } 
    
    static testMethod void TestValidationID_163_28() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b28_Date_started__c = system.today()-370;
    	oneForm.X32c28_Date_of_last_visit__c = system.today()-310;
    	oneForm.X32d28_Number_of_sessions__c = 1;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_163_28)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 163_28 not found in warnings list');
    } 
    
    static testMethod void TestValidationID_173() //Number of CP_Family therapy, if dates entered Q32b9, Q32b11 then Q33b can not be = 0
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b9_Date_started__c = system.today()-370;
    	oneForm.X32b11_Date_started__c = system.today()-370;
    	oneForm.X33b_Number_of_others_involved__c = 0;
    	oneForm.X26_Age_first_use_any_drug__c = 20;
    	oneForm.X27_Specify_first_drug_ever_used__c = [select id from NDTRS_Drugs__c where item_code__c=5131 limit 1].id;
    	oneForm.X28_Difficult_to_assess_main_problem__c = '2. No';
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_173)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 173 not found in warnings list');
    } 
    
    static testMethod void TestValidationID_175D1() // Q32 = 12 with opiates (100 to 188) and frequency = 3, 6, 7, 1 at Q21
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100); 
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
		oneForm.X21a_Main_drug__c = [select id from NDTRS_Drugs__c where item_code__c=122 limit 1].id;
		oneForm.X21b_Route_of_Admin_Main_drug__c = '1. Inject';
		oneForm.X21c_Frequency_of_use_in_last_mth__c = '3. Daily';
    	oneForm.X32b6_Date_started__c = system.today()-370;
    	oneForm.X32b15_Date_started__c = null;
    	oneForm.X32b16_Date_started__c = null;
    	oneForm.X32b18_Date_started__c = null;
    	oneForm.X32b19_Date_started__c = null;
    	oneForm.X30a_Ever_injected__c = '1. Yes';
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_175)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 175 not found in warnings list');
    }
    
    static testMethod void TestValidationID_175D2() // Q32 = 12 with opiates (100 to 188) and frequency = 3, 6, 7, 1 at Q22
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100); 
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
		oneForm.X22a_Drug_2__c = [select id from NDTRS_Drugs__c where item_code__c=122 limit 1].id;
		oneForm.X22b_Route_of_Admin_Drug2__c = '1. Inject';
		oneForm.X22c_Frequency_of_use_in_last_mth__c = '3. Daily';
    	oneForm.X32b6_Date_started__c = system.today()-370;
    	oneForm.X32b15_Date_started__c = null;
    	oneForm.X32b16_Date_started__c = null;
    	oneForm.X32b18_Date_started__c = null;
    	oneForm.X32b19_Date_started__c = null;
    	oneForm.X30a_Ever_injected__c = '1. Yes';
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_175)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 175 not found in warnings list');
    }
    
    static testMethod void TestValidationID_175D3() // Q32 = 12 with opiates (100 to 188) and frequency = 3, 6, 7, 1 at Q23
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100); 
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
		oneForm.X23a_Drug_3__c = [select id from NDTRS_Drugs__c where item_code__c=122 limit 1].id;
		oneForm.X23b_Route_of_Admin_Drug3__c = '1. Inject';
		oneForm.X23c_Frequency_of_use_in_last_mth__c = '3. Daily';
    	oneForm.X32b6_Date_started__c = system.today()-370;
    	oneForm.X32b15_Date_started__c = null;
    	oneForm.X32b16_Date_started__c = null;
    	oneForm.X32b18_Date_started__c = null;
    	oneForm.X32b19_Date_started__c = null;
    	oneForm.X30a_Ever_injected__c = '1. Yes';
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_175)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 175 not found in warnings list');
    }
    
    static testMethod void TestValidationID_175D4() // Q32 = 12 with opiates (100 to 188) and frequency = 3, 6, 7, 1 at Q24
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100); 
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
		oneForm.X24a_Drug_4__c = [select id from NDTRS_Drugs__c where item_code__c=122 limit 1].id;
		oneForm.X24b_Route_of_Admin_Drug4__c = '1. Inject';
		oneForm.X24c_Frequency_of_use_in_last_mth__c = '3. Daily';
    	oneForm.X32b6_Date_started__c = system.today()-370;
    	oneForm.X32b15_Date_started__c = null;
    	oneForm.X32b16_Date_started__c = null;
    	oneForm.X32b18_Date_started__c = null;
    	oneForm.X32b19_Date_started__c = null;
    	oneForm.X30a_Ever_injected__c = '1. Yes';
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_175)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 175 not found in warnings list');
    }
    
    static testMethod void TestValidationID_175D5() // Q32 = 12 with opiates (100 to 188) and frequency = 3, 6, 7, 1 at Q25
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100); 
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
		oneForm.X25a_Drug_5__c = [select id from NDTRS_Drugs__c where item_code__c=122 limit 1].id;
		oneForm.X25b_Route_of_Admin_Drug5__c = '1. Inject';
		oneForm.X25c_Frequency_of_use_in_last_mth__c = '3. Daily';
    	oneForm.X32b6_Date_started__c = system.today()-370;
    	oneForm.X32b15_Date_started__c = null;
    	oneForm.X32b16_Date_started__c = null;
    	oneForm.X32b18_Date_started__c = null;
    	oneForm.X32b19_Date_started__c = null;
    	oneForm.X30a_Ever_injected__c = '1. Yes';
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_175)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 175 not found in warnings list');
    }
    
    static testMethod void TestValidationID_176() 
    {
        NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
        
        Contact client = [select id from Contact where id = :oneForm.Contact__c limit 1];
        client.Birthdate = system.today().addYears (-35);
        oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X32b11_Date_started__c = system.today()-161;
    	oneForm.X32c11_Date_of_last_visit__c = system.today()-161;
    	oneForm.X32d11_Number_of_sessions__c = 1;
        update oneForm;
        
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_176)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 176 not found in warnings list');
    } 
    
    static testMethod void TestValidationID_177D1() // Q32 = 6. Medication Free Therapy excluding opiates (100 to 188) and frequency = 3, 6, 7, 8 at Q21
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100); 
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
		oneForm.X21a_Main_drug__c = [select id from NDTRS_Drugs__c where item_code__c=5136 limit 1].id;
		oneForm.X21b_Route_of_Admin_Main_drug__c = '1. Inject';
		oneForm.X21c_Frequency_of_use_in_last_mth__c = '3. Daily';
		oneForm.X30a_Ever_injected__c = '1. Yes';
    	oneForm.X32b6_Date_started__c = system.today()-370;
    	oneForm.X32b17_Date_started__c = null;
    	oneForm.X32b18_Date_started__c = null;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_177)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 177 not found in warnings list');
    }
    
    static testMethod void TestValidationID_177D2() // Q32 = 6. Medication Free Therapy excluding opiates (100 to 188) and frequency = 3, 6, 7, 8 at Q21
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100); 
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
		oneForm.X22a_Drug_2__c = [select id from NDTRS_Drugs__c where item_code__c=5136 limit 1].id;
		oneForm.X22b_Route_of_Admin_Drug2__c = '1. Inject';
		oneForm.X22c_Frequency_of_use_in_last_mth__c = '3. Daily';
		oneForm.X30a_Ever_injected__c = '1. Yes';
    	oneForm.X32b6_Date_started__c = system.today()-370;
    	oneForm.X32b17_Date_started__c = null;
    	oneForm.X32b18_Date_started__c = null;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_177)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 177 not found in warnings list');
    }
    
    static testMethod void TestValidationID_177D3() // Q32 = 6. Medication Free Therapy excluding opiates (100 to 188) and frequency = 3, 6, 7, 8 at Q21
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100); 
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
		oneForm.X23a_Drug_3__c = [select id from NDTRS_Drugs__c where item_code__c=5136 limit 1].id;
		oneForm.X23b_Route_of_Admin_Drug3__c = '1. Inject';
		oneForm.X23c_Frequency_of_use_in_last_mth__c = '3. Daily';
		oneForm.X30a_Ever_injected__c = '1. Yes';
    	oneForm.X32b6_Date_started__c = system.today()-370;
    	oneForm.X32b17_Date_started__c = null;
    	oneForm.X32b18_Date_started__c = null;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_177)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 177 not found in warnings list');
    }
    
    static testMethod void TestValidationID_177D4() // Q32 = 6. Medication Free Therapy excluding opiates (100 to 188) and frequency = 3, 6, 7, 8 at Q21
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100); 
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
		oneForm.X24a_Drug_4__c = [select id from NDTRS_Drugs__c where item_code__c=5136 limit 1].id;
		oneForm.X24b_Route_of_Admin_Drug4__c = '1. Inject';
		oneForm.X24c_Frequency_of_use_in_last_mth__c = '3. Daily';
		oneForm.X30a_Ever_injected__c = '1. Yes';
    	oneForm.X32b6_Date_started__c = system.today()-370;
    	oneForm.X32b17_Date_started__c = null;
    	oneForm.X32b18_Date_started__c = null;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_177)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 177 not found in warnings list');
    }
    
    static testMethod void TestValidationID_177D5() // Q32 = 6. Medication Free Therapy excluding opiates (100 to 188) and frequency = 3, 6, 7, 8 at Q21
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100); 
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
    	oneForm.X19b_Age_first_treated_Drugs__c = 99;
		oneForm.X25a_Drug_5__c = [select id from NDTRS_Drugs__c where item_code__c=5136 limit 1].id;
		oneForm.X25b_Route_of_Admin_Drug5__c = '1. Inject';
		oneForm.X25c_Frequency_of_use_in_last_mth__c = '3. Daily';
		oneForm.X30a_Ever_injected__c = '1. Yes';
    	oneForm.X32b6_Date_started__c = system.today()-370;
    	oneForm.X32b17_Date_started__c = null;
    	oneForm.X32b18_Date_started__c = null;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_177)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 177 not found in warnings list');
    }
    
    static testMethod void TestValidationID_178() // Q32 = 24 and/or 25 and/or 26 only
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100); 
    	oneForm.X12_Date_of_Referral__c = system.today()-380;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-370;
    	oneForm.X32b1_Date_started__c = null;
		oneForm.X32b2_Date_started__c = null;
		oneForm.X32b3_Date_started__c = null;
		oneForm.X32b4_Date_started__c = null;
		oneForm.X32b5_Date_started__c = null;
		oneForm.X32b6_Date_started__c = null;
		oneForm.X32b7_Date_started__c = null;
		oneForm.X32b8_Date_started__c = null;
		oneForm.X32b9_Date_started__c = null;
		oneForm.X32b10_Date_started__c = null;
		oneForm.X32b11_Date_started__c = null;
		oneForm.X32b12_Date_started__c = null;
		oneForm.X32b13_Date_started__c = null;
		oneForm.X32b14_Date_started__c = null;
		oneForm.X32b15_Date_started__c = null;
		oneForm.X32b16_Date_started__c = null;
		oneForm.X32b17_Date_started__c = null;
		oneForm.X32b18_Date_started__c = null;
		oneForm.X32b19_Date_started__c = null;
		oneForm.X32b20_Date_started__c = null;
		oneForm.X32b21_Date_started__c = null;
		oneForm.X32b22_Date_started__c = null;
		oneForm.X32b23_Date_started__c = null;
		oneForm.X32b24_Date_started__c = system.today()-365;
		oneForm.X32c24_Date_of_last_visit__c = system.today()-365;
		oneForm.X32d24_Number_of_sessions__c = 1;
		oneForm.X32b25_Date_started__c = system.today()-365;
		oneForm.X32c25_Date_of_last_visit__c = system.today()-365;
		oneForm.X32d25_Number_of_sessions__c = 1;
		oneForm.X32b26_Date_started__c = system.today()-365;
		oneForm.X32b27_Date_started__c = null;
		oneForm.X32b28_Date_started__c = null;
		oneForm.X26_Age_first_use_any_drug__c = 20;
    	oneForm.X27_Specify_first_drug_ever_used__c = [select id from NDTRS_Drugs__c where item_code__c=5131 limit 1].id;
    	oneForm.X28_Difficult_to_assess_main_problem__c = '2. No';
		oneForm.X35_Date_of_Final_Discharge_or_transfer__c = system.today()-350;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_178)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 178 not found in warnings list');
    }
    
    static testMethod void TestValidationID_179() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X26_Age_first_use_any_drug__c = 20;
    	oneForm.X27_Specify_first_drug_ever_used__c = [select id from NDTRS_Drugs__c where item_code__c=5131 limit 1].id;
    	oneForm.X28_Difficult_to_assess_main_problem__c = '2. No';
    	oneForm.X33a_Exit_details__c = '1. Treatment completed';
    	oneForm.X33a10_Exit_detail_Other__c = 'Never came back';
    	oneForm.X35_Date_of_Final_Discharge_or_transfer__c = system.today()-150;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_179)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 179 not found in warnings list');
    }
    
    static testMethod void TestValidationID_180() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X21a_Main_drug__c = [select id from NDTRS_Drugs__c where item_code__c=700 limit 1].id;
		oneForm.X21b_Route_of_Admin_Main_drug__c = '3. Eat/drink';
		oneForm.X21c_Frequency_of_use_in_last_mth__c = '3. Daily';
		oneForm.X21d_Age_at_1st_use__c = 20;
		oneForm.X26_Age_first_use_any_drug__c = 20;
    	oneForm.X27_Specify_first_drug_ever_used__c = [select id from NDTRS_Drugs__c where item_code__c=5131 limit 1].id;
    	oneForm.X28_Difficult_to_assess_main_problem__c = '2. No';
    	oneForm.X33a_Exit_details__c = '1. Treatment completed';
    	oneForm.X34_Client_s_Condition_on_discharge__c = '1. Drug free';
    	oneForm.X35_Date_of_Final_Discharge_or_transfer__c = system.today()-150;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_180)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 180 not found in warnings list');
    }
    
    static testMethod void TestValidationID_181() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X21a_Main_drug__c = [select id from NDTRS_Drugs__c where item_code__c=400 limit 1].id;
		oneForm.X21b_Route_of_Admin_Main_drug__c = '3. Eat/drink';
		oneForm.X21c_Frequency_of_use_in_last_mth__c = '3. Daily';
		oneForm.X21d_Age_at_1st_use__c = 20;
		oneForm.X26_Age_first_use_any_drug__c = 20;
    	oneForm.X27_Specify_first_drug_ever_used__c = [select id from NDTRS_Drugs__c where item_code__c=5131 limit 1].id;
    	oneForm.X28_Difficult_to_assess_main_problem__c = '2. No';
    	oneForm.X33a_Exit_details__c = '1. Treatment completed';
    	oneForm.X34_Client_s_Condition_on_discharge__c = '6. Alcohol consumption unchanged';
    	oneForm.X35_Date_of_Final_Discharge_or_transfer__c = system.today()-150;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_181)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 181 not found in warnings list');
    }
    
    static testMethod void TestValidationID_182()
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X21a_Main_drug__c = [select id from NDTRS_Drugs__c where item_code__c=400 limit 1].id;
		oneForm.X21b_Route_of_Admin_Main_drug__c = '3. Eat/drink';
		oneForm.X21c_Frequency_of_use_in_last_mth__c = '3. Daily';
		oneForm.X21d_Age_at_1st_use__c = 20;
		oneForm.X26_Age_first_use_any_drug__c = 20;
    	oneForm.X27_Specify_first_drug_ever_used__c = [select id from NDTRS_Drugs__c where item_code__c=5131 limit 1].id;
    	oneForm.X28_Difficult_to_assess_main_problem__c = '2. No';
    	oneForm.X33a_Exit_details__c = '1. Treatment completed';
    	oneForm.X34_Client_s_Condition_on_discharge__c = '99. Not known, 17. Other (specify), 1. Drug free, 4. Drug use reduced, 8. Alcohol consumption reduced, 10. Substantially reached priority goals, 13. Care plan gaps and blocks identified';
    	oneForm.X35_Date_of_Final_Discharge_or_transfer__c = system.today()-150;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_182)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 182 not found in warnings list');
    }
    
    static testMethod void TestValidationID_188() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X26_Age_first_use_any_drug__c = 20;
    	oneForm.X27_Specify_first_drug_ever_used__c = [select id from NDTRS_Drugs__c where item_code__c=5131 limit 1].id;
    	oneForm.X28_Difficult_to_assess_main_problem__c = '2. No';
		oneForm.Centre__c = '10001 - eCass Training Service 14';
    	oneForm.X33a_Exit_details__c = '9. Sentenced to prison';
    	oneForm.X35_Date_of_Final_Discharge_or_transfer__c = system.today()-150;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_188)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 188 not found in warnings list');
    }
    
    static testMethod void TestValidationID_189() 
    {
    	NDTRS_Form_2016__c oneForm = createForm(system.today()-400, system.today()-100);
    	oneForm.X12_Date_of_Referral__c = system.today()-180;
    	oneForm.X15_Date_of_initial_assessment__c = system.today()-170;
    	oneForm.X21a_Main_drug__c = [select id from NDTRS_Drugs__c where item_code__c=400 limit 1].id;
		oneForm.X21b_Route_of_Admin_Main_drug__c = '3. Eat/drink';
		oneForm.X21c_Frequency_of_use_in_last_mth__c = '3. Daily';
		oneForm.X21d_Age_at_1st_use__c = 20;
		oneForm.X26_Age_first_use_any_drug__c = 20;
    	oneForm.X27_Specify_first_drug_ever_used__c = [select id from NDTRS_Drugs__c where item_code__c=5131 limit 1].id;
    	oneForm.X28_Difficult_to_assess_main_problem__c = '2. No';
    	oneForm.X32b26_Date_started__c = null;
    	oneForm.X33a_Exit_details__c = '1. Treatment completed';
    	oneForm.X34_Client_s_Condition_on_discharge__c = '10. Substantially reached priority goals';
    	oneForm.X35_Date_of_Final_Discharge_or_transfer__c = system.today()-150;
    	update oneForm;
    	
        ApexPages.StandardController sc = new ApexPages.StandardController (oneForm);
        NDTRS_Display_Warnings ndw = new NDTRS_Display_Warnings (sc);
        
        system.assert (ndw.warnings.size() > 0);
        for (NDTRS_Display_Warnings.TreatmentMessage oneMsg : ndw.warnings)
        {
        	if (oneMsg.errorMsg == label.NDTRS_Rule_189)
        	{
        		return; // warning found
        	}
        }
        system.assert (false, 'Warning for 189 not found in warnings list');
    }
}