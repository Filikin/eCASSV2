/*
    Author: Eamon Kelly, Enclude
    Purpose:
        1) Implement validation rules to catch errors when pause button is off (Warnings will be caught separately) 
        2) Need to act as a rollup on the treatment to the contact to count number of NDTRS 2016 Forms -- IS THIS REQUIRED?
 */
@isTest
private class TestNDTRSErrors 
{
    @testSetup static void loadDrugsData ()
    {
        list<sObject> drugs = test.loadData(NDTRS_Drugs__c.sObjectType, 'NDTRSDrugsTable');
    }

    static NDTRS_Form_2016__c createForm (Date referralDate, Date initialAssessmentDate)
    {
        Contact client = new Contact (LastName='Test', X4_Gender__c='1. Male', X9a_Education_highest_level__c = '3. Leaving Cert', X9b_Age_left_primary_school__c = 17, X10_Employement_Status__c = '1. In paid employment');
        insert client;
        
        NDTRS_Form_2016__c form = new NDTRS_Form_2016__c (Contact__c = client.id, X12_Date_of_Referral__c=referralDate, X13_Main_Reason_for_referral__c = '1. Alcohol',
        X15_Date_of_initial_assessment__c=initialAssessmentDate, X31a_History_of_Hepatitis_C_screening__c = '1. Never tested', X31b_History_of_Hepatitis_B_screening__c = '1. Never tested',
        X31c_History_of_HIV_screening__c = '1. Never tested');
        insert form;    
        return form;
    }
    
    static testMethod void TestCommencementDate() 
    {
        NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
        oneForm.X32b10_Date_started__c = system.today()-10;
        oneForm.X32b11_Date_started__c = system.today()-5;
        update oneForm;
        
        oneForm = [select Date_latest_intervention_commenced__c, X32b11_Date_started__c from NDTRS_Form_2016__c where id = :oneForm.id];
        system.assertEquals (oneForm.X32b11_Date_started__c, oneForm.Date_latest_intervention_commenced__c);
    }
    
    static testMethod void ValidationID_7_and_8Q12_and_Q15()
    {/*Date of Assessment (assess) cannot be before date of referral (Referral), Assessment 19 days ago and Referral 10 days ago this is an error*/
        try
        {
            NDTRS_Form_2016__c oneForm = createForm(system.today()-10, system.today()-19);
            update oneForm;
        
            system.assert (false, 'Should not have got here as an exception should have been thrown');
        }
        catch (Exception e)
        {
            system.debug (e.getMessage());
            system.assert (e.getMessage().contains(label.NDTRS_Assessment_Date_Before_Referral));
        }
    }
    
