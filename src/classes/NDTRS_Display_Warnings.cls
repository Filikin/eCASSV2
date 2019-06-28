/*
    Author: Eamon Kelly, Enclude
    Purpose:
        1) Implement validation rules to catch warnings (Errors will be caught on a trigger)
    Called from: NDTRS_Display_Warnings page launched from button on NDTRS records
    Tested in: TestNDTRSWarnings 
 */
 public with sharing class NDTRS_Display_Warnings
{
    public class TreatmentMessage
    {
        public ID recordID {get;set;}
        public String errorMsg {get;set;}
        public TreatmentMessage (Id RecordID, String msg)
        {
            this.recordID = RecordID;
            errorMsg = msg;
        }   
        public TreatmentMessage (Id RecordID, String msg, String param1, String param2)
        {
            this.recordID = RecordID;
            errorMsg = string.format(msg, new String[] {param1, param2});
        }   
    }
    
    public list<TreatmentMessage> warnings {get;set;}
    public NDTRS_Form_2016__c currentForm {get;set;}
    
    public NDTRS_Display_Warnings (ApexPages.StandardController controller)
    {
        warnings = new list<TreatmentMessage>();
        currentForm = (NDTRS_Form_2016__c)controller.getRecord();
        CheckForWarnings ();
    }
    
    public void CheckForWarnings ()
    {
/*        currentForm = [select ID, Age__c, 
            X12_Date_of_Referral__c,X13_Main_Reason_for_referral__c,X13_4_Other_problem_speciify__c,
            X15_Date_of_initial_assessment__c,
            X17_Where_client_is_suitable_for_treatme__c,X17_9_Ohter_specify__c,
            X18_Number_times_started_this_year__c, 
            X19_History_of_treatment_Alcohol__c,X19_History_of_treatment_Drugs__c,X19_History_of_treatment_Other__c,
            X19b_Age_first_treated_Drugs__c,X19d_Age_first_treated_Alcohol__c,X19b_Age_first_treated_Other__c,
            X20a_Ever_received_any_opiate_substituti__c,
            X21a_Date_This_treatment_started__c,X32b1_Date_started__c,
            X32b2_Date_started__c,X32b3_Date_started__c,X32b4_Date_started__c,X32b5_Date_started__c,
            X32b6_Date_started__c,X32b7_Date_started__c,X32b8_Date_started__c,X32b9_Date_started__c,
            X32b10_Date_started__c,X32b11_Date_started__c,X32b12_Date_started__c,X32b13_Date_started__c,
            X32b14_Date_started__c,X32b15_Date_started__c,X32b16_Date_started__c,X32b17_Date_started__c,
            X32b18_Date_started__c,X32b19_Date_started__c,X32b20_Date_started__c,X32b21_Date_started__c,
            X32b22_Date_started__c,X32b23_Date_started__c,X32b24_Date_started__c,X32b25_Date_started__c,
            Contact__r.id,Contact__r.X4b_Age__c,Contact__r.X6_Number_of_children__c,Contact__r.X6a1_Children_under_5yrs_living_whith__c,
            Contact__r.X6b1_Children_under_5_yrs_living_w_other__c,Contact__r.X6c1_Children_under_5yrs_in_care__c,
            Contact__r.X6d1_Children_under_5yrs_living_elsewher__c,Contact__r.X6e1_Children_under_5yrs_living_not_know__c,
            Contact__r.X9a_Education_highest_level__c,Contact__r.X9b_Age_left_primary_school__c,
            Contact__r.X10_Employement_Status__c,Contact__r.X10_8_Specify_other_employment_status__c
            from NDTRS_Form_2016__c where id=:currentForm.id limit 1];
  */          
        String queryString = 'select ';
        queryString += NDTRSHelperFunctions.GetAllFieldsFromNDTRSForm ();
        queryString += NDTRSHelperFunctions.GetAllFieldsFromClient ();
        queryString += ', X13_2_Drug_specify__r.Item_Code__c, X21a_Main_drug__r.Item_Code__c, X22a_Drug_2__r.Item_Code__c, X23a_Drug_3__r.Item_Code__c, X24a_Drug_4__r.Item_Code__c, X25a_Drug_5__r.Item_Code__c, X27_Specify_first_drug_ever_used__r.Item_Code__c, X32a22_Detox_from_other_drug_Specify__r.Item_Code__c';
        queryString += ', X13_2_Drug_specify__r.Name, X21a_Main_drug__r.Name, X22a_Drug_2__r.Name, X23a_Drug_3__r.Name, X24a_Drug_4__r.Name, X25a_Drug_5__r.Name, X27_Specify_first_drug_ever_used__r.Name, X32a22_Detox_from_other_drug_Specify__r.Name';
        queryString += ' from NDTRS_Form_2016__c where id=\'' + currentForm.Id + '\'';
        System.Debug (queryString);
        currentForm = Database.query(queryString);
        
        ValidationID_6 ();
        ValidationID_17b ();
        ValidationID_20 ();
        ValidationID_25 ();
        ValidationID_26a ();
        ValidationID_26b ();
        ValidationID_26c ();
        ValidationID_26d ();
        ValidationID_26e ();
        ValidationID_30 ();
        ValidationID_31 ();
        ValidationID_32 ();
        ValidationID_33 ();
        ValidationID_34 ();
        ValidationID_35 ();
        ValidationID_36 ();
        ValidationID_40 ();
        ValidationID_42 ();
        ValidationID_50 ();
        ValidationID_51_1 ();
        ValidationID_51_2 ();
        ValidationID_51_3 ();
        ValidationID_51_4 ();
        ValidationID_51_5 ();
        ValidationID_51_6 ();
        ValidationID_51_7 ();
        ValidationID_51_8 ();
        ValidationID_51_9 ();
        ValidationID_51_10 ();
        ValidationID_51_11 ();
        ValidationID_51_12 ();
        ValidationID_51_13 ();
        ValidationID_51_14 ();
        ValidationID_51_15 ();
        ValidationID_51_16 ();
        ValidationID_51_17 ();
        ValidationID_51_18 ();
        ValidationID_51_19 ();
        ValidationID_51_20 ();
        ValidationID_51_21 ();
        ValidationID_51_22 ();
        ValidationID_51_23 ();
        ValidationID_51_24 ();
        ValidationID_51_25 ();
        ValidationID_51_26 ();
        ValidationID_51_27 ();
        ValidationID_51_28 ();
        ValidationID_60 ();
        ValidationID_61 ();
        ValidationID_62 ();
 /*     ValidationID_63 (); */
        ValidationID_70 ();
        ValidationID_72 ();
        ValidationID_73 ();
        ValidationID_74 ();
        ValidationID_75 ();
        ValidationID_76a ();
        ValidationID_76b ();
        ValidationID_77 ();
        ValidationID_78 ();
        ValidationID_83 ();
        ValidationID_88 ();
        ValidationID_88_2 ();
        ValidationID_88_3 ();
        ValidationID_88_4 ();
        ValidationID_88_5 ();
        ValidationID_89_to_92 ();
        ValidationID_89_to_92D2 ();
        ValidationID_89_to_92D3 ();
        ValidationID_89_to_92D4 ();
        ValidationID_89_to_92D5 ();
        ValidationID_93 ();
        ValidationID_93D2 ();
        ValidationID_93D3 ();
        ValidationID_93D4 ();
        ValidationID_93D5 ();
        ValidationID_94_to_96 ();
        ValidationID_94_to_96D2 ();
        ValidationID_94_to_96D3 ();
        ValidationID_94_to_96D4 ();
        ValidationID_94_to_96D5 ();
/*      ValidationID_102_D1 (); */
        ValidationID_102_D2 ();
        ValidationID_102_D3 ();
        ValidationID_102_D4 ();
        ValidationID_102_D5 ();
/*      ValidationID_105_to_106 (); */
        ValidationID_105_to_106D1 ();
        ValidationID_105_to_106D2 ();
        ValidationID_105_to_106D3 ();
        ValidationID_105_to_106D4 ();
        ValidationID_105_to_106D5 ();
        ValidationID_107_to_108D1 ();
        ValidationID_107_to_108D2 ();
        ValidationID_107_to_108D3 ();
        ValidationID_107_to_108D4 ();
        ValidationID_107_to_108D5 ();
        ValidationID_111_to_112D21 ();
        ValidationID_111_to_112D22 ();
        ValidationID_111_to_112D23 ();
        ValidationID_111_to_112D24 ();
        ValidationID_111_to_112D25 ();
        ValidationID_111_to_112D26 ();
        ValidationID_116 ();
        ValidationID_117 ();
        ValidationID_119D1 ();
        ValidationID_119D2 ();
        ValidationID_119D3 ();
        ValidationID_119D4 ();
        ValidationID_119D5 ();
        ValidationID_120D1 ();
        ValidationID_120D2 ();
        ValidationID_120D3 ();
        ValidationID_120D4 ();
        ValidationID_120D5 ();
        ValidationID_121 ();
        ValidationID_124 ();
        ValidationID_125 ();
        ValidationID_126 ();
        ValidationID_132 ();
        ValidationID_141 ();
        ValidationID_146_1 ();
        ValidationID_146_1b ();
        ValidationID_146_2 ();
        ValidationID_146_2b ();
        ValidationID_146_3 ();
        ValidationID_146_3b ();
        ValidationID_146_4 ();
        ValidationID_146_4b ();
        ValidationID_146_5 ();
        ValidationID_146_5b ();
        ValidationID_146_6 ();
        ValidationID_146_6b ();
        ValidationID_146_7 ();
        ValidationID_146_7b ();
        ValidationID_146_8 ();
        ValidationID_146_8b ();
        ValidationID_146_9 ();
        ValidationID_146_9b ();
        ValidationID_146_10 ();
        ValidationID_146_10b ();
        ValidationID_146_11 ();
        ValidationID_146_11b ();
        ValidationID_146_12 ();
        ValidationID_146_12b ();
        ValidationID_146_13 ();
        ValidationID_146_13b ();
        ValidationID_146_14 ();
        ValidationID_146_14b ();
        ValidationID_146_15 ();
        ValidationID_146_15b ();
        ValidationID_146_16 ();
        ValidationID_146_16b ();
        ValidationID_146_17 ();
        ValidationID_146_17b ();
        ValidationID_146_18 ();
        ValidationID_146_18b ();
        ValidationID_146_19 ();
        ValidationID_146_19b ();
        ValidationID_146_20 ();
        ValidationID_146_20b ();
        ValidationID_146_21 ();
        ValidationID_146_21b ();
        ValidationID_146_22 ();
        ValidationID_146_22b ();
        ValidationID_146_23 ();
        ValidationID_146_23b ();
        ValidationID_146_24 ();
        ValidationID_146_24b ();
        ValidationID_146_25 ();
        ValidationID_146_25b ();
        ValidationID_146_27 ();
        ValidationID_146_27b ();
        ValidationID_146_28 ();
        ValidationID_146_28b ();
        ValidationID_147_1 ();
        ValidationID_147_2 ();
        ValidationID_147_3 ();
        ValidationID_147_4 ();
        ValidationID_147_5 ();
        ValidationID_147_6 ();
        ValidationID_147_7 ();
        ValidationID_147_8 ();
        ValidationID_147_9 ();
        ValidationID_147_10 ();
        ValidationID_147_11 ();
        ValidationID_147_12 ();
        ValidationID_147_13 ();
        ValidationID_147_14 ();
        ValidationID_147_15 ();
        ValidationID_147_16 ();
        ValidationID_147_17 ();
        ValidationID_147_18 ();
        ValidationID_147_19 ();
        ValidationID_147_20 ();
        ValidationID_147_21 ();
        ValidationID_147_22 ();
        ValidationID_147_23 ();
        ValidationID_147_24 ();
        ValidationID_147_25 ();
        ValidationID_147_27 ();
        ValidationID_147_28 ();
        ValidationID_148_DA ();
        ValidationID_148_DH ();
        ValidationID_148_DM ();
        ValidationID_148_DB_1 ();
        ValidationID_148_DB_2 ();
        ValidationID_148_DZ_1 ();
        ValidationID_148_DZ_2 ();
        ValidationID_149 ();
        ValidationID_150 ();
        ValidationID_151 ();
        ValidationID_152 ();
        ValidationID_153 ();
        ValidationID_155 ();
        ValidationID_156 ();
        ValidationID_157 ();
        ValidationID_158 ();
        ValidationID_163_1 ();
        ValidationID_163_2 ();
        ValidationID_163_3 ();
        ValidationID_163_4 ();
        ValidationID_163_5 ();
        ValidationID_163_6 ();
        ValidationID_163_7 ();
        ValidationID_163_8 ();
        ValidationID_163_9 ();
        ValidationID_163_10 ();
        ValidationID_163_11 ();
        ValidationID_163_12 ();
        ValidationID_163_13 ();
        ValidationID_163_14 ();
        ValidationID_163_15 ();
        ValidationID_163_16 ();
        ValidationID_163_17 ();
        ValidationID_163_18 ();
        ValidationID_163_19 ();
        ValidationID_163_20 ();
        ValidationID_163_21 ();
        ValidationID_163_22 ();
        ValidationID_163_23 ();
        ValidationID_163_24 ();
        ValidationID_163_25 ();
        ValidationID_163_27 ();
        ValidationID_163_28 ();
        ValidationID_173 ();
        ValidationID_175D1 ();
        ValidationID_175D2 ();
        ValidationID_175D3 ();
        ValidationID_175D4 ();
        ValidationID_175D5 ();
        ValidationID_176 ();
        ValidationID_177D1 ();
        ValidationID_177D2 ();
        ValidationID_177D3 ();
        ValidationID_177D4 ();
        ValidationID_177D5 ();
        ValidationID_178 ();
        ValidationID_179 ();
        ValidationID_180 ();
        ValidationID_181 ();
        ValidationID_182 ();
        ValidationID_188 ();
        ValidationID_189 ();
       
    }
    
    public void ValidationID_6 ()
    {
        if (currentForm.X12_Date_of_Referral__c == null || currentForm.X15_Date_of_initial_assessment__c == null || currentForm.X21a_Date_This_treatment_started__c == null)
        {
            return;
        }
        if (currentForm.X12_Date_of_Referral__c.daysBetween (currentForm.X15_Date_of_initial_assessment__c) > 90
        || currentForm.X15_Date_of_initial_assessment__c.daysBetween (currentForm.X21a_Date_This_treatment_started__c) > 90)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_6));
        }
    }
    
    public void ValidationID_17b ()
    {
        if (currentForm.Age__c < 10 || currentForm.Age__c > 75)
        {
            warnings.add (new TreatmentMessage (currentForm.Contact__r.id, label.NDTRS_Rule_17b));
        }
    }
    
    public void ValidationID_20 ()
    {
        if (currentForm.Contact__r.X7_Living_Where__c == null && currentForm.Centre__c == null) return;
        if (currentForm.Contact__r.X7_Living_Where__c != null && currentForm.Contact__r.X7_Living_Where__c.startsWith('5.') && currentForm.Centre__c != null && !currentForm.Centre__c.endsWith('41'))
        {
            warnings.add (new TreatmentMessage (currentForm.Contact__r.id, label.NDTRS_Rule_20));
        }
    }

    public void ValidationID_25 ()
    {
        if (currentForm.Age__c < 15 && currentForm.Contact__r.X6_Total_Number_of_Children__c > 0 && currentForm.Contact__r.X6_Total_Number_of_Children__c < 99)
        {
            warnings.add (new TreatmentMessage (currentForm.Contact__r.id, label.NDTRS_Rule_25));
        }
    }
    
    public void ValidationID_26a ()
    {   
        if (currentForm.Age__c > 55 && currentForm.Contact__r.X6a1_Children_under_5yrs_living_whith__c > 0)
        {
            warnings.add (new TreatmentMessage (currentForm.Contact__r.id, label.NDTRS_Rule_26));
        }
    }
    
    public void ValidationID_26b ()
    {   
        if (currentForm.Age__c > 55 && currentForm.Contact__r.X6b1_Children_under_5_yrs_living_w_other__c > 0)
        {
            warnings.add (new TreatmentMessage (currentForm.Contact__r.id, label.NDTRS_Rule_26));
        }
    }
    
    public void ValidationID_26c ()
    {   
        if (currentForm.Age__c > 55 && currentForm.Contact__r.X6c1_Children_under_5yrs_in_care__c > 0)
        {
            warnings.add (new TreatmentMessage (currentForm.Contact__r.id, label.NDTRS_Rule_26));
        }
    }
    
    public void ValidationID_26d ()
    {   
        if (currentForm.Age__c > 55 && currentForm.Contact__r.X6d1_Children_under_5yrs_living_elsewher__c > 0)
        {
            warnings.add (new TreatmentMessage (currentForm.Contact__r.id, label.NDTRS_Rule_26));
        }
    }
    
    public void ValidationID_26e ()
    {   
        if (currentForm.Age__c > 55 && currentForm.Contact__r.X6e1_Children_under_5yrs_living_not_know__c > 0)
        {
            warnings.add (new TreatmentMessage (currentForm.Contact__r.id, label.NDTRS_Rule_26));
        }
    }
    
    public void ValidationID_30 ()
    {
        if (!currentForm.Contact__r.X9a_Education_highest_level__c.startsWith('5.') && (currentForm.Contact__r.X9b_Age_left_primary_school__c < 6 || currentForm.Contact__r.X9b_Age_left_primary_school__c > 21) && currentForm.Contact__r.X9b_Age_left_primary_school__c <> 88)
        {
            warnings.add (new TreatmentMessage (currentForm.Contact__r.id, label.NDTRS_Rule_30));
        }
    }
    
    public void ValidationID_31 ()
    {
        if (currentForm.Age__c > 20 && currentForm.Contact__r.X9b_Age_left_primary_school__c == 88)
        {
            warnings.add (new TreatmentMessage (currentForm.Contact__r.id, label.NDTRS_Rule_31));
        }
    }
    
    public void ValidationID_32 ()
    {
        if (currentForm.Contact__r.X9a_Education_highest_level__c.startsWith('5.') && currentForm.Contact__r.X9b_Age_left_primary_school__c != 1) 
        {
            warnings.add (new TreatmentMessage (currentForm.Contact__r.id, label.NDTRS_Rule_32));
        }
    }
    
    public void ValidationID_33 ()
    {
        if (currentForm.Contact__r.X9a_Education_highest_level__c.startsWith('3.') && currentForm.Contact__r.X9b_Age_left_primary_school__c < 16) 
        {
            warnings.add (new TreatmentMessage (currentForm.Contact__r.id, label.NDTRS_Rule_33));
        }
    }
    
    public void ValidationID_34 ()
    {
        if (currentForm.Contact__r.X9b_Age_left_primary_school__c > 16 && currentForm.Contact__r.X9a_Education_highest_level__c.startsWith('0.')
        || currentForm.Contact__r.X9b_Age_left_primary_school__c > 16 && currentForm.Contact__r.X9a_Education_highest_level__c.startsWith('1.'))
        {
            warnings.add (new TreatmentMessage (currentForm.Contact__r.id, label.NDTRS_Rule_34));
        }
    }
    
    public void ValidationID_35 ()
    {
        if (currentForm.Contact__r.X9a_Education_highest_level__c.startsWith('4.') && currentForm.Contact__r.X9b_Age_left_primary_school__c < 16) 
        {
            warnings.add (new TreatmentMessage (currentForm.Contact__r.id, label.NDTRS_Rule_35));
        }
    }
    
    public void ValidationID_36 ()
    {
        if (currentForm.Contact__r.X9a_Education_highest_level__c.startsWith('0.') && currentForm.Contact__r.X9b_Age_left_primary_school__c > 14) 
        {
            warnings.add (new TreatmentMessage (currentForm.Contact__r.id, label.NDTRS_Rule_36));
        }
    }
    
    public void ValidationID_40 ()
    {
        if (currentForm.Contact__r.X10_Employement_Status__c == null) return;
        if (currentForm.Contact__r.X10_Employement_Status__c.startsWith('8.') && currentForm.Contact__r.X10_8_Specify_other_employment_status__c == null) 
        {
            warnings.add (new TreatmentMessage (currentForm.Contact__r.id, label.NDTRS_Rule_40));
        }
    }
    
    public void ValidationID_42 ()
    {
        if (currentForm.Contact__r.X10_Employement_Status__c == null) return;
        if (currentForm.Age__c > 66 && currentForm.Contact__r.X10_Employement_Status__c.startsWith('2.')) 
        {
            warnings.add (new TreatmentMessage (currentForm.Contact__r.id, label.NDTRS_Rule_42));
        }
    }
    
    public void ValidationID_50 ()
    {
        if (currentForm.X17_Where_client_is_suitable_for_treatme__c == null) return;
        if (currentForm.X17_Where_client_is_suitable_for_treatme__c.startsWith('9.') && currentForm.X17_9_Ohter_specify__c == null)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_50));
        }
    }   
    
    public void ValidationID_51_1 ()
    {
        if (currentForm.X15_Date_of_initial_assessment__c == null ||currentForm.X32b1_Date_started__c == null) return;
        if (currentForm.X15_Date_of_initial_assessment__c.daysBetween (currentForm.X32b1_Date_started__c) > 30)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_51_1));
        }
    }   
    
    public void ValidationID_51_2 ()
    {
        if (currentForm.X15_Date_of_initial_assessment__c == null ||currentForm.X32b2_Date_started__c == null) return;
        if (currentForm.X15_Date_of_initial_assessment__c.daysBetween (currentForm.X32b2_Date_started__c) > 30)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_51_2));
        }
    }   
    
    public void ValidationID_51_3 ()
    {
        if (currentForm.X15_Date_of_initial_assessment__c == null ||currentForm.X32b3_Date_started__c == null) return;
        if (currentForm.X15_Date_of_initial_assessment__c.daysBetween (currentForm.X32b3_Date_started__c) > 30)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_51_3));
        }
    }   
    
    public void ValidationID_51_4 ()
    {
        if (currentForm.X15_Date_of_initial_assessment__c == null ||currentForm.X32b4_Date_started__c == null) return;
        if (currentForm.X15_Date_of_initial_assessment__c.daysBetween (currentForm.X32b4_Date_started__c) > 30)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_51_4));
        }
    }
    
    public void ValidationID_51_5 ()
    {
        if (currentForm.X15_Date_of_initial_assessment__c == null ||currentForm.X32b5_Date_started__c == null) return;
        if (currentForm.X15_Date_of_initial_assessment__c.daysBetween (currentForm.X32b5_Date_started__c) > 30)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_51_5));
        }
    }
    
    public void ValidationID_51_6 ()
    {
        if (currentForm.X15_Date_of_initial_assessment__c == null ||currentForm.X32b6_Date_started__c == null) return;
        if (currentForm.X15_Date_of_initial_assessment__c.daysBetween (currentForm.X32b6_Date_started__c) > 30)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_51_6));
        }
    }
    
    public void ValidationID_51_7 ()
    {
        if (currentForm.X15_Date_of_initial_assessment__c == null ||currentForm.X32b7_Date_started__c == null) return;
        if (currentForm.X15_Date_of_initial_assessment__c.daysBetween (currentForm.X32b7_Date_started__c) > 30)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_51_7));
        }
    }
    
    public void ValidationID_51_8 ()
    {
        if (currentForm.X15_Date_of_initial_assessment__c == null ||currentForm.X32b8_Date_started__c == null) return;
        if (currentForm.X15_Date_of_initial_assessment__c.daysBetween (currentForm.X32b8_Date_started__c) > 30)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_51_8));
        }
    }
    
    public void ValidationID_51_9 ()
    {
        if (currentForm.X15_Date_of_initial_assessment__c == null ||currentForm.X32b9_Date_started__c == null) return;
        if (currentForm.X15_Date_of_initial_assessment__c.daysBetween (currentForm.X32b9_Date_started__c) > 30)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_51_9));
        }
    }
    
    public void ValidationID_51_10 ()
    {
        if (currentForm.X15_Date_of_initial_assessment__c == null ||currentForm.X32b10_Date_started__c == null) return;
        if (currentForm.X15_Date_of_initial_assessment__c.daysBetween (currentForm.X32b10_Date_started__c) > 30)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_51_10));
        }
    }
    
    public void ValidationID_51_11 ()
    {
        if (currentForm.X15_Date_of_initial_assessment__c == null ||currentForm.X32b11_Date_started__c == null) return;
        if (currentForm.X15_Date_of_initial_assessment__c.daysBetween (currentForm.X32b11_Date_started__c) > 30)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_51_11));
        }
    }
    public void ValidationID_51_12 ()
    {
        if (currentForm.X15_Date_of_initial_assessment__c == null ||currentForm.X32b12_Date_started__c == null) return;
        if (currentForm.X15_Date_of_initial_assessment__c.daysBetween (currentForm.X32b12_Date_started__c) > 30)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_51_12));
        }
    }
    
    public void ValidationID_51_13 ()
    {
        if (currentForm.X15_Date_of_initial_assessment__c == null ||currentForm.X32b13_Date_started__c == null) return;
        if (currentForm.X15_Date_of_initial_assessment__c.daysBetween (currentForm.X32b13_Date_started__c) > 30)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_51_13));
        }
    }
    
    public void ValidationID_51_14 ()
    {
        if (currentForm.X15_Date_of_initial_assessment__c == null ||currentForm.X32b14_Date_started__c == null) return;
        if (currentForm.X15_Date_of_initial_assessment__c.daysBetween (currentForm.X32b14_Date_started__c) > 30)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_51_14));
        }
    }
    
    public void ValidationID_51_15 ()
    {
        if (currentForm.X15_Date_of_initial_assessment__c == null ||currentForm.X32b15_Date_started__c == null) return;
        if (currentForm.X15_Date_of_initial_assessment__c.daysBetween (currentForm.X32b15_Date_started__c) > 30)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_51_15));
        }
    }
    
    public void ValidationID_51_16 ()
    {
        if (currentForm.X15_Date_of_initial_assessment__c == null ||currentForm.X32b16_Date_started__c == null) return;
        if (currentForm.X15_Date_of_initial_assessment__c.daysBetween (currentForm.X32b16_Date_started__c) > 30)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_51_16));
        }
    }
    
    public void ValidationID_51_17 ()
    {
        if (currentForm.X15_Date_of_initial_assessment__c == null ||currentForm.X32b17_Date_started__c == null) return;
        if (currentForm.X15_Date_of_initial_assessment__c.daysBetween (currentForm.X32b17_Date_started__c) > 30)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_51_17));
        }
    }
    
    public void ValidationID_51_18 ()
    {
        if (currentForm.X15_Date_of_initial_assessment__c == null ||currentForm.X32b18_Date_started__c == null) return;
        if (currentForm.X15_Date_of_initial_assessment__c.daysBetween (currentForm.X32b18_Date_started__c) > 30)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_51_18));
        }
    }
    
    public void ValidationID_51_19 ()
    {
        if (currentForm.X15_Date_of_initial_assessment__c == null ||currentForm.X32b19_Date_started__c == null) return;
        if (currentForm.X15_Date_of_initial_assessment__c.daysBetween (currentForm.X32b19_Date_started__c) > 30)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_51_19));
        }
    }
    
    public void ValidationID_51_20 ()
    {
        if (currentForm.X15_Date_of_initial_assessment__c == null ||currentForm.X32b20_Date_started__c == null) return;
        if (currentForm.X15_Date_of_initial_assessment__c.daysBetween (currentForm.X32b20_Date_started__c) > 30)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_51_20));
        }
    }
    
    public void ValidationID_51_21 ()
    {
        if (currentForm.X15_Date_of_initial_assessment__c == null ||currentForm.X32b21_Date_started__c == null) return;
        if (currentForm.X15_Date_of_initial_assessment__c.daysBetween (currentForm.X32b21_Date_started__c) > 30)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_51_21));
        }
    }
    
    public void ValidationID_51_22 ()
    {
        if (currentForm.X15_Date_of_initial_assessment__c == null ||currentForm.X32b22_Date_started__c == null) return;
        if (currentForm.X15_Date_of_initial_assessment__c.daysBetween (currentForm.X32b22_Date_started__c) > 30)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_51_22));
        }
    }
    
    public void ValidationID_51_23 ()
    {
        if (currentForm.X15_Date_of_initial_assessment__c == null ||currentForm.X32b23_Date_started__c == null) return;
        if (currentForm.X15_Date_of_initial_assessment__c.daysBetween (currentForm.X32b23_Date_started__c) > 30)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_51_23));
        }
    }
    
    public void ValidationID_51_24 ()
    {
        if (currentForm.X15_Date_of_initial_assessment__c == null ||currentForm.X32b24_Date_started__c == null) return;
        if (currentForm.X15_Date_of_initial_assessment__c.daysBetween (currentForm.X32b24_Date_started__c) > 30)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_51_24));
        }
    }
    
    public void ValidationID_51_25 ()
    {
        if (currentForm.X15_Date_of_initial_assessment__c == null ||currentForm.X32b25_Date_started__c == null) return;
        if (currentForm.X15_Date_of_initial_assessment__c.daysBetween (currentForm.X32b25_Date_started__c) > 30)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_51_25));
        }
    }
    
    public void ValidationID_51_26 ()
    {
        if (currentForm.X15_Date_of_initial_assessment__c == null ||currentForm.X32b26_Date_started__c == null) return;
        if (currentForm.X15_Date_of_initial_assessment__c.daysBetween (currentForm.X32b26_Date_started__c) > 30)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_51_26));
        }
    }
    
    public void ValidationID_51_27 ()
    {
        if (currentForm.X15_Date_of_initial_assessment__c == null ||currentForm.X32b27_Date_started__c == null) return;
        if (currentForm.X15_Date_of_initial_assessment__c.daysBetween (currentForm.X32b27_Date_started__c) > 30)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_51_27));
        }
    }
    
    public void ValidationID_51_28 ()
    {
        if (currentForm.X15_Date_of_initial_assessment__c == null ||currentForm.X32b28_Date_started__c == null) return;
        if (currentForm.X15_Date_of_initial_assessment__c.daysBetween (currentForm.X32b28_Date_started__c) > 30)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_51_28));
        }
    }
    
    
    public void ValidationID_60 ()
    {
        if (currentForm.X13_Main_Reason_for_referral__c == null || currentForm.X18_Number_times_started_this_year__c == null ||currentForm.X19_History_of_treatment_Drugs__c == null) return;
        if (currentForm.X13_Main_Reason_for_referral__c.startsWith('2.') && currentForm.X18_Number_times_started_this_year__c > 1 && currentForm.X19_History_of_treatment_Drugs__c.startsWith('1.'))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_60));
        }
    }
    
    public void ValidationID_61 ()
    {
        if (currentForm.X13_Main_Reason_for_referral__c == null || currentForm.X18_Number_times_started_this_year__c == null ||currentForm.X19_History_of_treatment_Alcohol__c == null) return;
        if (currentForm.X13_Main_Reason_for_referral__c.startsWith('1.') && currentForm.X18_Number_times_started_this_year__c > 1 && currentForm.X19_History_of_treatment_Alcohol__c.startsWith('1.'))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_61));
        }
    }
 
    public void ValidationID_62 ()
    {
        if (currentForm.X13_Main_Reason_for_referral__c == null || currentForm.X18_Number_times_started_this_year__c == null ||currentForm.X19_History_of_treatment_Other__c == null) return;
        if (currentForm.X13_Main_Reason_for_referral__c.startsWith('4.') && currentForm.X18_Number_times_started_this_year__c > 1 && currentForm.X19_History_of_treatment_Other__c.startsWith('1.'))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_62));
        }
    }
 /*  
    public void ValidationID_63 ()
    {
        if (currentForm.X13_Main_Reason_for_referral__c == null || currentForm.X19_History_of_treatment_Drugs__c == null ||currentForm.X20a_Ever_received_any_opiate_substituti__c == null) return;
        if (currentForm.X13_Main_Reason_for_referral__c.startsWith('2.') && currentForm.X19_History_of_treatment_Drugs__c.startsWith('1.') && currentForm.X19b_Age_first_treated_Drugs__c != null &&
            currentForm.X20a_Ever_received_any_opiate_substituti__c.startsWith('1.') && currentForm.X20b_Age_first_received_any_opiate_subst__c != null)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_63));
        }
    }
*/
    public void ValidationID_70 ()
    {
        if (currentForm.X19_History_of_treatment_Drugs__c == null || currentForm.X19b_Age_first_treated_Drugs__c == null) return;
        if (currentForm.X19_History_of_treatment_Drugs__c.startsWith('2.') && currentForm.X19b_Age_first_treated_Drugs__c <16 )
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_70));
        }
    }
    
    public void ValidationID_72 ()
    {
        if (currentForm.X19_History_of_treatment_Drugs__c == null) return;
        if (currentForm.X19_History_of_treatment_Drugs__c.startsWith('2.') && currentForm.X19b_Age_first_treated_Drugs__c == null )
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_72));
        }
    }
    
    public void ValidationID_73 ()
    {
        if (currentForm.X18_Number_times_started_this_year__c == null || currentForm.X19_History_of_treatment_Drugs__c == null || currentForm.X19_History_of_treatment_Alcohol__c == null) return;
        if (currentForm.X18_Number_times_started_this_year__c > 1 && currentForm.X19_History_of_treatment_Drugs__c.startsWith('1.') && currentForm.X19_History_of_treatment_Alcohol__c.startsWith('1.') )
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_73));
        }
    }
    
    public void ValidationID_74 ()
    {
        if (currentForm.X19d_Age_first_treated_Alcohol__c == null) return;
        if (currentForm.X19d_Age_first_treated_Alcohol__c <16 )
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_74));
        }
    }
    
    public void ValidationID_75 ()
    {
        if (currentForm.X19_History_of_treatment_Alcohol__c == null) return;
        if (currentForm.X19_History_of_treatment_Alcohol__c.startsWith('2.') && currentForm.X19d_Age_first_treated_Alcohol__c == null )
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_75));
        }
    }
    
    public void ValidationID_76a ()
    {
        if (currentForm.X13_Main_Reason_for_referral__c == null) return;
        if (currentForm.X13_Main_Reason_for_referral__c.startsWith('4.') && currentForm.X19_History_of_treatment_Other__c == null)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_76a));
        }
    }
    
    public void ValidationID_76b ()
    {
        if (currentForm.X13_Main_Reason_for_referral__c == null) return;
        if (currentForm.X13_Main_Reason_for_referral__c.startsWith('4.') && currentForm.X19b_Age_first_treated_Other__c == null)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_76b));
        }
    }
    
    public void ValidationID_77 ()
    {
        if (currentForm.X13_Main_Reason_for_referral__c == null) return;
        if (currentForm.X13_Main_Reason_for_referral__c.startsWith('4.') && currentForm.X13_4_Other_problem_speciify__c == null)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_77));
        }
    }
    
    public void ValidationID_78 ()
    {
        if (currentForm.X13_Main_Reason_for_referral__c == null) return;
        if (currentForm.X13_Main_Reason_for_referral__c.startsWith('4.') && currentForm.X19b_Age_first_treated_Other__c < 16)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_78));
        }
    }
    
    public void ValidationID_83 ()
    {
        if (currentForm.X20a_Ever_received_any_opiate_substituti__c == null) return;
        if (currentForm.X20a_Ever_received_any_opiate_substituti__c.startsWith('1.') && currentForm.X20b_Age_first_received_any_opiate_subst__c < 16)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_83));
        }
    }
    
    public void ValidationID_88 ()
    {
        if (currentForm.X21a_Main_drug__c == null || currentForm.X21b_Route_of_Admin_Main_drug__c == null) return; 
        if (currentForm.X21a_Main_drug__c != null && currentForm.X21a_Main_drug__r.Item_Code__c == 111 && currentForm.X21b_Route_of_Admin_Main_drug__c != null && currentForm.X21b_Route_of_Admin_Main_drug__c.startsWith('3.'))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_88));
        }
    }
    
    public void ValidationID_88_2 ()
    {
        if (currentForm.X22a_Drug_2__c == null || currentForm.X22b_Route_of_Admin_Drug2__c == null) return; 
        if (currentForm.X22a_Drug_2__r.Item_Code__c == 111 && currentForm.X22b_Route_of_Admin_Drug2__c.startsWith('3.'))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_88));
        }
    }
    
    public void ValidationID_88_3 ()
    {
        if (currentForm.X23a_Drug_3__c == null || currentForm.X23b_Route_of_Admin_Drug3__c == null) return; 
        if (currentForm.X23a_Drug_3__r.Item_Code__c == 111 && currentForm.X23b_Route_of_Admin_Drug3__c.startsWith('3.'))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_88));
        }
    }
    
    public void ValidationID_88_4 ()
    {
        if (currentForm.X24a_Drug_4__c == null || currentForm.X24b_Route_of_Admin_Drug4__c == null) return; 
        if (currentForm.X24a_Drug_4__r.Item_Code__c == 111 && currentForm.X24b_Route_of_Admin_Drug4__c.startsWith('3.'))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_88));
        }
    }
    
    public void ValidationID_88_5 ()
    {
        if (currentForm.X25a_Drug_5__c == null || currentForm.X25b_Route_of_Admin_Drug5__c == null) return; 
        if (currentForm.X25a_Drug_5__r.Item_Code__c == 111 && currentForm.X25b_Route_of_Admin_Drug5__c.startsWith('3.'))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_88));
        }
    }
    
    public void ValidationID_89_to_92 ()
    {
        if (currentForm.X21a_Main_drug__c == null || currentForm.X21b_Route_of_Admin_Main_drug__c == null) return; 
        // first rules 89, 90 and 92
        if (((currentForm.X21a_Main_drug__r.Item_Code__c >= 121 && currentForm.X21a_Main_drug__r.Item_Code__c <= 181) ||
            (currentForm.X21a_Main_drug__r.Item_Code__c >= 230 && currentForm.X21a_Main_drug__r.Item_Code__c <= 238) || 
            (currentForm.X21a_Main_drug__r.Item_Code__c >= 300 && currentForm.X21a_Main_drug__r.Item_Code__c <= 388)) && 
            (currentForm.X21b_Route_of_Admin_Main_drug__c.startsWith('2.') || currentForm.X21b_Route_of_Admin_Main_drug__c.startsWith('4.')))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_89, currentForm.X21a_Main_drug__r.Name, currentForm.X21b_Route_of_Admin_Main_drug__c));
        }
        // now rule 91
        else if (currentForm.X21a_Main_drug__r.Item_Code__c == 240 && !currentForm.X21b_Route_of_Admin_Main_drug__c.startsWith('3.'))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_89, currentForm.X21a_Main_drug__r.Name, currentForm.X21b_Route_of_Admin_Main_drug__c));
        }
    }
    
    public void ValidationID_89_to_92D2 ()
    {
        if (currentForm.X22a_Drug_2__c == null || currentForm.X22b_Route_of_Admin_Drug2__c == null) return; 
        // first rules 89, 90 and 92
        if (((currentForm.X22a_Drug_2__r.Item_Code__c >= 121 && currentForm.X22a_Drug_2__r.Item_Code__c <= 181) ||
            (currentForm.X22a_Drug_2__r.Item_Code__c >= 230 && currentForm.X22a_Drug_2__r.Item_Code__c <= 238) || 
            (currentForm.X22a_Drug_2__r.Item_Code__c >= 300 && currentForm.X22a_Drug_2__r.Item_Code__c <= 388)) 
            && (currentForm.X22b_Route_of_Admin_Drug2__c.startsWith('2.') || currentForm.X22b_Route_of_Admin_Drug2__c.startsWith('4.')))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_89, currentForm.X22a_Drug_2__r.Name, currentForm.X22b_Route_of_Admin_Drug2__c));
        }
        // now rule 91
        else if (currentForm.X22a_Drug_2__r.Item_Code__c == 240 && !currentForm.X22b_Route_of_Admin_Drug2__c.startsWith('3.'))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_89, currentForm.X22a_Drug_2__r.Name, currentForm.X22b_Route_of_Admin_Drug2__c));
        }
    }
    
    public void ValidationID_89_to_92D3 ()
    {
        if (currentForm.X23a_Drug_3__c == null || currentForm.X23b_Route_of_Admin_Drug3__c == null) return; 
        // first rules 89, 90 and 92
        if (((currentForm.X23a_Drug_3__r.Item_Code__c >= 121 && currentForm.X23a_Drug_3__r.Item_Code__c <= 181) ||
            (currentForm.X23a_Drug_3__r.Item_Code__c >= 230 && currentForm.X23a_Drug_3__r.Item_Code__c <= 238) || 
            (currentForm.X23a_Drug_3__r.Item_Code__c >= 300 && currentForm.X23a_Drug_3__r.Item_Code__c <= 388)) 
            && (currentForm.X23b_Route_of_Admin_Drug3__c.startsWith('2.') || currentForm.X23b_Route_of_Admin_Drug3__c.startsWith('4.')))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_89, currentForm.X23a_Drug_3__r.Name, currentForm.X23b_Route_of_Admin_Drug3__c));
        }
        // now rule 91
        else if (currentForm.X23a_Drug_3__r.Item_Code__c == 240 && !currentForm.X23b_Route_of_Admin_Drug3__c.startsWith('3.'))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_89, currentForm.X23a_Drug_3__r.Name, currentForm.X23b_Route_of_Admin_Drug3__c));
        }
    }
    
    public void ValidationID_89_to_92D4 ()
    {
        if (currentForm.X24a_Drug_4__c == null || currentForm.X24b_Route_of_Admin_Drug4__c == null) return; 
        // first rules 89, 90 and 92
        if (((currentForm.X24a_Drug_4__r.Item_Code__c >= 121 && currentForm.X24a_Drug_4__r.Item_Code__c <= 181) ||
            (currentForm.X24a_Drug_4__r.Item_Code__c >= 230 && currentForm.X24a_Drug_4__r.Item_Code__c <= 238) || 
            (currentForm.X24a_Drug_4__r.Item_Code__c >= 300 && currentForm.X24a_Drug_4__r.Item_Code__c <= 388)) 
            && (currentForm.X24b_Route_of_Admin_Drug4__c.startsWith('2.') || currentForm.X24b_Route_of_Admin_Drug4__c.startsWith('4.')))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_89, currentForm.X24a_Drug_4__r.Name, currentForm.X24b_Route_of_Admin_Drug4__c));
        }
        // now rule 91
        else if (currentForm.X24a_Drug_4__r.Item_Code__c == 240 && !currentForm.X24b_Route_of_Admin_Drug4__c.startsWith('3.'))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_89, currentForm.X24a_Drug_4__r.Name, currentForm.X24b_Route_of_Admin_Drug4__c));
        }
    }
    
    public void ValidationID_89_to_92D5 ()
    {
        if (currentForm.X25a_Drug_5__c == null || currentForm.X25b_Route_of_Admin_Drug5__c == null) return; 
        // first rules 89, 90 and 92
        if (((currentForm.X25a_Drug_5__r.Item_Code__c >= 121 && currentForm.X25a_Drug_5__r.Item_Code__c <= 181) ||
            (currentForm.X25a_Drug_5__r.Item_Code__c >= 230 && currentForm.X25a_Drug_5__r.Item_Code__c <= 238) || 
            (currentForm.X25a_Drug_5__r.Item_Code__c >= 300 && currentForm.X25a_Drug_5__r.Item_Code__c <= 388)) 
            && (currentForm.X25b_Route_of_Admin_Drug5__c.startsWith('2.') || currentForm.X25b_Route_of_Admin_Drug5__c.startsWith('4.')))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_89, currentForm.X25a_Drug_5__r.Name, currentForm.X25b_Route_of_Admin_Drug5__c));
        }
        // now rule 91
        else if (currentForm.X25a_Drug_5__r.Item_Code__c == 240 && !currentForm.X25b_Route_of_Admin_Drug5__c.startsWith('3.'))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_89, currentForm.X25a_Drug_5__r.Name, currentForm.X25b_Route_of_Admin_Drug5__c));
        }
    }
    
    public void ValidationID_93 ()
    {
        if (currentForm.X21a_Main_drug__c == null || currentForm.X21b_Route_of_Admin_Main_drug__c == null) return;
        if ((currentForm.X21a_Main_drug__r.Item_Code__c >= 400 && currentForm.X21a_Main_drug__r.Item_Code__c <= 488 && !currentForm.X21b_Route_of_Admin_Main_drug__c.startsWith('3.')) &&
            (currentForm.X21a_Main_drug__r.Item_Code__c != 411 && currentForm.X21a_Main_drug__r.Item_Code__c != 423))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_93, currentForm.X21a_Main_drug__r.Name, currentForm.X21b_Route_of_Admin_Main_drug__c));
        }
    }
    
    public void ValidationID_93D2 ()
    {
        if (currentForm.X22a_Drug_2__c == null || currentForm.X22b_Route_of_Admin_Drug2__c == null) return;
        if ((currentForm.X22a_Drug_2__r.Item_Code__c >= 400 && currentForm.X22a_Drug_2__r.Item_Code__c <= 488 && !currentForm.X22b_Route_of_Admin_Drug2__c.startsWith('3.')) &&
            (currentForm.X22a_Drug_2__r.Item_Code__c != 411 && currentForm.X22a_Drug_2__r.Item_Code__c != 423))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_93, currentForm.X22a_Drug_2__r.Name, currentForm.X22b_Route_of_Admin_Drug2__c));
        }
    }
    
    public void ValidationID_93D3 ()
    {
        if (currentForm.X23a_Drug_3__c == null || currentForm.X23b_Route_of_Admin_Drug3__c == null) return;
        if ((currentForm.X23a_Drug_3__r.Item_Code__c >= 400 && currentForm.X23a_Drug_3__r.Item_Code__c <= 488 && !currentForm.X23b_Route_of_Admin_Drug3__c.startsWith('3.')) &&
            (currentForm.X23a_Drug_3__r.Item_Code__c != 411 && currentForm.X23a_Drug_3__r.Item_Code__c != 423))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_93, currentForm.X23a_Drug_3__r.Name, currentForm.X23b_Route_of_Admin_Drug3__c));
        }
    }
    
    public void ValidationID_93D4 ()
    {
        if (currentForm.X24a_Drug_4__c == null || currentForm.X24b_Route_of_Admin_Drug4__c == null) return;
        if ((currentForm.X24a_Drug_4__r.Item_Code__c >= 400 && currentForm.X24a_Drug_4__r.Item_Code__c <= 488 && !currentForm.X24b_Route_of_Admin_Drug4__c.startsWith('3.')) &&
            (currentForm.X24a_Drug_4__r.Item_Code__c != 411 && currentForm.X24a_Drug_4__r.Item_Code__c != 423))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_93, currentForm.X24a_Drug_4__r.Name, currentForm.X24b_Route_of_Admin_Drug4__c));
        }
    }
    
    public void ValidationID_93D5 ()
    {
        if (currentForm.X25a_Drug_5__c == null || currentForm.X25b_Route_of_Admin_Drug5__c == null) return;
        if ((currentForm.X25a_Drug_5__r.Item_Code__c >= 400 && currentForm.X25a_Drug_5__r.Item_Code__c <= 488 && !currentForm.X25b_Route_of_Admin_Drug5__c.startsWith('3.')) &&
            (currentForm.X25a_Drug_5__r.Item_Code__c != 411 && currentForm.X25a_Drug_5__r.Item_Code__c != 423))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_93, currentForm.X25a_Drug_5__r.Name, currentForm.X25b_Route_of_Admin_Drug5__c));
        }
    }
    
    public void ValidationID_94_to_96 ()
    {
        if (currentForm.X21a_Main_drug__c == null || currentForm.X21b_Route_of_Admin_Main_drug__c == null) return; 
        // first rules 94
        if (currentForm.X21a_Main_drug__r.Item_Code__c >= 500 && currentForm.X21a_Main_drug__r.Item_Code__c <= 588 && !currentForm.X21b_Route_of_Admin_Main_drug__c.startsWith('4.'))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_94, currentForm.X21a_Main_drug__r.Name, currentForm.X21b_Route_of_Admin_Main_drug__c));
        }
        // now rule 95
        else if (currentForm.X21a_Main_drug__r.Item_Code__c >= 600 && currentForm.X21a_Main_drug__r.Item_Code__c <= 688 && currentForm.X21b_Route_of_Admin_Main_drug__c.startsWith('1.'))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_95, currentForm.X21a_Main_drug__r.Name, currentForm.X21b_Route_of_Admin_Main_drug__c));
        }
        // now rule 96
        else if (currentForm.X21a_Main_drug__r.Item_Code__c == 700 && !currentForm.X21b_Route_of_Admin_Main_drug__c.startsWith('3.'))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_96, currentForm.X21a_Main_drug__r.Name, currentForm.X21b_Route_of_Admin_Main_drug__c));
        }
    }
    
    public void ValidationID_94_to_96D2 ()
    {
        if (currentForm.X22a_Drug_2__c == null || currentForm.X22b_Route_of_Admin_Drug2__c == null) return; 
        // first rules 94
        if (currentForm.X22a_Drug_2__r.Item_Code__c >= 500 && currentForm.X22a_Drug_2__r.Item_Code__c <= 588 && !currentForm.X22b_Route_of_Admin_Drug2__c.startsWith('4.'))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_94, currentForm.X22a_Drug_2__r.Name, currentForm.X22b_Route_of_Admin_Drug2__c));
        }
        // now rule 95
        else if (currentForm.X22a_Drug_2__r.Item_Code__c >= 600 && currentForm.X22a_Drug_2__r.Item_Code__c <= 688 && currentForm.X22b_Route_of_Admin_Drug2__c.startsWith('1.'))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_95, currentForm.X22a_Drug_2__r.Name, currentForm.X22b_Route_of_Admin_Drug2__c));
        }
        // now rule 96
        else if (currentForm.X22a_Drug_2__r.Item_Code__c == 700 && !currentForm.X22b_Route_of_Admin_Drug2__c.startsWith('3.'))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_96, currentForm.X22a_Drug_2__r.Name, currentForm.X22b_Route_of_Admin_Drug2__c));
        }
    }
    
    public void ValidationID_94_to_96D3 ()
    {
        if (currentForm.X23a_Drug_3__c == null || currentForm.X23b_Route_of_Admin_Drug3__c == null) return; 
        // first rules 94
        if (currentForm.X23a_Drug_3__r.Item_Code__c >= 500 && currentForm.X23a_Drug_3__r.Item_Code__c <= 588 && !currentForm.X23b_Route_of_Admin_Drug3__c.startsWith('4.'))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_94, currentForm.X23a_Drug_3__r.Name, currentForm.X23b_Route_of_Admin_Drug3__c));
        }
        // now rule 95
        else if (currentForm.X23a_Drug_3__r.Item_Code__c >= 600 && currentForm.X23a_Drug_3__r.Item_Code__c <= 688 && currentForm.X23b_Route_of_Admin_Drug3__c.startsWith('1.'))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_95, currentForm.X23a_Drug_3__r.Name, currentForm.X23b_Route_of_Admin_Drug3__c));
        }
        // now rule 96
        else if (currentForm.X23a_Drug_3__r.Item_Code__c == 700 && !currentForm.X23b_Route_of_Admin_Drug3__c.startsWith('3.'))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_96, currentForm.X23a_Drug_3__r.Name, currentForm.X23b_Route_of_Admin_Drug3__c));
        }
    }
    
    public void ValidationID_94_to_96D4 ()
    {
        if (currentForm.X24a_Drug_4__c == null || currentForm.X24b_Route_of_Admin_Drug4__c == null) return; 
        // first rules 94
        if (currentForm.X24a_Drug_4__r.Item_Code__c >= 500 && currentForm.X24a_Drug_4__r.Item_Code__c <= 588 && !currentForm.X24b_Route_of_Admin_Drug4__c.startsWith('4.'))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_94, currentForm.X24a_Drug_4__r.Name, currentForm.X24b_Route_of_Admin_Drug4__c));
        }
        // now rule 95
        else if (currentForm.X24a_Drug_4__r.Item_Code__c >= 600 && currentForm.X24a_Drug_4__r.Item_Code__c <= 688 && currentForm.X24b_Route_of_Admin_Drug4__c.startsWith('1.'))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_95, currentForm.X24a_Drug_4__r.Name, currentForm.X24b_Route_of_Admin_Drug4__c));
        }
        // now rule 96
        else if (currentForm.X24a_Drug_4__r.Item_Code__c == 700 && !currentForm.X24b_Route_of_Admin_Drug4__c.startsWith('3.'))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_96, currentForm.X24a_Drug_4__r.Name, currentForm.X24b_Route_of_Admin_Drug4__c));
        }
    }
    
    public void ValidationID_94_to_96D5 ()
    {
        if (currentForm.X25a_Drug_5__c == null || currentForm.X25b_Route_of_Admin_Drug5__c == null) return;
        // first rules 94
        if (currentForm.X25a_Drug_5__r.Item_Code__c >= 500 && currentForm.X25a_Drug_5__r.Item_Code__c <= 588 && !currentForm.X25b_Route_of_Admin_Drug5__c.startsWith('4.'))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_94, currentForm.X25a_Drug_5__r.Name, currentForm.X25b_Route_of_Admin_Drug5__c));
        }
        // now rule 95
        else if (currentForm.X25a_Drug_5__r.Item_Code__c >= 600 && currentForm.X25a_Drug_5__r.Item_Code__c <= 688 && currentForm.X25b_Route_of_Admin_Drug5__c.startsWith('1.'))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_95, currentForm.X25a_Drug_5__r.Name, currentForm.X25b_Route_of_Admin_Drug5__c));
        }
        // now rule 96
        else if (currentForm.X25a_Drug_5__r.Item_Code__c == 700 && !currentForm.X25b_Route_of_Admin_Drug5__c.startsWith('3.'))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_96, currentForm.X25a_Drug_5__r.Name, currentForm.X25b_Route_of_Admin_Drug5__c));
        }
    }
