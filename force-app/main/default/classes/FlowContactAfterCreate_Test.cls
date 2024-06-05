/* 
  Created by Juan Ramirez, June 04/2024

    @Purpose/Methods:
    Process to manage all unit test about the flow fired after a contact is created
    (Contact_After_Create) 
*/
@isTest
private class FlowContactAfterCreate_Test {

    @isTest
    static void convertLead_Test() {
        
        Contact con = (Contact)TestDataFactory.createSObject(new Contact(), TestDataFactory.ContactDefaults.class);
        insert con;

        Test.startTest();
        con.Lead_Date__c = true;
        con.LeadSource = 'Website - BLDR.com';
        update con;
        Test.stopTest();

        Contact conResult = [SELECT Id, LeadSource from Contact WHERE Id = :con.Id];
        Assert.areEqual('Portal - MyBFSBuilder', conResult.LeadSource, 'Lead Source should not change.');
    }
}