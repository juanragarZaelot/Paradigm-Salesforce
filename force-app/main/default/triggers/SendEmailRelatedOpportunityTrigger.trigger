trigger SendEmailRelatedOpportunityTrigger on Send_Email_Related_Opportunity__e (after insert) {
    for (Send_Email_Related_Opportunity__e event : Trigger.New) {

        EmailHelper.sendEmailByEmailTemplate(event.Email_Template_Dev_Name__c, event.Contact_Id__c, event.Opportunity_Id__c, event.Email__c, event.Owner_Name__c, event.Email_From__c);
    }
}