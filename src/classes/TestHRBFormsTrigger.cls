/*
Author: Eamon Kelly, Enclude
Purpose: Test the count of the number of completed HRB Forms
Called from: Test
*/
@isTest
private class TestHRBFormsTrigger 
{
    static testMethod void HRBFormTest() 
    {
        Account acct1 = new Account(name='driver account');
        insert acct1;
            
        Area_of_Residence__c res = new Area_of_Residence__c (Name='Shankill', Area_Code__c='339', CCA__c='1204', City_County__c='D', Tableyear2012__c=true);
        insert res;
        
        Contact client = new Contact(AccountId=acct1.Id,lastname='Driver',firstname='apex1');
        client.MailingStreet = '3 test screen \ntest area\ntest city';
        client.MailingCity = 'Dublin';
        client.X4_Gender__c = 'Male';
        client.BirthDate = date.valueOf ('1990-01-01');
        client.X7a_Living_with_whom__c = '1. Alone';
        client.X7b_Livin_Where__c = '1. sss';
        client.Area_of_Residence_and_Reg_Code__c = res.id;
        client.X10a_Nationality__c = '1. dd';
        client.X10b_Ethnic_Background__c = '1. Irish';
        client.X11_Employement_Status__c = '1. ddd';
        client.X12a_Age_left_primary_school__c = 17;
        client.X12b_Education_highest_level__c = '3. sss';
        insert client;
        
        Drug_HRB__c testDrug = new Drug_HRB__c (Name='testDrug');
        testDrug.DrugCode__c = '994';
        testDrug.Tableyear2012__c = true;
        insert testDrug;
        
        HRB_Form__c testTreatment = new HRB_Form__c (Name='Test', Contact__c=client.id, X16_Date_of_Assessment__c=date.valueOf('2010-01-04'), X37_Date_of_Final_Discharge__c =date.valueOf('2011-07-03'));
 		testTreatment.X21a_Date_This_treatment_started__c = date.valueOf('2011-01-01');
        testTreatment.X34_outcome_for_main_Treatment__c = '1. Treatment completed';
        testTreatment.X36_Client_s_Condition_on_discharge__c = '1. stable';
        testTreatment.X33b1_Date_Commenced__c = date.valueOf('2011-01-01');
        testTreatment.X33b12_Date_Commenced__c = date.valueOf('2011-01-01');
        testTreatment.X33b13_Date_Commenced__c = date.valueOf('2011-01-01');
        testTreatment.X33b14_Date_Commenced__c = date.valueOf('2011-01-01');
        testTreatment.X33b15_Date_Commenced__c = date.valueOf('2011-01-01');
        testTreatment.X33b16_Date_Commenced__c = date.valueOf('2011-01-01');
        testTreatment.X33b17_Date_Commenced__c = date.valueOf('2011-01-01');
        testTreatment.X33b18_Date_Commenced__c = date.valueOf('2011-01-01');
        testTreatment.X33b19_Date_Commenced__c = date.valueOf('2011-01-01');
        testTreatment.X33b20_Date_Commenced__c = date.valueOf('2011-01-01');
        testTreatment.X33b21_Date_Commenced__c = date.valueOf('2011-01-01');
        testTreatment.X33b23_Date_Commenced__c = date.valueOf('2011-01-01');
        testTreatment.X33c1_Date_Completed__c = date.valueOf('2011-01-02');
        testTreatment.X33c12_Date_Completed__c = date.valueOf('2011-01-02');
        testTreatment.X33c13_Date_Completed__c = date.valueOf('2011-01-02');
        testTreatment.X33c14_Date_Completed__c = date.valueOf('2011-01-02');
        testTreatment.X33c15_Date_Completed__c = date.valueOf('2011-01-02');
        testTreatment.X33c16_Date_Completed__c = date.valueOf('2011-01-02');
        testTreatment.X33c17_Date_Completed__c = date.valueOf('2011-01-02');
        testTreatment.X33c18_Date_Completed__c = date.valueOf('2011-01-02');
        testTreatment.X33c19_Date_Completed__c = date.valueOf('2011-01-02');
        testTreatment.X33c20_Date_Completed__c = date.valueOf('2011-01-02');
        testTreatment.X33d1_Number_of_Sessions__c = 1;
        testTreatment.X33d12_Number_of_Sessions__c = 1;
        testTreatment.X33d13_Number_of_Sessions__c = 1;
        testTreatment.X33d14_Number_of_Sessions__c = 1;
        testTreatment.X33d15_Number_of_Sessions__c = 1;
        testTreatment.X33d16_Number_of_Sessions__c = 1;
        testTreatment.X33d17_Number_of_Sesions__c = 1;
        testTreatment.X33d18_Number_of_Sessions__c = 1;
        testTreatment.X33d19_Number_of_Sessions__c = 1;
        testTreatment.X33d20_Number_of_Sessions__c = 1;
        testTreatment.X33a_Main_Intervention__c = '1. Brief intervention';
        testTreatment.X29a_Injected_in_past_month__c = '1. Yes';
        testTreatment.X29b_Ever_injected__c = '1. Yes';
        testTreatment.X29c_Age_first_injected__c = 10;
        testTreatment.X30_Ever_shared_any_injecting_equipment__c = '1. Yes';
        testTreatment.X13_Date_of_Referral__c = date.valueOf('2010-01-03');
        testTreatment.X14_Main_Reason_for_referral__c = '4. something';
        testTreatment.X14_Main_Reason_for_Referral_Drug__c = testDrug.id;
        testTreatment.X15_Source_of_referral__c = '1.something';
        testTreatment.X17a_Assessment_outcome__c = '1. something';
        testTreatment.X17b_Assessment_criterion_fulfilled__c = '1. something';
        testTreatment.X17c_Date_assessment_criteria_fulfilled__c = date.valueOf('2011-01-03');
        testTreatment.X18a_Clients_treatment_status__c = '1. something';
        testTreatment.X19_Accepted_place_at_this_centre__c = '1. something';
        testTreatment.X22_Ever_previously_treated_alc_drug__c = '8. something';
        testTreatment.X22_Ever_previously_treated_re_drug__c = '8. something';
        testTreatment.X23_Type_of_contact_with_this_centre__c = '1. something';
        testTreatment.X24a_Age_first_use_any_drug__c = 10;
        testTreatment.X24b_Specify_first_drug_used__c = testDrug.id;
        testTreatment.X25a_Main_substance__c = testDrug.id;
        testTreatment.X25b_Route_of_Admin_Main_sub__c = '2. something';
        testTreatment.X25c_Frequency_of_use_in_last_mth__c = '2. something';
        testTreatment.X25d_Age_at_1st_use__c = 10;
        insert testTreatment;
        
        HRB_Form__c updatedTreatment = [select ID, Date_latest_intervention_commenced__c from HRB_Form__c where ID = :testTreatment.id limit 1];
        system.assertEquals (date.valueOf('2011-01-01'), updatedTreatment.Date_latest_intervention_commenced__c);
        
        testTreatment.X33b1_Date_Commenced__c = date.valueOf('2011-01-02');
        update testTreatment;

        updatedTreatment = [select ID, Date_latest_intervention_commenced__c from HRB_Form__c where ID = :testTreatment.id limit 1];
        system.assertEquals (date.valueOf('2011-01-02'), updatedTreatment.Date_latest_intervention_commenced__c);

        client = [select Number_of_completed_Treatments__c from Contact where id = :client.id];
        system.assertEquals (1, client.Number_of_completed_Treatments__c);
        
        testTreatment.X37_Date_of_Final_Discharge__c = null;
        update testTreatment;
        
        client = [select Number_of_completed_Treatments__c from Contact where id = :client.id];
        system.assertEquals (0, client.Number_of_completed_Treatments__c);
        
        delete testTreatment;
        client = [select Number_of_completed_Treatments__c from Contact where id = :client.id];
        system.assertEquals (0, client.Number_of_completed_Treatments__c);
     }
}