/*    
    public void ValidationID_102_D1 () // Not required, Q13 must be equal to Q21a
    {
        if (currentForm.X13_2_Drug_specify__c == null || currentForm.X19_History_of_treatment_Drugs__c == null ||currentForm.X21a_Main_drug__c == null) return;
        // first rule 102 Q13 and Q21
        if ((currentForm.X13_2_Drug_specify__r.Item_Code__c == 210 && currentForm.X19_History_of_treatment_Drugs__c != null && currentForm.X21a_Main_drug__r.Item_Code__c == 212)||
            (currentForm.X13_2_Drug_specify__r.Item_Code__c == 212 && currentForm.X19_History_of_treatment_Drugs__c != null && currentForm.X21a_Main_drug__r.Item_Code__c == 210))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_102, currentForm.X13_2_Drug_specify__r.Name, currentForm.X21a_Main_drug__r.Name));
        }
    }
*/
    public void ValidationID_102_D2 ()  // now rule 102 Q13 and Q22
    {
        if(currentForm.X13_2_Drug_specify__c == null || currentForm.X22a_Drug_2__c == null) return;
        if ((currentForm.X13_2_Drug_specify__r.Item_Code__c == 210 && currentForm.X19_History_of_treatment_Drugs__c != null && currentForm.X22a_Drug_2__r.Item_Code__c == 212)||
            (currentForm.X13_2_Drug_specify__r.Item_Code__c == 212 && currentForm.X19_History_of_treatment_Drugs__c != null && currentForm.X22a_Drug_2__r.Item_Code__c == 210))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_102, currentForm.X13_2_Drug_specify__r.Name, currentForm.X22a_Drug_2__r.Name));
        }
    }

    public void ValidationID_102_D3 ()  // now rule 102 Q13 and Q23
    {
        if(currentForm.X13_2_Drug_specify__c == null || currentForm.X23a_Drug_3__c == null) return;
        if ((currentForm.X13_2_Drug_specify__r.Item_Code__c == 210 && currentForm.X19_History_of_treatment_Drugs__c != null && currentForm.X23a_Drug_3__r.Item_Code__c == 212)||
            (currentForm.X13_2_Drug_specify__r.Item_Code__c == 212 && currentForm.X19_History_of_treatment_Drugs__c != null && currentForm.X23a_Drug_3__r.Item_Code__c == 210))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_102, currentForm.X13_2_Drug_specify__r.Name, currentForm.X23a_Drug_3__r.Name));
        }
    }

    public void ValidationID_102_D4 ()  // now rule 102 Q13 and Q24
    {
        if(currentForm.X13_2_Drug_specify__c == null || currentForm.X24a_Drug_4__c == null) return;
        if ((currentForm.X13_2_Drug_specify__r.Item_Code__c == 210 && currentForm.X19_History_of_treatment_Drugs__c != null && currentForm.X24a_Drug_4__r.Item_Code__c == 212)||
            (currentForm.X13_2_Drug_specify__r.Item_Code__c == 212 && currentForm.X19_History_of_treatment_Drugs__c != null && currentForm.X24a_Drug_4__r.Item_Code__c == 210))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_102, currentForm.X13_2_Drug_specify__r.Name, currentForm.X24a_Drug_4__r.Name));
        }
    }

    public void ValidationID_102_D5 ()  // now rule 102 Q13 and Q25
    {
        if(currentForm.X13_2_Drug_specify__c == null || currentForm.X25a_Drug_5__c == null) return;
        if ((currentForm.X13_2_Drug_specify__r.Item_Code__c == 210 && currentForm.X19_History_of_treatment_Drugs__c != null && currentForm.X25a_Drug_5__r.Item_Code__c == 212)||
            (currentForm.X13_2_Drug_specify__r.Item_Code__c == 212 && currentForm.X19_History_of_treatment_Drugs__c != null && currentForm.X25a_Drug_5__r.Item_Code__c == 210))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_102, currentForm.X13_2_Drug_specify__r.Name, currentForm.X25a_Drug_5__r.Name));
        }
    }
