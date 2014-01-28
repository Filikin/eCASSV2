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
            
        Contact client = new Contact(AccountId=acct1.Id,lastname='Driver',firstname='apex1');
        client.MailingStreet = '3 test screen \ntest area\ntest city';
        client.MailingCity = 'Dublin';
        insert client;
        Drug_HRB__c testDrug = new Drug_HRB__c (Name='testDrug');
        testDrug.DrugCode__c = '994';
        testDrug.Tableyear2012__c = true;
        insert testDrug;
        
        HRB_Form__c testTreatment = new HRB_Form__c (Contact__c=client.id, X16_Date_of_Assessment__c=date.valueOf('2010-01-04'), X37_Date_of_Final_Discharge__c =date.valueOf('2011-07-03'));
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
        testTreatment.X33c21_Date_Completed__c = date.valueOf('2011-01-02');
        testTreatment.X33c23_Date_Completed__c = date.valueOf('2011-01-02');
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
        testTreatment.X33d21_Number_of_Sessions__c = 1;
        testTreatment.X33d23_Number_of_Sessions__c = 1;
        testTreatment.X33a_Main_Intervention__c = '1. Brief intervention';
        testTreatment.X29a_Injected_in_past_month__c = '1. Yes';
        testTreatment.X29b_Ever_injected__c = '1. Yes';
        testTreatment.X29c_Age_first_injected__c = 10;
        testTreatment.X30_Ever_shared_any_injecting_equipment__c = '1. Yes';
        testTreatment.X13_Date_of_Referral__c = date.valueOf('2010-01-03');
        insert testTreatment;
        
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