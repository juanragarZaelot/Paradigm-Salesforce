/* 
  Created by Juan Ramirez, June 06/2024

    @Purpose/Methods:
    Process to manage all unit test about Campaign member update lead batch
*/
@isTest
private class CampaignMemberUpdateLeadBatch_Test {


    @TestSetup
    public static void loadData() {
        Campaign cam = (Campaign)TestDataFactory.createSObject(new Campaign(), TestDataFactory.CampaignDefaults.class);
        insert cam;

        Lead lea = (Lead)TestDataFactory.createSObject(new Lead(), TestDataFactory.LeadDefaults.class);
        insert lea;

        CampaignMember member = (CampaignMember)TestDataFactory.createSObject(new CampaignMember(), TestDataFactory.CampaignMemberDefaults.class);
        member.CampaignId = cam.Id;
        member.LeadId = lea.Id;
        insert member;
        
    }

    @isTest
    static void batch_Test() {
        Test.startTest();
        CampaignMemberUpdateLeadBatch b = new CampaignMemberUpdateLeadBatch();
        ID batchprocessid = Database.executeBatch(b);
        Test.stopTest();
        Lead leadResult = [SELECT Id, Campaign__c from Lead LIMIT 1];
        Assert.isTrue(leadResult.Campaign__c != null, 'Campaign should has a value.');
    }
}