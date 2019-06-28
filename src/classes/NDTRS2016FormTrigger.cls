/*
    Author: Eamon Kelly, Enclude
    Purpose:
        1) Implement validation rules to catch errors when pause button is off (Warnings will be caught separately) 
        2) Need to act as a rollup on the treatment to the contact to count number of NDTRS 2016 Forms -- IS THIS REQUIRED?
    Called from: TriggerDispatcher
    Tested in: TestNDTRSErrors   
 */
public with sharing class NDTRS2016FormTrigger implements TriggerDispatcher.ITriggerEntry
{
    public void MainEntry (String TriggerObject, Boolean isBefore, Boolean isDelete, Boolean isAfter, Boolean isInsert, Boolean isUpdate, Boolean isExecuting,
        List<SObject> newList, Map<Id, SObject> newMap, List<SObject> oldList, Map<Id, SObject> oldMap)
    {
        if (isInsert)
        {
            if (isBefore)
            {
                VerifyErrorRules (newList);
                CalculateMaxInterventionCommencementDate (newList);
            }
            else if (isAfter) 
            {
                ChangeName ((map<Id, NDTRS_Form_2016__c>)newMap);
                CountNumberOfFormsStartedThisYear (newList);
            }
        }
        else if (isUpdate)
        {
            if (isBefore) 
            {
                VerifyErrorRules (newList);
                CalculateMaxInterventionCommencementDate (newList);
            }
            else if (isAfter)
            {
                CountNumberOfFormsStartedThisYear (newList);
            }
        }
        else if (isDelete)
        {
            if (isAfter)
            {
                CountNumberOfFormsStartedThisYear (oldList);
            }
        }
    }

    public void ChangeName (map<Id, NDTRS_Form_2016__c> frmMap)
    {
        String nameTemplate = AppConfigSupport.HRBFormNameTemplate;
        list<NDTRS_Form_2016__c>fromsToUpdate = new list<NDTRS_Form_2016__c>();
        for (NDTRS_Form_2016__c oneForm: [select ID, Name, Contact__c, Contact__r.Name, Contact__r.Initials__c, X15_Date_of_initial_assessment__c from NDTRS_Form_2016__c where ID in :frmMap.keySet()])
        {
            Date formDate = oneForm.X15_Date_of_initial_assessment__c != null ? oneForm.X15_Date_of_initial_assessment__c : system.today();
            String clientName = oneForm.Contact__c != null ? oneForm.Contact__r.Name : '';
            String clientInitials = oneForm.Contact__c != null ? oneForm.Contact__r.Initials__c : '';
            String newName = nameTemplate.replace('$NAME$', clientName).replace('$DATE$', formDate.format()).replace('$INITIALS$', clientInitials);
            if (newName.length() > AppConfigSupport.MAX_NAME_SIZE) newName = newName.subString (0, AppConfigSupport.MAX_NAME_SIZE);
            if (newName != oneForm.Name) 
            {
                oneForm.Name = newName;
                fromsToUpdate.add (oneForm);
            }
        }
        if (fromsToUpdate.size() > 0) update fromsToUpdate;
    }
    
    // this does not change forms where the client was not suitable for treatment
    public void CountNumberOfFormsStartedThisYear (List<NDTRS_Form_2016__c> frmList)
    {
        set<ID> clientSet = new set<ID>();
        for (NDTRS_Form_2016__c oneForm: frmList)
        {
            clientSet.add (oneForm.Contact__c);
        }
        Integer this_year = system.today().year();
        list<NDTRS_Form_2016__c> formsToUpdate = new list<NDTRS_Form_2016__c>();
        for (Contact oneClient : [SELECT ID, (SELECT Id FROM NDTRS_Forms__r where CALENDAR_YEAR(Date_latest_intervention_commenced__c) = :this_year and X16_Assessment_outcome__c like '1%') FROM Contact where ID in :clientSet])
        {
            Integer numberOfFormsThisYear = oneClient.NDTRS_Forms__r.size();
            for (NDTRS_Form_2016__c oneForm: oneClient.NDTRS_Forms__r)
            {
                formsToUpdate.add (new NDTRS_Form_2016__c (id=oneForm.id, X18_Number_times_started_this_year__c = numberOfFormsThisYear));
            }
        }
        if (formsToUpdate.size()>0) update formsToUpdate;
    }

    public void CalculateMaxInterventionCommencementDate (List<NDTRS_Form_2016__c> newList)
    {
        for (NDTRS_Form_2016__c oneForm: newList)
        {
            oneForm.Date_latest_intervention_commenced__c = Date.valueOf('2011-1-1');
            if (oneForm.X32b10_Date_started__c > oneForm.Date_latest_intervention_commenced__c) oneForm.Date_latest_intervention_commenced__c = oneForm.X32b10_Date_started__c;
            if (oneForm.X32b11_Date_started__c > oneForm.Date_latest_intervention_commenced__c) oneForm.Date_latest_intervention_commenced__c = oneForm.X32b11_Date_started__c;
            if (oneForm.X32b12_Date_started__c > oneForm.Date_latest_intervention_commenced__c) oneForm.Date_latest_intervention_commenced__c = oneForm.X32b12_Date_started__c;
            if (oneForm.X32b13_Date_started__c > oneForm.Date_latest_intervention_commenced__c) oneForm.Date_latest_intervention_commenced__c = oneForm.X32b13_Date_started__c;
            if (oneForm.X32b13_Date_started__c > oneForm.Date_latest_intervention_commenced__c) oneForm.Date_latest_intervention_commenced__c = oneForm.X32b13_Date_started__c;
            if (oneForm.X32b15_Date_started__c > oneForm.Date_latest_intervention_commenced__c) oneForm.Date_latest_intervention_commenced__c = oneForm.X32b15_Date_started__c;
            if (oneForm.X32b16_Date_started__c > oneForm.Date_latest_intervention_commenced__c) oneForm.Date_latest_intervention_commenced__c = oneForm.X32b16_Date_started__c;
            if (oneForm.X32b17_Date_started__c > oneForm.Date_latest_intervention_commenced__c) oneForm.Date_latest_intervention_commenced__c = oneForm.X32b17_Date_started__c;
            if (oneForm.X32b18_Date_started__c > oneForm.Date_latest_intervention_commenced__c) oneForm.Date_latest_intervention_commenced__c = oneForm.X32b18_Date_started__c;
            if (oneForm.X32b19_Date_started__c > oneForm.Date_latest_intervention_commenced__c) oneForm.Date_latest_intervention_commenced__c = oneForm.X32b19_Date_started__c;
            if (oneForm.X32b1_Date_started__c > oneForm.Date_latest_intervention_commenced__c) oneForm.Date_latest_intervention_commenced__c = oneForm.X32b1_Date_started__c;
            if (oneForm.X32b20_Date_started__c > oneForm.Date_latest_intervention_commenced__c) oneForm.Date_latest_intervention_commenced__c = oneForm.X32b20_Date_started__c;
            if (oneForm.X32b21_Date_started__c > oneForm.Date_latest_intervention_commenced__c) oneForm.Date_latest_intervention_commenced__c = oneForm.X32b21_Date_started__c;
            if (oneForm.X32b22_Date_started__c > oneForm.Date_latest_intervention_commenced__c) oneForm.Date_latest_intervention_commenced__c = oneForm.X32b22_Date_started__c;
            if (oneForm.X32b23_Date_started__c > oneForm.Date_latest_intervention_commenced__c) oneForm.Date_latest_intervention_commenced__c = oneForm.X32b23_Date_started__c;
            if (oneForm.X32b24_Date_started__c > oneForm.Date_latest_intervention_commenced__c) oneForm.Date_latest_intervention_commenced__c = oneForm.X32b24_Date_started__c;
            if (oneForm.X32b25_Date_started__c > oneForm.Date_latest_intervention_commenced__c) oneForm.Date_latest_intervention_commenced__c = oneForm.X32b25_Date_started__c;
            if (oneForm.X32b27_Date_started__c > oneForm.Date_latest_intervention_commenced__c) oneForm.Date_latest_intervention_commenced__c = oneForm.X32b27_Date_started__c;
            if (oneForm.X32b28_Date_started__c > oneForm.Date_latest_intervention_commenced__c) oneForm.Date_latest_intervention_commenced__c = oneForm.X32b28_Date_started__c;
            if (oneForm.X32b2_Date_started__c > oneForm.Date_latest_intervention_commenced__c) oneForm.Date_latest_intervention_commenced__c = oneForm.X32b2_Date_started__c;
            if (oneForm.X32b3_Date_started__c > oneForm.Date_latest_intervention_commenced__c) oneForm.Date_latest_intervention_commenced__c = oneForm.X32b3_Date_started__c;
            if (oneForm.X32b4_Date_started__c > oneForm.Date_latest_intervention_commenced__c) oneForm.Date_latest_intervention_commenced__c = oneForm.X32b4_Date_started__c;
            if (oneForm.X32b5_Date_started__c > oneForm.Date_latest_intervention_commenced__c) oneForm.Date_latest_intervention_commenced__c = oneForm.X32b5_Date_started__c;
            if (oneForm.X32b6_Date_started__c > oneForm.Date_latest_intervention_commenced__c) oneForm.Date_latest_intervention_commenced__c = oneForm.X32b6_Date_started__c;
            if (oneForm.X32b7_Date_started__c > oneForm.Date_latest_intervention_commenced__c) oneForm.Date_latest_intervention_commenced__c = oneForm.X32b7_Date_started__c;
            if (oneForm.X32b8_Date_started__c > oneForm.Date_latest_intervention_commenced__c) oneForm.Date_latest_intervention_commenced__c = oneForm.X32b8_Date_started__c;
            if (oneForm.X32b9_Date_started__c > oneForm.Date_latest_intervention_commenced__c) oneForm.Date_latest_intervention_commenced__c = oneForm.X32b9_Date_started__c;
        }
    }
    
    public void VerifyErrorRules (List<NDTRS_Form_2016__c> updatedForms)
    {
        if (AppConfigSupport.ValidationRulesOn == false) return;
        
        for (NDTRS_Form_2016__c oneForm: updatedForms)
        {
            if (oneForm.Pause__c == false)
            {
                String queryString = 'select ';
                queryString += NDTRSHelperFunctions.GetAllFieldsFromClientDirect ();
                queryString += ' from Contact where Id = \''+ oneForm.Contact__c + '\' limit 1';
                Contact client = Database.query(queryString);
                
                NDTRS_Drugs__c X13_2_Drug_specify;
                try
                {
                    X13_2_Drug_specify = [select ID, Item_Code__c, Name from NDTRS_Drugs__c where id = :oneForm.X13_2_Drug_specify__c limit 1];
                }
                catch (Exception e){/* don't care - this drug isn't needed for this test */}
                NDTRS_Drugs__c X21a_Main_drug;
                try
                {
                    X21a_Main_drug = [select ID, Item_Code__c, Item_Name__c, Name from NDTRS_Drugs__c where id = :oneForm.X21a_Main_drug__c limit 1];
                }
                catch (Exception e){/* don't care - this drug isn't needed for this test */}
                
                NDTRS_Drugs__c X22a_Drug_2;
                try
                {
                    X22a_Drug_2 = [select ID, Item_Code__c, Item_Name__c, Name from NDTRS_Drugs__c where id = :oneForm.X22a_Drug_2__c limit 1];
                }
                catch (Exception e){/* don't care - this drug isn't needed for this test */}
                
                NDTRS_Drugs__c X23a_Drug_3;
                try
                {
                    X23a_Drug_3= [select ID, Item_Code__c, Item_Name__c,  Name from NDTRS_Drugs__c where id = :oneForm.X23a_Drug_3__c limit 1];
                }
                catch (Exception e){/* don't care - this drug isn't needed for this test */}
                
                NDTRS_Drugs__c X24a_Drug_4;
                try
                {
                    X24a_Drug_4= [select ID, Item_Code__c, Item_Name__c,  Name from NDTRS_Drugs__c where id = :oneForm.X24a_Drug_4__c limit 1];
                }
                catch (Exception e){/* don't care - this drug isn't needed for this test */}
                
                NDTRS_Drugs__c X25a_Drug_5;
                try
                {
                     X25a_Drug_5 = [select ID, Item_Code__c, Item_Name__c,  Name from NDTRS_Drugs__c where id = :oneForm.X25a_Drug_5__c limit 1];
                }
                catch (Exception e){/* don't care - this drug isn't needed for this test */}
                
                NDTRS_Drugs__c X27_Specify_first_drug_ever_used;
                try
                {
                     X27_Specify_first_drug_ever_used = [select ID, Item_Code__c, Item_Name__c,  Name from NDTRS_Drugs__c where id = :oneForm.X27_Specify_first_drug_ever_used__c limit 1];
                }
                catch (Exception e){/* don't care - this drug isn't needed for this test */}
                
                NDTRS_Drugs__c X32a22_Detox_from_other_drug_Specify;
                try
                {
                    X32a22_Detox_from_other_drug_Specify = [select ID, Item_Code__c, Item_Name__c,  Name from NDTRS_Drugs__c where id = :oneForm.X32a22_Detox_from_other_drug_Specify__c limit 1];
                }
                catch (Exception e){/* don't care - this drug isn't needed for this test */}
            
                ValidationID_7_and_8Q12_and_Q15(oneForm);
                ValidationID_7_and_8Q15_and_Q35(oneForm);
                ValidationID_7_and_8Q15_and_Q32(oneForm);
                ValidationID_14_and_15 (oneForm, client);
                ValidationID_21 (oneForm, client);
                ValidationID_22 (oneForm, client);
                ValidationID_24 (oneForm, client);
                ValidationID_28 (oneForm, client);
                ValidationID_29 (oneForm, client);
                ValidationID_37 (oneForm, client);
                ValidationID_43 (oneForm, client);
                ValidationID_44 (oneForm);
                ValidationID_71 (oneForm);
                ValidationID_81 (oneForm);
                ValidationID_82 (oneForm, client);
                ValidationID_86 (oneForm, X13_2_Drug_specify, X21a_Main_drug);
                ValidationID_97_Q21_and_Q27 (oneForm, X21a_Main_drug, X27_Specify_first_drug_ever_used);
                ValidationID_97_Q22_and_Q27 (oneForm, X22a_Drug_2, X27_Specify_first_drug_ever_used);
                ValidationID_97_Q23_and_Q27 (oneForm, X23a_Drug_3, X27_Specify_first_drug_ever_used);
                ValidationID_97_Q24_and_Q27 (oneForm, X24a_Drug_4, X27_Specify_first_drug_ever_used);
                ValidationID_97_Q25_and_Q27 (oneForm, X25a_Drug_5, X27_Specify_first_drug_ever_used);
/*              ValidationID_99 (oneForm, X27_Specify_first_drug_ever_used); */
                ValidationID_100 (oneForm, X21a_Main_drug, X22a_Drug_2, X23a_Drug_3, X24a_Drug_4, X25a_Drug_5);
                ValidationID_109_Q21d (oneForm, X21a_Main_drug);
                ValidationID_109_Q22d (oneForm, X22a_Drug_2);
                ValidationID_109_Q23d (oneForm, X23a_Drug_3);
                ValidationID_109_Q24d (oneForm, X24a_Drug_4);
                ValidationID_109_Q25d (oneForm, X25a_Drug_5);
                ValidationID_123 (oneForm);
                ValidationID_127_Q21b (oneForm);
                ValidationID_127_Q22b (oneForm);
                ValidationID_127_Q23b (oneForm);
                ValidationID_127_Q24b (oneForm);
                ValidationID_127_Q25b (oneForm);
                ValidationID_130 (oneForm);
                ValidationID_131 (oneForm);
                ValidationID_134 (oneForm);
/*              ValidationID_134a (oneForm);*/
                ValidationID_135 (oneForm);
                ValidationID_142 (oneForm);
                ValidationID_166 (oneForm);
                InterventionDateCheck (oneForm);
                InterventionDetailsCheck_Q32c (oneForm);
                InterventionDetailsCheck_Q32d (oneForm, X27_Specify_first_drug_ever_used);
                ValidationID_171a (oneForm);
                ValidationID_171b (oneForm);
                ValidationID_172 (oneForm);
                ValidationID_174 (oneForm);
            }
        }
    }
    
    public void ValidationID_7_and_8Q12_and_Q15 (NDTRS_Form_2016__c currentForm)
    {
        /* Check dates order – reject if not sequential
            Dates have to be in subsequent order: a client is first referred, then assessed, then treated, 
            then receiving substitution (if applicable) and finally exiting treatment. 
            All dates can be the same but they cannot go backwards in time.
        */
        /* Dates should be in sequential order. 
            • Date of Assessment (assess) cannot be before date of referral (Referral)
            • Treatment start date (DOC) cannot be before ‘Referral’ and ‘Assess’ dates.
            • Substitution start date (Substart) can only be the same as or after  ‘Referral’ , ‘Assess’ and ‘Doc (treatment start date)’  dates
            • Date client finish treatment (Exitdate) can only be the same as or after ‘Referral’ , ‘Assess’, ‘Doc (treatment start date)’ and ‘Substart’  dates
            For each of the following records please check and correct as applicable the referral, assessment, treatment start date, substitution start date and/or Exit dates.
        */
        
        if (currentForm.X15_Date_of_initial_assessment__c < currentForm.X12_Date_of_Referral__c)
        {
            currentForm.X15_Date_of_initial_assessment__c.addError (label.NDTRS_Assessment_Date_Before_Referral);
        }
    }
    
    public void ValidationID_7_and_8Q15_and_Q35 (NDTRS_Form_2016__c currentForm)
    {
        if (currentForm.X35_Date_of_Final_Discharge_or_transfer__c < currentForm.X15_Date_of_initial_assessment__c )
        {
            currentForm.X35_Date_of_Final_Discharge_or_transfer__c.addError (label.NDTRS_Exit_Date_Too_Early);
        }
    
    }
    
    public void ValidationID_7_and_8Q15_and_Q32 (NDTRS_Form_2016__c currentForm)
    {
        if (currentForm.X32b1_Date_started__c < currentForm.X15_Date_of_initial_assessment__c) 
        {
            currentForm.X32b1_Date_started__c.addError (label.NDTRS_DOC_Before_Assessment_Date);
        }
        if (currentForm.X32b2_Date_started__c < currentForm.X15_Date_of_initial_assessment__c) 
        {
            currentForm.X32b2_Date_started__c.addError (label.NDTRS_DOC_Before_Assessment_Date);
        }
        if (currentForm.X32b3_Date_started__c < currentForm.X15_Date_of_initial_assessment__c) 
        {
            currentForm.X32b3_Date_started__c.addError (label.NDTRS_DOC_Before_Assessment_Date);
        }
        if (currentForm.X32b4_Date_started__c < currentForm.X15_Date_of_initial_assessment__c) 
        {
            currentForm.X32b4_Date_started__c.addError (label.NDTRS_DOC_Before_Assessment_Date);
        }
        if (currentForm.X32b5_Date_started__c < currentForm.X15_Date_of_initial_assessment__c) 
        {
            currentForm.X32b5_Date_started__c.addError (label.NDTRS_DOC_Before_Assessment_Date);
        }
        if (currentForm.X32b6_Date_started__c < currentForm.X15_Date_of_initial_assessment__c) 
        {
            currentForm.X32b6_Date_started__c.addError (label.NDTRS_DOC_Before_Assessment_Date);
        }
        if (currentForm.X32b7_Date_started__c < currentForm.X15_Date_of_initial_assessment__c) 
        {
            currentForm.X32b7_Date_started__c.addError (label.NDTRS_DOC_Before_Assessment_Date);
        }
        if (currentForm.X32b8_Date_started__c < currentForm.X15_Date_of_initial_assessment__c) 
        {
            currentForm.X32b8_Date_started__c.addError (label.NDTRS_DOC_Before_Assessment_Date);
        }
        if (currentForm.X32b9_Date_started__c < currentForm.X15_Date_of_initial_assessment__c) 
        {
            currentForm.X32b9_Date_started__c.addError (label.NDTRS_DOC_Before_Assessment_Date);
        }
        if (currentForm.X32b10_Date_started__c < currentForm.X15_Date_of_initial_assessment__c) 
        {
            currentForm.X32b10_Date_started__c.addError (label.NDTRS_DOC_Before_Assessment_Date);
        }
        if (currentForm.X32b11_Date_started__c < currentForm.X15_Date_of_initial_assessment__c) 
        {
            currentForm.X32b11_Date_started__c.addError (label.NDTRS_DOC_Before_Assessment_Date);
        }
        if (currentForm.X32b12_Date_started__c < currentForm.X15_Date_of_initial_assessment__c) 
        {
            currentForm.X32b12_Date_started__c.addError (label.NDTRS_DOC_Before_Assessment_Date);
        }
        if (currentForm.X32b13_Date_started__c < currentForm.X15_Date_of_initial_assessment__c) 
        {
            currentForm.X32b13_Date_started__c.addError (label.NDTRS_DOC_Before_Assessment_Date);
        }
        if (currentForm.X32b13_Date_started__c < currentForm.X15_Date_of_initial_assessment__c) 
        {
            currentForm.X32b13_Date_started__c.addError (label.NDTRS_DOC_Before_Assessment_Date);
        }
        if (currentForm.X32b15_Date_started__c < currentForm.X15_Date_of_initial_assessment__c) 
        {
            currentForm.X32b15_Date_started__c.addError (label.NDTRS_DOC_Before_Assessment_Date);
        }
        if (currentForm.X32b16_Date_started__c < currentForm.X15_Date_of_initial_assessment__c) 
        {
            currentForm.X32b16_Date_started__c.addError (label.NDTRS_DOC_Before_Assessment_Date);
        }
        if (currentForm.X32b17_Date_started__c < currentForm.X15_Date_of_initial_assessment__c) 
        {
            currentForm.X32b17_Date_started__c.addError (label.NDTRS_DOC_Before_Assessment_Date);
        }
        if (currentForm.X32b18_Date_started__c < currentForm.X15_Date_of_initial_assessment__c) 
        {
            currentForm.X32b18_Date_started__c.addError (label.NDTRS_DOC_Before_Assessment_Date);
        }
        if (currentForm.X32b19_Date_started__c < currentForm.X15_Date_of_initial_assessment__c) 
        {
            currentForm.X32b19_Date_started__c.addError (label.NDTRS_DOC_Before_Assessment_Date);
        }
        if (currentForm.X32b20_Date_started__c < currentForm.X15_Date_of_initial_assessment__c) 
        {
            currentForm.X32b20_Date_started__c.addError (label.NDTRS_DOC_Before_Assessment_Date);
        }
        if (currentForm.X32b21_Date_started__c < currentForm.X15_Date_of_initial_assessment__c) 
        {
            currentForm.X32b21_Date_started__c.addError (label.NDTRS_DOC_Before_Assessment_Date);
        }
        if (currentForm.X32b22_Date_started__c < currentForm.X15_Date_of_initial_assessment__c) 
        {
            currentForm.X32b22_Date_started__c.addError (label.NDTRS_DOC_Before_Assessment_Date);
        }
        if (currentForm.X32b23_Date_started__c < currentForm.X15_Date_of_initial_assessment__c) 
        {
            currentForm.X32b23_Date_started__c.addError (label.NDTRS_DOC_Before_Assessment_Date);
        }
        if (currentForm.X32b24_Date_started__c < currentForm.X15_Date_of_initial_assessment__c) 
        {
            currentForm.X32b24_Date_started__c.addError (label.NDTRS_DOC_Before_Assessment_Date);
        }
        if (currentForm.X32b25_Date_started__c < currentForm.X15_Date_of_initial_assessment__c) 
        {
            currentForm.X32b25_Date_started__c.addError (label.NDTRS_DOC_Before_Assessment_Date);
        }
        if (currentForm.X32b26_Date_started__c < currentForm.X15_Date_of_initial_assessment__c) 
        {
            currentForm.X32b26_Date_started__c.addError (label.NDTRS_DOC_Before_Assessment_Date);
        }
        if (currentForm.X32b27_Date_started__c < currentForm.X15_Date_of_initial_assessment__c) 
        {
            currentForm.X32b27_Date_started__c.addError (label.NDTRS_DOC_Before_Assessment_Date);
        }
        if (currentForm.X32b28_Date_started__c < currentForm.X15_Date_of_initial_assessment__c) 
        {
            currentForm.X32b28_Date_started__c.addError (label.NDTRS_DOC_Before_Assessment_Date);
        }
    }

    public void ValidationID_14_and_15 (NDTRS_Form_2016__c currentForm, Contact currentClient)
    {
        /* In specification, "Can't choose Male and Female, only allowed to choose Male and Transgender, Female and Transgender as a multiselect."
            However we are implementing this as a picklist, which must be selected
        */
        if (currentClient.X4_Gender__c == null)
        {
            currentForm.addError (label.NDTRS_Rule_14_and_15);
        }
    }
    
    public void ValidationID_21 (NDTRS_Form_2016__c currentForm, Contact currentClient)
    {
        if (currentClient.X5_Living_with_whom__c != null && currentClient.X7_Living_Where__c != null && 
            !currentClient.X5_Living_with_whom__c.startsWith('7.') && currentClient.X7_Living_Where__c.startsWith('5.') )
        {
            currentForm.addError (label.NDTRS_Homesless_prison_and_Living_with_Whom);
        }
    }
    
    public void ValidationID_22 (NDTRS_Form_2016__c currentForm, Contact currentClient)
    {
        if (currentClient.X5_Living_with_whom__c != null && (currentClient.X5_Living_with_whom__c.startsWith('5.') || currentClient.X5_Living_with_whom__c.startsWith('6.')) && 
        (currentClient.X6a1_Children_under_5yrs_living_whith__c == 0 && currentClient.X6a2_Children_5_17yrs_living_whith_clien__c == 0 && currentClient.X6a3_Children_18yrs_or_over_living_whith__c == 0 &&
        currentClient.Living_with_service_user_unknown__c == 0))
        {
            currentForm.addError (label.NDTRS_Living_with_Children);
        }
    }
    
    public void ValidationID_24 (NDTRS_Form_2016__c currentForm, Contact currentClient)
    {
        if (currentClient.X5_Living_with_whom__c != null && (!(currentClient.X5_Living_with_whom__c.startsWith('5.') || currentClient.X5_Living_with_whom__c.startsWith('6.'))) && 
        (currentClient.X6_Total_Number_of_Children__c >0 && currentClient.X6_Total_Number_of_Children__c != 99 ))
        {
            currentForm.addError (label.NDTRS_Living_with_Children_not_indicated);
        }
    }
    
    public void ValidationID_28 (NDTRS_Form_2016__c currentForm, Contact currentClient)
    {
        if (currentClient.X9a_Education_highest_level__c == null)
        {
            currentForm.addError (label.NDTRS_Rule_EDLEVEL);
        }
    }
    
    public void ValidationID_29 (NDTRS_Form_2016__c currentForm, Contact currentClient)
    {
        if (currentClient.X9b_Age_left_primary_school__c == null)
        {
            currentForm.addError (label.NDTRS_Rule_29);
        }
    }
    
    public void ValidationID_37 (NDTRS_Form_2016__c currentForm, Contact currentClient)
    {
        if (currentClient.X10_Employement_Status__c == null)
        {
            currentForm.addError (label.NDTRS_EmployCode);
        }
    }
    
    public void ValidationID_43 (NDTRS_Form_2016__c currentForm, Contact currentClient)
    {
        if (currentClient.X9b_Age_left_primary_school__c != null && currentClient.X10_Employement_Status__c != null &&
        currentClient.X9b_Age_left_primary_school__c == 88 && !currentClient.X10_Employement_Status__c.startsWith('4.'))
        {
            currentForm.addError (label.NDTRS_Q9_and_Q10_Employment_and_Education);
        }
    }
    
    public void ValidationID_44 (NDTRS_Form_2016__c currentForm)
    { 
        if(currentForm.X13_Main_Reason_for_referral__c == null)
        {
            currentForm.X13_Main_Reason_for_referral__c.addError (label.NDTRS_Reason_Q13);
        }
        
    }
    
    public void ValidationID_71 (NDTRS_Form_2016__c currentForm)
    { 
        if(currentForm.X19b_Age_first_treated_Drugs__c != 88 && currentForm.X19b_Age_first_treated_Drugs__c != 99 &&
        currentForm.X20b_Age_first_received_any_opiate_subst__c != 88 && currentForm.X20b_Age_first_received_any_opiate_subst__c != 99 &&
        currentForm.X19b_Age_first_treated_Drugs__c > currentForm.X20b_Age_first_received_any_opiate_subst__c)
        {
            currentForm.X19b_Age_first_treated_Drugs__c.addError (label.NDTRS_Q19_older_than_Q20b);
        }
    }
    
    public void ValidationID_81 (NDTRS_Form_2016__c currentForm)
    { 
        if(currentForm.X19_History_of_treatment_Drugs__c != null && currentForm.X20a_Ever_received_any_opiate_substituti__c != null &&
        !currentForm.X19_History_of_treatment_Drugs__c.startsWith('2.') && currentForm.X20a_Ever_received_any_opiate_substituti__c.startsWith('1.'))
        {
            currentForm.X19_History_of_treatment_Drugs__c.addError (label.NDTRS_Q19_previously_treated_and_Q20a);
        }
    }
    
    public void ValidationID_82 (NDTRS_Form_2016__c currentForm, Contact currentClient)
    { 
        if(currentForm.X19_History_of_treatment_Drugs__c != null && currentForm.X19b_Age_first_treated_Drugs__c != null &&
        currentForm.X20a_Ever_received_any_opiate_substituti__c != null && 
        currentForm.Age__c != 99 &&
        currentForm.X20b_Age_first_received_any_opiate_subst__c != null &&
        currentForm.X20b_Age_first_received_any_opiate_subst__c != 88 && currentForm.X20b_Age_first_received_any_opiate_subst__c != 99 &&
        currentForm.Age__c < currentForm.X20b_Age_first_received_any_opiate_subst__c)
        {
            currentForm.X20b_Age_first_received_any_opiate_subst__c.addError (label.NDTRS_AgeOpiateSub);
        }
    }
    
    public void ValidationID_86 (NDTRS_Form_2016__c currentForm, NDTRS_Drugs__c X13_2_Drug_specify, NDTRS_Drugs__c X21a_Main_drug)
    {
        if(X13_2_Drug_specify != null && X21a_Main_drug != null && X13_2_Drug_specify.Item_Code__c != X21a_Main_drug.Item_Code__c)
        {
            currentForm.X21a_Main_drug__c.addError (label.NDTRS_SPECIFYX_Q13_not_equal_Q21a);
        }
         
    }
    
    public void ValidationID_97_Q21_and_Q27 (NDTRS_Form_2016__c currentForm, NDTRS_Drugs__c X21a_Main_drug, NDTRS_Drugs__c X27_Specify_first_drug_ever_used)
    {
        if(X21a_Main_drug != null && X27_Specify_first_drug_ever_used != null && (X21a_Main_drug.Item_Code__c == X27_Specify_first_drug_ever_used.Item_Code__c) && 
        currentForm.X21d_Age_at_1st_use__c != currentForm.X26_Age_first_use_any_drug__c)
        {
            currentForm.X21d_Age_at_1st_use__c.addError (label.NDTRS_Age_1st_Used);
        }
         
    }
    
    public void ValidationID_97_Q22_and_Q27 (NDTRS_Form_2016__c currentForm, NDTRS_Drugs__c X22a_Drug_2, NDTRS_Drugs__c X27_Specify_first_drug_ever_used)
    {
        if(X22a_Drug_2 != null && X27_Specify_first_drug_ever_used != null && X22a_Drug_2.Item_Code__c == X27_Specify_first_drug_ever_used.Item_Code__c && 
        currentForm.X22d_Age_of_1st_use__c != currentForm.X26_Age_first_use_any_drug__c)
        {
            currentForm.X22d_Age_of_1st_use__c.addError (label.NDTRS_Age_1st_Used);
        }
         
    }
    
    public void ValidationID_97_Q23_and_Q27 (NDTRS_Form_2016__c currentForm, NDTRS_Drugs__c X23a_Drug_3, NDTRS_Drugs__c X27_Specify_first_drug_ever_used)
    {
        if(X23a_Drug_3 != null && X27_Specify_first_drug_ever_used != null && X23a_Drug_3.Item_Code__c == X27_Specify_first_drug_ever_used.Item_Code__c && 
        currentForm.X23d_Age_of_1st_use__c != currentForm.X26_Age_first_use_any_drug__c)
        {
            currentForm.X23d_Age_of_1st_use__c.addError (label.NDTRS_Age_1st_Used);
        }
         
    }
    
    public void ValidationID_97_Q24_and_Q27 (NDTRS_Form_2016__c currentForm, NDTRS_Drugs__c X24a_Drug_4, NDTRS_Drugs__c X27_Specify_first_drug_ever_used)
    {
        if(X24a_Drug_4 != null && X27_Specify_first_drug_ever_used != null && X24a_Drug_4.Item_Code__c == X27_Specify_first_drug_ever_used.Item_Code__c && 
        currentForm.X24d_Age_of_1st_use__c != currentForm.X26_Age_first_use_any_drug__c)
        {
            currentForm.X24d_Age_of_1st_use__c.addError (label.NDTRS_Age_1st_Used);
        }
         
    }
    
    public void ValidationID_97_Q25_and_Q27 (NDTRS_Form_2016__c currentForm, NDTRS_Drugs__c X25a_Drug_5, NDTRS_Drugs__c X27_Specify_first_drug_ever_used)
    {
        if(X25a_Drug_5 != null && X27_Specify_first_drug_ever_used != null && X25a_Drug_5.Item_Code__c == X27_Specify_first_drug_ever_used.Item_Code__c && 
        currentForm.X25d_Age_of_1st_use__c != currentForm.X26_Age_first_use_any_drug__c)
        {
            currentForm.X25d_Age_of_1st_use__c.addError (label.NDTRS_Age_1st_Used);
        }
         
    }

/*  //E. Drug use (Excluding Alcohol and Tobacco) can NOT be left blank when treatment is complete
    public void ValidationID_99 (NDTRS_Form_2016__c currentForm, NDTRS_Drugs__c X27_Specify_first_drug_ever_used)
    {
        if(currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && 
            (currentForm.X26_Age_first_use_any_drug__c == null || X27_Specify_first_drug_ever_used == null || currentForm.X28_Difficult_to_assess_main_problem__c == null))
        {
            currentForm.X26_Age_first_use_any_drug__c.addError (label.NDTRS_Rule_99);
        }
    }
*/

    
    public void ValidationID_100 (NDTRS_Form_2016__c currentForm, NDTRS_Drugs__c X21a_Main_drug, NDTRS_Drugs__c X22a_Drug_2, NDTRS_Drugs__c X23a_Drug_3,
                                NDTRS_Drugs__c X24a_Drug_4, NDTRS_Drugs__c X25a_Drug_5)
    {
        if((X21a_Main_drug != null && X22a_Drug_2 != null && X21a_Main_drug.Item_Name__c == X22a_Drug_2.Item_Name__c) ||
        (X21a_Main_drug != null && X23a_Drug_3 != null && X21a_Main_drug.Item_Name__c == X23a_Drug_3.Item_Name__c) ||
        (X21a_Main_drug != null && X24a_Drug_4 != null && X21a_Main_drug.Item_Name__c == X24a_Drug_4.Item_Name__c) ||
        (X21a_Main_drug != null && X25a_Drug_5 != null && X21a_Main_drug.Item_Name__c == X25a_Drug_5.Item_Name__c) ||
        (X22a_Drug_2 != null && X23a_Drug_3 != null && X22a_Drug_2.Item_Name__c == X23a_Drug_3.Item_Name__c) ||
        (X22a_Drug_2 != null && X24a_Drug_4 != null && X22a_Drug_2.Item_Name__c == X24a_Drug_4.Item_Name__c) ||
        (X22a_Drug_2 != null && X25a_Drug_5 != null && X22a_Drug_2.Item_Name__c == X25a_Drug_5.Item_Name__c) ||
        (X23a_Drug_3 != null && X24a_Drug_4 != null && X23a_Drug_3.Item_Name__c == X24a_Drug_4.Item_Name__c) ||
        (X23a_Drug_3 != null && X25a_Drug_5 != null && X23a_Drug_3.Item_Name__c == X25a_Drug_5.Item_Name__c) ||
        (X24a_Drug_4 != null && X25a_Drug_5 != null && X24a_Drug_4.Item_Name__c == X25a_Drug_5.Item_Name__c))
        {
            currentForm.addError (label.NDTRS_Duplicate_drug);
        }
    }
    
    //Reject if 21d-21d < 26, except if corresponding drug is alcohol in 21d-25d.
    public void ValidationID_109_Q21d (NDTRS_Form_2016__c currentForm, NDTRS_Drugs__c X21a_Main_drug)
    {
        if(X21a_Main_drug != null && X21a_Main_drug.Item_Code__c != 700 &&
        (currentForm.X26_Age_first_use_any_drug__c != 88 && currentForm.X26_Age_first_use_any_drug__c != 99) &&
        currentForm.X21d_Age_at_1st_use__c < currentForm.X26_Age_first_use_any_drug__c)
        {
            currentForm.X21d_Age_at_1st_use__c.addError (label.NDTRS_Ages_of_1st_use_Q26);
        }
    }
    //Reject if 21d-21d < 26, except if corresponding drug is alcohol in 21d-25d.
    public void ValidationID_109_Q22d (NDTRS_Form_2016__c currentForm, NDTRS_Drugs__c X22a_Drug_2)
    {
        if(X22a_Drug_2 != null && X22a_Drug_2.Item_Code__c != 700 &&
        (currentForm.X26_Age_first_use_any_drug__c != 88 && currentForm.X26_Age_first_use_any_drug__c != 99) &&
        currentForm.X22d_Age_of_1st_use__c < currentForm.X26_Age_first_use_any_drug__c)
        {
            currentForm.X22d_Age_of_1st_use__c.addError (label.NDTRS_Ages_of_1st_use_Q26);
        }
    }
    //Reject if 21d-21d < 26, except if corresponding drug is alcohol in 21d-25d.
    public void ValidationID_109_Q23d (NDTRS_Form_2016__c currentForm, NDTRS_Drugs__c X23a_Drug_3)
    {
        if(X23a_Drug_3 != null && X23a_Drug_3.Item_Code__c != 700 &&
        (currentForm.X26_Age_first_use_any_drug__c != 88 && currentForm.X26_Age_first_use_any_drug__c != 99) &&
        currentForm.X23d_Age_of_1st_use__c < currentForm.X26_Age_first_use_any_drug__c)
        {
            currentForm.X23d_Age_of_1st_use__c.addError (label.NDTRS_Ages_of_1st_use_Q26);
        }
    }
    //Reject if 21d-21d < 26, except if corresponding drug is alcohol in 21d-25d.
    public void ValidationID_109_Q24d (NDTRS_Form_2016__c currentForm, NDTRS_Drugs__c X24a_Drug_4)
    {
        if(X24a_Drug_4 != null && X24a_Drug_4.Item_Code__c != 700 &&
        (currentForm.X26_Age_first_use_any_drug__c != 88 && currentForm.X26_Age_first_use_any_drug__c != 99) &&
        currentForm.X24d_Age_of_1st_use__c < currentForm.X26_Age_first_use_any_drug__c)
        {
            currentForm.X24d_Age_of_1st_use__c.addError (label.NDTRS_Ages_of_1st_use_Q26);
        }
    }
    //Reject if 21d-21d < 26, except if corresponding drug is alcohol in 21d-25d.
    public void ValidationID_109_Q25d (NDTRS_Form_2016__c currentForm, NDTRS_Drugs__c X25a_Drug_5)
    {
        if(X25a_Drug_5 != null && X25a_Drug_5.Item_Code__c != 700 &&
        (currentForm.X26_Age_first_use_any_drug__c != 88 && currentForm.X26_Age_first_use_any_drug__c != 99) &&
        currentForm.X25d_Age_of_1st_use__c < currentForm.X26_Age_first_use_any_drug__c)
        {
            currentForm.X25d_Age_of_1st_use__c.addError (label.NDTRS_Ages_of_1st_use_Q26);
        }
    }
    
    public void ValidationID_123 (NDTRS_Form_2016__c currentForm)
    {
        if((currentForm.X26_Age_first_use_any_drug__c != 88 && currentForm.X26_Age_first_use_any_drug__c != 99) &&
            (currentForm.X30b_Age_first_injected__c != 88 && currentForm.X30b_Age_first_injected__c != 99) &&
            (currentForm.X26_Age_first_use_any_drug__c > currentForm.X30b_Age_first_injected__c))
        {
            currentForm.X30b_Age_first_injected__c.addError (label.NDTRS_Ages_of_1st_use_1st_injected_consistency);
        }
    }
    
    public void ValidationID_127_Q21b (NDTRS_Form_2016__c currentForm)
    { 
        if(currentForm.X21b_Route_of_Admin_Main_drug__c != null && currentForm.X21b_Route_of_Admin_Main_drug__c.startsWith('1.') && 
        currentForm.X30a_Ever_injected__c != null && !currentForm.X30a_Ever_injected__c.startsWith('1.'))
        {
            currentForm.X30a_Ever_injected__c.addError (label.NDTRS_Ever_Injected);
        }
    }
    
    public void ValidationID_127_Q22b (NDTRS_Form_2016__c currentForm)
    { 
        if(currentForm.X22b_Route_of_Admin_Drug2__c != null && currentForm.X22b_Route_of_Admin_Drug2__c.startsWith('1.') && 
        currentForm.X30a_Ever_injected__c != null && !currentForm.X30a_Ever_injected__c.startsWith('1.'))
        {
            currentForm.X30a_Ever_injected__c.addError (label.NDTRS_Ever_Injected);
        }
    }
    
    public void ValidationID_127_Q23b (NDTRS_Form_2016__c currentForm)
    { 
        if(currentForm.X23b_Route_of_Admin_Drug3__c != null && currentForm.X23b_Route_of_Admin_Drug3__c.startsWith('1.') && 
        currentForm.X30a_Ever_injected__c != null && !currentForm.X30a_Ever_injected__c.startsWith('1.'))
        {
            currentForm.X30a_Ever_injected__c.addError (label.NDTRS_Ever_Injected);
        }
    }
    
    public void ValidationID_127_Q24b (NDTRS_Form_2016__c currentForm)
    { 
        if(currentForm.X24b_Route_of_Admin_Drug4__c != null && currentForm.X24b_Route_of_Admin_Drug4__c.startsWith('1.') && 
        currentForm.X30a_Ever_injected__c != null && !currentForm.X30a_Ever_injected__c.startsWith('1.'))
        {
            currentForm.X30a_Ever_injected__c.addError (label.NDTRS_Ever_Injected);
        }
    }
    
     public void ValidationID_127_Q25b (NDTRS_Form_2016__c currentForm)
    { 
        if(currentForm.X25b_Route_of_Admin_Drug5__c != null && currentForm.X25b_Route_of_Admin_Drug5__c.startsWith('1.') && 
        currentForm.X30a_Ever_injected__c != null && !currentForm.X30a_Ever_injected__c.startsWith('1.'))
        {
            currentForm.X30a_Ever_injected__c.addError (label.NDTRS_Ever_Injected);
        }
    }
    
    public void ValidationID_130 (NDTRS_Form_2016__c currentForm)
    { 
        if(currentForm.X30a_Ever_injected__c != null && currentForm.X30a_Ever_injected__c.startsWith('1.') && currentForm.X30c_Frequency_of_injecting__c == null)
        {
            currentForm.X30c_Frequency_of_injecting__c.addError (label.NDTRS_Freq_of_Injecting);
        }
        //now rule 131
    }
    public void ValidationID_131 (NDTRS_Form_2016__c currentForm)
    {   
        if(currentForm.X30a_Ever_injected__c != null && currentForm.X30a_Ever_injected__c.startsWith('1.') && currentForm.X30d_Ever_shared_needle_and_syringes__c == null)
        {
            currentForm.X30d_Ever_shared_needle_and_syringes__c.addError (label.NDTRS_SharedNeedle);
        }
    }
    
    Boolean InjectedInLast30Days (String route, String frequency){
        if (route == null || frequency == null || route.startsWith('9.') || frequency.startsWith('9.')){
            return false; // because we don't know
        }else if (!route.startsWith('1.')){
            return false; // because not injecting
        }else if (frequency.startsWith('4.')){
            return false; // because not frequent enough
        }else{
            return true;
        }
    }
    public void ValidationID_134 (NDTRS_Form_2016__c currentForm) // ROUTE: No drug has been injected
    {   
        if (currentForm.X30c_Frequency_of_injecting__c != null && currentForm.X30c_Frequency_of_injecting__c.startsWith('1.')
            &&  !InjectedInLast30Days(currentForm.X21b_Route_of_Admin_Main_drug__c, currentForm.X21c_Frequency_of_use_in_last_mth__c)
            && !InjectedInLast30Days(currentForm.X22b_Route_of_Admin_Drug2__c, currentForm.X22c_Frequency_of_use_in_last_mth__c)
            && !InjectedInLast30Days(currentForm.X23b_Route_of_Admin_Drug3__c, currentForm.X23c_Frequency_of_use_in_last_mth__c)
            && !InjectedInLast30Days(currentForm.X24b_Route_of_Admin_Drug4__c, currentForm.X24c_Frequency_of_use_in_last_mth__c)
            && !InjectedInLast30Days(currentForm.X25b_Route_of_Admin_Drug5__c, currentForm.X25c_Frequency_of_use_in_last_mth__c))
/*
        if(((currentForm.X21b_Route_of_Admin_Main_drug__c != null && !currentForm.X21b_Route_of_Admin_Main_drug__c.startsWith('1.')) 
        ||
            (currentForm.X22b_Route_of_Admin_Drug2__c != null && !currentForm.X22b_Route_of_Admin_Drug2__c.startsWith('1.')) 
        ||
            (currentForm.X23b_Route_of_Admin_Drug3__c != null && !currentForm.X23b_Route_of_Admin_Drug3__c.startsWith('1.')) 
        ||
            (currentForm.X24b_Route_of_Admin_Drug4__c != null && !currentForm.X24b_Route_of_Admin_Drug4__c.startsWith('1.')) 
        ||
            (currentForm.X25b_Route_of_Admin_Drug5__c != null && !currentForm.X25b_Route_of_Admin_Drug5__c.startsWith('1.'))) && 
            currentForm.X30c_Frequency_of_injecting__c != null && currentForm.X30c_Frequency_of_injecting__c.startsWith('1.'))*/
        {
            currentForm.X30c_Frequency_of_injecting__c.addError (label.NDTRS_Currently_Injecting_Q30c);
        }
    }
 
/*    public void ValidationID_134a (NDTRS_Form_2016__c currentForm) // FREQUENCY: injected during the last month
    {   
        if(((currentForm.X21b_Route_of_Admin_Main_drug__c != null && currentForm.X21b_Route_of_Admin_Main_drug__c.startsWith('1.')) &&
            (currentForm.X21c_Frequency_of_use_in_last_mth__c != null && !(currentForm.X21c_Frequency_of_use_in_last_mth__c.startsWith('4.') || currentForm.X21c_Frequency_of_use_in_last_mth__c.startsWith('9.')))
            || 
            (currentForm.X22b_Route_of_Admin_Drug2__c != null && currentForm.X22b_Route_of_Admin_Drug2__c.startsWith('1.')) &&
            (currentForm.X22c_Frequency_of_use_in_last_mth__c != null && !(currentForm.X22c_Frequency_of_use_in_last_mth__c.startsWith('4.') || currentForm.X22c_Frequency_of_use_in_last_mth__c.startsWith('9.')))
            ||
            (currentForm.X23b_Route_of_Admin_Drug3__c != null && currentForm.X23b_Route_of_Admin_Drug3__c.startsWith('1.')) &&
            currentForm.X23c_Frequency_of_use_in_last_mth__c != null && !(currentForm.X23c_Frequency_of_use_in_last_mth__c.startsWith('4.') || currentForm.X23c_Frequency_of_use_in_last_mth__c.startsWith('9.')))
        ||
        (currentForm.X24b_Route_of_Admin_Drug4__c != null && currentForm.X24b_Route_of_Admin_Drug4__c.startsWith('1.') &&
            currentForm.X24c_Frequency_of_use_in_last_mth__c != null && !(currentForm.X24c_Frequency_of_use_in_last_mth__c.startsWith('4.') || currentForm.X24c_Frequency_of_use_in_last_mth__c.startsWith('9.')))
        ||
        (currentForm.X25b_Route_of_Admin_Drug5__c != null && currentForm.X25b_Route_of_Admin_Drug5__c.startsWith('1.') &&
            currentForm.X25c_Frequency_of_use_in_last_mth__c != null && !(currentForm.X25c_Frequency_of_use_in_last_mth__c.startsWith('4.') || currentForm.X25c_Frequency_of_use_in_last_mth__c.startsWith('9.')))) &&
            currentForm.X30c_Frequency_of_injecting__c != null && !currentForm.X30c_Frequency_of_injecting__c.startsWith('1.'))
        {
            currentForm.X30c_Frequency_of_injecting__c.addError (label.NDTRS_Currently_Injecting_Q30c);
        }
    }
*/
    public void ValidationID_135 (NDTRS_Form_2016__c currentForm) // FREQUENCY: injected but NOT in the last month
    { 
        if  (currentForm.X21b_Route_of_Admin_Main_drug__c != null && currentForm.X21b_Route_of_Admin_Main_drug__c.startsWith('1.') && 
            currentForm.X21c_Frequency_of_use_in_last_mth__c != null && currentForm.X21c_Frequency_of_use_in_last_mth__c.startsWith('4.') &&
            currentForm.X22b_Route_of_Admin_Drug2__c != null && currentForm.X22b_Route_of_Admin_Drug2__c.startsWith('1.') && 
            currentForm.X22c_Frequency_of_use_in_last_mth__c != null && currentForm.X22c_Frequency_of_use_in_last_mth__c.startsWith('4.') &&
            currentForm.X23b_Route_of_Admin_Drug3__c != null && currentForm.X23b_Route_of_Admin_Drug3__c.startsWith('1.') &&
            currentForm.X23c_Frequency_of_use_in_last_mth__c != null && currentForm.X23c_Frequency_of_use_in_last_mth__c.startsWith('4.') &&
            currentForm.X24b_Route_of_Admin_Drug4__c != null && currentForm.X24b_Route_of_Admin_Drug4__c.startsWith('1.') && 
            currentForm.X24c_Frequency_of_use_in_last_mth__c != null && currentForm.X24c_Frequency_of_use_in_last_mth__c.startsWith('4.') &&
            currentForm.X25b_Route_of_Admin_Drug5__c != null && currentForm.X25b_Route_of_Admin_Drug5__c.startsWith('1.') &&
            currentForm.X25c_Frequency_of_use_in_last_mth__c != null && currentForm.X25c_Frequency_of_use_in_last_mth__c.startsWith('4.') &&
            currentForm.X30c_Frequency_of_injecting__c != null && currentForm.X30c_Frequency_of_injecting__c.startsWith('1.'))
        {
            currentForm.X30c_Frequency_of_injecting__c.addError (label.NDTRS_Currently_Injecting_Q21_Q25_equal_4);
        }
    }   
    
    public void ValidationID_142 (NDTRS_Form_2016__c currentForm) //Viral screening Q31: Can only 1 value in each column.  Cannot be blank. 
    {
        if (currentForm.X31a_History_of_Hepatitis_C_screening__c == null)
        {
            currentForm.X31a_History_of_Hepatitis_C_screening__c.addError (label.NDTRS_Viral_screening);
        }
        if (currentForm.X31b_History_of_Hepatitis_B_screening__c == null)
        {
            currentForm.X31b_History_of_Hepatitis_B_screening__c.addError (label.NDTRS_Viral_screening);
        }
        if (currentForm.X31c_History_of_HIV_screening__c == null)
        {
            currentForm.X31c_History_of_HIV_screening__c.addError (label.NDTRS_Viral_screening);
        }
    }
    
    public void InterventionDateCheck (NDTRS_Form_2016__c currentForm)
    {
        if(currentForm.X32c1_Date_of_last_visit__c < currentForm.X32b1_Date_started__c)
        {
            currentForm.X32c1_Date_of_last_visit__c.addError (label.NDTRS_Intervention_Date_Check);
        }
        if(currentForm.X32c2_Date_of_last_visit__c < currentForm.X32b2_Date_started__c)
        {
            currentForm.X32c2_Date_of_last_visit__c.addError (label.NDTRS_Intervention_Date_Check);
        }
        if(currentForm.X32c3_Date_of_last_visit__c < currentForm.X32b3_Date_started__c)
        {
            currentForm.X32c3_Date_of_last_visit__c.addError (label.NDTRS_Intervention_Date_Check);
        }
        if(currentForm.X32c4_Date_of_last_visit__c < currentForm.X32b4_Date_started__c)
        {
            currentForm.X32c4_Date_of_last_visit__c.addError (label.NDTRS_Intervention_Date_Check);
        }
        if(currentForm.X32c5_Date_of_last_visit__c < currentForm.X32b5_Date_started__c)
        {
            currentForm.X32c5_Date_of_last_visit__c.addError (label.NDTRS_Intervention_Date_Check);
        }
        if(currentForm.X32c6_Date_of_last_visit__c < currentForm.X32b6_Date_started__c)
        {
            currentForm.X32c6_Date_of_last_visit__c.addError (label.NDTRS_Intervention_Date_Check);
        }
        if(currentForm.X32c7_Date_of_last_visit__c < currentForm.X32b7_Date_started__c)
        {
            currentForm.X32c7_Date_of_last_visit__c.addError (label.NDTRS_Intervention_Date_Check);
        }
        if(currentForm.X32c8_Date_of_last_visit__c < currentForm.X32b8_Date_started__c)
        {
            currentForm.X32c8_Date_of_last_visit__c.addError (label.NDTRS_Intervention_Date_Check);
        }
        if(currentForm.X32c9_Date_of_last_visit__c < currentForm.X32b9_Date_started__c)
        {
            currentForm.X32c9_Date_of_last_visit__c.addError (label.NDTRS_Intervention_Date_Check);
        }
        if(currentForm.X32c10_Date_of_last_visit__c < currentForm.X32b10_Date_started__c)
        {
            currentForm.X32c10_Date_of_last_visit__c.addError (label.NDTRS_Intervention_Date_Check);
        }
        if(currentForm.X32c11_Date_of_last_visit__c < currentForm.X32b11_Date_started__c)
        {
            currentForm.X32c11_Date_of_last_visit__c.addError (label.NDTRS_Intervention_Date_Check);
        }
        if(currentForm.X32c12_Date_of_last_visit__c < currentForm.X32b12_Date_started__c)
        {
            currentForm.X32c12_Date_of_last_visit__c.addError (label.NDTRS_Intervention_Date_Check);
        }
        if(currentForm.X32c13_Date_of_last_visit__c < currentForm.X32b13_Date_started__c)
        {
            currentForm.X32c13_Date_of_last_visit__c.addError (label.NDTRS_Intervention_Date_Check);
        }
        if(currentForm.X32c13_Date_of_last_visit__c < currentForm.X32b13_Date_started__c)
        {
            currentForm.X32c13_Date_of_last_visit__c.addError (label.NDTRS_Intervention_Date_Check);
        }
        if(currentForm.X32c15_Date_of_last_visit__c < currentForm.X32b15_Date_started__c)
        {
            currentForm.X32c15_Date_of_last_visit__c.addError (label.NDTRS_Intervention_Date_Check);
        }
        if(currentForm.X32c16_Date_of_last_visit__c < currentForm.X32b16_Date_started__c)
        {
            currentForm.X32c16_Date_of_last_visit__c.addError (label.NDTRS_Intervention_Date_Check);
        }
        if(currentForm.X32c17_Date_of_last_visit__c < currentForm.X32b17_Date_started__c)
        {
            currentForm.X32c17_Date_of_last_visit__c.addError (label.NDTRS_Intervention_Date_Check);
        }
        if(currentForm.X32c18_Date_of_last_visit__c < currentForm.X32b18_Date_started__c)
        {
            currentForm.X32c18_Date_of_last_visit__c.addError (label.NDTRS_Intervention_Date_Check);
        }
        if(currentForm.X32c19_Date_of_last_visit__c < currentForm.X32b19_Date_started__c)
        {
            currentForm.X32c19_Date_of_last_visit__c.addError (label.NDTRS_Intervention_Date_Check);
        }
        if(currentForm.X32c20_Date_of_last_visit__c < currentForm.X32b20_Date_started__c)
        {
            currentForm.X32c20_Date_of_last_visit__c.addError (label.NDTRS_Intervention_Date_Check);
        }
        if(currentForm.X32c21_Date_of_last_visit__c < currentForm.X32b21_Date_started__c)
        {
            currentForm.X32c21_Date_of_last_visit__c.addError (label.NDTRS_Intervention_Date_Check);
        }
        if(currentForm.X32c22_Date_of_last_visit__c < currentForm.X32b22_Date_started__c)
        {
            currentForm.X32c22_Date_of_last_visit__c.addError (label.NDTRS_Intervention_Date_Check);
        }
        if(currentForm.X32c23_Date_of_last_visit__c < currentForm.X32b23_Date_started__c)
        {
            currentForm.X32c23_Date_of_last_visit__c.addError (label.NDTRS_Intervention_Date_Check);
        }
        if(currentForm.X32c24_Date_of_last_visit__c < currentForm.X32b24_Date_started__c)
        {
            currentForm.X32c24_Date_of_last_visit__c.addError (label.NDTRS_Intervention_Date_Check);
        }
        if(currentForm.X32c25_Date_of_last_visit__c < currentForm.X32b25_Date_started__c)
        {
            currentForm.X32c25_Date_of_last_visit__c.addError (label.NDTRS_Intervention_Date_Check);
        }
        if(currentForm.X32c27_Date_of_last_visit__c < currentForm.X32b27_Date_started__c)
        {
            currentForm.X32c27_Date_of_last_visit__c.addError (label.NDTRS_Intervention_Date_Check);
        }
        if(currentForm.X32c28_Date_of_last_visit__c < currentForm.X32b28_Date_started__c)
        {
            currentForm.X32c28_Date_of_last_visit__c.addError (label.NDTRS_Intervention_Date_Check);
        }
    }
    
    public void ValidationID_166 (NDTRS_Form_2016__c currentForm)
    { 
        if(currentForm.X32c1_Date_of_last_visit__c > currentForm.X35_Date_of_Final_Discharge_or_transfer__c)
        {
            currentForm.X32c1_Date_of_last_visit__c.addError (label.NDTRS_Rule_166);
        }
        if(currentForm.X32c2_Date_of_last_visit__c > currentForm.X35_Date_of_Final_Discharge_or_transfer__c)
        {
            currentForm.X32c2_Date_of_last_visit__c.addError (label.NDTRS_Rule_166);
        }
        if(currentForm.X32c3_Date_of_last_visit__c > currentForm.X35_Date_of_Final_Discharge_or_transfer__c)
        {
            currentForm.X32c3_Date_of_last_visit__c.addError (label.NDTRS_Rule_166);
        }
        if(currentForm.X32c4_Date_of_last_visit__c > currentForm.X35_Date_of_Final_Discharge_or_transfer__c)
        {
            currentForm.X32c4_Date_of_last_visit__c.addError (label.NDTRS_Rule_166);
        }
        if(currentForm.X32c5_Date_of_last_visit__c > currentForm.X35_Date_of_Final_Discharge_or_transfer__c)
        {
            currentForm.X32c5_Date_of_last_visit__c.addError (label.NDTRS_Rule_166);
        }
        if(currentForm.X32c6_Date_of_last_visit__c > currentForm.X35_Date_of_Final_Discharge_or_transfer__c)
        {
            currentForm.X32c6_Date_of_last_visit__c.addError (label.NDTRS_Rule_166);
        }
        if(currentForm.X32c7_Date_of_last_visit__c > currentForm.X35_Date_of_Final_Discharge_or_transfer__c)
        {
            currentForm.X32c7_Date_of_last_visit__c.addError (label.NDTRS_Rule_166);
        }
        if(currentForm.X32c8_Date_of_last_visit__c > currentForm.X35_Date_of_Final_Discharge_or_transfer__c)
        {
            currentForm.X32c8_Date_of_last_visit__c.addError (label.NDTRS_Rule_166);
        }
        if(currentForm.X32c9_Date_of_last_visit__c > currentForm.X35_Date_of_Final_Discharge_or_transfer__c)
        {
            currentForm.X32c9_Date_of_last_visit__c.addError (label.NDTRS_Rule_166);
        }
        if(currentForm.X32c10_Date_of_last_visit__c > currentForm.X35_Date_of_Final_Discharge_or_transfer__c)
        {
            currentForm.X32c10_Date_of_last_visit__c.addError (label.NDTRS_Rule_166);
        }
        if(currentForm.X32c11_Date_of_last_visit__c > currentForm.X35_Date_of_Final_Discharge_or_transfer__c)
        {
            currentForm.X32c11_Date_of_last_visit__c.addError (label.NDTRS_Rule_166);
        }
        if(currentForm.X32c12_Date_of_last_visit__c > currentForm.X35_Date_of_Final_Discharge_or_transfer__c)
        {
            currentForm.X32c12_Date_of_last_visit__c.addError (label.NDTRS_Rule_166);
        }
        if(currentForm.X32c13_Date_of_last_visit__c > currentForm.X35_Date_of_Final_Discharge_or_transfer__c)
        {
            currentForm.X32c13_Date_of_last_visit__c.addError (label.NDTRS_Rule_166);
        }
        if(currentForm.X32c13_Date_of_last_visit__c > currentForm.X35_Date_of_Final_Discharge_or_transfer__c)
        {
            currentForm.X32c13_Date_of_last_visit__c.addError (label.NDTRS_Rule_166);
        }
        if(currentForm.X32c15_Date_of_last_visit__c > currentForm.X35_Date_of_Final_Discharge_or_transfer__c)
        {
            currentForm.X32c15_Date_of_last_visit__c.addError (label.NDTRS_Rule_166);
        }
        if(currentForm.X32c16_Date_of_last_visit__c > currentForm.X35_Date_of_Final_Discharge_or_transfer__c)
        {
            currentForm.X32c16_Date_of_last_visit__c.addError (label.NDTRS_Rule_166);
        }
        if(currentForm.X32c17_Date_of_last_visit__c > currentForm.X35_Date_of_Final_Discharge_or_transfer__c)
        {
            currentForm.X32c17_Date_of_last_visit__c.addError (label.NDTRS_Rule_166);
        }
        if(currentForm.X32c18_Date_of_last_visit__c > currentForm.X35_Date_of_Final_Discharge_or_transfer__c)
        {
            currentForm.X32c18_Date_of_last_visit__c.addError (label.NDTRS_Rule_166);
        }
        if(currentForm.X32c19_Date_of_last_visit__c > currentForm.X35_Date_of_Final_Discharge_or_transfer__c)
        {
            currentForm.X32c19_Date_of_last_visit__c.addError (label.NDTRS_Rule_166);
        }
        if(currentForm.X32c20_Date_of_last_visit__c > currentForm.X35_Date_of_Final_Discharge_or_transfer__c)
        {
            currentForm.X32c20_Date_of_last_visit__c.addError (label.NDTRS_Rule_166);
        }
        if(currentForm.X32c21_Date_of_last_visit__c > currentForm.X35_Date_of_Final_Discharge_or_transfer__c)
        {
            currentForm.X32c21_Date_of_last_visit__c.addError (label.NDTRS_Rule_166);
        }
        if(currentForm.X32c22_Date_of_last_visit__c > currentForm.X35_Date_of_Final_Discharge_or_transfer__c)
        {
            currentForm.X32c22_Date_of_last_visit__c.addError (label.NDTRS_Rule_166);
        }
        if(currentForm.X32c23_Date_of_last_visit__c > currentForm.X35_Date_of_Final_Discharge_or_transfer__c)
        {
            currentForm.X32c23_Date_of_last_visit__c.addError (label.NDTRS_Rule_166);
        }
        if(currentForm.X32c24_Date_of_last_visit__c > currentForm.X35_Date_of_Final_Discharge_or_transfer__c)
        {
            currentForm.X32c24_Date_of_last_visit__c.addError (label.NDTRS_Rule_166);
        }
        if(currentForm.X32c25_Date_of_last_visit__c > currentForm.X35_Date_of_Final_Discharge_or_transfer__c)
        {
            currentForm.X32c25_Date_of_last_visit__c.addError (label.NDTRS_Rule_166);
        }
        if(currentForm.X32c27_Date_of_last_visit__c > currentForm.X35_Date_of_Final_Discharge_or_transfer__c)
        {
            currentForm.X32c27_Date_of_last_visit__c.addError (label.NDTRS_Rule_166);
        }
        if(currentForm.X32c28_Date_of_last_visit__c > currentForm.X35_Date_of_Final_Discharge_or_transfer__c)
        {
            currentForm.X32c28_Date_of_last_visit__c.addError (label.NDTRS_Rule_166);
        }
    }
    
public void InterventionDetailsCheck_Q32c (NDTRS_Form_2016__c currentForm)
    {
        if(currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X32b1_Date_started__c != null && currentForm.X32c1_Date_of_last_visit__c == null )
        {
            currentForm.X32c1_Date_of_last_visit__c.addError (label.NDTRS_Intervention_Details_Check);
        }
        if(currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X32b2_Date_started__c != null && currentForm.X32c2_Date_of_last_visit__c == null )
        {
            currentForm.X32c2_Date_of_last_visit__c.addError (label.NDTRS_Intervention_Details_Check);
        }
        if(currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X32b3_Date_started__c != null && currentForm.X32c3_Date_of_last_visit__c == null )
        {
            currentForm.X32c3_Date_of_last_visit__c.addError (label.NDTRS_Intervention_Details_Check);
        }
        if(currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X32b4_Date_started__c != null && currentForm.X32c4_Date_of_last_visit__c == null )
        {
            currentForm.X32c4_Date_of_last_visit__c.addError (label.NDTRS_Intervention_Details_Check);
        }
        if(currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X32b5_Date_started__c != null && currentForm.X32c5_Date_of_last_visit__c == null )
        {
            currentForm.X32c5_Date_of_last_visit__c.addError (label.NDTRS_Intervention_Details_Check);
        }
        if(currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X32b6_Date_started__c != null && currentForm.X32c6_Date_of_last_visit__c == null )
        {
            currentForm.X32c6_Date_of_last_visit__c.addError (label.NDTRS_Intervention_Details_Check);
        }
        if(currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X32b7_Date_started__c != null && currentForm.X32c7_Date_of_last_visit__c == null )
        {
            currentForm.X32c7_Date_of_last_visit__c.addError (label.NDTRS_Intervention_Details_Check);
        }
        if(currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X32b8_Date_started__c != null && currentForm.X32c8_Date_of_last_visit__c == null )
        {
            currentForm.X32c8_Date_of_last_visit__c.addError (label.NDTRS_Intervention_Details_Check);
        }
        if(currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X32b9_Date_started__c != null && currentForm.X32c9_Date_of_last_visit__c == null )
        {
            currentForm.X32c9_Date_of_last_visit__c.addError (label.NDTRS_Intervention_Details_Check);
        }
        if(currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X32b10_Date_started__c != null && currentForm.X32c10_Date_of_last_visit__c == null )
        {
            currentForm.X32c10_Date_of_last_visit__c.addError (label.NDTRS_Intervention_Details_Check);
        }
        if(currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X32b11_Date_started__c != null && currentForm.X32c11_Date_of_last_visit__c == null )
        {
            currentForm.X32c11_Date_of_last_visit__c.addError (label.NDTRS_Intervention_Details_Check);
        }
        if(currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X32b12_Date_started__c != null && currentForm.X32c12_Date_of_last_visit__c == null )
        {
            currentForm.X32c12_Date_of_last_visit__c.addError (label.NDTRS_Intervention_Details_Check);
        }
        if(currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X32b13_Date_started__c != null && currentForm.X32c13_Date_of_last_visit__c == null )
        {
            currentForm.X32c13_Date_of_last_visit__c.addError (label.NDTRS_Intervention_Details_Check);
        }
        if(currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X32b14_Date_started__c != null && currentForm.X32c14_Date_of_last_visit__c == null )
        {
            currentForm.X32c14_Date_of_last_visit__c.addError (label.NDTRS_Intervention_Details_Check);
        }
        if(currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X32b15_Date_started__c != null && currentForm.X32c15_Date_of_last_visit__c == null )
        {
            currentForm.X32c15_Date_of_last_visit__c.addError (label.NDTRS_Intervention_Details_Check);
        }
        if(currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X32b16_Date_started__c != null && currentForm.X32c16_Date_of_last_visit__c == null )
        {
            currentForm.X32c16_Date_of_last_visit__c.addError (label.NDTRS_Intervention_Details_Check);
        }
        if(currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X32b17_Date_started__c != null && currentForm.X32c17_Date_of_last_visit__c == null )
        {
            currentForm.X32c17_Date_of_last_visit__c.addError (label.NDTRS_Intervention_Details_Check);
        }
        if(currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X32b18_Date_started__c != null && currentForm.X32c18_Date_of_last_visit__c == null )
        {
            currentForm.X32c18_Date_of_last_visit__c.addError (label.NDTRS_Intervention_Details_Check);
        }
        if(currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X32b19_Date_started__c != null && currentForm.X32c19_Date_of_last_visit__c == null )
        {
            currentForm.X32c19_Date_of_last_visit__c.addError (label.NDTRS_Intervention_Details_Check);
        }
        if(currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X32b20_Date_started__c != null && currentForm.X32c20_Date_of_last_visit__c == null )
        {
            currentForm.X32c20_Date_of_last_visit__c.addError (label.NDTRS_Intervention_Details_Check);
        }
        if(currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X32b21_Date_started__c != null && currentForm.X32c21_Date_of_last_visit__c == null )
        {
            currentForm.X32c21_Date_of_last_visit__c.addError (label.NDTRS_Intervention_Details_Check);
        }
        if(currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X32b22_Date_started__c != null && currentForm.X32c22_Date_of_last_visit__c == null )
        {
            currentForm.X32c22_Date_of_last_visit__c.addError (label.NDTRS_Intervention_Details_Check);
        }
        if(currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X32b23_Date_started__c != null && currentForm.X32c23_Date_of_last_visit__c == null )
        {
            currentForm.X32c23_Date_of_last_visit__c.addError (label.NDTRS_Intervention_Details_Check);
        }
        if(currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X32b24_Date_started__c != null && currentForm.X32c24_Date_of_last_visit__c == null )
        {
            currentForm.X32c24_Date_of_last_visit__c.addError (label.NDTRS_Intervention_Details_Check);
        }
        if(currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X32b25_Date_started__c != null && currentForm.X32c25_Date_of_last_visit__c == null )
        {
            currentForm.X32c25_Date_of_last_visit__c.addError (label.NDTRS_Intervention_Details_Check);
        }
        if(currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X32b27_Date_started__c != null && currentForm.X32c27_Date_of_last_visit__c == null )
        {
            currentForm.X32c27_Date_of_last_visit__c.addError (label.NDTRS_Intervention_Details_Check);
        }
        if(currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X32b28_Date_started__c != null && currentForm.X32c28_Date_of_last_visit__c == null )
        {
            currentForm.X32c28_Date_of_last_visit__c.addError (label.NDTRS_Intervention_Details_Check);
        }
        
    }
    
    public void InterventionDetailsCheck_Q32d (NDTRS_Form_2016__c currentForm, NDTRS_Drugs__c X27_Specify_first_drug_ever_used) // Warning 168 Sessions is covered by this rule, no need for another warning, also includes Age first use any drug
    {
        if (currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X32b1_Date_started__c != null && (currentForm.X32d1_Number_of_sessions__c == null || currentForm.X32d1_Number_of_sessions__c == 0))
            {
                currentForm.X32d1_Number_of_sessions__c.addError (label.NDTRS_Intervention_Details_Check);
            }
            
        if (currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X32b2_Date_started__c != null && (currentForm.X32d2_Number_of_sessions__c == null || currentForm.X32d2_Number_of_sessions__c == 0))
            {
                currentForm.X32d2_Number_of_sessions__c.addError (label.NDTRS_Intervention_Details_Check);
            }
            
        if (currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X32b3_Date_started__c != null && (currentForm.X32d3_Number_of_sessions__c == null || currentForm.X32d3_Number_of_sessions__c == 0))
            {
                currentForm.X32d3_Number_of_sessions__c.addError (label.NDTRS_Intervention_Details_Check);
            }
            
        if (currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X32b4_Date_started__c != null && (currentForm.X32d4_Number_of_sessions__c == null || currentForm.X32d4_Number_of_sessions__c == 0))
            {
                currentForm.X32d4_Number_of_sessions__c.addError (label.NDTRS_Intervention_Details_Check);
            }
            
        if (currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X32b5_Date_started__c != null && (currentForm.X32d5_Number_of_sessions__c == null || currentForm.X32d5_Number_of_sessions__c == 0))
            {
                currentForm.X32d5_Number_of_sessions__c.addError (label.NDTRS_Intervention_Details_Check);
            }
            
        if (currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X32b6_Date_started__c != null && (currentForm.X32d6_Number_of_sessions__c == null || currentForm.X32d6_Number_of_sessions__c == 0))
            {
                currentForm.X32d6_Number_of_sessions__c.addError (label.NDTRS_Intervention_Details_Check);
            }
            
        if (currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X32b7_Date_started__c != null && (currentForm.X32d7_Number_of_sessions__c == null || currentForm.X32d7_Number_of_sessions__c == 0))
            {
                currentForm.X32d7_Number_of_sessions__c.addError (label.NDTRS_Intervention_Details_Check);
            }
            
        if (currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X32b8_Date_started__c != null && (currentForm.X32d8_Number_of_sessions__c == null || currentForm.X32d8_Number_of_sessions__c == 0))
            {
                currentForm.X32d8_Number_of_sessions__c.addError (label.NDTRS_Intervention_Details_Check);
            }
            
        if (currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X32b9_Date_started__c != null && (currentForm.X32d9_Number_of_sessions__c == null || currentForm.X32d9_Number_of_sessions__c == 0))
            {
                currentForm.X32d9_Number_of_sessions__c.addError (label.NDTRS_Intervention_Details_Check);
            }
            
        if (currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X32b10_Date_started__c != null && (currentForm.X32d10_Number_of_sessions__c == null || currentForm.X32d10_Number_of_sessions__c == 0))
            {
                currentForm.X32d10_Number_of_sessions__c.addError (label.NDTRS_Intervention_Details_Check);
            }
            
        if (currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X32b11_Date_started__c != null && (currentForm.X32d11_Number_of_sessions__c == null || currentForm.X32d11_Number_of_sessions__c == 0))
            {
                currentForm.X32d11_Number_of_sessions__c.addError (label.NDTRS_Intervention_Details_Check);
            }
            
        if (currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X32b12_Date_started__c != null && (currentForm.X32d12_Number_of_sessions__c == null || currentForm.X32d12_Number_of_sessions__c == 0))
            {
                currentForm.X32d12_Number_of_sessions__c.addError (label.NDTRS_Intervention_Details_Check);
            }
            
        if (currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X32b13_Date_started__c != null && (currentForm.X32d13_Number_of_sessions__c == null || currentForm.X32d13_Number_of_sessions__c == 0))
            {
                currentForm.X32d13_Number_of_sessions__c.addError (label.NDTRS_Intervention_Details_Check);
            }
            
        if (currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X32b14_Date_started__c != null && (currentForm.X32d14_Number_of_sessions__c == null || currentForm.X32d14_Number_of_sessions__c == 0))
            {
                currentForm.X32d14_Number_of_sessions__c.addError (label.NDTRS_Intervention_Details_Check);
            }
            
        if (currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X32b15_Date_started__c != null && (currentForm.X32d15_Number_of_sessions__c == null || currentForm.X32d15_Number_of_sessions__c == 0))
            {
                currentForm.X32d15_Number_of_sessions__c.addError (label.NDTRS_Intervention_Details_Check);
            }
            
        if (currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X32b16_Date_started__c != null && (currentForm.X32d16_Number_of_sessions__c == null || currentForm.X32d16_Number_of_sessions__c == 0))
            {
                currentForm.X32d16_Number_of_sessions__c.addError (label.NDTRS_Intervention_Details_Check);
            }
            
        if (currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X32b17_Date_started__c != null && (currentForm.X32d17_Number_of_sessions__c == null || currentForm.X32d17_Number_of_sessions__c == 0))
            {
                currentForm.X32d17_Number_of_sessions__c.addError (label.NDTRS_Intervention_Details_Check);
            }
            
        if (currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X32b18_Date_started__c != null && (currentForm.X32d18_Number_of_sessions__c == null || currentForm.X32d18_Number_of_sessions__c == 0))
            {
                currentForm.X32d18_Number_of_sessions__c.addError (label.NDTRS_Intervention_Details_Check);
            }
            
        if (currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X32b19_Date_started__c != null && (currentForm.X32d19_Number_of_sessions__c == null || currentForm.X32d19_Number_of_sessions__c == 0))
            {
                currentForm.X32d19_Number_of_sessions__c.addError (label.NDTRS_Intervention_Details_Check);
            }
            
        if (currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X32b20_Date_started__c != null && (currentForm.X32d20_Number_of_sessions__c == null || currentForm.X32d20_Number_of_sessions__c == 0))
            {
                currentForm.X32d20_Number_of_sessions__c.addError (label.NDTRS_Intervention_Details_Check);
            }
            
        if (currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X32b21_Date_started__c != null && (currentForm.X32d21_Number_of_sessions__c == null || currentForm.X32d21_Number_of_sessions__c == 0))
            {
                currentForm.X32d21_Number_of_sessions__c.addError (label.NDTRS_Intervention_Details_Check);
            }
            
        if (currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X32b22_Date_started__c != null && (currentForm.X32d22_Number_of_sessions__c == null || currentForm.X32d22_Number_of_sessions__c == 0))
            {
                currentForm.X32d22_Number_of_sessions__c.addError (label.NDTRS_Intervention_Details_Check);
            }
            
        if (currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X32b23_Date_started__c != null && (currentForm.X32d23_Number_of_sessions__c == null || currentForm.X32d23_Number_of_sessions__c == 0))
            {
                currentForm.X32d23_Number_of_sessions__c.addError (label.NDTRS_Intervention_Details_Check);
            }
            
        if (currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X32b24_Date_started__c != null && (currentForm.X32d24_Number_of_sessions__c == null || currentForm.X32d24_Number_of_sessions__c == 0))
            {
                currentForm.X32d24_Number_of_sessions__c.addError (label.NDTRS_Intervention_Details_Check);
            }
    
        if (currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X32b25_Date_started__c != null && (currentForm.X32d25_Number_of_sessions__c == null || currentForm.X32d25_Number_of_sessions__c == 0))
            {
                currentForm.X32d25_Number_of_sessions__c.addError (label.NDTRS_Intervention_Details_Check);
            }
    
        if (currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X32b27_Date_started__c != null && (currentForm.X32d27_Number_of_sessions__c == null || currentForm.X32d27_Number_of_sessions__c == 0))
            {
                currentForm.X32d27_Number_of_sessions__c.addError (label.NDTRS_Intervention_Details_Check);
            }
    
        if (currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X32b28_Date_started__c != null && (currentForm.X32d28_Number_of_sessions__c == null || currentForm.X32d28_Number_of_sessions__c == 0))
            {
                currentForm.X32d28_Number_of_sessions__c.addError (label.NDTRS_Intervention_Details_Check);
            }
        
        if(currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X26_Age_first_use_any_drug__c == null)
            {
                currentForm.X26_Age_first_use_any_drug__c.addError (label.NDTRS_Rule_99);
            }
        
        if(currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && X27_Specify_first_drug_ever_used == null)
            {
                currentForm.X27_Specify_first_drug_ever_used__c.addError (label.NDTRS_Rule_99);
            }
        
        if(currentForm.X35_Date_of_Final_Discharge_or_transfer__c != null && currentForm.X28_Difficult_to_assess_main_problem__c == null)
            {
                currentForm.X28_Difficult_to_assess_main_problem__c.addError (label.NDTRS_Rule_99);
            }   
    }
    
    
    public void ValidationID_171a (NDTRS_Form_2016__c currentForm) // InterOutcome Q33a option 6, but text blank
    {   
        if  (currentForm.X33a_Exit_details__c != null && currentForm.X33a_Exit_details__c.startsWith('6.') && 
            currentForm.X33a6_Reason_for_exit_6_above__c == null)
        {
            currentForm.X33a6_Reason_for_exit_6_above__c.addError (label.NDTRS_Rule_171);
        }
    }
    
    public void ValidationID_171b (NDTRS_Form_2016__c currentForm) // InterOutcome Q33a option 10, but text blank
    {
        if  (currentForm.X33a_Exit_details__c != null && currentForm.X33a_Exit_details__c.startsWith('10.') && 
            currentForm.X33a10_Exit_detail_Other__c == null)
        {
            currentForm.X33a10_Exit_detail_Other__c.addError (label.NDTRS_Rule_171);
        }
    }   
    
    public void ValidationID_172 (NDTRS_Form_2016__c currentForm) // InterOutcome Q33a option 2 Client is transferred, but 33b is blank. 
    { 
        if  (currentForm.X33a_Exit_details__c != null && currentForm.X33a_Exit_details__c.startsWith('2.') && 
            currentForm.X33a2_Transfer_to_Centre__c == null)
        {
            currentForm.X33a2_Transfer_to_Centre__c.addError (label.NDTRS_Rule_172);
        }   
    }
    
    public void ValidationID_174 (NDTRS_Form_2016__c currentForm) // Exit Date cannot be blank if any of Q33a/33b/33c/34 are filled
    {
        if (currentForm.X35_Date_of_Final_Discharge_or_transfer__c == null && 
            (currentForm.X33a_Exit_details__c != null || currentForm.X33b_Number_of_others_involved__c != 0 || currentForm.X34_Client_s_Condition_on_discharge__c != null))
        
        {
            currentForm.X35_Date_of_Final_Discharge_or_transfer__c.addError (label.NDTRS_ExitDate);
        }
    }
    
    
}