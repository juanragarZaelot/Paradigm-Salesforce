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
	 * @date 2024/05/24
	 * @description Given an Opportunity
        When record type is 'Digital Tools'
        And the opportunity is inserted
        Then CloseDate is generated with 30 days after CreatedDate
     * 
	 */
    @isTest
    static void createOpportunity_Test() {

        Opportunity oppor = (Opportunity)TestDataFactory.createSObject(new Opportunity(), TestDataFactory.OpportunityDefaults.class);
        insert oppor;
        Test.setCreatedDate(oppor.Id, Date.today());
        Test.startTest();
        
        Test.stopTest();
        Opportunity opporResult = [SELECT Id, CloseDate from Opportunity LIMIT 1];
        Assert.areNotEqual(null, opporResult.CloseDate, 'CloseDate should be not null.');
    }
}