/* 
  Created by Juan Ramirez, June 07/2024

    @Purpose/Methods:
    Process to manage all unit test about the flow fired before a Opportunity is created
    (Opportunity_Before_Create) 
*/
@isTest
private class FlowOpportunityBeforeCreate_Test {
    private final static Paradigm_Config__mdt PRICE_BOOK_DIGITAL_TOOLS = Paradigm_Config__mdt.getInstance('Price_Book_Digital_Tools');
    @isTest
    static void createOpportunity_Test() {
        Opportunity oppor = (Opportunity)TestDataFactory.createSObject(new Opportunity(), TestDataFactory.OpportunityDefaults.class);
        insert oppor;
        Test.startTest();
        
        Test.stopTest();
        Opportunity opporResult = [SELECT Id, Pricebook2Id from Opportunity LIMIT 1];
        Assert.areEqual(PRICE_BOOK_DIGITAL_TOOLS.Value__c, opporResult.Pricebook2Id, 'Opportunity Price Book should be Digital Tools.');
    }
}