/*   
    public void ValidationID_105_to_106 ()
    {
        // first rule 105 Q13 to Q25
        if (currentForm.X13_2_Drug_specify__c == null && currentForm.X19_History_of_treatment_Drugs__c == null && currentForm.X21a_Main_drug__c == null && currentForm.X22a_Drug_2__c == null &&
         currentForm.X23a_Drug_3__c == null && currentForm.X24a_Drug_4__c == null && currentForm.X25a_Drug_5__c == null) return;
        if(currentForm.X13_2_Drug_specify__r.Item_Code__c == 161||
        currentForm.X21a_Main_drug__r.Item_Code__c == 161 ||
        currentForm.X22a_Drug_2__r.Item_Code__c == 161 ||
        currentForm.X23a_Drug_3__r.Item_Code__c == 161 ||
        currentForm.X24a_Drug_4__r.Item_Code__c == 161 ||
        currentForm.X25a_Drug_5__r.Item_Code__c == 161)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_105, currentForm.X13_2_Drug_specify__r.Name, currentForm.X13_2_Drug_specify__r.Name));
        }
        // now rule 106 Q13 to Q25
        else if(currentForm.X13_2_Drug_specify__r.Item_Code__c == 163 || 
        currentForm.X21a_Main_drug__r.Item_Code__c == 163 ||
        currentForm.X22a_Drug_2__r.Item_Code__c == 163 || 
        currentForm.X23a_Drug_3__r.Item_Code__c == 163 || 
        currentForm.X24a_Drug_4__r.Item_Code__c == 163 ||
        currentForm.X25a_Drug_5__r.Item_Code__c == 163)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_106, currentForm.X13_2_Drug_specify__r.Name, currentForm.X13_2_Drug_specify__r.Name));
        }
    }
*/
    public void ValidationID_105_to_106D1 ()
    {
        // first rule 105 Q13 or Q25
        if (currentForm.X13_2_Drug_specify__c == null && currentForm.X19_History_of_treatment_Drugs__c == null && currentForm.X21a_Main_drug__c == null) return;
        if (currentForm.X13_2_Drug_specify__r.Item_Code__c == 161 && !currentForm.X19_History_of_treatment_Drugs__c.startsWith('1.') && currentForm.X21a_Main_drug__r.Item_Code__c == 161)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_105_D1, currentForm.X21a_Main_drug__r.Name, currentForm.X19_History_of_treatment_Drugs__c));
        }
        // now rule 106 Q13 or Q25
        else if(currentForm.X21a_Main_drug__r.Item_Code__c == 163)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_106_D1, currentForm.X21a_Main_drug__r.Name, currentForm.X19_History_of_treatment_Drugs__c));
        }
    }

    public void ValidationID_105_to_106D2 ()
    {
        // first rule 105 Q22a
        if(currentForm.X19_History_of_treatment_Drugs__c == null && currentForm.X22a_Drug_2__c == null) return;
        if(!currentForm.X19_History_of_treatment_Drugs__c.startsWith('1.') && currentForm.X22a_Drug_2__r.Item_Code__c == 161)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_105_D2, currentForm.X22a_Drug_2__r.Name, currentForm.X19_History_of_treatment_Drugs__c));
        }
        // now rule 106 Q22a
        else if(currentForm.X22a_Drug_2__r.Item_Code__c == 163)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_106_D2, currentForm.X22a_Drug_2__r.Name, currentForm.X19_History_of_treatment_Drugs__c));
        }
    }
    
    public void ValidationID_105_to_106D3 ()
    {
        // first rule 105 Q23a
        if(currentForm.X19_History_of_treatment_Drugs__c == null && currentForm.X23a_Drug_3__c == null) return;
        if(!currentForm.X19_History_of_treatment_Drugs__c.startsWith('1.') && currentForm.X23a_Drug_3__r.Item_Code__c == 161)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_105_D3, currentForm.X23a_Drug_3__r.Name, currentForm.X19_History_of_treatment_Drugs__c));
        }
        // now rule 106 Q23a
        else if(currentForm.X23a_Drug_3__r.Item_Code__c == 163)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_106_D3, currentForm.X23a_Drug_3__r.Name, currentForm.X19_History_of_treatment_Drugs__c));
        }
    }
    
    public void ValidationID_105_to_106D4 ()
    {
        // first rule 105 Q24a
        if(currentForm.X19_History_of_treatment_Drugs__c == null && currentForm.X24a_Drug_4__c == null) return;
        if(!currentForm.X19_History_of_treatment_Drugs__c.startsWith('1.') && currentForm.X24a_Drug_4__r.Item_Code__c == 161)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_105_D4, currentForm.X24a_Drug_4__r.Name, currentForm.X19_History_of_treatment_Drugs__c));
        }
        // now rule 106 Q24a
        else if(currentForm.X24a_Drug_4__r.Item_Code__c == 163)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_106_D4, currentForm.X24a_Drug_4__r.Name, currentForm.X19_History_of_treatment_Drugs__c));
        }
    }
    
    public void ValidationID_105_to_106D5 ()
    {
        // first rule 105 Q25a
        if(currentForm.X19_History_of_treatment_Drugs__c == null && currentForm.X25a_Drug_5__c == null) return;
        if(!currentForm.X19_History_of_treatment_Drugs__c.startsWith('1.') && currentForm.X25a_Drug_5__r.Item_Code__c == 161)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_105_D5, currentForm.X25a_Drug_5__r.Name, currentForm.X19_History_of_treatment_Drugs__c));
        }
        // now rule 106 Q25a
        else if(currentForm.X25a_Drug_5__r.Item_Code__c == 163)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_106_D5, currentForm.X25a_Drug_5__r.Name, currentForm.X19_History_of_treatment_Drugs__c));
        }
    }

    public void ValidationID_107_to_108D1 () // If never treated for drugs at Q19, prescribed methadone (161)  shouldn't be listed at Q21-25a
    {
        if(currentForm.X19_History_of_treatment_Drugs__c == null && currentForm.X21a_Main_drug__c == null) return;
        if(currentForm.X21a_Main_drug__r.Item_Code__c == 161 && currentForm.X19_History_of_treatment_Drugs__c.startsWith('1.'))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_107_D1, currentForm.X21a_Main_drug__r.Name, currentForm.X19_History_of_treatment_Drugs__c));
        }
        //If never treated for drugs at Q19, prescribed Suboxone (163) shouldn't be listed at Q21-25a
        else if(currentForm.X21a_Main_drug__r.Item_Code__c == 163 && currentForm.X19_History_of_treatment_Drugs__c.startsWith('1.'))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_108_D1, currentForm.X21a_Main_drug__r.Name, currentForm.X19_History_of_treatment_Drugs__c));
        }
    }
    
    public void ValidationID_107_to_108D2 () // If never treated for drugs at Q19, prescribed methadone (161)  shouldn't be listed at Q21-25a
    {
        if(currentForm.X19_History_of_treatment_Drugs__c == null && currentForm.X22a_Drug_2__c == null) return;
        if(currentForm.X22a_Drug_2__r.Item_Code__c == 161 && currentForm.X19_History_of_treatment_Drugs__c.startsWith('1.'))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_107_D2, currentForm.X22a_Drug_2__r.Name, currentForm.X19_History_of_treatment_Drugs__c));
        }
        //If never treated for drugs at Q19, prescribed Suboxone (163) shouldn't be listed at Q21-25a
        else if(currentForm.X22a_Drug_2__r.Item_Code__c == 163 && currentForm.X19_History_of_treatment_Drugs__c.startsWith('1.'))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_108_D2, currentForm.X22a_Drug_2__r.Name, currentForm.X19_History_of_treatment_Drugs__c));
        }
    }
    
    public void ValidationID_107_to_108D3 () // If never treated for drugs at Q19, prescribed methadone (161)  shouldn't be listed at Q21-25a
    {
        if(currentForm.X19_History_of_treatment_Drugs__c == null && currentForm.X23a_Drug_3__c == null) return;
        if(currentForm.X23a_Drug_3__r.Item_Code__c == 161 && currentForm.X19_History_of_treatment_Drugs__c.startsWith('1.'))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_107_D3, currentForm.X23a_Drug_3__r.Name, currentForm.X19_History_of_treatment_Drugs__c));
        }
        //If never treated for drugs at Q19, prescribed Suboxone (163) shouldn't be listed at Q21-25a
        else if(currentForm.X23a_Drug_3__r.Item_Code__c == 163 && currentForm.X19_History_of_treatment_Drugs__c.startsWith('1.'))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_108_D3, currentForm.X23a_Drug_3__r.Name, currentForm.X19_History_of_treatment_Drugs__c));
        }
    }
    
    public void ValidationID_107_to_108D4 () // If never treated for drugs at Q19, prescribed methadone (161)  shouldn't be listed at Q21-25a
    {
        if(currentForm.X19_History_of_treatment_Drugs__c == null && currentForm.X24a_Drug_4__c == null) return;
        if(currentForm.X24a_Drug_4__r.Item_Code__c == 161 && currentForm.X19_History_of_treatment_Drugs__c.startsWith('1.'))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_107_D4, currentForm.X24a_Drug_4__r.Name, currentForm.X19_History_of_treatment_Drugs__c));
        }
        //If never treated for drugs at Q19, prescribed Suboxone (163) shouldn't be listed at Q21-25a
        else if(currentForm.X24a_Drug_4__r.Item_Code__c == 163 && currentForm.X19_History_of_treatment_Drugs__c.startsWith('1.'))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_108_D4, currentForm.X24a_Drug_4__r.Name, currentForm.X19_History_of_treatment_Drugs__c));
        }
    }
    
    public void ValidationID_107_to_108D5 () // If never treated for drugs at Q19, prescribed methadone (161)  shouldn't be listed at Q21-25a
    {
        if(currentForm.X19_History_of_treatment_Drugs__c == null && currentForm.X25a_Drug_5__c == null) return;
        if(currentForm.X25a_Drug_5__r.Item_Code__c == 161 && currentForm.X19_History_of_treatment_Drugs__c.startsWith('1.'))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_107_D5, currentForm.X25a_Drug_5__r.Name, currentForm.X19_History_of_treatment_Drugs__c));
        }
        //If never treated for drugs at Q19, prescribed Suboxone (163) shouldn't be listed at Q21-25a
        else if(currentForm.X25a_Drug_5__r.Item_Code__c == 163 && currentForm.X19_History_of_treatment_Drugs__c.startsWith('1.'))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_108_D5, currentForm.X25a_Drug_5__r.Name, currentForm.X19_History_of_treatment_Drugs__c));
        }
    }
     
    public void ValidationID_111_to_112D21 ()
    {
        if(currentForm.X21a_Main_drug__c == null && currentForm.X21d_Age_at_1st_use__c == null)return;
        if((currentForm.X21a_Main_drug__r.Item_Code__c >= 100 && currentForm.X21d_Age_at_1st_use__c <12 || 
         currentForm.X21a_Main_drug__r.Item_Code__c >= 100 && currentForm.X21d_Age_at_1st_use__c > 45) && 
        (currentForm.X21d_Age_at_1st_use__c !=88 && currentForm.X21d_Age_at_1st_use__c !=99))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_111));
        }
     }
     
    public void ValidationID_111_to_112D22 ()
    {
        if(currentForm.X22a_Drug_2__c == null && currentForm.X22d_Age_of_1st_use__c == null)return;
        if(currentForm.X22a_Drug_2__r.Item_Code__c >= 100 && (currentForm.X22d_Age_of_1st_use__c <12 || currentForm.X22d_Age_of_1st_use__c > 45) && 
        (currentForm.X22d_Age_of_1st_use__c !=88 && currentForm.X22d_Age_of_1st_use__c !=99))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_111));
        }
     }
    
    public void ValidationID_111_to_112D23 ()
    {
        if(currentForm.X23a_Drug_3__c == null && currentForm.X23d_Age_of_1st_use__c == null)return;
        if(currentForm.X23a_Drug_3__r.Item_Code__c >= 100 && (currentForm.X23d_Age_of_1st_use__c <12 || currentForm.X23d_Age_of_1st_use__c > 45) && 
        (currentForm.X23d_Age_of_1st_use__c !=88 && currentForm.X23d_Age_of_1st_use__c !=99))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_111));
        }
     }
     
    public void ValidationID_111_to_112D24 ()
    {
        if(currentForm.X24a_Drug_4__c == null && currentForm.X24d_Age_of_1st_use__c == null)return;
        if(currentForm.X24a_Drug_4__r.Item_Code__c >= 100 && (currentForm.X24d_Age_of_1st_use__c <12 || currentForm.X24d_Age_of_1st_use__c > 45) && 
        (currentForm.X24d_Age_of_1st_use__c !=88 && currentForm.X24d_Age_of_1st_use__c !=99))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_111));
        }
     }
    
    public void ValidationID_111_to_112D25 ()
    {
        if(currentForm.X25a_Drug_5__c == null && currentForm.X25d_Age_of_1st_use__c == null)return;
        if(currentForm.X25a_Drug_5__r.Item_Code__c >= 100 && (currentForm.X25d_Age_of_1st_use__c <12 || currentForm.X25d_Age_of_1st_use__c > 45) && 
        (currentForm.X25d_Age_of_1st_use__c !=88 && currentForm.X25d_Age_of_1st_use__c !=99))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_111));
        }
     }
    
    public void ValidationID_111_to_112D26 ()
    {
        if(currentForm.X27_Specify_first_drug_ever_used__c == null && currentForm.X26_Age_first_use_any_drug__c == null)return;
        if(currentForm.X27_Specify_first_drug_ever_used__r.Item_Code__c >= 100 && (currentForm.X26_Age_first_use_any_drug__c <12 || currentForm.X26_Age_first_use_any_drug__c > 45) && 
        (currentForm.X26_Age_first_use_any_drug__c !=88 && currentForm.X26_Age_first_use_any_drug__c !=99))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_111));
        }
     }
 
    public void ValidationID_116 ()
    {
        if(currentForm.X21a_Main_drug__c == null && currentForm.X22a_Drug_2__c == null && currentForm.X23a_Drug_3__c == null && currentForm.X24a_Drug_4__c == null && 
        currentForm.X25a_Drug_5__c == null && currentForm.X29a_Preferred_types_of_alcohol_consumed__c == null && currentForm.X29b_How_many_drinks_per_occasion__c == null &&
        currentForm.X29c_Extent_of_drinking_problem__c == null && currentForm.X29d_Number_of_previous_alcohol_detoxes__c == null) return;
        if((currentForm.X21a_Main_drug__r.Item_Code__c == 700 || 
        currentForm.X22a_Drug_2__r.Item_Code__c == 700 ||
        currentForm.X23a_Drug_3__r.Item_Code__c == 700 || 
        currentForm.X24a_Drug_4__r.Item_Code__c == 700 ||
        currentForm.X25a_Drug_5__r.Item_Code__c == 700) && (currentForm.X29a_Preferred_types_of_alcohol_consumed__c == null ||
        currentForm.X29b_How_many_drinks_per_occasion__c == null ||currentForm.X29c_Extent_of_drinking_problem__c == null ||
        currentForm.X29d_Number_of_previous_alcohol_detoxes__c == null))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_118));
        }
        
    }
    public void ValidationID_117 ()
    {
        if(currentForm.X29a_Preferred_types_of_alcohol_consumed__c == null && currentForm.X29b_How_many_drinks_per_occasion__c == null) return;
        if(currentForm.X29a_Preferred_types_of_alcohol_consumed__c != null && currentForm.X29b_How_many_drinks_per_occasion__c > 66)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_117));
        }
        
    }
    
    public void ValidationID_119D1 ()
    {
        if(currentForm.X21a_Main_drug__c == null && currentForm.X21b_Route_of_Admin_Main_drug__c == null && currentForm.X21c_Frequency_of_use_in_last_mth__c == null && 
        currentForm.X21d_Age_at_1st_use__c == null && currentForm.X29a_Preferred_types_of_alcohol_consumed__c == null && currentForm.X29b_How_many_drinks_per_occasion__c == null &&
        currentForm.X29c_Extent_of_drinking_problem__c == null && currentForm.X29d_Number_of_previous_alcohol_detoxes__c == null) return;
        // Only D1
        if(currentForm.X21a_Main_drug__r.Item_Code__c == 700 && 
        currentForm.X21b_Route_of_Admin_Main_drug__c.startsWith('3.') &&
        !currentForm.X21c_Frequency_of_use_in_last_mth__c.startsWith('4.') && 
        currentForm.X21d_Age_at_1st_use__c >0 &&
        currentForm.X29a_Preferred_types_of_alcohol_consumed__c != null && 
        currentForm.X29b_How_many_drinks_per_occasion__c ==0 &&
        currentForm.X29c_Extent_of_drinking_problem__c != null &&
        currentForm.X29d_Number_of_previous_alcohol_detoxes__c != null)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_119));
        }
    }
    
    public void ValidationID_119D2 ()
    {
        if(currentForm.X22a_Drug_2__c == null && currentForm.X22b_Route_of_Admin_Drug2__c == null && currentForm.X22c_Frequency_of_use_in_last_mth__c == null && 
        currentForm.X22d_Age_of_1st_use__c == null && currentForm.X29a_Preferred_types_of_alcohol_consumed__c == null && currentForm.X29b_How_many_drinks_per_occasion__c == null &&
        currentForm.X29c_Extent_of_drinking_problem__c == null && currentForm.X29d_Number_of_previous_alcohol_detoxes__c == null) return;
        // Only D2
        if(currentForm.X22a_Drug_2__r.Item_Code__c == 700 && 
        currentForm.X22b_Route_of_Admin_Drug2__c.startsWith('3.') &&
        !currentForm.X22c_Frequency_of_use_in_last_mth__c.startsWith('4.') && 
        currentForm.X22d_Age_of_1st_use__c >0 &&
        currentForm.X29a_Preferred_types_of_alcohol_consumed__c != null && 
        currentForm.X29b_How_many_drinks_per_occasion__c ==0 &&
        currentForm.X29c_Extent_of_drinking_problem__c != null &&
        currentForm.X29d_Number_of_previous_alcohol_detoxes__c != null)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_119));
        }
    }
    
    public void ValidationID_119D3 ()
    {
        if(currentForm.X23a_Drug_3__c == null && currentForm.X23b_Route_of_Admin_Drug3__c == null && currentForm.X23c_Frequency_of_use_in_last_mth__c == null && 
        currentForm.X23d_Age_of_1st_use__c == null && currentForm.X29a_Preferred_types_of_alcohol_consumed__c == null && currentForm.X29b_How_many_drinks_per_occasion__c == null &&
        currentForm.X29c_Extent_of_drinking_problem__c == null && currentForm.X29d_Number_of_previous_alcohol_detoxes__c == null) return;
        // Only D3
        if(currentForm.X23a_Drug_3__r.Item_Code__c == 700 && 
        currentForm.X23b_Route_of_Admin_Drug3__c.startsWith('3.') &&
        !currentForm.X23c_Frequency_of_use_in_last_mth__c.startsWith('4.') && 
        currentForm.X23d_Age_of_1st_use__c >0 &&
        currentForm.X29a_Preferred_types_of_alcohol_consumed__c != null && 
        currentForm.X29b_How_many_drinks_per_occasion__c ==0 &&
        currentForm.X29c_Extent_of_drinking_problem__c != null &&
        currentForm.X29d_Number_of_previous_alcohol_detoxes__c != null)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_119));
        }
    }
    
    public void ValidationID_119D4 ()
    {
        if(currentForm.X24a_Drug_4__c == null && currentForm.X24b_Route_of_Admin_Drug4__c == null && currentForm.X24c_Frequency_of_use_in_last_mth__c == null && 
        currentForm.X24d_Age_of_1st_use__c == null && currentForm.X29a_Preferred_types_of_alcohol_consumed__c == null && currentForm.X29b_How_many_drinks_per_occasion__c == null &&
        currentForm.X29c_Extent_of_drinking_problem__c == null && currentForm.X29d_Number_of_previous_alcohol_detoxes__c == null) return;
        // Only D4
        if(currentForm.X24a_Drug_4__r.Item_Code__c == 700 && 
        currentForm.X24b_Route_of_Admin_Drug4__c.startsWith('3.') &&
        !currentForm.X24c_Frequency_of_use_in_last_mth__c.startsWith('4.') && 
        currentForm.X24d_Age_of_1st_use__c >0 &&
        currentForm.X29a_Preferred_types_of_alcohol_consumed__c != null && 
        currentForm.X29b_How_many_drinks_per_occasion__c ==0 &&
        currentForm.X29c_Extent_of_drinking_problem__c != null &&
        currentForm.X29d_Number_of_previous_alcohol_detoxes__c != null)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_119));
        }
    }
    
    public void ValidationID_119D5 ()
    {
        if(currentForm.X25a_Drug_5__c == null && currentForm.X25b_Route_of_Admin_Drug5__c == null && currentForm.X25c_Frequency_of_use_in_last_mth__c == null && 
        currentForm.X25d_Age_of_1st_use__c == null && currentForm.X29a_Preferred_types_of_alcohol_consumed__c == null && currentForm.X29b_How_many_drinks_per_occasion__c == null &&
        currentForm.X29c_Extent_of_drinking_problem__c == null && currentForm.X29d_Number_of_previous_alcohol_detoxes__c == null) return;
        // Only D5
        if(currentForm.X25a_Drug_5__r.Item_Code__c == 700 && 
        currentForm.X25b_Route_of_Admin_Drug5__c.startsWith('3.') &&
        !currentForm.X25c_Frequency_of_use_in_last_mth__c.startsWith('4.') && 
        currentForm.X25d_Age_of_1st_use__c >0 &&
        currentForm.X29a_Preferred_types_of_alcohol_consumed__c != null && 
        currentForm.X29b_How_many_drinks_per_occasion__c ==0 &&
        currentForm.X29c_Extent_of_drinking_problem__c != null &&
        currentForm.X29d_Number_of_previous_alcohol_detoxes__c != null)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_119));
        }
    }
    
    public void ValidationID_120D1 ()
    {
        if(currentForm.X21a_Main_drug__c == null && currentForm.X21b_Route_of_Admin_Main_drug__c == null && currentForm.X21c_Frequency_of_use_in_last_mth__c == null && 
        currentForm.X21d_Age_at_1st_use__c == null && currentForm.X29a_Preferred_types_of_alcohol_consumed__c == null && currentForm.X29b_How_many_drinks_per_occasion__c == null &&
        currentForm.X29c_Extent_of_drinking_problem__c == null && currentForm.X29d_Number_of_previous_alcohol_detoxes__c == null) return;
        // Only D1
        if(currentForm.X21a_Main_drug__r.Item_Code__c == 700 && 
        currentForm.X21b_Route_of_Admin_Main_drug__c.startsWith('3.') &&
        currentForm.X21c_Frequency_of_use_in_last_mth__c.startsWith('4.') && 
        currentForm.X21d_Age_at_1st_use__c >0 &&
        currentForm.X29a_Preferred_types_of_alcohol_consumed__c != null && 
        currentForm.X29b_How_many_drinks_per_occasion__c > 0 &&
        currentForm.X29c_Extent_of_drinking_problem__c != null &&
        currentForm.X29d_Number_of_previous_alcohol_detoxes__c != null)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_120));
        }
    }
    
    public void ValidationID_120D2 ()
    {
        if(currentForm.X22a_Drug_2__c == null && currentForm.X22b_Route_of_Admin_Drug2__c == null && currentForm.X22c_Frequency_of_use_in_last_mth__c == null && 
        currentForm.X22d_Age_of_1st_use__c == null && currentForm.X29a_Preferred_types_of_alcohol_consumed__c == null && currentForm.X29b_How_many_drinks_per_occasion__c == null &&
        currentForm.X29c_Extent_of_drinking_problem__c == null && currentForm.X29d_Number_of_previous_alcohol_detoxes__c == null) return;
        // Only D2
        if(currentForm.X22a_Drug_2__r.Item_Code__c == 700 && 
        currentForm.X22b_Route_of_Admin_Drug2__c.startsWith('3.') &&
        currentForm.X22c_Frequency_of_use_in_last_mth__c.startsWith('4.') && 
        currentForm.X22d_Age_of_1st_use__c >0 &&
        currentForm.X29a_Preferred_types_of_alcohol_consumed__c != null && 
        currentForm.X29b_How_many_drinks_per_occasion__c > 0 &&
        currentForm.X29c_Extent_of_drinking_problem__c != null &&
        currentForm.X29d_Number_of_previous_alcohol_detoxes__c != null)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_120));
        }
    }
    
    public void ValidationID_120D3 ()
    {
        if(currentForm.X23a_Drug_3__c == null && currentForm.X23b_Route_of_Admin_Drug3__c == null && currentForm.X23c_Frequency_of_use_in_last_mth__c == null && 
        currentForm.X23d_Age_of_1st_use__c == null && currentForm.X29a_Preferred_types_of_alcohol_consumed__c == null && currentForm.X29b_How_many_drinks_per_occasion__c == null &&
        currentForm.X29c_Extent_of_drinking_problem__c == null && currentForm.X29d_Number_of_previous_alcohol_detoxes__c == null) return;
        // Only D3
        if(currentForm.X23a_Drug_3__r.Item_Code__c == 700 && 
        currentForm.X23b_Route_of_Admin_Drug3__c.startsWith('3.') &&
        currentForm.X23c_Frequency_of_use_in_last_mth__c.startsWith('4.') && 
        currentForm.X23d_Age_of_1st_use__c >0 &&
        currentForm.X29a_Preferred_types_of_alcohol_consumed__c != null && 
        currentForm.X29b_How_many_drinks_per_occasion__c > 0 &&
        currentForm.X29c_Extent_of_drinking_problem__c != null &&
        currentForm.X29d_Number_of_previous_alcohol_detoxes__c != null)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_120));
        }
    }
    
    public void ValidationID_120D4 ()
    {
        if(currentForm.X24a_Drug_4__c == null && currentForm.X24b_Route_of_Admin_Drug4__c == null && currentForm.X24c_Frequency_of_use_in_last_mth__c == null && 
        currentForm.X24d_Age_of_1st_use__c == null && currentForm.X29a_Preferred_types_of_alcohol_consumed__c == null && currentForm.X29b_How_many_drinks_per_occasion__c == null &&
        currentForm.X29c_Extent_of_drinking_problem__c == null && currentForm.X29d_Number_of_previous_alcohol_detoxes__c == null) return;
        // Only D4
        if(currentForm.X24a_Drug_4__r.Item_Code__c == 700 && 
        currentForm.X24b_Route_of_Admin_Drug4__c.startsWith('3.') &&
        currentForm.X24c_Frequency_of_use_in_last_mth__c.startsWith('4.') && 
        currentForm.X24d_Age_of_1st_use__c >0 &&
        currentForm.X29a_Preferred_types_of_alcohol_consumed__c != null && 
        currentForm.X29b_How_many_drinks_per_occasion__c > 0 &&
        currentForm.X29c_Extent_of_drinking_problem__c != null &&
        currentForm.X29d_Number_of_previous_alcohol_detoxes__c != null)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_120));
        }
    }
    
    public void ValidationID_120D5 ()
    {
        if(currentForm.X25a_Drug_5__c == null && currentForm.X25b_Route_of_Admin_Drug5__c == null && currentForm.X25c_Frequency_of_use_in_last_mth__c == null && 
        currentForm.X25d_Age_of_1st_use__c == null && currentForm.X29a_Preferred_types_of_alcohol_consumed__c == null && currentForm.X29b_How_many_drinks_per_occasion__c == null &&
        currentForm.X29c_Extent_of_drinking_problem__c == null && currentForm.X29d_Number_of_previous_alcohol_detoxes__c == null) return;
        // Only D5
        if(currentForm.X25a_Drug_5__r.Item_Code__c == 700 && 
        currentForm.X25b_Route_of_Admin_Drug5__c.startsWith('3.') &&
        currentForm.X25c_Frequency_of_use_in_last_mth__c.startsWith('4.') && 
        currentForm.X25d_Age_of_1st_use__c >0 &&
        currentForm.X29a_Preferred_types_of_alcohol_consumed__c != null && 
        currentForm.X29b_How_many_drinks_per_occasion__c > 0 &&
        currentForm.X29c_Extent_of_drinking_problem__c != null &&
        currentForm.X29d_Number_of_previous_alcohol_detoxes__c != null)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_120));
        }
    }
    
    public void ValidationID_121 ()
    {
        if(currentForm.X21a_Main_drug__c == null && currentForm.X22a_Drug_2__c == null && currentForm.X23a_Drug_3__c == null && currentForm.X24a_Drug_4__c == null && 
        currentForm.X25a_Drug_5__c == null && currentForm.X29a_Preferred_types_of_alcohol_consumed__c == null && currentForm.X29b_How_many_drinks_per_occasion__c == null &&
        currentForm.X29c_Extent_of_drinking_problem__c == null && currentForm.X29d_Number_of_previous_alcohol_detoxes__c == null) return;
        if((currentForm.X21a_Main_drug__r.Item_Code__c != 700 && 
        currentForm.X22a_Drug_2__r.Item_Code__c != 700 &&
        currentForm.X23a_Drug_3__r.Item_Code__c != 700 && 
        currentForm.X24a_Drug_4__r.Item_Code__c != 700 &&
        currentForm.X25a_Drug_5__r.Item_Code__c != 700) && 
        (currentForm.X29a_Preferred_types_of_alcohol_consumed__c != null ||
        currentForm.X29b_How_many_drinks_per_occasion__c != null ||currentForm.X29c_Extent_of_drinking_problem__c != null ||
        currentForm.X29d_Number_of_previous_alcohol_detoxes__c != null))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_121));
        }
    }
    
    public void ValidationID_124() 
    {
        if(currentForm.X30b_Age_first_injected__c == null) return;
        if((currentForm.X21b_Route_of_Admin_Main_drug__c != null && currentForm.X21b_Route_of_Admin_Main_drug__c.startsWith('1.') && currentForm.X21d_Age_at_1st_use__c > currentForm.X30b_Age_first_injected__c) ||
        (currentForm.X22b_Route_of_Admin_Drug2__c != null && currentForm.X22b_Route_of_Admin_Drug2__c.startsWith('1.') && currentForm.X22d_Age_of_1st_use__c > currentForm.X30b_Age_first_injected__c) ||
        (currentForm.X23b_Route_of_Admin_Drug3__c != null && currentForm.X23b_Route_of_Admin_Drug3__c.startsWith('1.') && currentForm.X23d_Age_of_1st_use__c > currentForm.X30b_Age_first_injected__c) ||
        (currentForm.X24b_Route_of_Admin_Drug4__c != null && currentForm.X24b_Route_of_Admin_Drug4__c.startsWith('1.') && currentForm.X24d_Age_of_1st_use__c > currentForm.X30b_Age_first_injected__c) ||
        (currentForm.X25b_Route_of_Admin_Drug5__c != null && currentForm.X25b_Route_of_Admin_Drug5__c.startsWith('1.') && currentForm.X25d_Age_of_1st_use__c > currentForm.X30b_Age_first_injected__c))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_124));
        }
    }
    
    public void ValidationID_125() 
    {
        if(currentForm.X21b_Route_of_Admin_Main_drug__c == null) return;
        if((currentForm.X21b_Route_of_Admin_Main_drug__c != null && !currentForm.X21b_Route_of_Admin_Main_drug__c.startsWith('1.')) && 
        (currentForm.X22b_Route_of_Admin_Drug2__c != null && currentForm.X22b_Route_of_Admin_Drug2__c.startsWith('1.')) ||
        (currentForm.X23b_Route_of_Admin_Drug3__c != null && currentForm.X23b_Route_of_Admin_Drug3__c.startsWith('1.')) ||
        (currentForm.X24b_Route_of_Admin_Drug4__c != null && currentForm.X24b_Route_of_Admin_Drug4__c.startsWith('1.')) ||
        (currentForm.X25b_Route_of_Admin_Drug5__c != null && currentForm.X25b_Route_of_Admin_Drug5__c.startsWith('1.')))
        {
        warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_125));
        }
    }
    
    public void ValidationID_126() 
    {
        if(currentForm.X30b_Age_first_injected__c == null) return;
        if((currentForm.X21b_Route_of_Admin_Main_drug__c != null && currentForm.X21b_Route_of_Admin_Main_drug__c.startsWith('1.') && currentForm.X21d_Age_at_1st_use__c != null && (currentForm.X30b_Age_first_injected__c <12 || currentForm.X30b_Age_first_injected__c > 45)) ||
        (currentForm.X22b_Route_of_Admin_Drug2__c != null && currentForm.X22b_Route_of_Admin_Drug2__c.startsWith('1.') && currentForm.X22d_Age_of_1st_use__c != null && (currentForm.X30b_Age_first_injected__c <12 || currentForm.X30b_Age_first_injected__c > 45)) ||
        (currentForm.X23b_Route_of_Admin_Drug3__c != null && currentForm.X23b_Route_of_Admin_Drug3__c.startsWith('1.') && currentForm.X23d_Age_of_1st_use__c != null && (currentForm.X30b_Age_first_injected__c <12 || currentForm.X30b_Age_first_injected__c > 45)) ||
        (currentForm.X24b_Route_of_Admin_Drug4__c != null && currentForm.X24b_Route_of_Admin_Drug4__c.startsWith('1.') && currentForm.X24d_Age_of_1st_use__c != null && (currentForm.X30b_Age_first_injected__c <12 || currentForm.X30b_Age_first_injected__c > 45)) ||
        (currentForm.X25b_Route_of_Admin_Drug5__c != null && currentForm.X25b_Route_of_Admin_Drug5__c.startsWith('1.') && currentForm.X25d_Age_of_1st_use__c != null && (currentForm.X30b_Age_first_injected__c <12 || currentForm.X30b_Age_first_injected__c > 45)))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_126));
        }
    }
    
    public void ValidationID_132() 
    {
        if(currentForm.X30a_Ever_injected__c == null && currentForm.X30c_Frequency_of_injecting__c == null && currentForm.X30d_Ever_shared_needle_and_syringes__c == null) return;
        if(currentForm.X30d_Ever_shared_needle_and_syringes__c != null && !currentForm.X30d_Ever_shared_needle_and_syringes__c.startsWith('2.') && !currentForm.X30d_Ever_shared_needle_and_syringes__c.startsWith('88.') && 
        (currentForm.X30a_Ever_injected__c != null && (currentForm.X30a_Ever_injected__c.startsWith('2.')|| currentForm.X30a_Ever_injected__c.startsWith('9.'))))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_132));
        }
    }
    
    public void ValidationID_141() 
    {
        if(currentForm.X30e_Ever_shared_other_drug_paraphernali__c == null) 
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_141));
        }
    }
    
    public void ValidationID_146_1()  // Number of interventions should correlate with start and end dates. Date started = Date of last visit
    {
        if(currentForm.X32b1_Date_started__c == null || currentForm.X32c1_Date_of_last_visit__c == null || currentForm.X32d1_Number_of_sessions__c == null) return;
        if(currentForm.X32b1_Date_started__c.daysBetween (currentForm.X32c1_Date_of_last_visit__c) == 0 && currentForm.X32d1_Number_of_sessions__c > 1)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_146_1));
        }
    }
    public void ValidationID_146_1b() // Number of interventions should correlate with start and end dates. Date started != Date of last visit
    {   
        if(currentForm.X32b1_Date_started__c == null || currentForm.X32c1_Date_of_last_visit__c == null || currentForm.X32d1_Number_of_sessions__c == null) return;
        if (currentForm.X32b1_Date_started__c.daysBetween (currentForm.X32c1_Date_of_last_visit__c) >0 && 
                currentForm.X32b1_Date_started__c.daysBetween (currentForm.X32c1_Date_of_last_visit__c) < (currentForm.X32d1_Number_of_sessions__c - 1))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_146_1));   
        }
    }
    
    public void ValidationID_146_2()  // Number of interventions should correlate with start and end dates. Date started = Date of last visit
    {
        if(currentForm.X32b2_Date_started__c == null || currentForm.X32c2_Date_of_last_visit__c == null || currentForm.X32d2_Number_of_sessions__c == null) return;
        if(currentForm.X32b2_Date_started__c.daysBetween (currentForm.X32c2_Date_of_last_visit__c) == 0 && currentForm.X32d2_Number_of_sessions__c > 1)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_146_2));
        }
    }
    
    public void ValidationID_146_2b() // Number of interventions should correlate with start and end dates. Date started != Date of last visit
    {   
        if(currentForm.X32b2_Date_started__c == null || currentForm.X32c2_Date_of_last_visit__c == null || currentForm.X32d2_Number_of_sessions__c == null) return;
        if (currentForm.X32b2_Date_started__c.daysBetween (currentForm.X32c2_Date_of_last_visit__c) >0 && 
                currentForm.X32b2_Date_started__c.daysBetween (currentForm.X32c2_Date_of_last_visit__c) < (currentForm.X32d2_Number_of_sessions__c - 1))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_146_2));   
        }
    }
    
    public void ValidationID_146_3()  // Number of interventions should correlate with start and end dates. Date started = Date of last visit
    {
        if(currentForm.X32b3_Date_started__c == null || currentForm.X32c3_Date_of_last_visit__c == null || currentForm.X32d3_Number_of_sessions__c == null) return;
        if(currentForm.X32b3_Date_started__c.daysBetween (currentForm.X32c3_Date_of_last_visit__c) == 0 && currentForm.X32d3_Number_of_sessions__c > 1)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_146_3));
        }
    }
    
    public void ValidationID_146_3b() // Number of interventions should correlate with start and end dates. Date started != Date of last visit
    {
        if(currentForm.X32b3_Date_started__c == null || currentForm.X32c3_Date_of_last_visit__c == null || currentForm.X32d3_Number_of_sessions__c == null) return;
        if (currentForm.X32b3_Date_started__c.daysBetween (currentForm.X32c3_Date_of_last_visit__c) >0 && 
            currentForm.X32b3_Date_started__c.daysBetween (currentForm.X32c3_Date_of_last_visit__c) < (currentForm.X32d3_Number_of_sessions__c - 1))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_146_3));   
        }
    }
    
    public void ValidationID_146_4()  // Number of interventions should correlate with start and end dates. Date started = Date of last visit
    {
        if(currentForm.X32b4_Date_started__c == null || currentForm.X32c4_Date_of_last_visit__c == null || currentForm.X32d4_Number_of_sessions__c == null) return;
        if(currentForm.X32b4_Date_started__c.daysBetween (currentForm.X32c4_Date_of_last_visit__c) == 0 && currentForm.X32d4_Number_of_sessions__c > 1)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_146_4));
        }
    }
    
    public void ValidationID_146_4b() // Number of interventions should correlate with start and end dates. Date started != Date of last visit
    {   
        if(currentForm.X32b4_Date_started__c == null || currentForm.X32c4_Date_of_last_visit__c == null || currentForm.X32d4_Number_of_sessions__c == null) return;
        if (currentForm.X32b4_Date_started__c.daysBetween (currentForm.X32c4_Date_of_last_visit__c) >0 && 
            currentForm.X32b4_Date_started__c.daysBetween (currentForm.X32c4_Date_of_last_visit__c) < (currentForm.X32d4_Number_of_sessions__c - 1))
        {
        warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_146_4));   
        }
    }
    
    public void ValidationID_146_5()  // Number of interventions should correlate with start and end dates. Date started = Date of last visit
    {
        if(currentForm.X32b5_Date_started__c == null || currentForm.X32c5_Date_of_last_visit__c == null || currentForm.X32d5_Number_of_sessions__c == null) return;
        if(currentForm.X32b5_Date_started__c.daysBetween (currentForm.X32c5_Date_of_last_visit__c) == 0 && currentForm.X32d5_Number_of_sessions__c > 1)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_146_5));
        }
    }
    
    public void ValidationID_146_5b() // Number of interventions should correlate with start and end dates. Date started != Date of last visit
    {   
        if(currentForm.X32b5_Date_started__c == null || currentForm.X32c5_Date_of_last_visit__c == null || currentForm.X32d5_Number_of_sessions__c == null) return;
        if (currentForm.X32b5_Date_started__c.daysBetween (currentForm.X32c5_Date_of_last_visit__c) >0 && 
            currentForm.X32b5_Date_started__c.daysBetween (currentForm.X32c5_Date_of_last_visit__c) < (currentForm.X32d5_Number_of_sessions__c - 1))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_146_5));   
        }
    }
    
    public void ValidationID_146_6()  // Number of interventions should correlate with start and end dates. Date started = Date of last visit
    {
        if(currentForm.X32b6_Date_started__c == null || currentForm.X32c6_Date_of_last_visit__c == null || currentForm.X32d6_Number_of_sessions__c == null) return;
        if(currentForm.X32b6_Date_started__c.daysBetween (currentForm.X32c6_Date_of_last_visit__c) == 0 && currentForm.X32d6_Number_of_sessions__c > 1)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_146_6));
        }
    }
    
    public void ValidationID_146_6b() // Number of interventions should correlate with start and end dates. Date started != Date of last visit
    {
        if(currentForm.X32b6_Date_started__c == null || currentForm.X32c6_Date_of_last_visit__c == null || currentForm.X32d6_Number_of_sessions__c == null) return;
        if (currentForm.X32b6_Date_started__c.daysBetween (currentForm.X32c6_Date_of_last_visit__c) >0 && 
            currentForm.X32b6_Date_started__c.daysBetween (currentForm.X32c6_Date_of_last_visit__c) < (currentForm.X32d6_Number_of_sessions__c - 1))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_146_6));   
        }
    }
    
    public void ValidationID_146_7()  // Number of interventions should correlate with start and end dates. Date started = Date of last visit
    {
        if(currentForm.X32b7_Date_started__c == null || currentForm.X32c7_Date_of_last_visit__c == null || currentForm.X32d7_Number_of_sessions__c == null) return;
        if(currentForm.X32b7_Date_started__c.daysBetween (currentForm.X32c7_Date_of_last_visit__c) == 0 && currentForm.X32d7_Number_of_sessions__c > 1)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_146_7));
        }
    }
    
    public void ValidationID_146_7b() // Number of interventions should correlate with start and end dates. Date started != Date of last visit
    {   
        if(currentForm.X32b7_Date_started__c == null || currentForm.X32c7_Date_of_last_visit__c == null || currentForm.X32d7_Number_of_sessions__c == null) return;
        if (currentForm.X32b7_Date_started__c.daysBetween (currentForm.X32c7_Date_of_last_visit__c) >0 && 
            currentForm.X32b7_Date_started__c.daysBetween (currentForm.X32c7_Date_of_last_visit__c) < (currentForm.X32d7_Number_of_sessions__c - 1))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_146_7));   
        }
    }
    
    public void ValidationID_146_8()  // Number of interventions should correlate with start and end dates. Date started = Date of last visit
    {
        if(currentForm.X32b8_Date_started__c == null || currentForm.X32c8_Date_of_last_visit__c == null || currentForm.X32d8_Number_of_sessions__c == null) return;
        if(currentForm.X32b8_Date_started__c.daysBetween (currentForm.X32c8_Date_of_last_visit__c) == 0 && currentForm.X32d8_Number_of_sessions__c > 1)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_146_8));
        }
    }
    
    public void ValidationID_146_8b() // Number of interventions should correlate with start and end dates. Date started != Date of last visit
    {
        if(currentForm.X32b8_Date_started__c == null || currentForm.X32c8_Date_of_last_visit__c == null || currentForm.X32d8_Number_of_sessions__c == null) return;
        if (currentForm.X32b8_Date_started__c.daysBetween (currentForm.X32c8_Date_of_last_visit__c) >0 && 
            currentForm.X32b8_Date_started__c.daysBetween (currentForm.X32c8_Date_of_last_visit__c) < (currentForm.X32d8_Number_of_sessions__c - 1))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_146_8));   
        }
    }
    
    public void ValidationID_146_9()  // Number of interventions should correlate with start and end dates. Date started = Date of last visit
    {
        if(currentForm.X32b9_Date_started__c == null || currentForm.X32c9_Date_of_last_visit__c == null || currentForm.X32d9_Number_of_sessions__c == null) return;
        if(currentForm.X32b9_Date_started__c.daysBetween (currentForm.X32c9_Date_of_last_visit__c) == 0 && currentForm.X32d9_Number_of_sessions__c > 1)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_146_9));
        }
    }
    
    public void ValidationID_146_9b() // Number of interventions should correlate with start and end dates. Date started != Date of last visit
    {
        if(currentForm.X32b9_Date_started__c == null || currentForm.X32c9_Date_of_last_visit__c == null || currentForm.X32d9_Number_of_sessions__c == null) return;
        if (currentForm.X32b9_Date_started__c.daysBetween (currentForm.X32c9_Date_of_last_visit__c) >0 && 
            currentForm.X32b9_Date_started__c.daysBetween (currentForm.X32c9_Date_of_last_visit__c) < (currentForm.X32d9_Number_of_sessions__c - 1))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_146_9));   
        }
    }
    
    public void ValidationID_146_10()  // Number of interventions should correlate with start and end dates. Date started = Date of last visit
    {
        if(currentForm.X32b10_Date_started__c == null || currentForm.X32c10_Date_of_last_visit__c == null || currentForm.X32d10_Number_of_sessions__c == null) return;
        if(currentForm.X32b10_Date_started__c.daysBetween (currentForm.X32c10_Date_of_last_visit__c) == 0 && currentForm.X32d10_Number_of_sessions__c > 1)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_146_10));
        }
    }
    
    public void ValidationID_146_10b() // Number of interventions should correlate with start and end dates. Date started != Date of last visit
    {
        if(currentForm.X32b10_Date_started__c == null || currentForm.X32c10_Date_of_last_visit__c == null || currentForm.X32d10_Number_of_sessions__c == null) return;
        if (currentForm.X32b10_Date_started__c.daysBetween (currentForm.X32c10_Date_of_last_visit__c) >0 && 
            currentForm.X32b10_Date_started__c.daysBetween (currentForm.X32c10_Date_of_last_visit__c) < (currentForm.X32d10_Number_of_sessions__c - 1))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_146_10));  
        }
    }
    
    public void ValidationID_146_11()  // Number of interventions should correlate with start and end dates. Date started = Date of last visit
    {
        if(currentForm.X32b11_Date_started__c == null || currentForm.X32c11_Date_of_last_visit__c == null || currentForm.X32d11_Number_of_sessions__c == null) return;
        if(currentForm.X32b11_Date_started__c.daysBetween (currentForm.X32c11_Date_of_last_visit__c) == 0 && currentForm.X32d11_Number_of_sessions__c > 1)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_146_11));
        }
    }
    
    public void ValidationID_146_11b() // Number of interventions should correlate with start and end dates. Date started != Date of last visit
    {
        if(currentForm.X32b11_Date_started__c == null || currentForm.X32c11_Date_of_last_visit__c == null || currentForm.X32d11_Number_of_sessions__c == null) return;
        if (currentForm.X32b11_Date_started__c.daysBetween (currentForm.X32c11_Date_of_last_visit__c) >0 && 
            currentForm.X32b11_Date_started__c.daysBetween (currentForm.X32c11_Date_of_last_visit__c) < (currentForm.X32d11_Number_of_sessions__c - 1))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_146_11));  
        }
    }
    
    public void ValidationID_146_12()  // Number of interventions should correlate with start and end dates. Date started = Date of last visit
    {
        if(currentForm.X32b12_Date_started__c == null || currentForm.X32c12_Date_of_last_visit__c == null || currentForm.X32d12_Number_of_sessions__c == null) return;
        if(currentForm.X32b12_Date_started__c.daysBetween (currentForm.X32c12_Date_of_last_visit__c) == 0 && currentForm.X32d12_Number_of_sessions__c > 1)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_146_12));
        }
    }
    
    public void ValidationID_146_12b() // Number of interventions should correlate with start and end dates. Date started != Date of last visit
    {
        if(currentForm.X32b12_Date_started__c == null || currentForm.X32c12_Date_of_last_visit__c == null || currentForm.X32d12_Number_of_sessions__c == null) return;
        if (currentForm.X32b12_Date_started__c.daysBetween (currentForm.X32c12_Date_of_last_visit__c) >0 && 
            currentForm.X32b12_Date_started__c.daysBetween (currentForm.X32c12_Date_of_last_visit__c) < (currentForm.X32d12_Number_of_sessions__c - 1))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_146_12));  
        }
    }
    
    public void ValidationID_146_13()  // Number of interventions should correlate with start and end dates. Date started = Date of last visit
    {
        if(currentForm.X32b13_Date_started__c == null || currentForm.X32c13_Date_of_last_visit__c == null || currentForm.X32d13_Number_of_sessions__c == null) return;
        if(currentForm.X32b13_Date_started__c.daysBetween (currentForm.X32c13_Date_of_last_visit__c) == 0 && currentForm.X32d13_Number_of_sessions__c > 1)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_146_13));
        }
    }
    
    public void ValidationID_146_13b() // Number of interventions should correlate with start and end dates. Date started != Date of last visit
    {
        if(currentForm.X32b13_Date_started__c == null || currentForm.X32c13_Date_of_last_visit__c == null || currentForm.X32d13_Number_of_sessions__c == null) return;
        if (currentForm.X32b13_Date_started__c.daysBetween (currentForm.X32c13_Date_of_last_visit__c) >0 && 
            currentForm.X32b13_Date_started__c.daysBetween (currentForm.X32c13_Date_of_last_visit__c) < (currentForm.X32d13_Number_of_sessions__c - 1))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_146_13));  
        }
    }
    
    public void ValidationID_146_14()  // Number of interventions should correlate with start and end dates. Date started = Date of last visit
    {
        if(currentForm.X32b14_Date_started__c == null || currentForm.X32c14_Date_of_last_visit__c == null || currentForm.X32d14_Number_of_sessions__c == null) return;
        if(currentForm.X32b14_Date_started__c.daysBetween (currentForm.X32c14_Date_of_last_visit__c) == 0 && currentForm.X32d14_Number_of_sessions__c > 1)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_146_14));
        }
    }
    
    public void ValidationID_146_14b() // Number of interventions should correlate with start and end dates. Date started != Date of last visit
    {
        if(currentForm.X32b14_Date_started__c == null || currentForm.X32c14_Date_of_last_visit__c == null || currentForm.X32d14_Number_of_sessions__c == null) return;
        if (currentForm.X32b14_Date_started__c.daysBetween (currentForm.X32c14_Date_of_last_visit__c) >0 && 
            currentForm.X32b14_Date_started__c.daysBetween (currentForm.X32c14_Date_of_last_visit__c) < (currentForm.X32d14_Number_of_sessions__c - 1))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_146_14));  
        }
    }
    
    public void ValidationID_146_15()  // Number of interventions should correlate with start and end dates. Date started = Date of last visit
    {
        if(currentForm.X32b15_Date_started__c == null || currentForm.X32c15_Date_of_last_visit__c == null || currentForm.X32d15_Number_of_sessions__c == null) return;
        if(currentForm.X32b15_Date_started__c.daysBetween (currentForm.X32c15_Date_of_last_visit__c) == 0 && currentForm.X32d15_Number_of_sessions__c > 1)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_146_15));
        }
    }
    
    public void ValidationID_146_15b() // Number of interventions should correlate with start and end dates. Date started != Date of last visit
    {
        if(currentForm.X32b15_Date_started__c == null || currentForm.X32c15_Date_of_last_visit__c == null || currentForm.X32d15_Number_of_sessions__c == null) return;
        if (currentForm.X32b15_Date_started__c.daysBetween (currentForm.X32c15_Date_of_last_visit__c) >0 && 
            currentForm.X32b15_Date_started__c.daysBetween (currentForm.X32c15_Date_of_last_visit__c) < (currentForm.X32d15_Number_of_sessions__c - 1))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_146_15));  
        }
    }
    
    public void ValidationID_146_16()  // Number of interventions should correlate with start and end dates. Date started = Date of last visit
    {
        if(currentForm.X32b16_Date_started__c == null || currentForm.X32c16_Date_of_last_visit__c == null || currentForm.X32d16_Number_of_sessions__c == null) return;
        if(currentForm.X32b16_Date_started__c.daysBetween (currentForm.X32c16_Date_of_last_visit__c) == 0 && currentForm.X32d16_Number_of_sessions__c > 1)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_146_16));
        }
    }
    
    public void ValidationID_146_16b() // Number of interventions should correlate with start and end dates. Date started != Date of last visit
    {
        if(currentForm.X32b16_Date_started__c == null || currentForm.X32c16_Date_of_last_visit__c == null || currentForm.X32d16_Number_of_sessions__c == null) return;
        if(currentForm.X32b16_Date_started__c.daysBetween (currentForm.X32c16_Date_of_last_visit__c) >0 && 
            currentForm.X32b16_Date_started__c.daysBetween (currentForm.X32c16_Date_of_last_visit__c) < (currentForm.X32d16_Number_of_sessions__c - 1))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_146_16));  
        }
    }
    
    public void ValidationID_146_17()  // Number of interventions should correlate with start and end dates. Date started = Date of last visit
    {
        if(currentForm.X32b17_Date_started__c == null || currentForm.X32c17_Date_of_last_visit__c == null || currentForm.X32d17_Number_of_sessions__c == null) return;
        if(currentForm.X32b17_Date_started__c.daysBetween (currentForm.X32c17_Date_of_last_visit__c) == 0 && currentForm.X32d17_Number_of_sessions__c > 1)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_146_17));
        }
    }
    
    public void ValidationID_146_17b() // Number of interventions should correlate with start and end dates. Date started != Date of last visit
    {
        if(currentForm.X32b17_Date_started__c == null || currentForm.X32c17_Date_of_last_visit__c == null || currentForm.X32d17_Number_of_sessions__c == null) return;
        if (currentForm.X32b17_Date_started__c.daysBetween (currentForm.X32c17_Date_of_last_visit__c) >0 && 
            currentForm.X32b17_Date_started__c.daysBetween (currentForm.X32c17_Date_of_last_visit__c) < (currentForm.X32d17_Number_of_sessions__c - 1))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_146_17));  
        }
    }
    
    public void ValidationID_146_18()  // Number of interventions should correlate with start and end dates. Date started = Date of last visit
    {
        if(currentForm.X32b18_Date_started__c == null || currentForm.X32c18_Date_of_last_visit__c == null || currentForm.X32d18_Number_of_sessions__c == null) return;
        if(currentForm.X32b18_Date_started__c.daysBetween (currentForm.X32c18_Date_of_last_visit__c) == 0 && currentForm.X32d18_Number_of_sessions__c > 1)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_146_18));
        }
    }
    
    public void ValidationID_146_18b() // Number of interventions should correlate with start and end dates. Date started != Date of last visit
    {
        if(currentForm.X32b18_Date_started__c == null || currentForm.X32c18_Date_of_last_visit__c == null || currentForm.X32d18_Number_of_sessions__c == null) return;
        if (currentForm.X32b18_Date_started__c.daysBetween (currentForm.X32c18_Date_of_last_visit__c) >0 && 
            currentForm.X32b18_Date_started__c.daysBetween (currentForm.X32c18_Date_of_last_visit__c) < (currentForm.X32d18_Number_of_sessions__c - 1))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_146_18));  
        }
    }
    
    public void ValidationID_146_19()  // Number of interventions should correlate with start and end dates. Date started = Date of last visit
    {
        if(currentForm.X32b19_Date_started__c == null || currentForm.X32c19_Date_of_last_visit__c == null || currentForm.X32d19_Number_of_sessions__c == null) return;
        if(currentForm.X32b19_Date_started__c.daysBetween (currentForm.X32c19_Date_of_last_visit__c) == 0 && currentForm.X32d19_Number_of_sessions__c > 1)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_146_19));
        }
    }
    
    public void ValidationID_146_19b() // Number of interventions should correlate with start and end dates. Date started != Date of last visit
    {
        if(currentForm.X32b19_Date_started__c == null || currentForm.X32c19_Date_of_last_visit__c == null || currentForm.X32d19_Number_of_sessions__c == null) return;
        if (currentForm.X32b19_Date_started__c.daysBetween (currentForm.X32c19_Date_of_last_visit__c) >0 && 
            currentForm.X32b19_Date_started__c.daysBetween (currentForm.X32c19_Date_of_last_visit__c) < (currentForm.X32d19_Number_of_sessions__c - 1))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_146_19));  
        }
    }
    
    public void ValidationID_146_20()  // Number of interventions should correlate with start and end dates. Date started = Date of last visit
    {
        if(currentForm.X32b20_Date_started__c == null || currentForm.X32c20_Date_of_last_visit__c == null || currentForm.X32d20_Number_of_sessions__c == null) return;
        if(currentForm.X32b20_Date_started__c.daysBetween (currentForm.X32c20_Date_of_last_visit__c) == 0 && currentForm.X32d20_Number_of_sessions__c > 1)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_146_20));
        }
    }
    
    public void ValidationID_146_20b() // Number of interventions should correlate with start and end dates. Date started != Date of last visit
    {
        if(currentForm.X32b20_Date_started__c == null || currentForm.X32c20_Date_of_last_visit__c == null || currentForm.X32d20_Number_of_sessions__c == null) return;
        if (currentForm.X32b20_Date_started__c.daysBetween (currentForm.X32c20_Date_of_last_visit__c) >0 && 
            currentForm.X32b20_Date_started__c.daysBetween (currentForm.X32c20_Date_of_last_visit__c) < (currentForm.X32d20_Number_of_sessions__c - 1))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_146_20));  
        }
    }
    
    public void ValidationID_146_21()  // Number of interventions should correlate with start and end dates. Date started = Date of last visit
    {
        if(currentForm.X32b21_Date_started__c == null || currentForm.X32c21_Date_of_last_visit__c == null || currentForm.X32d21_Number_of_sessions__c == null) return;
        if(currentForm.X32b21_Date_started__c.daysBetween (currentForm.X32c21_Date_of_last_visit__c) == 0 && currentForm.X32d21_Number_of_sessions__c > 1)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_146_21));
        }
    }
    
    public void ValidationID_146_21b() // Number of interventions should correlate with start and end dates. Date started != Date of last visit
    {
        if(currentForm.X32b21_Date_started__c == null || currentForm.X32c21_Date_of_last_visit__c == null || currentForm.X32d21_Number_of_sessions__c == null) return;
        if (currentForm.X32b21_Date_started__c.daysBetween (currentForm.X32c21_Date_of_last_visit__c) >0 && 
            currentForm.X32b21_Date_started__c.daysBetween (currentForm.X32c21_Date_of_last_visit__c) < (currentForm.X32d21_Number_of_sessions__c - 1))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_146_21));  
        }
    }
    
    public void ValidationID_146_22()  // Number of interventions should correlate with start and end dates. Date started = Date of last visit
    {
        if(currentForm.X32b22_Date_started__c == null || currentForm.X32c22_Date_of_last_visit__c == null || currentForm.X32d22_Number_of_sessions__c == null) return;
        if(currentForm.X32b22_Date_started__c.daysBetween (currentForm.X32c22_Date_of_last_visit__c) == 0 && currentForm.X32d22_Number_of_sessions__c > 1)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_146_22));
        }
    }
    
    public void ValidationID_146_22b() // Number of interventions should correlate with start and end dates. Date started != Date of last visit
    {
        if(currentForm.X32b22_Date_started__c == null || currentForm.X32c22_Date_of_last_visit__c == null || currentForm.X32d22_Number_of_sessions__c == null) return;
        if (currentForm.X32b22_Date_started__c.daysBetween (currentForm.X32c22_Date_of_last_visit__c) >0 && 
            currentForm.X32b22_Date_started__c.daysBetween (currentForm.X32c22_Date_of_last_visit__c) < (currentForm.X32d22_Number_of_sessions__c - 1))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_146_22));  
        }
    }
    
    public void ValidationID_146_23()  // Number of interventions should correlate with start and end dates. Date started = Date of last visit
    {
        if(currentForm.X32b23_Date_started__c == null || currentForm.X32c23_Date_of_last_visit__c == null || currentForm.X32d23_Number_of_sessions__c == null) return;
        if(currentForm.X32b23_Date_started__c.daysBetween (currentForm.X32c23_Date_of_last_visit__c) == 0 && currentForm.X32d23_Number_of_sessions__c > 1)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_146_23));
        }
    }
    
    public void ValidationID_146_23b() // Number of interventions should correlate with start and end dates. Date started != Date of last visit
    {
        if(currentForm.X32b23_Date_started__c == null || currentForm.X32c23_Date_of_last_visit__c == null || currentForm.X32d23_Number_of_sessions__c == null) return;
        if (currentForm.X32b23_Date_started__c.daysBetween (currentForm.X32c23_Date_of_last_visit__c) >0 && 
            currentForm.X32b23_Date_started__c.daysBetween (currentForm.X32c23_Date_of_last_visit__c) < (currentForm.X32d23_Number_of_sessions__c - 1))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_146_23));  
        }
    }
    
    public void ValidationID_146_24()  // Number of interventions should correlate with start and end dates. Date started = Date of last visit
    {
        if(currentForm.X32b24_Date_started__c == null || currentForm.X32c24_Date_of_last_visit__c == null || currentForm.X32d24_Number_of_sessions__c == null) return;
        if(currentForm.X32b24_Date_started__c.daysBetween (currentForm.X32c24_Date_of_last_visit__c) == 0 && currentForm.X32d24_Number_of_sessions__c > 1)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_146_24));
        }
    }
    
    public void ValidationID_146_24b() // Number of interventions should correlate with start and end dates. Date started != Date of last visit
    {
        if(currentForm.X32b24_Date_started__c == null || currentForm.X32c24_Date_of_last_visit__c == null || currentForm.X32d24_Number_of_sessions__c == null) return;
        if (currentForm.X32b24_Date_started__c.daysBetween (currentForm.X32c24_Date_of_last_visit__c) > 0 && 
            currentForm.X32b24_Date_started__c.daysBetween (currentForm.X32c24_Date_of_last_visit__c) < (currentForm.X32d24_Number_of_sessions__c - 1))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_146_24));  
        }
    }
    
    public void ValidationID_146_25()  // Number of interventions should correlate with start and end dates. Date started = Date of last visit
    {
        if(currentForm.X32b25_Date_started__c == null || currentForm.X32c25_Date_of_last_visit__c == null || currentForm.X32d25_Number_of_sessions__c == null) return;
        if(currentForm.X32b25_Date_started__c.daysBetween (currentForm.X32c25_Date_of_last_visit__c) == 0 && currentForm.X32d25_Number_of_sessions__c > 1)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_146_25));
        }
    }
    
    public void ValidationID_146_25b() // Number of interventions should correlate with start and end dates. Date started != Date of last visit
    {
        if(currentForm.X32b25_Date_started__c == null || currentForm.X32c25_Date_of_last_visit__c == null || currentForm.X32d25_Number_of_sessions__c == null) return;
        if (currentForm.X32b25_Date_started__c.daysBetween (currentForm.X32c25_Date_of_last_visit__c) >0 && 
            currentForm.X32b25_Date_started__c.daysBetween (currentForm.X32c25_Date_of_last_visit__c) < (currentForm.X32d25_Number_of_sessions__c - 1))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_146_25));  
        }
    }
    
    public void ValidationID_146_27()  // Number of interventions should correlate with start and end dates. Date started = Date of last visit
    {
        if(currentForm.X32b27_Date_started__c == null || currentForm.X32c27_Date_of_last_visit__c == null || currentForm.X32d27_Number_of_sessions__c == null) return;
        if(currentForm.X32b27_Date_started__c.daysBetween (currentForm.X32c27_Date_of_last_visit__c) == 0 && currentForm.X32d27_Number_of_sessions__c > 1)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_146_27));
        }
    }
    
    public void ValidationID_146_27b() // Number of interventions should correlate with start and end dates. Date started != Date of last visit
    {
        if(currentForm.X32b27_Date_started__c == null || currentForm.X32c27_Date_of_last_visit__c == null || currentForm.X32d27_Number_of_sessions__c == null) return;
        if (currentForm.X32b27_Date_started__c.daysBetween (currentForm.X32c27_Date_of_last_visit__c) >0 && 
            currentForm.X32b27_Date_started__c.daysBetween (currentForm.X32c27_Date_of_last_visit__c) < (currentForm.X32d27_Number_of_sessions__c - 1))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_146_27));  
        }
    }
    
    public void ValidationID_146_28() // Number of interventions should correlate with start and end dates. Date started = Date of last visit
    {
        if(currentForm.X32b28_Date_started__c == null || currentForm.X32c28_Date_of_last_visit__c == null || currentForm.X32d28_Number_of_sessions__c == null) return;
        if(currentForm.X32b28_Date_started__c.daysBetween (currentForm.X32c28_Date_of_last_visit__c) == 0 && currentForm.X32d28_Number_of_sessions__c > 1)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_146_28));
        }
    }
    
    public void ValidationID_146_28b() // Number of interventions should correlate with start and end dates. Date started != Date of last visit
    {
        if(currentForm.X32b28_Date_started__c == null || currentForm.X32c28_Date_of_last_visit__c == null || currentForm.X32d28_Number_of_sessions__c == null) return;
        if (currentForm.X32b28_Date_started__c.daysBetween (currentForm.X32c28_Date_of_last_visit__c) >0 && 
            currentForm.X32b28_Date_started__c.daysBetween (currentForm.X32c28_Date_of_last_visit__c) < (currentForm.X32d28_Number_of_sessions__c - 1))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_146_28));  
        }
    }
    
    public void ValidationID_147_1()  // Long time span between start and end dates  greater than one year
    {
        if(currentForm.X32b1_Date_started__c == null || currentForm.X32c1_Date_of_last_visit__c == null || currentForm.X32d1_Number_of_sessions__c == null) return;
        if(currentForm.X32b1_Date_started__c.daysBetween (currentForm.X32c1_Date_of_last_visit__c) > 365)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_147_1));
        }
    }
    
    public void ValidationID_147_2()  // Long time span between start and end dates  greater than one year
    {
        if(currentForm.X32b2_Date_started__c == null || currentForm.X32c2_Date_of_last_visit__c == null || currentForm.X32d2_Number_of_sessions__c == null) return;
        if(currentForm.X32b2_Date_started__c.daysBetween (currentForm.X32c2_Date_of_last_visit__c) > 365)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_147_2));
        }
    }
    
    public void ValidationID_147_3()  // Long time span between start and end dates  greater than one year
    {
        if(currentForm.X32b3_Date_started__c == null || currentForm.X32c3_Date_of_last_visit__c == null || currentForm.X32d3_Number_of_sessions__c == null) return;
        if(currentForm.X32b3_Date_started__c.daysBetween (currentForm.X32c3_Date_of_last_visit__c) > 365)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_147_3));
        }
    }
    
    public void ValidationID_147_4()  // Long time span between start and end dates  greater than one year
    {
        if(currentForm.X32b4_Date_started__c == null || currentForm.X32c4_Date_of_last_visit__c == null || currentForm.X32d4_Number_of_sessions__c == null) return;
        if(currentForm.X32b4_Date_started__c.daysBetween (currentForm.X32c4_Date_of_last_visit__c) > 365)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_147_4));
        }
    }

    public void ValidationID_147_5()  // Long time span between start and end dates  greater than one year
    {
        if(currentForm.X32b5_Date_started__c == null || currentForm.X32c5_Date_of_last_visit__c == null || currentForm.X32d5_Number_of_sessions__c == null) return;
        if(currentForm.X32b5_Date_started__c.daysBetween (currentForm.X32c5_Date_of_last_visit__c) > 365)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_147_5));
        }
    }
    
    public void ValidationID_147_6()  // Long time span between start and end dates  greater than one year
    {
        if(currentForm.X32b6_Date_started__c == null || currentForm.X32c6_Date_of_last_visit__c == null || currentForm.X32d6_Number_of_sessions__c == null) return;
        if(currentForm.X32b6_Date_started__c.daysBetween (currentForm.X32c6_Date_of_last_visit__c) > 365)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_147_6));
        }
    }
    
    public void ValidationID_147_7()  // Long time span between start and end dates  greater than one year
    {
        if(currentForm.X32b7_Date_started__c == null || currentForm.X32c7_Date_of_last_visit__c == null || currentForm.X32d7_Number_of_sessions__c == null) return;
        if(currentForm.X32b7_Date_started__c.daysBetween (currentForm.X32c7_Date_of_last_visit__c) > 365)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_147_7));
        }
    }

    public void ValidationID_147_8()  // Long time span between start and end dates  greater than one year
    {
        if(currentForm.X32b8_Date_started__c == null || currentForm.X32c8_Date_of_last_visit__c == null || currentForm.X32d8_Number_of_sessions__c == null) return;
        if(currentForm.X32b8_Date_started__c.daysBetween (currentForm.X32c8_Date_of_last_visit__c) > 365)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_147_8));
        }
    }
    
    public void ValidationID_147_9()  // Long time span between start and end dates  greater than one year
    {
        if(currentForm.X32b9_Date_started__c == null || currentForm.X32c9_Date_of_last_visit__c == null || currentForm.X32d9_Number_of_sessions__c == null) return;
        if(currentForm.X32b9_Date_started__c.daysBetween (currentForm.X32c9_Date_of_last_visit__c) > 365)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_147_9));
        }
    }
    
    public void ValidationID_147_10()  // Long time span between start and end dates  greater than one year
    {
        if(currentForm.X32b10_Date_started__c == null || currentForm.X32c10_Date_of_last_visit__c == null || currentForm.X32d10_Number_of_sessions__c == null) return;
        if(currentForm.X32b10_Date_started__c.daysBetween (currentForm.X32c10_Date_of_last_visit__c) > 365)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_147_10));
        }
    }
    
    public void ValidationID_147_11()  // Long time span between start and end dates  greater than one year
    {
        if(currentForm.X32b11_Date_started__c == null || currentForm.X32c11_Date_of_last_visit__c == null || currentForm.X32d11_Number_of_sessions__c == null) return;
        if(currentForm.X32b11_Date_started__c.daysBetween (currentForm.X32c11_Date_of_last_visit__c) > 365)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_147_11));
        }
    }
    
    public void ValidationID_147_12()  // Long time span between start and end dates  greater than one year
    {
        if(currentForm.X32b12_Date_started__c == null || currentForm.X32c12_Date_of_last_visit__c == null || currentForm.X32d12_Number_of_sessions__c == null) return;
        if(currentForm.X32b12_Date_started__c.daysBetween (currentForm.X32c12_Date_of_last_visit__c) > 365)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_147_12));
        }
    }
    
    public void ValidationID_147_13()  // Long time span between start and end dates  greater than one year
    {
        if(currentForm.X32b13_Date_started__c == null || currentForm.X32c13_Date_of_last_visit__c == null || currentForm.X32d13_Number_of_sessions__c == null) return;
        if(currentForm.X32b13_Date_started__c.daysBetween (currentForm.X32c13_Date_of_last_visit__c) > 365)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_147_13));
        }
    }
    
    public void ValidationID_147_14()  // Long time span between start and end dates  greater than one year
    {
        if(currentForm.X32b14_Date_started__c == null || currentForm.X32c14_Date_of_last_visit__c == null || currentForm.X32d14_Number_of_sessions__c == null) return;
        if(currentForm.X32b14_Date_started__c.daysBetween (currentForm.X32c14_Date_of_last_visit__c) > 365)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_147_14));
        }
    }
    
    public void ValidationID_147_15()  // Long time span between start and end dates  greater than one year
    {
        if(currentForm.X32b15_Date_started__c == null || currentForm.X32c15_Date_of_last_visit__c == null || currentForm.X32d15_Number_of_sessions__c == null) return;
        if(currentForm.X32b15_Date_started__c.daysBetween (currentForm.X32c15_Date_of_last_visit__c) > 365)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_147_15));
        }
    }
    
    public void ValidationID_147_16()  // Long time span between start and end dates  greater than one year
    {
        if(currentForm.X32b16_Date_started__c == null || currentForm.X32c16_Date_of_last_visit__c == null || currentForm.X32d16_Number_of_sessions__c == null) return;
        if(currentForm.X32b16_Date_started__c.daysBetween (currentForm.X32c16_Date_of_last_visit__c) > 365)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_147_16));
        }
    }
    
    public void ValidationID_147_17()  // Long time span between start and end dates  greater than one year
    {
        if(currentForm.X32b17_Date_started__c == null || currentForm.X32c17_Date_of_last_visit__c == null || currentForm.X32d17_Number_of_sessions__c == null) return;
        if(currentForm.X32b17_Date_started__c.daysBetween (currentForm.X32c17_Date_of_last_visit__c) > 365)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_147_17));
        }
    }
    
    public void ValidationID_147_18()  // Long time span between start and end dates  greater than one year
    {
        if(currentForm.X32b18_Date_started__c == null || currentForm.X32c18_Date_of_last_visit__c == null || currentForm.X32d18_Number_of_sessions__c == null) return;
        if(currentForm.X32b18_Date_started__c.daysBetween (currentForm.X32c18_Date_of_last_visit__c) > 365)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_147_18));
        }
    }
    
    public void ValidationID_147_19()  // Long time span between start and end dates  greater than one year
    {
        if(currentForm.X32b19_Date_started__c == null || currentForm.X32c19_Date_of_last_visit__c == null || currentForm.X32d19_Number_of_sessions__c == null) return;
        if(currentForm.X32b19_Date_started__c.daysBetween (currentForm.X32c19_Date_of_last_visit__c) > 365)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_147_19));
        }
    }
    
    public void ValidationID_147_20()  // Long time span between start and end dates  greater than one year
    {
        if(currentForm.X32b20_Date_started__c == null || currentForm.X32c20_Date_of_last_visit__c == null || currentForm.X32d20_Number_of_sessions__c == null) return;
        if(currentForm.X32b20_Date_started__c.daysBetween (currentForm.X32c20_Date_of_last_visit__c) > 365)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_147_20));
        }
    }
    
    public void ValidationID_147_21()  // Long time span between start and end dates  greater than one year
    {
        if(currentForm.X32b21_Date_started__c == null || currentForm.X32c21_Date_of_last_visit__c == null || currentForm.X32d21_Number_of_sessions__c == null) return;
        if(currentForm.X32b21_Date_started__c.daysBetween (currentForm.X32c21_Date_of_last_visit__c) > 365)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_147_21));
        }
    }
    
    public void ValidationID_147_22()  // Long time span between start and end dates  greater than one year
    {
        if(currentForm.X32b22_Date_started__c == null || currentForm.X32c22_Date_of_last_visit__c == null || currentForm.X32d22_Number_of_sessions__c == null) return;
        if(currentForm.X32b22_Date_started__c.daysBetween (currentForm.X32c22_Date_of_last_visit__c) > 365)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_147_22));
        }
    }
    
    public void ValidationID_147_23()  // Long time span between start and end dates  greater than one year
    {
        if(currentForm.X32b23_Date_started__c == null || currentForm.X32c23_Date_of_last_visit__c == null || currentForm.X32d23_Number_of_sessions__c == null) return;
        if(currentForm.X32b23_Date_started__c.daysBetween (currentForm.X32c23_Date_of_last_visit__c) > 365)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_147_23));
        }
    }
    
    public void ValidationID_147_24()  // Long time span between start and end dates  greater than one year
    {
        if(currentForm.X32b24_Date_started__c == null || currentForm.X32c24_Date_of_last_visit__c == null || currentForm.X32d24_Number_of_sessions__c == null) return;
        if(currentForm.X32b24_Date_started__c.daysBetween (currentForm.X32c24_Date_of_last_visit__c) > 365)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_147_24));
        }
    }
    
    public void ValidationID_147_25()  // Long time span between start and end dates  greater than one year
    {
        if(currentForm.X32b25_Date_started__c == null || currentForm.X32c25_Date_of_last_visit__c == null || currentForm.X32d25_Number_of_sessions__c == null) return;
        if(currentForm.X32b25_Date_started__c.daysBetween (currentForm.X32c25_Date_of_last_visit__c) > 365)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_147_25));
        }
    }
    
    public void ValidationID_147_27()  // Long time span between start and end dates  greater than one year
    {
        if(currentForm.X32b27_Date_started__c == null || currentForm.X32c27_Date_of_last_visit__c == null || currentForm.X32d27_Number_of_sessions__c == null) return;
        if(currentForm.X32b27_Date_started__c.daysBetween (currentForm.X32c27_Date_of_last_visit__c) > 365)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_147_27));
        }
    }
    
    public void ValidationID_147_28() // Long time span between start and end dates  greater than one year
    {
        if(currentForm.X32b28_Date_started__c == null || currentForm.X32c28_Date_of_last_visit__c == null || currentForm.X32d28_Number_of_sessions__c == null) return;
        if(currentForm.X32b28_Date_started__c.daysBetween (currentForm.X32c28_Date_of_last_visit__c) > 365)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_147_28));
        }
    }
    
    public void ValidationID_148_DA() // Detox Alcohol, Drug to Assist the detoxification process must be entered
    
    {
        if(currentForm.X21a_Main_drug__c == null && currentForm.X22a_Drug_2__c == null && currentForm.X23a_Drug_3__c == null && currentForm.X24a_Drug_4__c == null && 
        currentForm.X25a_Drug_5__c == null && currentForm.X32b17_Date_started__c == null) return;
        if((currentForm.X21a_Main_drug__r.Item_Code__c == 700 || 
            currentForm.X22a_Drug_2__r.Item_Code__c == 700 ||
            currentForm.X23a_Drug_3__r.Item_Code__c == 700 || 
            currentForm.X24a_Drug_4__r.Item_Code__c == 700 ||
            currentForm.X25a_Drug_5__r.Item_Code__c == 700) && 
            currentForm.X32b17_Date_started__c == null)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_148_DA));
        }
        //Now check the drugs used to assist the detoxification process
        else if((currentForm.X21a_Main_drug__r.Item_Code__c == 700 || 
            currentForm.X22a_Drug_2__r.Item_Code__c == 700 ||
            currentForm.X23a_Drug_3__r.Item_Code__c == 700 || 
            currentForm.X24a_Drug_4__r.Item_Code__c == 700 ||
            currentForm.X25a_Drug_5__r.Item_Code__c == 700) && 
            (currentForm.Assist_Alcohol_Detox1__c == null && currentForm.Assist_Alcohol_Detox2__c == null && currentForm.Assist_Alcohol_Detox3__c == null))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_148_DA));
        }
    }
    
    public void ValidationID_148_DH() // Detox from Heroin, Drug to Assist the detoxification process must be entered
    
    {
        if(currentForm.X21a_Main_drug__c == null && currentForm.X22a_Drug_2__c == null && currentForm.X23a_Drug_3__c == null && currentForm.X24a_Drug_4__c == null && 
        currentForm.X25a_Drug_5__c == null && currentForm.X32b18_Date_started__c == null) return;
        if((currentForm.X21a_Main_drug__r.Item_Code__c == 111 ||
            currentForm.X22a_Drug_2__r.Item_Code__c == 111 ||
            currentForm.X23a_Drug_3__r.Item_Code__c == 111 || 
            currentForm.X24a_Drug_4__r.Item_Code__c == 111 ||
            currentForm.X25a_Drug_5__r.Item_Code__c == 111) && 
            currentForm.X32b18_Date_started__c == null)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_148_DH));
        }
        //Now check the drugs used to assist the detoxification process
        else if((currentForm.X21a_Main_drug__r.Item_Code__c == 111 ||
            currentForm.X22a_Drug_2__r.Item_Code__c == 111 ||
            currentForm.X23a_Drug_3__r.Item_Code__c == 111 || 
            currentForm.X24a_Drug_4__r.Item_Code__c == 111 ||
            currentForm.X25a_Drug_5__r.Item_Code__c == 111) && 
            (currentForm.Assist_Heroin_Detox1__c == null && currentForm.Assist_Heroin_Detox2__c == null && currentForm.Assist_Heroin_Detox3__c == null))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_148_DH));
        }
    }
    
    public void ValidationID_148_DM() // Detox from Methadone, Drug to Assist the detoxification process must be entered
    
    {
        if(currentForm.X21a_Main_drug__c == null && currentForm.X22a_Drug_2__c == null && currentForm.X23a_Drug_3__c == null && currentForm.X24a_Drug_4__c == null && 
        currentForm.X25a_Drug_5__c == null && currentForm.X32b19_Date_started__c == null) return;
        if(((currentForm.X21a_Main_drug__r.Item_Code__c == 144 || currentForm.X21a_Main_drug__r.Item_Code__c == 161 || currentForm.X21a_Main_drug__r.Item_Code__c == 149) ||
            (currentForm.X22a_Drug_2__r.Item_Code__c == 144 || currentForm.X22a_Drug_2__r.Item_Code__c == 161 || currentForm.X22a_Drug_2__r.Item_Code__c == 149) ||
            (currentForm.X23a_Drug_3__r.Item_Code__c == 144 || currentForm.X23a_Drug_3__r.Item_Code__c == 161 || currentForm.X23a_Drug_3__r.Item_Code__c == 149) ||
            (currentForm.X24a_Drug_4__r.Item_Code__c == 144 || currentForm.X24a_Drug_4__r.Item_Code__c == 161 || currentForm.X24a_Drug_4__r.Item_Code__c == 149) ||
            (currentForm.X25a_Drug_5__r.Item_Code__c == 141 || currentForm.X25a_Drug_5__r.Item_Code__c == 161 || currentForm.X25a_Drug_5__r.Item_Code__c == 149)) &&
            currentForm.X32b19_Date_started__c == null)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_148_DM));
        }
        //Now check the drugs used to assist the detoxification process
        else if(((currentForm.X21a_Main_drug__r.Item_Code__c == 144 || currentForm.X21a_Main_drug__r.Item_Code__c == 161 || currentForm.X21a_Main_drug__r.Item_Code__c == 149) ||
            (currentForm.X22a_Drug_2__r.Item_Code__c == 144 || currentForm.X22a_Drug_2__r.Item_Code__c == 161 || currentForm.X22a_Drug_2__r.Item_Code__c == 149) ||
            (currentForm.X23a_Drug_3__r.Item_Code__c == 144 || currentForm.X23a_Drug_3__r.Item_Code__c == 161 || currentForm.X23a_Drug_3__r.Item_Code__c == 149) ||
            (currentForm.X24a_Drug_4__r.Item_Code__c == 144 || currentForm.X24a_Drug_4__r.Item_Code__c == 161 || currentForm.X24a_Drug_4__r.Item_Code__c == 149) ||
            (currentForm.X25a_Drug_5__r.Item_Code__c == 141 || currentForm.X25a_Drug_5__r.Item_Code__c == 161 || currentForm.X25a_Drug_5__r.Item_Code__c == 149)) &&
            (currentForm.Assist_Methadone_Detox1__c == null && currentForm.Assist_Methadone_Detox2__c == null && currentForm.Assist_Methadone_Detox3__c == null))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_148_DM));
        }
    }
    
    public void ValidationID_148_DB_1() // Detox from benzodiazepines, Drug to Assist the detoxification process must be entered
    
    {
        if(currentForm.X21a_Main_drug__c == null && currentForm.X22a_Drug_2__c == null && currentForm.X23a_Drug_3__c == null && currentForm.X24a_Drug_4__c == null && 
        currentForm.X25a_Drug_5__c == null && currentForm.X32b20_Date_started__c == null) return;
        if(((currentForm.X21a_Main_drug__r.Item_Code__c >= 320 && currentForm.X21a_Main_drug__r.Item_Code__c <= 328) ||
            (currentForm.X22a_Drug_2__r.Item_Code__c >= 320 && currentForm.X22a_Drug_2__r.Item_Code__c <= 328) ||
            (currentForm.X23a_Drug_3__r.Item_Code__c >= 320 && currentForm.X23a_Drug_3__r.Item_Code__c <= 328) ||
            (currentForm.X24a_Drug_4__r.Item_Code__c >= 320 && currentForm.X24a_Drug_4__r.Item_Code__c <= 328) ||
            (currentForm.X25a_Drug_5__r.Item_Code__c >= 320 && currentForm.X25a_Drug_5__r.Item_Code__c <= 328)) && 
            currentForm.X32b20_Date_started__c == null)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_148_DB));
        }
    }
    
    public void ValidationID_148_DB_2() //Now check the drugs used to assist the detoxification process
    {
        if(currentForm.X21a_Main_drug__c == null && currentForm.X22a_Drug_2__c == null && currentForm.X23a_Drug_3__c == null && currentForm.X24a_Drug_4__c == null && 
        currentForm.X25a_Drug_5__c == null && currentForm.X32b20_Date_started__c == null) return;
        if(((currentForm.X21a_Main_drug__r.Item_Code__c >= 320 && currentForm.X21a_Main_drug__r.Item_Code__c <= 328) ||
            (currentForm.X22a_Drug_2__r.Item_Code__c >= 320 && currentForm.X22a_Drug_2__r.Item_Code__c <= 328) ||
            (currentForm.X23a_Drug_3__r.Item_Code__c >= 320 && currentForm.X23a_Drug_3__r.Item_Code__c <= 328) ||
            (currentForm.X24a_Drug_4__r.Item_Code__c >= 320 && currentForm.X24a_Drug_4__r.Item_Code__c <= 328) ||
            (currentForm.X25a_Drug_5__r.Item_Code__c >= 320 && currentForm.X25a_Drug_5__r.Item_Code__c <= 328)) && 
            currentForm.X32b20_Date_started__c != null &&
            (currentForm.Assist_Benzo_Detox1__c == null && currentForm.Assist_Benzo_Detox2__c == null && currentForm.Assist_Benzo_Detox3__c == null))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_148_DB));
        }
    }
    
    public void ValidationID_148_DZ_1() // Detox from Z drugs, Drug to Assist the detoxification process must be entered
    
    {
        if(currentForm.X21a_Main_drug__c == null && currentForm.X22a_Drug_2__c == null && currentForm.X23a_Drug_3__c == null && currentForm.X24a_Drug_4__c == null && 
        currentForm.X25a_Drug_5__c == null && currentForm.X32b21_Date_started__c == null) return;
        if((currentForm.X21a_Main_drug__r.Item_Code__c == 318 || 
            currentForm.X22a_Drug_2__r.Item_Code__c == 318 ||
            currentForm.X23a_Drug_3__r.Item_Code__c == 318 ||
            currentForm.X24a_Drug_4__r.Item_Code__c == 318 ||
            currentForm.X25a_Drug_5__r.Item_Code__c == 318) && 
            currentForm.X32b21_Date_started__c == null)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_148_DZ));
        }
    }
    
    public void ValidationID_148_DZ_2() //Now check the drugs used to assist the detoxification process
    {
        if(currentForm.X21a_Main_drug__c == null && currentForm.X22a_Drug_2__c == null && currentForm.X23a_Drug_3__c == null && currentForm.X24a_Drug_4__c == null && 
        currentForm.X25a_Drug_5__c == null && currentForm.X32b21_Date_started__c == null) return;
        if((currentForm.X21a_Main_drug__r.Item_Code__c == 318 || 
            currentForm.X22a_Drug_2__r.Item_Code__c == 318 ||
            currentForm.X23a_Drug_3__r.Item_Code__c == 318 ||
            currentForm.X24a_Drug_4__r.Item_Code__c == 318 ||
            currentForm.X25a_Drug_5__r.Item_Code__c == 318) && 
            currentForm.X32b21_Date_started__c != null &&
            (currentForm.Assist_ZDrugs_Detox1__c == null && currentForm.Assist_ZDrugs_Detox2__c == null && currentForm.Assist_ZDrugs_Detox3__c == null))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_148_DZ));
        }
    }
    
    public void ValidationID_149 () // Alcohol Detox must be listed as problem drugs.
    {
        if(currentForm.X21a_Main_drug__c == null && currentForm.X22a_Drug_2__c == null && currentForm.X23a_Drug_3__c == null && currentForm.X24a_Drug_4__c == null && 
        currentForm.X25a_Drug_5__c == null && currentForm.X32b17_Date_started__c == null) return;
        if((currentForm.X21a_Main_drug__r.Item_Code__c != 700 && 
        currentForm.X22a_Drug_2__r.Item_Code__c != 700 &&
        currentForm.X23a_Drug_3__r.Item_Code__c != 700 && 
        currentForm.X24a_Drug_4__r.Item_Code__c != 700 &&
        currentForm.X25a_Drug_5__r.Item_Code__c != 700) && currentForm.X32b17_Date_started__c != null)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_149));
        }
        
    }
    
    public void ValidationID_150 () // Detox heroin must be listed as problem drugs.
    {
        if(currentForm.X21a_Main_drug__c == null && currentForm.X22a_Drug_2__c == null && currentForm.X23a_Drug_3__c == null && currentForm.X24a_Drug_4__c == null && 
        currentForm.X25a_Drug_5__c == null && currentForm.X32b18_Date_started__c == null) return;
        if((currentForm.X21a_Main_drug__r.Item_Code__c != 111 && 
        currentForm.X22a_Drug_2__r.Item_Code__c != 111 &&
        currentForm.X23a_Drug_3__r.Item_Code__c != 111 && 
        currentForm.X24a_Drug_4__r.Item_Code__c != 111 &&
        currentForm.X25a_Drug_5__r.Item_Code__c != 111) && currentForm.X32b18_Date_started__c != null)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_150));
        }
        
    }
    
    public void ValidationID_151 () // Detox methadone must be listed as problem drugs.
    {
        if(currentForm.X21a_Main_drug__c == null && currentForm.X22a_Drug_2__c == null && currentForm.X23a_Drug_3__c == null && currentForm.X24a_Drug_4__c == null && 
        currentForm.X25a_Drug_5__c == null && currentForm.X32b19_Date_started__c == null) return;
        if(((currentForm.X21a_Main_drug__r.Item_Code__c != 144 && currentForm.X21a_Main_drug__r.Item_Code__c != 161 && currentForm.X21a_Main_drug__r.Item_Code__c != 149) &&
            (currentForm.X22a_Drug_2__r.Item_Code__c != 144 && currentForm.X22a_Drug_2__r.Item_Code__c != 161 && currentForm.X22a_Drug_2__r.Item_Code__c != 149) &&
            (currentForm.X23a_Drug_3__r.Item_Code__c != 144 && currentForm.X23a_Drug_3__r.Item_Code__c != 161 && currentForm.X23a_Drug_3__r.Item_Code__c != 149) &&
            (currentForm.X24a_Drug_4__r.Item_Code__c != 144 && currentForm.X24a_Drug_4__r.Item_Code__c != 161 && currentForm.X24a_Drug_4__r.Item_Code__c != 149) &&
            (currentForm.X25a_Drug_5__r.Item_Code__c != 141 && currentForm.X25a_Drug_5__r.Item_Code__c != 161 && currentForm.X25a_Drug_5__r.Item_Code__c != 149)) && 
            currentForm.X32b19_Date_started__c != null)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_151));
        }
        
    }
    
    public void ValidationID_152 () // Detox Benzodiazepines must be listed as problem drugs.
    {
        if(currentForm.X21a_Main_drug__c == null && currentForm.X22a_Drug_2__c == null && currentForm.X23a_Drug_3__c == null && currentForm.X24a_Drug_4__c == null && 
        currentForm.X25a_Drug_5__c == null && currentForm.X32b20_Date_started__c == null) return;
        if((!(currentForm.X21a_Main_drug__r.Item_Code__c >= 320 && currentForm.X21a_Main_drug__r.Item_Code__c <= 328) &&
            !(currentForm.X22a_Drug_2__r.Item_Code__c >= 320 && currentForm.X22a_Drug_2__r.Item_Code__c <= 328) &&
            !(currentForm.X23a_Drug_3__r.Item_Code__c >= 320 && currentForm.X23a_Drug_3__r.Item_Code__c <= 328) &&
            !(currentForm.X24a_Drug_4__r.Item_Code__c >= 320 && currentForm.X24a_Drug_4__r.Item_Code__c <= 328) &&
            !(currentForm.X25a_Drug_5__r.Item_Code__c >= 320 && currentForm.X25a_Drug_5__r.Item_Code__c <= 328)) && 
            currentForm.X32b20_Date_started__c != null)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_152));
        }
        
    }
    
    public void ValidationID_153 () // Detox Z drugs must be listed as problem drugs.
    {
        if(currentForm.X21a_Main_drug__c == null && currentForm.X22a_Drug_2__c == null && currentForm.X23a_Drug_3__c == null && currentForm.X24a_Drug_4__c == null && 
        currentForm.X25a_Drug_5__c == null && currentForm.X32b21_Date_started__c == null) return;
        if((currentForm.X21a_Main_drug__r.Item_Code__c != 318 && 
        currentForm.X22a_Drug_2__r.Item_Code__c != 318 &&
        currentForm.X23a_Drug_3__r.Item_Code__c != 318 &&
        currentForm.X24a_Drug_4__r.Item_Code__c != 318 &&
        currentForm.X25a_Drug_5__r.Item_Code__c != 318) && currentForm.X32b21_Date_started__c != null)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_153));
        }
        
    }
    
    public void ValidationID_155 () // Detox Drugs must be listed as problem drugs.
    {
        if(currentForm.X21a_Main_drug__c == null && currentForm.X22a_Drug_2__c == null && currentForm.X23a_Drug_3__c == null && currentForm.X24a_Drug_4__c == null && 
        currentForm.X25a_Drug_5__c == null && currentForm.X32a22_Detox_from_other_drug_Specify__c == null) return;
        if(((currentForm.X21a_Main_drug__c != null && currentForm.X21a_Main_drug__r.Item_Code__c != 700) ||
        (currentForm.X22a_Drug_2__c != null && currentForm.X22a_Drug_2__r.Item_Code__c != 700) ||
        (currentForm.X23a_Drug_3__c != null && currentForm.X23a_Drug_3__r.Item_Code__c != 700) ||
        (currentForm.X24a_Drug_4__c != null && currentForm.X24a_Drug_4__r.Item_Code__c != 700) ||
        (currentForm.X25a_Drug_5__c != null && currentForm.X25a_Drug_5__r.Item_Code__c != 700)) && 
        currentForm.X32a22_Detox_from_other_drug_Specify__c != null && 
        (currentForm.X32a22_Detox_from_other_drug_Specify__r.Item_Code__c != currentForm.X21a_Main_drug__r.Item_Code__c &&
        currentForm.X32a22_Detox_from_other_drug_Specify__r.Item_Code__c != currentForm.X22a_Drug_2__r.Item_Code__c &&
        currentForm.X32a22_Detox_from_other_drug_Specify__r.Item_Code__c != currentForm.X23a_Drug_3__r.Item_Code__c &&
        currentForm.X32a22_Detox_from_other_drug_Specify__r.Item_Code__c != currentForm.X24a_Drug_4__r.Item_Code__c &&
        currentForm.X32a22_Detox_from_other_drug_Specify__r.Item_Code__c != currentForm.X25a_Drug_5__r.Item_Code__c))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_155));
        }
        
    }
    
    public void ValidationID_156 () // Opiate Substitution and no opiate. If opiate substitution selected (Q32, Inter 15 or 16), Q22-26 no opiate (100 to 188).
    {
        if(currentForm.X21a_Main_drug__c == null && currentForm.X22a_Drug_2__c == null && currentForm.X23a_Drug_3__c == null && currentForm.X24a_Drug_4__c == null && 
            currentForm.X25a_Drug_5__c == null && currentForm.X32b15_Date_started__c == null && currentForm.X32b16_Date_started__c == null) return;
        if((!(currentForm.X21a_Main_drug__r.Item_Code__c >= 100 && currentForm.X21a_Main_drug__r.Item_Code__c <= 188) &&
            !(currentForm.X22a_Drug_2__r.Item_Code__c >= 100 && currentForm.X22a_Drug_2__r.Item_Code__c <= 188) &&
            !(currentForm.X23a_Drug_3__r.Item_Code__c >= 100 && currentForm.X23a_Drug_3__r.Item_Code__c <= 188) &&
            !(currentForm.X24a_Drug_4__r.Item_Code__c >= 100 && currentForm.X24a_Drug_4__r.Item_Code__c <= 188) &&
            !(currentForm.X25a_Drug_5__r.Item_Code__c >= 100 && currentForm.X25a_Drug_5__r.Item_Code__c <= 188)) && 
            (currentForm.X32b15_Date_started__c != null || currentForm.X32b16_Date_started__c != null))
            {
                warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_156));
            }
        
    }
    
    public void ValidationID_157 () // OST and Detox. Q32 = option 15 or 16 AND Inter 18, 19 or opiate (100 to 188) at option 32 but intervention dates overlap/ The dates should run concurrently 
    {
        if(currentForm.X32b15_Date_started__c == null && currentForm.X32b16_Date_started__c == null && currentForm.X32b18_Date_started__c == null && currentForm.X32b19_Date_started__c == null) return;
        if((currentForm.X32b15_Date_started__c != null && currentForm.X32b18_Date_started__c != null && currentForm.X32b15_Date_started__c != currentForm.X32b18_Date_started__c)||
            (currentForm.X32b15_Date_started__c != null && currentForm.X32b19_Date_started__c != null && currentForm.X32b15_Date_started__c != currentForm.X32b19_Date_started__c)||
            (currentForm.X32b16_Date_started__c != null && currentForm.X32b18_Date_started__c != null && currentForm.X32b16_Date_started__c != currentForm.X32b18_Date_started__c)||
            (currentForm.X32b16_Date_started__c != null && currentForm.X32b19_Date_started__c != null && currentForm.X32b16_Date_started__c != currentForm.X32b19_Date_started__c))
            {
                warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_157));
            }
    }
    
    public void ValidationID_158 () // OST and med free. Q32 = option 8 or 9 AND option 12  but intervention dates overlap/ The dates should run concurrently 
    {
        if(currentForm.X32b15_Date_started__c == null && currentForm.X32b16_Date_started__c == null && currentForm.X32b6_Date_started__c == null) return;
        if((currentForm.X32b15_Date_started__c != null && currentForm.X32b6_Date_started__c != null && currentForm.X32b15_Date_started__c != currentForm.X32b6_Date_started__c)||
            (currentForm.X32b16_Date_started__c != null && currentForm.X32b6_Date_started__c != null && currentForm.X32b16_Date_started__c != currentForm.X32b6_Date_started__c))
            {
                warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_158));
            }
    }
    
    public void ValidationID_163_1 () // Intervention dates_one session
    {
        if(currentForm.X32b1_Date_started__c == null || currentForm.X32c1_Date_of_last_visit__c == null || currentForm.X32d1_Number_of_sessions__c == null) return;
        if(currentForm.X32b1_Date_started__c!= currentForm.X32c1_Date_of_last_visit__c && currentForm.X32d1_Number_of_sessions__c == 1)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_163_1));
        }   
    }
    
    public void ValidationID_163_2 () // Intervention dates_one session
    {
        if(currentForm.X32b2_Date_started__c == null || currentForm.X32c2_Date_of_last_visit__c == null || currentForm.X32d2_Number_of_sessions__c == null) return;
        if(currentForm.X32b2_Date_started__c!= currentForm.X32c2_Date_of_last_visit__c && currentForm.X32d2_Number_of_sessions__c == 1)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_163_2));
        }   
    }
    
    public void ValidationID_163_3 () // Intervention dates_one session
    {
        if(currentForm.X32b3_Date_started__c == null || currentForm.X32c3_Date_of_last_visit__c == null || currentForm.X32d3_Number_of_sessions__c == null) return;
        if(currentForm.X32b3_Date_started__c!= currentForm.X32c3_Date_of_last_visit__c && currentForm.X32d3_Number_of_sessions__c == 1)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_163_3));
        }   
    }
    
    public void ValidationID_163_4 () // Intervention dates_one session
    {
        if(currentForm.X32b4_Date_started__c == null || currentForm.X32c4_Date_of_last_visit__c == null || currentForm.X32d4_Number_of_sessions__c == null) return;
        if(currentForm.X32b4_Date_started__c!= currentForm.X32c4_Date_of_last_visit__c && currentForm.X32d4_Number_of_sessions__c == 1)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_163_4));
        }
    }
    
    public void ValidationID_163_5 () // Intervention dates_one session
    {
        if(currentForm.X32b5_Date_started__c == null || currentForm.X32c5_Date_of_last_visit__c == null || currentForm.X32d5_Number_of_sessions__c == null) return;
        if(currentForm.X32b5_Date_started__c!= currentForm.X32c5_Date_of_last_visit__c && currentForm.X32d5_Number_of_sessions__c == 1)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_163_5));
        }
    }
    
    public void ValidationID_163_6 () // Intervention dates_one session
    {
        if(currentForm.X32b6_Date_started__c == null || currentForm.X32c6_Date_of_last_visit__c == null || currentForm.X32d6_Number_of_sessions__c == null) return;
        if(currentForm.X32b6_Date_started__c!= currentForm.X32c6_Date_of_last_visit__c && currentForm.X32d6_Number_of_sessions__c == 1)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_163_6));
        }
    }
    
    public void ValidationID_163_7 () // Intervention dates_one session
    {
        if(currentForm.X32b7_Date_started__c == null || currentForm.X32c7_Date_of_last_visit__c == null || currentForm.X32d7_Number_of_sessions__c == null) return;
        if(currentForm.X32b7_Date_started__c!= currentForm.X32c7_Date_of_last_visit__c && currentForm.X32d7_Number_of_sessions__c == 1)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_163_7));
        }
    }
    
    public void ValidationID_163_8 () // Intervention dates_one session
    {
        if(currentForm.X32b8_Date_started__c == null || currentForm.X32c8_Date_of_last_visit__c == null || currentForm.X32d8_Number_of_sessions__c == null) return;
        if(currentForm.X32b8_Date_started__c!= currentForm.X32c8_Date_of_last_visit__c && currentForm.X32d8_Number_of_sessions__c == 1)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_163_8));
        }
    }
    
    public void ValidationID_163_9 () // Intervention dates_one session
    {
        if(currentForm.X32b9_Date_started__c == null || currentForm.X32c9_Date_of_last_visit__c == null || currentForm.X32d9_Number_of_sessions__c == null) return;
        if(currentForm.X32b9_Date_started__c!= currentForm.X32c9_Date_of_last_visit__c && currentForm.X32d9_Number_of_sessions__c == 1)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_163_9));
        }
    }
    
    public void ValidationID_163_10 () // Intervention dates_one session
    {
        if(currentForm.X32b10_Date_started__c == null || currentForm.X32c10_Date_of_last_visit__c == null || currentForm.X32d10_Number_of_sessions__c == null) return;
        if(currentForm.X32b10_Date_started__c!= currentForm.X32c10_Date_of_last_visit__c && currentForm.X32d10_Number_of_sessions__c == 1)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_163_10));
        }
    }
    
    public void ValidationID_163_11 () // Intervention dates_one session
    {
        if(currentForm.X32b11_Date_started__c == null || currentForm.X32c11_Date_of_last_visit__c == null || currentForm.X32d11_Number_of_sessions__c == null) return;
        if(currentForm.X32b11_Date_started__c!= currentForm.X32c11_Date_of_last_visit__c && currentForm.X32d11_Number_of_sessions__c == 1)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_163_11));
        }
    }
    
    public void ValidationID_163_12 () // Intervention dates_one session
    {
        if(currentForm.X32b12_Date_started__c == null || currentForm.X32c12_Date_of_last_visit__c == null || currentForm.X32d12_Number_of_sessions__c == null) return;
        if(currentForm.X32b12_Date_started__c!= currentForm.X32c12_Date_of_last_visit__c && currentForm.X32d12_Number_of_sessions__c == 1)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_163_12));
        }
    }
    
    public void ValidationID_163_13 () // Intervention dates_one session
    {
        if(currentForm.X32b13_Date_started__c == null || currentForm.X32c13_Date_of_last_visit__c == null || currentForm.X32d13_Number_of_sessions__c == null) return;
        if(currentForm.X32b13_Date_started__c!= currentForm.X32c13_Date_of_last_visit__c && currentForm.X32d13_Number_of_sessions__c == 1)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_163_13));
        }
    }
    
    public void ValidationID_163_14 () // Intervention dates_one session
    {
        if(currentForm.X32b14_Date_started__c == null || currentForm.X32c14_Date_of_last_visit__c == null || currentForm.X32d14_Number_of_sessions__c == null) return;
        if(currentForm.X32b14_Date_started__c!= currentForm.X32c14_Date_of_last_visit__c && currentForm.X32d14_Number_of_sessions__c == 1)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_163_14));
        }
    }
    
    public void ValidationID_163_15 () // Intervention dates_one session
    {
        if(currentForm.X32b15_Date_started__c == null || currentForm.X32c15_Date_of_last_visit__c == null || currentForm.X32d15_Number_of_sessions__c == null) return;
        if(currentForm.X32b15_Date_started__c!= currentForm.X32c15_Date_of_last_visit__c && currentForm.X32d15_Number_of_sessions__c == 1)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_163_15));
        }
    }
    
    public void ValidationID_163_16 () // Intervention dates_one session
    {
        if(currentForm.X32b16_Date_started__c == null || currentForm.X32c16_Date_of_last_visit__c == null || currentForm.X32d16_Number_of_sessions__c == null) return;
        if(currentForm.X32b16_Date_started__c!= currentForm.X32c16_Date_of_last_visit__c && currentForm.X32d16_Number_of_sessions__c == 1)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_163_16));
        }
    }
    
    public void ValidationID_163_17 () // Intervention dates_one session
    {
        if(currentForm.X32b17_Date_started__c == null || currentForm.X32c17_Date_of_last_visit__c == null || currentForm.X32d17_Number_of_sessions__c == null) return;
        if(currentForm.X32b17_Date_started__c!= currentForm.X32c17_Date_of_last_visit__c && currentForm.X32d17_Number_of_sessions__c == 1)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_163_17));
        }
    }
    
    public void ValidationID_163_18 () // Intervention dates_one session
    {
        if(currentForm.X32b18_Date_started__c == null || currentForm.X32c18_Date_of_last_visit__c == null || currentForm.X32d18_Number_of_sessions__c == null) return;
        if(currentForm.X32b18_Date_started__c!= currentForm.X32c18_Date_of_last_visit__c && currentForm.X32d18_Number_of_sessions__c == 1)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_163_18));
        }
    }
    
    public void ValidationID_163_19 () // Intervention dates_one session
    {
        if(currentForm.X32b19_Date_started__c == null || currentForm.X32c19_Date_of_last_visit__c == null || currentForm.X32d19_Number_of_sessions__c == null) return;
        if(currentForm.X32b19_Date_started__c!= currentForm.X32c19_Date_of_last_visit__c && currentForm.X32d19_Number_of_sessions__c == 1)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_163_19));
        }
    }
    
    public void ValidationID_163_20 () // Intervention dates_one session
    {
        if(currentForm.X32b20_Date_started__c == null || currentForm.X32c20_Date_of_last_visit__c == null || currentForm.X32d20_Number_of_sessions__c == null) return;
        if(currentForm.X32b20_Date_started__c!= currentForm.X32c20_Date_of_last_visit__c && currentForm.X32d20_Number_of_sessions__c == 1)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_163_20));
        }
    }
    
    public void ValidationID_163_21 () // Intervention dates_one session
    {
        if(currentForm.X32b21_Date_started__c == null || currentForm.X32c21_Date_of_last_visit__c == null || currentForm.X32d21_Number_of_sessions__c == null) return;
        if(currentForm.X32b21_Date_started__c!= currentForm.X32c21_Date_of_last_visit__c && currentForm.X32d21_Number_of_sessions__c == 1)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_163_21));
        }
    }
    
    public void ValidationID_163_22 () // Intervention dates_one session
    {
        if(currentForm.X32b22_Date_started__c == null || currentForm.X32c22_Date_of_last_visit__c == null || currentForm.X32d22_Number_of_sessions__c == null) return;
        if(currentForm.X32b22_Date_started__c!= currentForm.X32c22_Date_of_last_visit__c && currentForm.X32d22_Number_of_sessions__c == 1)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_163_22));
        }
    }
    
    public void ValidationID_163_23 () // Intervention dates_one session
    {
        if(currentForm.X32b23_Date_started__c == null || currentForm.X32c23_Date_of_last_visit__c == null || currentForm.X32d23_Number_of_sessions__c == null) return;
        if(currentForm.X32b23_Date_started__c!= currentForm.X32c23_Date_of_last_visit__c && currentForm.X32d23_Number_of_sessions__c == 1)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_163_23));
        }
    }
    
    public void ValidationID_163_24 () // Intervention dates_one session
    {
        if(currentForm.X32b24_Date_started__c == null || currentForm.X32c24_Date_of_last_visit__c == null || currentForm.X32d24_Number_of_sessions__c == null) return;
        if(currentForm.X32b24_Date_started__c!= currentForm.X32c24_Date_of_last_visit__c && currentForm.X32d24_Number_of_sessions__c == 1)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_163_24));
        }
    }
    
    public void ValidationID_163_25 () // Intervention dates_one session
    {
        if(currentForm.X32b25_Date_started__c == null || currentForm.X32c25_Date_of_last_visit__c == null || currentForm.X32d25_Number_of_sessions__c == null) return;
        if(currentForm.X32b25_Date_started__c!= currentForm.X32c25_Date_of_last_visit__c && currentForm.X32d25_Number_of_sessions__c == 1)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_163_25));
        }
    }
    
    public void ValidationID_163_27 () // Intervention dates_one session
    {
        if(currentForm.X32b27_Date_started__c == null || currentForm.X32c27_Date_of_last_visit__c == null || currentForm.X32d27_Number_of_sessions__c == null) return;
        if(currentForm.X32b27_Date_started__c!= currentForm.X32c27_Date_of_last_visit__c && currentForm.X32d27_Number_of_sessions__c == 1)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_163_27));
        }
    }
    
    public void ValidationID_163_28 () // Intervention dates_one session
    {
        if(currentForm.X32b28_Date_started__c == null || currentForm.X32c28_Date_of_last_visit__c == null || currentForm.X32d28_Number_of_sessions__c == null) return;
        if(currentForm.X32b28_Date_started__c!= currentForm.X32c28_Date_of_last_visit__c && currentForm.X32d28_Number_of_sessions__c == 1)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_163_28));
        }
    }
    
    public void ValidationID_173 () // Number of CP_Family therapy/Consultation, if dates entered Q32b9, Q32b11 then Q33b can not be = 0
    {
        if(currentForm.X32b9_Date_started__c == null && currentForm.X32b11_Date_started__c == null && currentForm.X33b_Number_of_others_involved__c == null) return;
        if((currentForm.X32b9_Date_started__c!= null || currentForm.X32b11_Date_started__c != null) && currentForm.X33b_Number_of_others_involved__c == 0)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_173));
        }
    }
    
    
    public void ValidationID_175D1 () // Q32 = 6. Medication Free Therapy with opiates (100 to 188) and frequency = 3, 6, 7, 1 at Q21
    {
        if(currentForm.X21a_Main_drug__c == null && currentForm.X21b_Route_of_Admin_Main_drug__c == null && currentForm.X21c_Frequency_of_use_in_last_mth__c == null && currentForm.X32b6_Date_started__c == null) return;
        if((currentForm.X21a_Main_drug__c != null && currentForm.X21a_Main_drug__r.Item_Code__c >= 100 && currentForm.X21a_Main_drug__r.Item_Code__c <= 188) && 
            (currentForm.X21b_Route_of_Admin_Main_drug__c != null && !currentForm.X21b_Route_of_Admin_Main_drug__c.startsWith('2.') && !currentForm.X21b_Route_of_Admin_Main_drug__c.startsWith('3.') && !currentForm.X21b_Route_of_Admin_Main_drug__c.startsWith('4.')) &&
            (currentForm.X21c_Frequency_of_use_in_last_mth__c != null && currentForm.X21c_Frequency_of_use_in_last_mth__c.startsWith('3.') || currentForm.X21c_Frequency_of_use_in_last_mth__c.startsWith('6.') || currentForm.X21c_Frequency_of_use_in_last_mth__c.startsWith('7.') || currentForm.X21c_Frequency_of_use_in_last_mth__c.startsWith('1.')) && 
            (currentForm.X32b15_Date_started__c == null && currentForm.X32b16_Date_started__c == null && currentForm.X32b18_Date_started__c == null && currentForm.X32b19_Date_started__c == null) &&
            currentForm.X32b6_Date_started__c != null)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_175));
        }   
    }
    
    public void ValidationID_175D2 () // Q32 = 6. Medication Free Therapy with opiates (100 to 188) and frequency = 3, 6, 7, 1 at Q22
    {
        if(currentForm.X22a_Drug_2__c == null && currentForm.X22b_Route_of_Admin_Drug2__c == null && currentForm.X22c_Frequency_of_use_in_last_mth__c == null && currentForm.X32b6_Date_started__c == null) return;
        if((currentForm.X22a_Drug_2__c != null && currentForm.X22a_Drug_2__r.Item_Code__c >= 100 && currentForm.X22a_Drug_2__r.Item_Code__c <= 188) && 
            (currentForm.X22b_Route_of_Admin_Drug2__c != null && !currentForm.X22b_Route_of_Admin_Drug2__c.startsWith('2.') && !currentForm.X22b_Route_of_Admin_Drug2__c.startsWith('3.') && !currentForm.X22b_Route_of_Admin_Drug2__c.startsWith('4.')) &&
            (currentForm.X22c_Frequency_of_use_in_last_mth__c != null && currentForm.X22c_Frequency_of_use_in_last_mth__c.startsWith('3.') || currentForm.X22c_Frequency_of_use_in_last_mth__c.startsWith('6.') || currentForm.X22c_Frequency_of_use_in_last_mth__c.startsWith('7.') || currentForm.X22c_Frequency_of_use_in_last_mth__c.startsWith('1.')) && 
            (currentForm.X32b15_Date_started__c == null && currentForm.X32b16_Date_started__c == null && currentForm.X32b18_Date_started__c == null && currentForm.X32b19_Date_started__c == null) &&
            currentForm.X32b6_Date_started__c != null)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_175));
        }   
    }
    
    public void ValidationID_175D3 () // Q32 = 6. Medication Free Therapy with opiates (100 to 188) and frequency = 3, 6, 7, 1 at Q23
    {
        if(currentForm.X23a_Drug_3__c == null && currentForm.X23b_Route_of_Admin_Drug3__c == null && currentForm.X23c_Frequency_of_use_in_last_mth__c == null && currentForm.X32b6_Date_started__c == null) return;
        if((currentForm.X23a_Drug_3__c != null && currentForm.X23a_Drug_3__r.Item_Code__c >= 100 && currentForm.X23a_Drug_3__r.Item_Code__c <= 188) && 
            (currentForm.X23b_Route_of_Admin_Drug3__c != null && !currentForm.X23b_Route_of_Admin_Drug3__c.startsWith('2.') && !currentForm.X23b_Route_of_Admin_Drug3__c.startsWith('3.') && !currentForm.X23b_Route_of_Admin_Drug3__c.startsWith('4.')) &&
            (currentForm.X23c_Frequency_of_use_in_last_mth__c != null && currentForm.X23c_Frequency_of_use_in_last_mth__c.startsWith('3.') || currentForm.X23c_Frequency_of_use_in_last_mth__c.startsWith('6.') || currentForm.X23c_Frequency_of_use_in_last_mth__c.startsWith('7.') || currentForm.X23c_Frequency_of_use_in_last_mth__c.startsWith('1.')) && 
            (currentForm.X32b15_Date_started__c == null && currentForm.X32b16_Date_started__c == null && currentForm.X32b18_Date_started__c == null && currentForm.X32b19_Date_started__c == null) &&
            currentForm.X32b6_Date_started__c != null)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_175));
        }   
    }
    
    public void ValidationID_175D4 () // Q32 = 6. Medication Free Therapy with opiates (100 to 188) and frequency = 3, 6, 7, 1 at Q24
    {
        if(currentForm.X24a_Drug_4__c == null && currentForm.X24b_Route_of_Admin_Drug4__c == null && currentForm.X23c_Frequency_of_use_in_last_mth__c == null && currentForm.X32b6_Date_started__c == null) return;
        if((currentForm.X24a_Drug_4__c != null && currentForm.X24a_Drug_4__r.Item_Code__c >= 100 && currentForm.X24a_Drug_4__r.Item_Code__c <= 188) && 
            (currentForm.X24b_Route_of_Admin_Drug4__c != null && !currentForm.X24b_Route_of_Admin_Drug4__c.startsWith('2.') && !currentForm.X24b_Route_of_Admin_Drug4__c.startsWith('3.') && !currentForm.X24b_Route_of_Admin_Drug4__c.startsWith('4.')) &&
            (currentForm.X24c_Frequency_of_use_in_last_mth__c != null && currentForm.X24c_Frequency_of_use_in_last_mth__c.startsWith('3.') || currentForm.X24c_Frequency_of_use_in_last_mth__c.startsWith('6.') || currentForm.X24c_Frequency_of_use_in_last_mth__c.startsWith('7.') || currentForm.X24c_Frequency_of_use_in_last_mth__c.startsWith('1.')) && 
            (currentForm.X32b15_Date_started__c == null && currentForm.X32b16_Date_started__c == null && currentForm.X32b18_Date_started__c == null && currentForm.X32b19_Date_started__c == null) &&
            currentForm.X32b6_Date_started__c != null)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_175));
        }   
    }
    
    public void ValidationID_175D5 () // Q32 = 6. Medication Free Therapy with opiates (100 to 188) and frequency = 3, 6, 7, 1 at Q25
    {
        if(currentForm.X25a_Drug_5__c == null && currentForm.X25b_Route_of_Admin_Drug5__c == null && currentForm.X23c_Frequency_of_use_in_last_mth__c == null && currentForm.X32b6_Date_started__c == null) return;
        if((currentForm.X25a_Drug_5__c != null && currentForm.X25a_Drug_5__r.Item_Code__c >= 100 && currentForm.X25a_Drug_5__r.Item_Code__c <= 188) && 
            (currentForm.X25b_Route_of_Admin_Drug5__c != null && !currentForm.X25b_Route_of_Admin_Drug5__c.startsWith('2.') && !currentForm.X25b_Route_of_Admin_Drug5__c.startsWith('3.') && !currentForm.X25b_Route_of_Admin_Drug5__c.startsWith('4.')) &&
            (currentForm.X25c_Frequency_of_use_in_last_mth__c != null && currentForm.X25c_Frequency_of_use_in_last_mth__c.startsWith('3.') || currentForm.X25c_Frequency_of_use_in_last_mth__c.startsWith('6.') || currentForm.X25c_Frequency_of_use_in_last_mth__c.startsWith('7.') || currentForm.X25c_Frequency_of_use_in_last_mth__c.startsWith('1.')) && 
            (currentForm.X32b15_Date_started__c == null && currentForm.X32b16_Date_started__c == null && currentForm.X32b18_Date_started__c == null && currentForm.X32b19_Date_started__c == null) &&
            currentForm.X32b6_Date_started__c != null)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_175));
        }   
    }
    
    public void ValidationID_176 () // strengthening family programme but client Age > 18
    {
        if(currentForm.X32b11_Date_started__c == null || currentForm.X32c11_Date_of_last_visit__c == null || currentForm.X32d11_Number_of_sessions__c == null) return;
        if (currentForm.X32b11_Date_started__c != null && currentForm.X32c11_Date_of_last_visit__c != null && currentForm.X32d11_Number_of_sessions__c > 0 && currentForm.Age__c > 18)
        {
            warnings.add (new TreatmentMessage (currentForm.Contact__r.id, label.NDTRS_Rule_176));
        }
    }
    
    public void ValidationID_177D1 () // Q32 = 12 excluding opiates (<121 and >188) and frequency = 3, 6, 7, 8 at Q21- 25d
    {
        if(currentForm.X21a_Main_drug__c == null && currentForm.X21b_Route_of_Admin_Main_drug__c == null && currentForm.X21c_Frequency_of_use_in_last_mth__c == null && currentForm.X32b6_Date_started__c == null) return;
        if((currentForm.X21a_Main_drug__c != null && (currentForm.X21a_Main_drug__r.Item_Code__c < 121 || currentForm.X21a_Main_drug__r.Item_Code__c > 188)) && 
            (currentForm.X21b_Route_of_Admin_Main_drug__c != null && !currentForm.X21b_Route_of_Admin_Main_drug__c.startsWith('2.') && !currentForm.X21b_Route_of_Admin_Main_drug__c.startsWith('3.') && !currentForm.X21b_Route_of_Admin_Main_drug__c.startsWith('4.')) &&
            (currentForm.X21c_Frequency_of_use_in_last_mth__c != null && (currentForm.X21c_Frequency_of_use_in_last_mth__c.startsWith('3.') || currentForm.X21c_Frequency_of_use_in_last_mth__c.startsWith('6.') || currentForm.X21c_Frequency_of_use_in_last_mth__c.startsWith('7.') || currentForm.X21c_Frequency_of_use_in_last_mth__c.startsWith('1.'))) && 
            currentForm.X32b6_Date_started__c != null && currentForm.X32b17_Date_started__c == null && currentForm.X32b18_Date_started__c == null)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_177));
        }   
    }
    
    public void ValidationID_177D2 () // Q32 = 12 excluding opiates (<121 and >188) and frequency = 3, 6, 7, 8 at Q21- 25d
    {
        if(currentForm.X22a_Drug_2__c == null && currentForm.X21b_Route_of_Admin_Main_drug__c == null && currentForm.X22c_Frequency_of_use_in_last_mth__c == null && currentForm.X32b6_Date_started__c == null) return;
        if((currentForm.X22a_Drug_2__c != null && (currentForm.X22a_Drug_2__r.Item_Code__c < 121 || currentForm.X22a_Drug_2__r.Item_Code__c > 188)) && 
            (currentForm.X22b_Route_of_Admin_Drug2__c != null && !currentForm.X22b_Route_of_Admin_Drug2__c.startsWith('2.') && !currentForm.X22b_Route_of_Admin_Drug2__c.startsWith('3.') && !currentForm.X22b_Route_of_Admin_Drug2__c.startsWith('4.')) &&
            (currentForm.X22c_Frequency_of_use_in_last_mth__c != null && (currentForm.X22c_Frequency_of_use_in_last_mth__c.startsWith('3.') || currentForm.X22c_Frequency_of_use_in_last_mth__c.startsWith('6.') || currentForm.X22c_Frequency_of_use_in_last_mth__c.startsWith('7.') || currentForm.X22c_Frequency_of_use_in_last_mth__c.startsWith('1.'))) && 
            currentForm.X32b6_Date_started__c != null && currentForm.X32b17_Date_started__c == null && currentForm.X32b18_Date_started__c == null)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_177));
        }   
    }
    
    public void ValidationID_177D3 () // Q32 = 12 excluding opiates (<121 and >188) and frequency = 3, 6, 7, 8 at Q21- 25d
    {
        if(currentForm.X23a_Drug_3__c == null && currentForm.X23b_Route_of_Admin_Drug3__c == null && currentForm.X21c_Frequency_of_use_in_last_mth__c == null && currentForm.X32b6_Date_started__c == null) return;
        if((currentForm.X23a_Drug_3__c != null && (currentForm.X23a_Drug_3__r.Item_Code__c < 121 || currentForm.X23a_Drug_3__r.Item_Code__c > 188)) && 
            (currentForm.X23b_Route_of_Admin_Drug3__c != null && !currentForm.X23b_Route_of_Admin_Drug3__c.startsWith('2.') && !currentForm.X23b_Route_of_Admin_Drug3__c.startsWith('3.') && !currentForm.X23b_Route_of_Admin_Drug3__c.startsWith('4.')) &&
            (currentForm.X23c_Frequency_of_use_in_last_mth__c != null && (currentForm.X23c_Frequency_of_use_in_last_mth__c.startsWith('3.') || currentForm.X23c_Frequency_of_use_in_last_mth__c.startsWith('6.') || currentForm.X23c_Frequency_of_use_in_last_mth__c.startsWith('7.') || currentForm.X23c_Frequency_of_use_in_last_mth__c.startsWith('1.'))) && 
            currentForm.X32b6_Date_started__c != null && currentForm.X32b17_Date_started__c == null && currentForm.X32b18_Date_started__c == null)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_177));
        }   
    }
    
    public void ValidationID_177D4 () // Q32 = 12 excluding opiates (<121 and >188) and frequency = 3, 6, 7, 8 at Q21- 25d
    {
        if(currentForm.X24a_Drug_4__c == null && currentForm.X24b_Route_of_Admin_Drug4__c == null && currentForm.X24c_Frequency_of_use_in_last_mth__c == null && currentForm.X32b6_Date_started__c == null) return;
        if((currentForm.X24a_Drug_4__c != null && (currentForm.X24a_Drug_4__r.Item_Code__c < 121 || currentForm.X24a_Drug_4__r.Item_Code__c > 188)) && 
            (currentForm.X24b_Route_of_Admin_Drug4__c != null && !currentForm.X24b_Route_of_Admin_Drug4__c.startsWith('2.') && !currentForm.X24b_Route_of_Admin_Drug4__c.startsWith('3.') && !currentForm.X24b_Route_of_Admin_Drug4__c.startsWith('4.')) &&
            (currentForm.X24c_Frequency_of_use_in_last_mth__c != null && (currentForm.X24c_Frequency_of_use_in_last_mth__c.startsWith('3.') || currentForm.X24c_Frequency_of_use_in_last_mth__c.startsWith('6.') || currentForm.X24c_Frequency_of_use_in_last_mth__c.startsWith('7.') || currentForm.X24c_Frequency_of_use_in_last_mth__c.startsWith('1.'))) && 
            currentForm.X32b6_Date_started__c != null && currentForm.X32b17_Date_started__c == null && currentForm.X32b18_Date_started__c == null)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_177));
        }   
    }
    
    public void ValidationID_177D5 () // Q32 = 12 excluding opiates (<121 and >188) and frequency = 3, 6, 7, 8 at Q21- 25d
    {
        if(currentForm.X25a_Drug_5__c == null && currentForm.X25b_Route_of_Admin_Drug5__c == null && currentForm.X25c_Frequency_of_use_in_last_mth__c == null && currentForm.X32b6_Date_started__c == null) return;
        if((currentForm.X25a_Drug_5__c != null && (currentForm.X25a_Drug_5__r.Item_Code__c < 121 || currentForm.X25a_Drug_5__r.Item_Code__c > 188)) && 
            (currentForm.X25b_Route_of_Admin_Drug5__c != null && !currentForm.X25b_Route_of_Admin_Drug5__c.startsWith('2.') && !currentForm.X25b_Route_of_Admin_Drug5__c.startsWith('3.') && !currentForm.X25b_Route_of_Admin_Drug5__c.startsWith('4.')) &&
            (currentForm.X25c_Frequency_of_use_in_last_mth__c != null && (currentForm.X25c_Frequency_of_use_in_last_mth__c.startsWith('3.') || currentForm.X25c_Frequency_of_use_in_last_mth__c.startsWith('6.') || currentForm.X25c_Frequency_of_use_in_last_mth__c.startsWith('7.') || currentForm.X25c_Frequency_of_use_in_last_mth__c.startsWith('1.'))) && 
            currentForm.X32b6_Date_started__c != null && currentForm.X32b17_Date_started__c == null && currentForm.X32b18_Date_started__c == null)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_177));
        }   
    }
    
    public void ValidationID_178 () // Q32 = 24 and/or 25 and/or 26 only
    {
        if( currentForm.X32b1_Date_started__c == null && currentForm.X32b2_Date_started__c == null && currentForm.X32b3_Date_started__c == null && currentForm.X32b4_Date_started__c == null &&
            currentForm.X32b5_Date_started__c == null && currentForm.X32b6_Date_started__c == null && currentForm.X32b7_Date_started__c == null && currentForm.X32b8_Date_started__c == null &&
            currentForm.X32b9_Date_started__c == null && currentForm.X32b10_Date_started__c == null && currentForm.X32b11_Date_started__c == null && currentForm.X32b12_Date_started__c == null && 
            currentForm.X32b13_Date_started__c == null && currentForm.X32b14_Date_started__c == null && currentForm.X32b15_Date_started__c == null && currentForm.X32b16_Date_started__c == null && 
            currentForm.X32b17_Date_started__c == null && currentForm.X32b18_Date_started__c == null && currentForm.X32b19_Date_started__c == null && currentForm.X32b20_Date_started__c == null &&
            currentForm.X32b21_Date_started__c == null && currentForm.X32b22_Date_started__c == null && currentForm.X32b23_Date_started__c == null && currentForm.X32b24_Date_started__c == null && 
            currentForm.X32b25_Date_started__c == null && currentForm.X32b26_Date_started__c == null && currentForm.X32b27_Date_started__c == null && currentForm.X32b28_Date_started__c == null &&
            currentForm.X35_Date_of_Final_Discharge_or_transfer__c == null) return;
        if( currentForm.X32b1_Date_started__c == null && currentForm.X32b2_Date_started__c == null && currentForm.X32b3_Date_started__c == null && currentForm.X32b4_Date_started__c == null &&
            currentForm.X32b5_Date_started__c == null && currentForm.X32b6_Date_started__c == null && currentForm.X32b7_Date_started__c == null && currentForm.X32b8_Date_started__c == null &&
            currentForm.X32b9_Date_started__c == null && currentForm.X32b10_Date_started__c == null && currentForm.X32b11_Date_started__c == null && currentForm.X32b12_Date_started__c == null && 
            currentForm.X32b13_Date_started__c == null && currentForm.X32b14_Date_started__c == null && currentForm.X32b15_Date_started__c == null && currentForm.X32b16_Date_started__c == null && 
            currentForm.X32b17_Date_started__c == null && currentForm.X32b18_Date_started__c == null && currentForm.X32b19_Date_started__c == null && currentForm.X32b20_Date_started__c == null &&
            currentForm.X32b21_Date_started__c == null && currentForm.X32b22_Date_started__c == null && currentForm.X32b23_Date_started__c == null && 
            (currentForm.X32b24_Date_started__c != null || currentForm.X32b25_Date_started__c != null || currentForm.X32b26_Date_started__c != null) && 
            currentForm.X32b27_Date_started__c == null && currentForm.X32b28_Date_started__c == null && currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_178));
        }
    }
    
    public void ValidationID_179 () // Exit Details Specify Other - InterOutcomeSpecify can only be entered if option 10 is selected at Q33a
    {
        if(currentForm.X33a_Exit_details__c == null && currentForm.X33a10_Exit_detail_Other__c == null) return;
        if((currentForm.X33a_Exit_details__c != null && !currentForm.X33a_Exit_details__c.startsWith('10.')) && currentForm.X33a10_Exit_detail_Other__c != null)
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_179));
        }   
    }
    
    public void ValidationID_180 () // Exit Condition Drug Free
    {
        if(currentForm.X21a_Main_drug__c == null && currentForm.X22a_Drug_2__c == null && currentForm.X23a_Drug_3__c == null && currentForm.X24a_Drug_4__c == null && currentForm.X25a_Drug_5__c == null && 
            currentForm.X34_Client_s_Condition_on_discharge__c == null) return;
        if((currentForm.X21a_Main_drug__c != null && currentForm.X21a_Main_drug__r.Item_Code__c == 700 || currentForm.X22a_Drug_2__c != null && currentForm.X22a_Drug_2__r.Item_Code__c == 700 ||
            currentForm.X23a_Drug_3__c != null && currentForm.X23a_Drug_3__r.Item_Code__c == 700 || currentForm.X24a_Drug_4__c != null && currentForm.X24a_Drug_4__r.Item_Code__c == 700 ||
            currentForm.X25a_Drug_5__c != null && currentForm.X24a_Drug_4__r.Item_Code__c == 700) &&
            (currentForm.X34_Client_s_Condition_on_discharge__c != null && (currentForm.X34_Client_s_Condition_on_discharge__c.contains('1. Drug free') || currentForm.X34_Client_s_Condition_on_discharge__c.contains('2. Drug use unchanged') ||
            currentForm.X34_Client_s_Condition_on_discharge__c.contains('3. Drug use increased') || currentForm.X34_Client_s_Condition_on_discharge__c.contains('4. Drug use reduced'))))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_180));
        }   
    }
    
    public void ValidationID_181 () // Exit Condition Alcohol Free
    {
        if(currentForm.X21a_Main_drug__c == null && currentForm.X22a_Drug_2__c == null && currentForm.X23a_Drug_3__c == null && currentForm.X24a_Drug_4__c == null && currentForm.X25a_Drug_5__c == null && 
            currentForm.X34_Client_s_Condition_on_discharge__c == null) return;
        if((currentForm.X21a_Main_drug__c != null && currentForm.X21a_Main_drug__r.Item_Code__c != 700 || currentForm.X22a_Drug_2__c != null && currentForm.X22a_Drug_2__r.Item_Code__c != 700 ||
            currentForm.X23a_Drug_3__c != null && currentForm.X23a_Drug_3__r.Item_Code__c != 700 || currentForm.X24a_Drug_4__c != null && currentForm.X24a_Drug_4__r.Item_Code__c != 700 ||
            currentForm.X25a_Drug_5__c != null && currentForm.X24a_Drug_4__r.Item_Code__c != 700) &&
            (currentForm.X34_Client_s_Condition_on_discharge__c != null && (currentForm.X34_Client_s_Condition_on_discharge__c.contains('5. Abstaining from alcohol') || currentForm.X34_Client_s_Condition_on_discharge__c.contains('6. Alcohol consumption unchanged') ||
            currentForm.X34_Client_s_Condition_on_discharge__c.contains('7. Alcohol consumption increased') || currentForm.X34_Client_s_Condition_on_discharge__c.contains('8. Alcohol consumption reduced'))))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_181));
        }   
    }
    
    public void ValidationID_182 () // Exit Condition Unknown
    {
        if(currentForm.X34_Client_s_Condition_on_discharge__c == null) return;
        if(currentForm.X34_Client_s_Condition_on_discharge__c != null && (currentForm.X34_Client_s_Condition_on_discharge__c.contains('99. Not known') && 
            (currentForm.X34_Client_s_Condition_on_discharge__c.contains('1. Drug free') || currentForm.X34_Client_s_Condition_on_discharge__c.contains('2. Drug use unchanged') || currentForm.X34_Client_s_Condition_on_discharge__c.contains('3. Drug use increased') ||
            currentForm.X34_Client_s_Condition_on_discharge__c.contains('4. Drug use reduced') || currentForm.X34_Client_s_Condition_on_discharge__c.contains('5. Abstaining from alcohol') || currentForm.X34_Client_s_Condition_on_discharge__c.contains('6. Alcohol consumption unchanged') ||
            currentForm.X34_Client_s_Condition_on_discharge__c.contains('6. Alcohol consumption unchanged') || currentForm.X34_Client_s_Condition_on_discharge__c.contains('7. Alcohol consumption increased') || currentForm.X34_Client_s_Condition_on_discharge__c.contains('8. Alcohol consumption reduced') ||
            currentForm.X34_Client_s_Condition_on_discharge__c.contains('10. Substantially reached priority goals') || currentForm.X34_Client_s_Condition_on_discharge__c.contains('11. Engaging with care plan') || currentForm.X34_Client_s_Condition_on_discharge__c.contains('12. Disengaged from care plan') || 
            currentForm.X34_Client_s_Condition_on_discharge__c.contains('13. Care plan gaps and blocks identified') || currentForm.X34_Client_s_Condition_on_discharge__c.contains('14. Engaging with other services (e.g. housing, education)') ||currentForm.X34_Client_s_Condition_on_discharge__c.contains('15. Engaging with other therapeutic services (e.g. self help groups, AA)') || 
            currentForm.X34_Client_s_Condition_on_discharge__c.contains('16. Engaging in other unstructured aftercare') || currentForm.X34_Client_s_Condition_on_discharge__c.contains('17. Other (specify)'))))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_182));
        }   
    }
    
    public void ValidationID_188 () // Exit details Prison
    {
        if(currentForm.Centre__c == null && currentForm.X33a_Exit_details__c == null) return;
        if(currentForm.Centre__c != null && !currentForm.Centre__c.endsWith('41') && currentForm.X33a_Exit_details__c != null && 
        (currentForm.X33a_Exit_details__c.startsWith('7.') || currentForm.X33a_Exit_details__c.startsWith('9.') ||currentForm.X33a_Exit_details__c.startsWith('14.')))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_188));
        }
    }

    
    public void ValidationID_189 () // Exit Condition related to Care Plan, must have care plan (Inter 26) ticked
    {
        if(currentForm.X32b26_Date_started__c == null && currentForm.X34_Client_s_Condition_on_discharge__c == null) return;
        if(currentForm.X32b26_Date_started__c == null && currentForm.X34_Client_s_Condition_on_discharge__c != null && 
            (currentForm.X34_Client_s_Condition_on_discharge__c.contains('10. Substantially reached priority goals') || 
            currentForm.X34_Client_s_Condition_on_discharge__c.contains('11. Engaging with care plan') || 
            currentForm.X34_Client_s_Condition_on_discharge__c.contains('12. Disengaged from care plan') || 
            currentForm.X34_Client_s_Condition_on_discharge__c.contains('13. Care plan gaps and blocks identified')))
        {
            warnings.add (new TreatmentMessage (currentForm.id, label.NDTRS_Rule_189));
        }   
    }
    
}