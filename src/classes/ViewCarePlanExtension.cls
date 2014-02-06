/*
	Author: Eamon Kelly, Enclude
	Purpose: additions to the care plan to support care care plan domains - each care plan objective can be part of one of six care plan domains
	Called from CarePlanOverview  - a version of the care plan that groups the objectives by domain
*/

public with sharing class ViewCarePlanExtension 
{
    public List<Care_Plan_Objective__c> carePlanGoalsAdmin {get;set;}
    public List<Care_Plan_Objective__c> carePlanGoalsDrugAlcoholUse {get;set;}
    public List<Care_Plan_Objective__c> carePlanGoalsPhysical {get;set;}
    public List<Care_Plan_Objective__c> carePlanGoalsLegal {get;set;}
    public List<Care_Plan_Objective__c> carePlanGoalsSocial {get;set;}
    public List<Care_Plan_Objective__c> carePlanGoalsRisk {get;set;}
    
    ID recordID;
    String recordName;
    public String CaseManager {get;set;}

	public Boolean showInternal {get;set;}
	
	public ViewCarePlanExtension (ApexPages.StandardController controller) 
    {
        sObject con = controller.getRecord();
        recordID = con.id;
        Contact client = [select Name, Counsellor__r.Name from Contact where id = :con.id];
        if (client != null)
        {
            recordName = client.Name;
            CaseManager = client.Counsellor__r.Name;
        }
 
        carePlanGoalsAdmin = getCarePlanGoals ('Care Plan Administration');
        carePlanGoalsDrugAlcoholUse = getCarePlanGoals ('Drug & Alcohol Use');
        carePlanGoalsPhysical = getCarePlanGoals ('Physical & Psychological Problems');
        carePlanGoalsLegal = getCarePlanGoals ('Legal Problems');
        carePlanGoalsSocial = getCarePlanGoals ('Social Functioning');
        carePlanGoalsRisk = getCarePlanGoals ('Risk Assessment');
     }
    
    private List <Care_Plan_Objective__c> getCarePlanGoals (String area)
    {
         List <Care_Plan_Objective__c>carePlanObjectives = [SELECT ID, Name, Latest_Outcome__c, Outcome__c, Objective_and_Timescale__c, Date_objective_set__c, Next_Review_Date__c, 
         	Date_completed__c, Objective_Status__c, How_will_progress_be_measured__c, Tools_used__c, Lead_Agency_name__c,
	         (SELECT ID, Name, Description__c, Person_Responsible_for_Action__c, Date__c, Status__c, Status_Comment__c
	          FROM Care_plan_steps__r order by Date__c DESC, Description__c DESC)
              FROM Care_Plan_Objective__c 
              where Client__c = :recordID and Area__c = :area and (Objective_Status__c = 'In Progress' or Objective_Status__c = 'Draft' or Objective_Status__c = 'Blocked') 
              order by CreatedDate DESC, Date_objective_set__c DESC, Name DESC];
        
   		return carePlanObjectives;
    }
    
    public PageReference printCarePlan ()
	{
		PageReference pdf = new PageReference ('/apex/' +  AppConfigSupport.CarePlanOverviewPrintPage);
		return pdf;
	}
	
    public static testMethod void testViewCarePlan()
    {
        Contact youngPerson = new Contact (LastName = 'Kelly');
        insert youngPerson;
        
        Care_Plan_Objective__c careplan = new Care_Plan_Objective__c (Name='Improve welbeing', Client__c=youngPerson.id, Area__c = 'Drug & Alcohol Use',Objective_Status__c = 'In Progress');
        insert careplan;
        
        Event e1 = new Event (WhoID=youngPerson.id, OwnerID=UserInfo.getUserId(), WhatID=careplan.id, Subject='Test', StartDateTime=DateTime.newInstance(2012,1,5,12,30,30), EndDateTime=DateTime.newInstance(2012,1,5,13,30,30));
        insert e1;
        
        Integer carePlanSteps = [select count() from Care_plan_step__c where Reference__c != null];
        system.assertEquals(1, carePlanSteps);
        
        ApexPages.StandardController contactController = new ApexPages.StandardController(youngPerson);
        ViewCarePlanExtension vc = new ViewCarePlanExtension (contactController);
        vc.printCarePlan();
    }
}