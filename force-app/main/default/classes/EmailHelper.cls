
/* 
  Created by Juan Ramirez, June 13/2024
 
  Purpose/Methods:
  - class to manage the functionality to send emails
 
 */
public class EmailHelper {

    /*
     * @author Juan Ramirez
     * @date 2024/06/13
     * @description method to send an email called from platform event trigger
     * @param emailTemplateDevName email template name to find it
     * @param contactId Id of contact related to the Case or Account
     * @param opportunityId Id of the opportunity
     * @param email email of the opportunity used to send the email
	 * @param ownerName name of the owner used to send the email. It's the name of the user
     * @param emailFrom name of Organization-Wide Addresses
	 */
	
	 public static void sendEmailByEmailTemplate(String emailTemplateDevName, String contactId, String opportunityId, String email, String ownerName, String emailFrom) {
		
		EmailTemplate emailTemp = new EmailTemplate();
		List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
		try{
			String templateName = emailTemplateDevName + '%';
			Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
			
			List<EmailTemplate> emailTemplateList = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body 
			from EmailTemplate where DeveloperName LIKE :templateName ORDER BY DeveloperName];
			if(emailTemplateList.size() == 0) {
				return;
			}
			emailTemp = emailTemplateList.get(0);
            if(!Test.isRunningTest()){
				OrgWideEmailAddress[] owea = [SELECT Id FROM OrgWideEmailAddress WHERE Address = :emailFrom LIMIT 1];
				message.setOrgWideEmailAddressId(owea.get(0)?.Id); 
			}
			if(contactId != null && contactId != ''){
				Messaging.reserveSingleEmailCapacity(2);
				message.setTargetObjectId(Id.valueOf(contactId));
				message.setTemplateID(emailTemp.Id);
				
			} else {
				message.setHtmlBody(emailTemp.HtmlValue.replace('{{{Opportunity.Opportunity_Owner_Text__c}}}', ownerName).replace('{{{Opportunity.Id}}}', opportunityId).replace('{{{Opportunity.ContactId}}}', ''));
                message.setSubject(emailTemp.Subject.replace('{{{Opportunity.Id}}}', opportunityId));
                
			}
			message.setWhatId(Id.valueOf(opportunityId));
			message.setBccSender(false);
			message.setUseSignature(false);
            message.setSaveAsActivity(false);
            message.toAddresses = new String[] { email};
			messages = new List<Messaging.SingleEmailMessage> {message};
			Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
    		
		} catch (Exception e) {
			System.debug('Failed to Send Email emailId: ' + emailTemp.Id + ' |  emailName: ' + emailTemplateDevName + ' |  contactId: ' + contactId + ' | opportunityId ' + opportunityId + ' | Email '+ email + ' | Owber Name '+ ownerName + ' | Error: '+ e.getMessage() + ' ' + e.getStackTraceString() + ' Email object: ' + JSON.serializePretty(messages));
			
		}
	
	}
    
}