    static testMethod void ValidationID_7_and_8Q15_and_Q35()
    {/*Date final discharge can't be before date of Assessment, assesment 10 days ago and date discharge 15 days ago, this is an error*/
        try
        {
            NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-10);
            oneForm.X35_Date_of_Final_Discharge_or_transfer__c = system.today()-15;
            update oneForm;
        
            system.assert (false, 'Should not have got here as an exception should have been thrown');
        }
        catch (Exception e)
        {
            system.debug (e.getMessage());
            system.assert (e.getMessage().contains(label.NDTRS_Exit_Date_Too_Early));
        }
    }
    
    static testMethod void ValidationID_7_and_8Q15_and_Q32()
    {
        try
        {
            NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
            oneForm.X32b1_Date_started__c = system.today()-25;
            oneForm.X32b2_Date_started__c = system.today()-25;
            oneForm.X32b3_Date_started__c = system.today()-25;
            oneForm.X32b4_Date_started__c = system.today()-25;
            oneForm.X32b5_Date_started__c = system.today()-25;
            oneForm.X32b6_Date_started__c = system.today()-25;
            oneForm.X32b7_Date_started__c = system.today()-25;
            oneForm.X32b8_Date_started__c = system.today()-25;
            oneForm.X32b9_Date_started__c = system.today()-25;
            oneForm.X32b10_Date_started__c = system.today()-25;
            oneForm.X32b11_Date_started__c = system.today()-25;
            oneForm.X32b12_Date_started__c = system.today()-25;
            oneForm.X32b13_Date_started__c = system.today()-25;
            oneForm.X32b14_Date_started__c = system.today()-25;
            oneForm.X32b15_Date_started__c = system.today()-25;
            oneForm.X32b16_Date_started__c = system.today()-25;
            oneForm.X32b17_Date_started__c = system.today()-25;
            oneForm.X32b18_Date_started__c = system.today()-25;
            oneForm.X32b19_Date_started__c = system.today()-25;
            oneForm.X32b20_Date_started__c = system.today()-25;
            oneForm.X32b21_Date_started__c = system.today()-25;
            oneForm.X32b22_Date_started__c = system.today()-25;
            oneForm.X32b23_Date_started__c = system.today()-25;
            oneForm.X32b24_Date_started__c = system.today()-25;
            oneForm.X32b25_Date_started__c = system.today()-25;
            oneForm.X32b26_Date_started__c = system.today()-25;
            oneForm.X32b27_Date_started__c = system.today()-25;
            oneForm.X32b28_Date_started__c = system.today()-25;
            update oneForm;
        
            system.assert (false, 'Should not have got here as an exception should have been thrown');
        }
        catch (Exception e)
        {
            system.debug (e.getMessage());
            system.assert (e.getMessage().contains(label.NDTRS_DOC_Before_Assessment_Date));
        }
    }
    
    
    static testMethod void TestValidationID_14_and_15 ()
    {
        try
        {
            NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
            Contact client = [select X4_Gender__c from Contact where id = :oneForm.Contact__c limit 1];
            client.X4_Gender__c = null;
            update client;
            update oneForm;
            
            system.assert (false, 'Should not have got here as an exception should have been thrown');
        }
        catch (Exception e)
        {
            system.assert (e.getMessage().contains(label.NDTRS_Rule_14_and_15));
        }
    }
    
    static testMethod void TestValidationID_21 ()
    {
        try
        {
            NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
            Contact client = [select X4_Gender__c from Contact where id = :oneForm.Contact__c limit 1];
            client.X5_Living_with_whom__c = '1. Alone';
            client.X7_Living_Where__c = '5. Prison';
            update client;
            update oneForm;
            
            system.assert (false, 'Should not have got here as an exception should have been thrown');
        }
        catch (Exception e)
        {
            system.debug ('Test 21 message: ' + e.getMessage());
            system.assert (e.getMessage().contains(label.NDTRS_Homesless_prison_and_Living_with_Whom));
        }
    }
    
    static testMethod void TestValidationID_22 ()
    {
        try
        {
            NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
            Contact client = [select X4_Gender__c from Contact where id = :oneForm.Contact__c limit 1];
            client.X5_Living_with_whom__c = '5. Partner & Child(ren)';
            client.X6a1_Children_under_5yrs_living_whith__c = 0;
            client.X6a2_Children_5_17yrs_living_whith_clien__c = 0;
            client.X6a3_Children_18yrs_or_over_living_whith__c = 0;
            client.Living_with_service_user_unknown__c = 0;
            update client;
            update oneForm;
            
            system.assert (false, 'Should not have got here as an exception should have been thrown');
        }
        catch (Exception e)
        {
            system.debug (e.getMessage());
            system.assert (e.getMessage().contains(label.NDTRS_Living_with_Children));
        }
    }
    
    static testMethod void TestValidationID_24 ()
    {
        try
        {
            NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
            Contact client = [select X4_Gender__c from Contact where id = :oneForm.Contact__c limit 1];
            client.X5_Living_with_whom__c = '3. Friends';
            client.X6a1_Children_under_5yrs_living_whith__c = 1;
            client.X6a2_Children_5_17yrs_living_whith_clien__c = 0;
            client.X6a3_Children_18yrs_or_over_living_whith__c = 0;
            update client;
            update oneForm;
            
            system.assert (false, 'Should not have got here as an exception should have been thrown');
        }
        catch (Exception e)
        {
            system.assert (e.getMessage().contains(label.NDTRS_Living_with_Children_not_indicated));
        }
    }
    
    static testMethod void TestValidationID_28 ()
    {
        try
        {
            NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
            Contact client = [select X4_Gender__c from Contact where id = :oneForm.Contact__c limit 1];
            client.X9a_Education_highest_level__c = null;
            update client;
            update oneForm;
            
            system.assert (false, 'Should not have got here as an exception should have been thrown');
        }
        catch (Exception e)
        {
            system.assert (e.getMessage().contains(label.NDTRS_Rule_EDLEVEL));
        }
    }
    
    static testMethod void TestValidationID_29 ()
    {
        try
        {
            NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
            Contact client = [select X4_Gender__c from Contact where id = :oneForm.Contact__c limit 1];
            client.X9b_Age_left_primary_school__c = null;
            update client;
            update oneForm;
            
            system.assert (false, 'Should not have got here as an exception should have been thrown');
        }
        catch (Exception e)
        {
            system.assert (e.getMessage().contains(label.NDTRS_Rule_29));
        }
    }

    static testMethod void TestValidationID_37 ()
    {
        try
        {
            NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
            Contact client = [select X4_Gender__c from Contact where id = :oneForm.Contact__c limit 1];
            client.X10_Employement_Status__c = null;
            update client;
            update oneForm;
            
            system.assert (false, 'Should not have got here as an exception should have been thrown');
        }
        catch (Exception e)
        {
            system.assert (e.getMessage().contains(label.NDTRS_EmployCode));
        }
    }
  
    static testMethod void TestValidationID_43 ()
    {
        try
        {
            NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
            Contact client = [select X4_Gender__c from Contact where id = :oneForm.Contact__c limit 1];
            client.X9b_Age_left_primary_school__c = 88;
            client.X10_Employement_Status__c = '1. In paid employment';
            update client;
            update oneForm;
            
            system.assert (false, 'Should not have got here as an exception should have been thrown');
        }
        catch (Exception e)
        {
            system.assert (e.getMessage().contains(label.NDTRS_Q9_and_Q10_Employment_and_Education));
        }
    }
    
    static testMethod void TestValidationID_44 ()
    {
        try
        {
            NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
            oneForm.X13_Main_Reason_for_referral__c = null;
            update oneForm;
            
            system.assert (false, 'Should not have got here as an exception should have been thrown');
        }
        catch (Exception e)
        {
            system.assert (e.getMessage().contains(label.NDTRS_Reason_Q13));
        }
    }
    
    static testMethod void TestValidationID_71 ()
    {
        try
        {
            NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
            oneForm.X19b_Age_first_treated_Drugs__c = 40;
            oneForm.X20b_Age_first_received_any_opiate_subst__c = 20;
            update oneForm;
            
            system.assert (false, 'Should not have got here as an exception should have been thrown');
        }
        catch (Exception e)
        {
            system.assert (e.getMessage().contains(label.NDTRS_Q19_older_than_Q20b));
        }
    }
    
    static testMethod void TestValidationID_81 ()
    {
        try
        {
            NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
            oneForm.X19_History_of_treatment_Drugs__c = '1. Never treated';
            oneForm.X20a_Ever_received_any_opiate_substituti__c = '1. Previously received';
            update oneForm;
            
            system.assert (false, 'Should not have got here as an exception should have been thrown');
        }
        catch (Exception e)
        {
            system.assert (e.getMessage().contains(label.NDTRS_Q19_previously_treated_and_Q20a));
        }
    }
    
    static testMethod void TestValidationID_82 ()
    {
        try
        {
            NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
            Contact client = [select X4_Gender__c from Contact where id = :oneForm.Contact__c limit 1];
            client.Birthdate = system.today().addYears (-20);
            oneForm.X19_History_of_treatment_Drugs__c = '2. Previously treated';
            oneForm.X19b_Age_first_treated_Drugs__c = 40;
            oneForm.X20a_Ever_received_any_opiate_substituti__c = '1. Previously received';
            oneForm.X20b_Age_first_received_any_opiate_subst__c = 40;
            update client;
            update oneForm;
            
            system.assert (false, 'Should not have got here as an exception should have been thrown');
        }
        catch (Exception e)
        {
            system.assert (e.getMessage().contains(label.NDTRS_AgeOpiateSub));
        }
    }
    
    static testMethod void TestValidationID_86 ()
    {
        try
        {
            NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
            oneForm.X13_Main_Reason_for_referral__c = '1. Alcohol';
            oneForm.X13_2_Drug_specify__c = [select id from NDTRS_Drugs__c where item_code__c= 700 limit 1].id;
            oneForm.X16_Assessment_outcome__c = '1. Suitable for tratment in any drug/alcohol service';
            oneForm.X17_Where_client_is_suitable_for_treatme__c = '1. Treatment offered with this centre and client accepted';
            oneForm.X19_History_of_treatment_Drugs__c = '9. Treatment status unknown';
            oneForm.X19b_Age_first_treated_Drugs__c = 99;
            oneForm.X19_History_of_treatment_Alcohol__c = '1. Never treated';
            oneForm.X19d_Age_first_treated_Alcohol__c = 21;
            oneForm.X19_History_of_treatment_Other__c = '9. Treatment status unknown';
            oneForm.X19b_Age_first_treated_Other__c = 99;
            oneForm.X20a_Ever_received_any_opiate_substituti__c = '2. received';
            oneForm.X20b_Age_first_received_any_opiate_subst__c = 88;
            oneForm.X21a_Main_drug__c = [select id from NDTRS_Drugs__c where item_code__c=612 limit 1].id;
            oneForm.X21b_Route_of_Admin_Main_drug__c = '2. Smoke';
            oneForm.X21c_Frequency_of_use_in_last_mth__c = '3. Daily';
            oneForm.X21d_Age_at_1st_use__c = 20;
            update oneForm;
            
            system.assert (false, 'Should not have got here as an exception should have been thrown');
        }
        catch (Exception e)
        {
            system.assert (e.getMessage().contains(label.NDTRS_SPECIFYX_Q13_not_equal_Q21a));
        }
    }
    
    static testMethod void TestValidationID_97_Q21_and_Q27 ()
    {
        try
        {
            NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
            oneForm.X21a_Main_drug__c = [select id from NDTRS_Drugs__c where item_code__c=612 limit 1].id;
            oneForm.X21d_Age_at_1st_use__c = 20;
            oneForm.X27_Specify_first_drug_ever_used__c = [select id from NDTRS_Drugs__c where item_code__c=612 limit 1].id;
            oneForm.X26_Age_first_use_any_drug__c = 19;
            update oneForm;
            
            system.assert (false, 'Should not have got here as an exception should have been thrown');
        }
        catch (Exception e)
        {
            system.assert (e.getMessage().contains(label.NDTRS_Age_1st_Used));
        }
    }
    
    static testMethod void TestValidationID_97_Q22_and_Q27 ()
    {
        try
        {
            NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
            oneForm.X22a_Drug_2__c = [select id from NDTRS_Drugs__c where item_code__c=612 limit 1].id;
            oneForm.X22d_Age_of_1st_use__c = 20;
            oneForm.X27_Specify_first_drug_ever_used__c = [select id from NDTRS_Drugs__c where item_code__c=612 limit 1].id;
            oneForm.X26_Age_first_use_any_drug__c = 19;
            update oneForm;
            
            system.assert (false, 'Should not have got here as an exception should have been thrown');
        }
        catch (Exception e)
        {
            system.assert (e.getMessage().contains(label.NDTRS_Age_1st_Used));
        }
    }
    
    static testMethod void TestValidationID_97_Q23_and_Q27 ()
    {
        try
        {
            NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
            oneForm.X23a_Drug_3__c = [select id from NDTRS_Drugs__c where item_code__c=612 limit 1].id;
            oneForm.X23d_Age_of_1st_use__c = 20;
            oneForm.X27_Specify_first_drug_ever_used__c = [select id from NDTRS_Drugs__c where item_code__c=612 limit 1].id;
            oneForm.X26_Age_first_use_any_drug__c = 19;
            update oneForm;
            
            system.assert (false, 'Should not have got here as an exception should have been thrown');
        }
        catch (Exception e)
        {
            system.assert (e.getMessage().contains(label.NDTRS_Age_1st_Used));
        }
    }
    
    static testMethod void TestValidationID_97_Q24_and_Q27 ()
    {
        try
        {
            NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
            oneForm.X24a_Drug_4__c = [select id from NDTRS_Drugs__c where item_code__c=612 limit 1].id;
            oneForm.X24d_Age_of_1st_use__c = 20;
            oneForm.X27_Specify_first_drug_ever_used__c = [select id from NDTRS_Drugs__c where item_code__c=612 limit 1].id;
            oneForm.X26_Age_first_use_any_drug__c = 19;
            update oneForm;
            
            system.assert (false, 'Should not have got here as an exception should have been thrown');
        }
        catch (Exception e)
        {
            system.assert (e.getMessage().contains(label.NDTRS_Age_1st_Used));
        }
    }
    
    static testMethod void TestValidationID_97_Q25_and_Q27 ()
    {
        try
        {
            NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
            oneForm.X25a_Drug_5__c = [select id from NDTRS_Drugs__c where item_code__c=612 limit 1].id;
            oneForm.X25d_Age_of_1st_use__c = 20;
            oneForm.X27_Specify_first_drug_ever_used__c = [select id from NDTRS_Drugs__c where item_code__c=612 limit 1].id;
            oneForm.X26_Age_first_use_any_drug__c = 19;
            update oneForm;
            
            system.assert (false, 'Should not have got here as an exception should have been thrown');
        }
        catch (Exception e)
        {
            system.assert (e.getMessage().contains(label.NDTRS_Age_1st_Used));
        }
    }
    
