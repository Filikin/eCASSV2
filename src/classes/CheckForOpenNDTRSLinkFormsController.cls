/*
	Author: Eamon Kelly, Enclude
	Purpose: A client can only have one open NDTRS form
	Called from: NewNDTRSLinkForm which overrides the new NDTRS_Form_2016__c standard page
*/
public with sharing class CheckForOpenNDTRSLinkFormsController {
    public list<NDTRS_Form_2016__c>openForms {get;set;}
    
    public CheckForOpenNDTRSLinkFormsController(ApexPages.StandardController controller) 
    {
    }
    
    public pageReference countOpenForms ()
    {
        Schema.DescribeSObjectResult dsr = NDTRS_Form_2016__c.SObjectType.getDescribe();
        try
        {
            // find the ID from the parameters
            ID contactID = null;
            map<String,String> parametersMap = ApexPages.currentPage().getParameters();
            for (String oneKey: parametersMap.keySet())
            {
                if (oneKey.contains('_lkid'))
                {
                    contactID = (ID)parametersMap.get(oneKey);
                    break;
                }
            }
            openForms = [SELECT Id, Name FROM NDTRS_Form_2016__c where X35_Date_of_Final_Discharge_or_transfer__c = null and Contact__c = :contactID Limit 100];
            if (openForms.size() > 0)
            {
                String msg = Label.NDTRS_Link_Form_Open_Msg;
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, msg);
                ApexPages.addMessage(myMsg);
                return null;
            }       
            else
            {
                Contact client = [select Name, Initials__c from Contact where ID = :contactID limit 1];
                String nameTemplate = AppConfigSupport.HRBFormNameTemplate;
                
                String tempName = nameTemplate.replace('$NAME$', client.Name).replace('$DATE$', '').replace('$INITIALS$', client.Initials__c);
                
                PageReference newNDTRSLinkFormPage = new PageReference('/' + dsr.getKeyPrefix() + '/e?nooverride=1&Name=' + tempName);
                newNDTRSLinkFormPage.setRedirect(true);
                newNDTRSLinkFormPage.getParameters().putall(parametersMap);
                String url = newNDTRSLinkFormPage.getUrl();
                url = url.remove('&save_new=1');
                return new PageReference (url);
             }
        }
        catch (Exception e)
        {
            // page not called from the contact page, so just show the normal new Form page
            PageReference newNDTRSLinkFormPage = new PageReference('/' + dsr.getKeyPrefix() + '/e?nooverride=1');
            newNDTRSLinkFormPage.setRedirect(true);
            return newNDTRSLinkFormPage;
        }       
    }
}