/* 
  Created by Juan Ramirez, June 06/2024
 
  Purpose/Methods:
  - class to get all campaign members and Leads without campaign assigned and update Campaign field
 
 */
global class CampaignMemberUpdateLeadBatch implements Database.Batchable<SObject>{

    
    global Database.QueryLocator start(Database.BatchableContext context) {
        
        String query = 'SELECT Id, CampaignId, LeadId, Lead.Campaign__c, Status  from CampaignMember Where Lead.Campaign__c = null';
		return Database.getQueryLocator(query);

    }

    global void execute(Database.BatchableContext context, List<CampaignMember> scope){

        List<Lead> leadList = new List<Lead>();
        for(CampaignMember member: scope){
			Lead l = new Lead();
            l.Campaign__c = member.CampaignId;
            l.Id = member.LeadId;
            leadList.add(l);
        }
        Database.update(scope, false);

    }

    global void finish(Database.BatchableContext context) {
		
	 }
    
}