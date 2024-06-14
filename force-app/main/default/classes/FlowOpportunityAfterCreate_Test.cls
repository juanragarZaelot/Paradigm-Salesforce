/* 
  Created by Juan Ramirez, May 29/2024

    @Purpose/Methods:
    Process to manage all unit test about the flow fired after a Opportunity is created
    (Opportunity_After_Create) 
*/
@isTest
private class FlowOpportunityAfterCreate_Test {

    /**
	 * @author Juan Ramirez
	 * @date 2024/06/12
	 * @description Given an Opportunity
        When record type is 'Digital Tools'
        And StageName is 'Lead'
        And the opportunity is inserted
        Then a Task is generated with Due Date as today
     * 
	 */
    @isTest
    static void convertOpportunityLeadStage_Test() {

        Test.startTest();
        Opportunity oppor = (Opportunity)TestDataFactory.createSObject(new Opportunity(), TestDataFactory.OpportunityDefaults.class);
        oppor.StageName = 'Lead';
        insert oppor;
        Test.stopTest();

        Task taskResult = [SELECT Id, ActivityDate from Task WHERE WhatId = :oppor.Id LIMIT 1];
        Assert.areEqual(Date.today(), taskResult.ActivityDate, 'Task due date should be as today.');
    }

    /**
	 * @author Juan Ramirez
	 * @date 2024/06/12
	 * @description Given an Opportunity
        When record type is 'Digital Tools'
        And StageName is 'Meeting Set'
        And the opportunity is inserted
        Then two Tasks are generated
     * 
	 */
    @isTest
    static void convertOpportunityMeetingSetStage_Test() {

        Test.startTest();
        Opportunity oppor = (Opportunity)TestDataFactory.createSObject(new Opportunity(), TestDataFactory.OpportunityDefaults.class);
        oppor.StageName = 'Meeting Set';
        oppor.Meeting_Set_Date__c = Date.today();
        insert oppor;
        Test.stopTest();

        List<Task> taskResult = [SELECT Id, ActivityDate from Task WHERE WhatId = :oppor.Id];
        Assert.areEqual(2, taskResult.size(), 'It should create two tasks.');
    }

    /**
	 * @author Juan Ramirez
	 * @date 2024/06/12
	 * @description Given an Opportunity
        When record type is 'Digital Tools'
        And StageName is 'Meeting Complete'
        And the opportunity is inserted
        Then a Task is generated with Due Date 3 days after the opportunity was converted
     * 
	 */
    @isTest
    static void convertOpportunityMeetingCompleteStage_Test() {

        Test.startTest();
        Opportunity oppor = (Opportunity)TestDataFactory.createSObject(new Opportunity(), TestDataFactory.OpportunityDefaults.class);
        oppor.StageName = 'Meeting Complete';
        oppor.Meeting_Date_Completed__c = Date.today();
        insert oppor;
        Test.stopTest();

        Task taskResult = [SELECT Id, ActivityDate from Task WHERE WhatId = :oppor.Id LIMIT 1];
        Assert.areEqual(Date.today() + 3, taskResult.ActivityDate, 'Task due date should be 3 days after the opportunity was converted.');
    }

    /**
	 * @author Juan Ramirez
	 * @date 2024/06/12
	 * @description Given an Opportunity
        When record type is 'Digital Tools'
        And StageName is 'Closed Won'
        And the opportunity is inserted
        Then a Task is generated with Due Date 14 days after the opportunity was converted
     * 
	 */
    @isTest
    static void convertOpportunityCloseWonStage_Test() {

        Test.startTest();
        Opportunity oppor = (Opportunity)TestDataFactory.createSObject(new Opportunity(), TestDataFactory.OpportunityDefaults.class);
        oppor.StageName = 'Closed Won';
        insert oppor;
        Test.stopTest();

        Task taskResult = [SELECT Id, ActivityDate from Task WHERE WhatId = :oppor.Id LIMIT 1];
        Assert.areEqual(Date.today() + 14, taskResult.ActivityDate, 'Task due date should be 14 days after the opportunity was converted.');
    }

     /**
	 * @author Juan Ramirez
	 * @date 2024/06/12
	 * @description Given an Opportunity
        When record type is 'Digital Tools'
        And StageName is 'Delivered'
        And the opportunity is inserted
        Then a Task is generated with Due Date 5 days after the opportunity was converted
     * 
	 */
    @isTest
    static void convertOpportunityDeliveredStage_Test() {

        Test.startTest();
        Opportunity oppor = (Opportunity)TestDataFactory.createSObject(new Opportunity(), TestDataFactory.OpportunityDefaults.class);
        oppor.StageName = 'Delivered';
        insert oppor;
        Test.stopTest();

        Task taskResult = [SELECT Id, ActivityDate from Task WHERE WhatId = :oppor.Id LIMIT 1];
        Assert.areEqual(Date.today() + 5, taskResult.ActivityDate, 'Task due date should be 5 days after the opportunity was converted.');
    }
}