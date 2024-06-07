/* 
  Created by Juan Ramirez, June 06/2024
 
  Purpose/Methods:
  - class to get all campaign members and Leads without campaign assigned and update Campaign field
 
 */
global class CampaignMemberUpdateLeadBatch implements Database.Batchable<SObject>{

    
    global Database.QueryLocator start(Database.BatchableContext context) {
        
        String query = 'SELECT Id, CampaignId, LeadId, Lead.Campaign__c,Lead.LeadSource, Lead.Status,Lead.Company, Lead.FirstName, Lead.LastName, Lead.Title, Lead.Address from CampaignMember Where CampaignId != null AND LeadId !=null order by CreatedDate';
		return Database.getQueryLocator(query);

    }

    global void execute(Database.BatchableContext context, List<CampaignMember> scope){

        Map<Id, Lead> leadsMap = new Map<Id, Lead>();
        
        for(CampaignMember member: scope){
            
            Lead l = new Lead();
            l.Campaign__c = member.CampaignId;
            l.Id = member.LeadId;
            l.LeadSource = member.Lead.LeadSource;
            l.Status = member.Lead.Status;
            l.Company = member.Lead.Company;
            l.FirstName = member.Lead.FirstName;
            l.LastName = member.Lead.LastName;
            l.Title = member.Lead.Title;
            leadsMap.put(member.LeadId, l);
        }
        Database.update(leadsMap.values(), false);

    }

    global void finish(Database.BatchableContext context) {
		
	 }
    
}