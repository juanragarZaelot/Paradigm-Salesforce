/* 
  Created by Juan Ramirez, June 07/2024

    @Purpose/Methods:
    Process to manage all unit test about the flow fired after a campaign Member is deleted
    (Campaign_Member_Before_Delete) 
*/
@isTest
private class FlowCampaignMemberBeforeDelete_Test {

    @isTest
    static void deleteCampaignMember_Test() {
        Campaign cam = (Campaign)TestDataFactory.createSObject(new Campaign(), TestDataFactory.CampaignDefaults.class);
        insert cam;

        Lead lea = (Lead)TestDataFactory.createSObject(new Lead(), TestDataFactory.LeadDefaults.class);
        insert lea;
        
        CampaignMember member = (CampaignMember)TestDataFactory.createSObject(new CampaignMember(), TestDataFactory.CampaignMemberDefaults.class);
        member.CampaignId = cam.Id;
        member.LeadId = lea.Id;
        insert member;

        Test.startTest();
        delete member;
        Test.stopTest();

        Lead leadResult = [SELECT Id, Campaign__c from Lead WHERE Id = :lea.Id];
        Assert.areEqual(null, leadResult.Campaign__c, 'Lead Campaign should be null.');
    }
}