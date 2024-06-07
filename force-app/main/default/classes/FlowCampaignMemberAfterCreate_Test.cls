/* 
  Created by Juan Ramirez, June 07/2024

    @Purpose/Methods:
    Process to manage all unit test about the flow fired after a campaign Member is created
    (Campaign_Member_After_Create) 
*/
@isTest
private class FlowCampaignMemberAfterCreate_Test {

    @isTest
    static void createCampaignMember_Test() {
        Campaign cam = (Campaign)TestDataFactory.createSObject(new Campaign(), TestDataFactory.CampaignDefaults.class);
        insert cam;

        Lead lea = (Lead)TestDataFactory.createSObject(new Lead(), TestDataFactory.LeadDefaults.class);
        insert lea;
        Test.startTest();
        CampaignMember member = (CampaignMember)TestDataFactory.createSObject(new CampaignMember(), TestDataFactory.CampaignMemberDefaults.class);
        member.CampaignId = cam.Id;
        member.LeadId = lea.Id;
        insert member;
        Test.stopTest();

        Lead leadResult = [SELECT Id, Campaign__c from Lead WHERE Id = :lea.Id];
        Assert.areEqual(cam.Id, leadResult.Campaign__c, 'Lead Campaign should be Campaign Id.');
    }
}