/*    static testMethod void TestValidationID_99 ()
    {
        try
        {
            NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
            oneForm.X26_Age_first_use_any_drug__c = null;
            oneForm.X27_Specify_first_drug_ever_used__c = null;
            oneForm.X28_Difficult_to_assess_main_problem__c = null;
            oneForm.X35_Date_of_Final_Discharge_or_transfer__c = system.today()-1;
            update oneForm;
            
            system.assert (false, 'Should not have got here as an exception should have been thrown');
        }
        catch (Exception e)
        {
            system.assert (e.getMessage().contains(label.NDTRS_Rule_99));
        }
    }
*/    
    static testMethod void TestValidationID_100 ()
    {
        try
        {
            NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
            oneForm.X13_2_Drug_specify__c = [select id from NDTRS_Drugs__c where item_code__c= 700 limit 1].id;
            oneForm.X19_History_of_treatment_Alcohol__c = '2. Previously treated';
            oneForm.X19d_Age_first_treated_Alcohol__c = 20;
            oneForm.X21a_Main_drug__c = [select id from NDTRS_Drugs__c where item_code__c= 700 limit 1].id;
            oneForm.X21b_Route_of_Admin_Main_drug__c = '3. Eat/drink';
            oneForm.X21c_Frequency_of_use_in_last_mth__c = '3. Daily';
            oneForm.X21d_Age_at_1st_use__c = 20;
            oneForm.X22a_Drug_2__c = [select id from NDTRS_Drugs__c where item_code__c=700 limit 1].id;
            oneForm.X22b_Route_of_Admin_Drug2__c = '3. Eat/drink';
            oneForm.X22c_Frequency_of_use_in_last_mth__c = '3. Daily';
            oneForm.X22d_Age_of_1st_use__c = 20;
            oneForm.X23a_Drug_3__c = [select id from NDTRS_Drugs__c where item_code__c=700 limit 1].id;
            oneForm.X23b_Route_of_Admin_Drug3__c = '3. Eat/drink';
            oneForm.X23c_Frequency_of_use_in_last_mth__c = '3. Daily';
            oneForm.X23d_Age_of_1st_use__c = 20;
            oneForm.X24a_Drug_4__c = [select id from NDTRS_Drugs__c where item_code__c=700 limit 1].id;
            oneForm.X24b_Route_of_Admin_Drug4__c = '3. Eat/drink';
            oneForm.X24c_Frequency_of_use_in_last_mth__c = '3. Daily';
            oneForm.X24d_Age_of_1st_use__c = 20;
            oneForm.X25a_Drug_5__c = [select id from NDTRS_Drugs__c where item_code__c= 700 limit 1].id;
            oneForm.X25b_Route_of_Admin_Drug5__c = '3. Eat/drink';
            oneForm.X25c_Frequency_of_use_in_last_mth__c = '3. Daily';
            oneForm.X25d_Age_of_1st_use__c = 20;
            update oneForm;
            
            system.assert (false, 'Should not have got here as an exception should have been thrown');
        }
        catch (Exception e)
        {
            system.assert (e.getMessage().contains(label.NDTRS_Duplicate_drug));
        }
    }
    
    static testMethod void TestValidationID_109_Q21d ()
    {
        try
        {
            NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
            oneForm.X21a_Main_drug__c = [select id from NDTRS_Drugs__c where item_code__c= 224 limit 1].id;
            oneForm.X21d_Age_at_1st_use__c = 20;
            oneForm.X26_Age_first_use_any_drug__c = 30;
            update oneForm;
            
            system.assert (false, 'Should not have got here as an exception should have been thrown');
        }
        catch (Exception e)
        {
            system.assert (e.getMessage().contains(label.NDTRS_Ages_of_1st_use_Q26));
        }
    }
    
    static testMethod void TestValidationID_109_Q22d ()
    {
        try
        {
            NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
            oneForm.X22a_Drug_2__c = [select id from NDTRS_Drugs__c where item_code__c= 224 limit 1].id;
            oneForm.X22d_Age_of_1st_use__c = 20;
            oneForm.X26_Age_first_use_any_drug__c = 30;
            update oneForm;
            
            system.assert (false, 'Should not have got here as an exception should have been thrown');
        }
        catch (Exception e)
        {
            system.assert (e.getMessage().contains(label.NDTRS_Ages_of_1st_use_Q26));
        }
    }
    
    static testMethod void TestValidationID_109_Q23d ()
    {
        try
        {
            NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
            oneForm.X23a_Drug_3__c = [select id from NDTRS_Drugs__c where item_code__c= 224 limit 1].id;
            oneForm.X23d_Age_of_1st_use__c = 20;
            oneForm.X26_Age_first_use_any_drug__c = 30;
            update oneForm;
            
            system.assert (false, 'Should not have got here as an exception should have been thrown');
        }
        catch (Exception e)
        {
            system.assert (e.getMessage().contains(label.NDTRS_Ages_of_1st_use_Q26));
        }
    }
    
    static testMethod void TestValidationID_109_Q24d ()
    {
        try
        {
            NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
            oneForm.X24a_Drug_4__c = [select id from NDTRS_Drugs__c where item_code__c= 224 limit 1].id;
            oneForm.X24d_Age_of_1st_use__c = 20;
            oneForm.X26_Age_first_use_any_drug__c = 30;
            update oneForm;
            
            system.assert (false, 'Should not have got here as an exception should have been thrown');
        }
        catch (Exception e)
        {
            system.assert (e.getMessage().contains(label.NDTRS_Ages_of_1st_use_Q26));
        }
    }
    
    static testMethod void TestValidationID_109_Q25d ()
    {
        try
        {
            NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
            oneForm.X25a_Drug_5__c = [select id from NDTRS_Drugs__c where item_code__c= 224 limit 1].id;
            oneForm.X25d_Age_of_1st_use__c = 20;
            oneForm.X26_Age_first_use_any_drug__c = 30;
            update oneForm;
            
            system.assert (false, 'Should not have got here as an exception should have been thrown');
        }
        catch (Exception e)
        {
            system.assert (e.getMessage().contains(label.NDTRS_Ages_of_1st_use_Q26));
        }
    }
    
    static testMethod void TestValidationID_123 ()
    {
        try
        {
            NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
            oneForm.X26_Age_first_use_any_drug__c = 40;
            oneForm.X30b_Age_first_injected__c = 20;
            update oneForm;
            
            system.assert (false, 'Should not have got here as an exception should have been thrown');
        }
        catch (Exception e)
        {
            system.assert (e.getMessage().contains(label.NDTRS_Ages_of_1st_use_1st_injected_consistency));
        }
    }
    
    static testMethod void TestValidationID_127_Q21b ()
    {
        try
        {
            NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
            oneForm.X21b_Route_of_Admin_Main_drug__c = '1. Inject';
            oneForm.X30a_Ever_injected__c = '2. No';
            update oneForm;
            
            system.assert (false, 'Should not have got here as an exception should have been thrown');
        }
        catch (Exception e)
        {
            system.assert (e.getMessage().contains(label.NDTRS_Ever_Injected));
        }
    }
    
    static testMethod void TestValidationID_127_Q22b ()
    {
        try
        {
            NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
            oneForm.X22b_Route_of_Admin_Drug2__c = '1. Inject';
            oneForm.X30a_Ever_injected__c = '2. No';
            update oneForm;
            
            system.assert (false, 'Should not have got here as an exception should have been thrown');
        }
        catch (Exception e)
        {
            system.assert (e.getMessage().contains(label.NDTRS_Ever_Injected));
        }
    }
    
    static testMethod void TestValidationID_127_Q23b ()
    {
        try
        {
            NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
            oneForm.X23b_Route_of_Admin_Drug3__c = '1. Inject';
            oneForm.X30a_Ever_injected__c = '2. No';
            update oneForm;
            
            system.assert (false, 'Should not have got here as an exception should have been thrown');
        }
        catch (Exception e)
        {
            system.assert (e.getMessage().contains(label.NDTRS_Ever_Injected));
        }
    }
    
    static testMethod void TestValidationID_127_Q24b ()
    {
        try
        {
            NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
            oneForm.X24b_Route_of_Admin_Drug4__c = '1. Inject';
            oneForm.X30a_Ever_injected__c = '2. No';
            update oneForm;
            
            system.assert (false, 'Should not have got here as an exception should have been thrown');
        }
        catch (Exception e)
        {
            system.assert (e.getMessage().contains(label.NDTRS_Ever_Injected));
        }
    }
    
    static testMethod void TestValidationID_127_Q25b ()
    {
        try
        {
            NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
            oneForm.X25b_Route_of_Admin_Drug5__c = '1. Inject';
            oneForm.X30a_Ever_injected__c = '2. No';
            update oneForm;
            
            system.assert (false, 'Should not have got here as an exception should have been thrown');
        }
        catch (Exception e)
        {
            system.assert (e.getMessage().contains(label.NDTRS_Ever_Injected));
        }
    }
    
    static testMethod void TestValidationID_130 ()
    {
        try
        {
            NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
            oneForm.X30a_Ever_injected__c = '1. Yes';
            oneForm.X30c_Frequency_of_injecting__c = null;
            update oneForm;
            
            system.assert (false, 'Should not have got here as an exception should have been thrown');
        }
        catch (Exception e)
        {
            system.assert (e.getMessage().contains(label.NDTRS_Freq_of_Injecting));
        }
    }
    
    static testMethod void TestValidationID_131 ()
    {
        try
        {
            NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
            oneForm.X30a_Ever_injected__c = '1. Yes';
            oneForm.X30c_Frequency_of_injecting__c = '4. Client did not wish to answer';
            oneForm.X30d_Ever_shared_needle_and_syringes__c = null;
            update oneForm;
            
            system.assert (false, 'Should not have got here as an exception should have been thrown');
        }
        catch (Exception e)
        {
            system.assert (e.getMessage().contains(label.NDTRS_SharedNeedle));
        }
    }
    
    static testMethod void TestValidationID_134 ()
    {
        try
        {
            NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
            oneForm.X21b_Route_of_Admin_Main_drug__c = '3. Eat/drink';
            oneForm.X22b_Route_of_Admin_Drug2__c = '3. Eat/drink';
            oneForm.X23b_Route_of_Admin_Drug3__c = '3. Eat/drink';
            oneForm.X24b_Route_of_Admin_Drug4__c = '3. Eat/drink';
            oneForm.X25b_Route_of_Admin_Drug5__c = '3. Eat/drink';
            oneForm.X30c_Frequency_of_injecting__c = '1. Injected in the las 30 days';
            update oneForm;
            
            system.assert (false, 'Should not have got here as an exception should have been thrown');
        }
        catch (Exception e)
        {
            system.assert (e.getMessage().contains(label.NDTRS_Currently_Injecting_Q30c));
        }
    }
    
 /*   static testMethod void TestValidationID_134a ()
    {
        try
        {
            NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
            oneForm.X21b_Route_of_Admin_Main_drug__c = '1. Inject';
            oneForm.X21c_Frequency_of_use_in_last_mth__c = '1. Once a week or less';
            oneForm.X22b_Route_of_Admin_Drug2__c = '1. Inject';
            oneForm.X22c_Frequency_of_use_in_last_mth__c = '1. Once a week or less';
            oneForm.X23b_Route_of_Admin_Drug3__c = '1. Inject';
            oneForm.X23c_Frequency_of_use_in_last_mth__c = '1. Once a week or less';
            oneForm.X24b_Route_of_Admin_Drug4__c = '1. Inject';
            oneForm.X24c_Frequency_of_use_in_last_mth__c = '1. Once a week or less';
            oneForm.X25b_Route_of_Admin_Drug5__c = '1. Inject';
            oneForm.X25c_Frequency_of_use_in_last_mth__c = '1. Once a week or less';
            oneForm.X30c_Frequency_of_injecting__c = '3. Injected but not in the last 12 months';
            update oneForm;
            
            system.assert (false, 'Should not have got here as an exception should have been thrown');
        }
        catch (Exception e)
        {
            system.assert (e.getMessage().contains(label.NDTRS_Currently_Injecting_Q30c));
        }
    }
*/   
    static testMethod void TestValidationID_135 ()
    {
        try
        {
            NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
            oneForm.X21b_Route_of_Admin_Main_drug__c = '1. Inject';
            oneForm.X21c_Frequency_of_use_in_last_mth__c = '4. No use in past month';
            oneForm.X22b_Route_of_Admin_Drug2__c = '1. Inject';
            oneForm.X22c_Frequency_of_use_in_last_mth__c = '4. No use in past month';
            oneForm.X23b_Route_of_Admin_Drug3__c = '1. Inject';
            oneForm.X23c_Frequency_of_use_in_last_mth__c = '4. No use in past month';
            oneForm.X24b_Route_of_Admin_Drug4__c = '1. Inject';
            oneForm.X24c_Frequency_of_use_in_last_mth__c = '4. No use in past month';
            oneForm.X25b_Route_of_Admin_Drug5__c = '1. Inject';
            oneForm.X25c_Frequency_of_use_in_last_mth__c = '4. No use in past month';
            oneForm.X30a_Ever_injected__c = '1. Yes';
            oneForm.X30b_Age_first_injected__c = 20;
            oneForm.X30c_Frequency_of_injecting__c = '1. Injected in the las 30 days';
            oneForm.X30d_Ever_shared_needle_and_syringes__c = '99. Not known';
            update oneForm;
            
            system.assert (false, 'Should not have got here as an exception should have been thrown');
        }
        catch (Exception e)
        {
            system.assert (e.getMessage().contains(label.NDTRS_Currently_Injecting_Q21_Q25_equal_4));
        }
    }
    
    static testMethod void TestValidationID_142 ()
    {
        try
        {
            NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
            oneForm.X31a_History_of_Hepatitis_C_screening__c = null;
            oneForm.X31b_History_of_Hepatitis_B_screening__c = null;
            oneForm.X31c_History_of_HIV_screening__c = null;
            update oneForm;
            
            system.assert (false, 'Should not have got here as an exception should have been thrown');
        }
        catch (Exception e)
        {
            system.assert (e.getMessage().contains(label.NDTRS_Viral_screening));
        }
    }
    
    static testMethod void TestInterventionDateCheck ()
    { /* if client last visited 10 days ago and intervention started 5 days ago - this is and error */
        try
        {
            NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
            oneForm.X32b1_Date_started__c = system.today()-5;
            oneForm.X32c1_Date_of_last_visit__c = system.today()-10;
            oneForm.X32b2_Date_started__c = system.today()-5;
            oneForm.X32c2_Date_of_last_visit__c = system.today()-10;
            oneForm.X32b3_Date_started__c = system.today()-5;
            oneForm.X32c3_Date_of_last_visit__c = system.today()-10;
            oneForm.X32b4_Date_started__c = system.today()-5;
            oneForm.X32c4_Date_of_last_visit__c = system.today()-10;
            oneForm.X32b5_Date_started__c = system.today()-5;
            oneForm.X32c5_Date_of_last_visit__c = system.today()-10;
            oneForm.X32b6_Date_started__c = system.today()-5;
            oneForm.X32c6_Date_of_last_visit__c = system.today()-10;
            oneForm.X32b7_Date_started__c = system.today()-5;
            oneForm.X32c7_Date_of_last_visit__c = system.today()-10;
            oneForm.X32b8_Date_started__c = system.today()-5;
            oneForm.X32c8_Date_of_last_visit__c = system.today()-10;
            oneForm.X32b9_Date_started__c = system.today()-5;
            oneForm.X32c9_Date_of_last_visit__c = system.today()-10;
            oneForm.X32b10_Date_started__c = system.today()-5;
            oneForm.X32c10_Date_of_last_visit__c = system.today()-10;
            oneForm.X32b11_Date_started__c = system.today()-5;
            oneForm.X32c11_Date_of_last_visit__c = system.today()-10;
            oneForm.X32b12_Date_started__c = system.today()-5;
            oneForm.X32c12_Date_of_last_visit__c = system.today()-10;
            oneForm.X32b13_Date_started__c = system.today()-5;
            oneForm.X32c13_Date_of_last_visit__c = system.today()-10;
            oneForm.X32b14_Date_started__c = system.today()-5;
            oneForm.X32c14_Date_of_last_visit__c = system.today()-10;
            oneForm.X32b15_Date_started__c = system.today()-5;
            oneForm.X32c15_Date_of_last_visit__c = system.today()-10;
            oneForm.X32b16_Date_started__c = system.today()-5;
            oneForm.X32c16_Date_of_last_visit__c = system.today()-10;
            oneForm.X32b17_Date_started__c = system.today()-5;
            oneForm.X32c17_Date_of_last_visit__c = system.today()-10;
            oneForm.X32b18_Date_started__c = system.today()-5;
            oneForm.X32c18_Date_of_last_visit__c = system.today()-10;
            oneForm.X32b19_Date_started__c = system.today()-5;
            oneForm.X32c19_Date_of_last_visit__c = system.today()-10;
            oneForm.X32b20_Date_started__c = system.today()-5;
            oneForm.X32c20_Date_of_last_visit__c = system.today()-10;
            oneForm.X32b21_Date_started__c = system.today()-5;
            oneForm.X32c21_Date_of_last_visit__c = system.today()-10;
            oneForm.X32b22_Date_started__c = system.today()-5;
            oneForm.X32c22_Date_of_last_visit__c = system.today()-10;
            oneForm.X32b23_Date_started__c = system.today()-5;
            oneForm.X32c23_Date_of_last_visit__c = system.today()-10;
            oneForm.X32b24_Date_started__c = system.today()-5;
            oneForm.X32c24_Date_of_last_visit__c = system.today()-10;
            oneForm.X32b25_Date_started__c = system.today()-5;
            oneForm.X32c25_Date_of_last_visit__c = system.today()-10;
            oneForm.X32b27_Date_started__c = system.today()-5;
            oneForm.X32c27_Date_of_last_visit__c = system.today()-10;
            oneForm.X32b28_Date_started__c = system.today()-5;
            oneForm.X32c28_Date_of_last_visit__c = system.today()-10;
            update oneForm;
            
            system.assert (false, 'Should not have got here as an exception should have been thrown');
        }
        catch (Exception e)
        {
            system.debug (e.getMessage());
            system.assert (e.getMessage().contains(label.NDTRS_Intervention_Date_Check));
        }
    }
    
    static testMethod void TestValidationID_166 ()
    { /* if client last visited 10 days ago and was discharged 20 days ago - this is and error */
        try
        {
            NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
            oneForm.X32c1_Date_of_last_visit__c = system.today()-10;
            oneForm.X32c2_Date_of_last_visit__c = system.today()-10;
            oneForm.X32c3_Date_of_last_visit__c = system.today()-10;
            oneForm.X32c4_Date_of_last_visit__c = system.today()-10;
            oneForm.X32c5_Date_of_last_visit__c = system.today()-10;
            oneForm.X32c6_Date_of_last_visit__c = system.today()-10;
            oneForm.X32c7_Date_of_last_visit__c = system.today()-10;
            oneForm.X32c8_Date_of_last_visit__c = system.today()-10;
            oneForm.X32c9_Date_of_last_visit__c = system.today()-10;
            oneForm.X32c10_Date_of_last_visit__c = system.today()-10;
            oneForm.X32c11_Date_of_last_visit__c = system.today()-10;
            oneForm.X32c12_Date_of_last_visit__c = system.today()-10;
            oneForm.X32c13_Date_of_last_visit__c = system.today()-10;
            oneForm.X32c14_Date_of_last_visit__c = system.today()-10;
            oneForm.X32c15_Date_of_last_visit__c = system.today()-10;
            oneForm.X32c16_Date_of_last_visit__c = system.today()-10;
            oneForm.X32c17_Date_of_last_visit__c = system.today()-10;
            oneForm.X32c18_Date_of_last_visit__c = system.today()-10;
            oneForm.X32c19_Date_of_last_visit__c = system.today()-10;
            oneForm.X32c20_Date_of_last_visit__c = system.today()-10;
            oneForm.X32c21_Date_of_last_visit__c = system.today()-10;
            oneForm.X32c22_Date_of_last_visit__c = system.today()-10;
            oneForm.X32c23_Date_of_last_visit__c = system.today()-10;
            oneForm.X32c24_Date_of_last_visit__c = system.today()-10;
            oneForm.X32c25_Date_of_last_visit__c = system.today()-10;
            oneForm.X32c27_Date_of_last_visit__c = system.today()-10;
            oneForm.X32c28_Date_of_last_visit__c = system.today()-10;
            oneForm.X35_Date_of_Final_Discharge_or_transfer__c = system.today()-15;
            update oneForm;
            
            system.assert (false, 'Should not have got here as an exception should have been thrown');
        }
        catch (Exception e)
        {
            system.debug (e.getMessage());
            system.assert (e.getMessage().contains(label.NDTRS_Rule_166));
        }
    }
    
    static testMethod void TestInterventionDetailsCheck_Q32c ()
    { /* All interventions details must be either complete or blank when date of final discharge is set  */
        try
        {
            NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
            oneForm.X32b1_Date_started__c = system.today()-5;
            oneForm.X32c1_Date_of_last_visit__c = null;
            oneForm.X32b2_Date_started__c = system.today()-5;
            oneForm.X32c2_Date_of_last_visit__c = null;
            oneForm.X32b3_Date_started__c = system.today()-5;
            oneForm.X32c3_Date_of_last_visit__c = null;
            oneForm.X32b4_Date_started__c = system.today()-5;
            oneForm.X32c4_Date_of_last_visit__c = null;
            oneForm.X32b5_Date_started__c = system.today()-5;
            oneForm.X32c5_Date_of_last_visit__c = null;
            oneForm.X32b6_Date_started__c = system.today()-5;
            oneForm.X32c6_Date_of_last_visit__c = null;
            oneForm.X32b7_Date_started__c = system.today()-5;
            oneForm.X32c7_Date_of_last_visit__c = null;
            oneForm.X32b8_Date_started__c = system.today()-5;
            oneForm.X32c8_Date_of_last_visit__c = null;
            oneForm.X32b9_Date_started__c = system.today()-5;
            oneForm.X32c9_Date_of_last_visit__c = null;
            oneForm.X32b10_Date_started__c = system.today()-5;
            oneForm.X32c10_Date_of_last_visit__c = null;
            oneForm.X32b11_Date_started__c = system.today()-5;
            oneForm.X32c11_Date_of_last_visit__c = null;
            oneForm.X32b12_Date_started__c = system.today()-5;
            oneForm.X32c12_Date_of_last_visit__c = null;
            oneForm.X32b13_Date_started__c = system.today()-5;
            oneForm.X32c13_Date_of_last_visit__c = null;
            oneForm.X32b14_Date_started__c = system.today()-5;
            oneForm.X32c14_Date_of_last_visit__c = null;
            oneForm.X32b15_Date_started__c = system.today()-5;
            oneForm.X32c15_Date_of_last_visit__c = null;
            oneForm.X32b16_Date_started__c = system.today()-5;
            oneForm.X32c16_Date_of_last_visit__c = null;
            oneForm.X32b17_Date_started__c = system.today()-5;
            oneForm.X32c17_Date_of_last_visit__c = null;
            oneForm.X32b18_Date_started__c = system.today()-5;
            oneForm.X32c18_Date_of_last_visit__c = null;
            oneForm.X32b19_Date_started__c = system.today()-5;
            oneForm.X32c19_Date_of_last_visit__c = null;
            oneForm.X32b20_Date_started__c = system.today()-5;
            oneForm.X32c20_Date_of_last_visit__c = null;
            oneForm.X32b21_Date_started__c = system.today()-5;
            oneForm.X32c21_Date_of_last_visit__c = null;
            oneForm.X32b22_Date_started__c = system.today()-5;
            oneForm.X32c22_Date_of_last_visit__c = null;
            oneForm.X32b23_Date_started__c = system.today()-5;
            oneForm.X32c23_Date_of_last_visit__c = null;
            oneForm.X32b24_Date_started__c = system.today()-5;
            oneForm.X32c24_Date_of_last_visit__c = null;
            oneForm.X32b25_Date_started__c = system.today()-5;
            oneForm.X32c25_Date_of_last_visit__c = null;
            oneForm.X32b27_Date_started__c = system.today()-5;
            oneForm.X32c27_Date_of_last_visit__c = null;
            oneForm.X32b28_Date_started__c = system.today()-5;
            oneForm.X32c28_Date_of_last_visit__c = null;
            oneForm.X35_Date_of_Final_Discharge_or_transfer__c= system.today()-4;
            update oneForm;
            
            system.assert (false, 'Should not have got here as an exception should have been thrown');
        }
        catch (Exception e)
        {
            system.debug (e.getMessage());
            system.assert (e.getMessage().contains(label.NDTRS_Intervention_Details_Check));
        }
    }
    
    static testMethod void TestInterventionDetailsCheck_Q32d ()
    { /* All interventions details must be either complete or blank when date of final discharge is set  */
        try
        {
            NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
            oneForm.X32b1_Date_started__c = system.today()-5;
            oneForm.X32d1_Number_of_sessions__c = null;
            oneForm.X32b2_Date_started__c = system.today()-5;
            oneForm.X32d2_Number_of_sessions__c = null;
            oneForm.X32b3_Date_started__c = system.today()-5;
            oneForm.X32d3_Number_of_sessions__c = null;
            oneForm.X32b4_Date_started__c = system.today()-5;
            oneForm.X32d4_Number_of_sessions__c = null;
            oneForm.X32b5_Date_started__c = system.today()-5;
            oneForm.X32d5_Number_of_sessions__c = null;
            oneForm.X32b6_Date_started__c = system.today()-5;
            oneForm.X32d6_Number_of_sessions__c = null;
            oneForm.X32b7_Date_started__c = system.today()-5;
            oneForm.X32d7_Number_of_sessions__c = null;
            oneForm.X32b8_Date_started__c = system.today()-5;
            oneForm.X32d8_Number_of_sessions__c = null;
            oneForm.X32b9_Date_started__c = system.today()-5;
            oneForm.X32d9_Number_of_sessions__c = null;
            oneForm.X32b10_Date_started__c = system.today()-5;
            oneForm.X32d10_Number_of_sessions__c = null;
            oneForm.X32b11_Date_started__c = system.today()-5;
            oneForm.X32d11_Number_of_sessions__c = null;
            oneForm.X32b12_Date_started__c = system.today()-5;
            oneForm.X32d12_Number_of_sessions__c = null;
            oneForm.X32b13_Date_started__c = system.today()-5;
            oneForm.X32d13_Number_of_sessions__c = null;
            oneForm.X32b14_Date_started__c = system.today()-5;
            oneForm.X32d14_Number_of_sessions__c = null;
            oneForm.X32b15_Date_started__c = system.today()-5;
            oneForm.X32d15_Number_of_sessions__c = null;
            oneForm.X32b16_Date_started__c = system.today()-5;
            oneForm.X32d16_Number_of_sessions__c = null;
            oneForm.X32b17_Date_started__c = system.today()-5;
            oneForm.X32d17_Number_of_sessions__c = null;
            oneForm.X32b18_Date_started__c = system.today()-5;
            oneForm.X32d18_Number_of_sessions__c = null;
            oneForm.X32b19_Date_started__c = system.today()-5;
            oneForm.X32d19_Number_of_sessions__c = null;
            oneForm.X32b20_Date_started__c = system.today()-5;
            oneForm.X32d20_Number_of_sessions__c = null;
            oneForm.X32b21_Date_started__c = system.today()-5;
            oneForm.X32d21_Number_of_sessions__c = null;
            oneForm.X32b22_Date_started__c = system.today()-5;
            oneForm.X32d22_Number_of_sessions__c = null;
            oneForm.X32b23_Date_started__c = system.today()-5;
            oneForm.X32d23_Number_of_sessions__c = null;
            oneForm.X32b24_Date_started__c = system.today()-5;
            oneForm.X32d24_Number_of_sessions__c = null;
            oneForm.X32b25_Date_started__c = system.today()-5;
            oneForm.X32d25_Number_of_sessions__c = null;
            oneForm.X32b27_Date_started__c = system.today()-5;
            oneForm.X32d27_Number_of_sessions__c = null;
            oneForm.X32b28_Date_started__c = system.today()-5;
            oneForm.X32d28_Number_of_sessions__c = null;
            oneForm.X26_Age_first_use_any_drug__c = null;
            oneForm.X27_Specify_first_drug_ever_used__c = null;
            oneForm.X28_Difficult_to_assess_main_problem__c = null;
            oneForm.X35_Date_of_Final_Discharge_or_transfer__c= system.today()-4;
            update oneForm;
            
            system.assert (false, 'Should not have got here as an exception should have been thrown');
        }
        catch (Exception e)
        {
            system.debug (e.getMessage());
            system.assert (e.getMessage().contains(label.NDTRS_Intervention_Details_Check));
        }
    }
    
    static testMethod void TestValidationID_171a ()
    {
        try
        {
            NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
            oneForm.X33a_Exit_details__c = '6. Premature exit for non-compliance. Specify reason';
            oneForm.X33a6_Reason_for_exit_6_above__c = null;
            update oneForm;
            
            system.assert (false, 'Should not have got here as an exception should have been thrown');
        }
        catch (Exception e)
        {
            system.assert (e.getMessage().contains(label.NDTRS_Rule_171));
        }
    }
    
    static testMethod void TestValidationID_171b ()
    {
        try
        {
            NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
            oneForm.X33a_Exit_details__c = '10. Other (specify)';
            oneForm.X33a10_Exit_detail_Other__c = null;
            update oneForm;
            
            system.assert (false, 'Should not have got here as an exception should have been thrown');
        }
        catch (Exception e)
        {
            system.assert (e.getMessage().contains(label.NDTRS_Rule_171));
        }
    }
    
    static testMethod void TestValidationID_172 ()
    {
        try
        {
            NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
            oneForm.X33a_Exit_details__c = '2. Transferred/referred to another drug/alcohol treatment service';
            oneForm.X33a2_Transfer_to_Centre__c = null;
            update oneForm;
            
            system.assert (false, 'Should not have got here as an exception should have been thrown');
        }
        catch (Exception e)
        {
            system.assert (e.getMessage().contains(label.NDTRS_Rule_172));
        }
    }   
    
 static testMethod void TestValidationID_174 ()
    {
        try
        {
            NDTRS_Form_2016__c oneForm = createForm(system.today()-20, system.today()-19);
            oneForm.X33a_Exit_details__c = '1. Treatment completed';
            oneForm.X33b_Number_of_others_involved__c = 2;
            oneForm.X34_Client_s_Condition_on_discharge__c = '1. Drug free';
            oneForm.X35_Date_of_Final_Discharge_or_transfer__c = null;
            update oneForm;
            
            system.assert (false, 'Should not have got here as an exception should have been thrown');
        }
        catch (Exception e)
        {
            system.assert (e.getMessage().contains(label.NDTRS_ExitDate));
        }
    }   
     
}