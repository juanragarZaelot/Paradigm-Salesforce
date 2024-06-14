/* 
  Created by Juan Ramirez, June 13/2024
 
  Purpose/Methods:
  - class to process all unit test about EmailHelper
 
 */
@isTest
private class EmailHelper_Test {


    @TestSetup
    public static void loadData() {
        Account acc = (Account)TestDataFactory.createSObject(new Account(), TestDataFactory.CustomerAccountsDefaults.class);
        insert acc;

        Contact con = (Contact)TestDataFactory.createSObject(new Contact(), TestDataFactory.ContactDefaults.class);
        insert con;
        
        User u = (User)TestDataFactory.createSObject(new User(), TestDataFactory.UserAdminDefaults.class);
        insert u;
        
        Opportunity oppor = (Opportunity)TestDataFactory.createSObject(new Opportunity(), TestDataFactory.OpportunityDefaults.class);
        oppor.StageName = 'Lead';
        oppor.AccountId = acc.Id;
        oppor.ContactId = con.Id;
        oppor.OwnerId = u.Id;
        insert oppor;
        
    }

    /**
	 * @author Juan Ramirez
	 * @date 2024/06/13
	 * @description Given a opportunity related to an account and contact with a specific email
        When Record Type is Digital Tools
        Then it sends an email
     *
	 */
    @isTest
    public static void sendEmailByEmailTemplateTest() {
        
        Opportunity oppor = [SELECT Id, Owner.Email, Owner.Name,contactId from Opportunity LIMIT 1];

        Test.startTest();
        
		String opportunityId = oppor.Id;
		String email = oppor.Owner.Email;
		String contactId = oppor.ContactId;
		String emailTemplateDevName = 'Opportunity_Lead_Stage_Intro';
		String ownerName = oppor.Owner.Name;
		EmailHelper.sendEmailByEmailTemplate(emailTemplateDevName, contactId, opportunityId, email, ownerName, ''); 

        Test.stopTest();
        List<EmailMessage> emailMessageList = [SELECT Id, FromAddress from EmailMessage];
        Assert.isTrue(!emailMessageList.isEmpty(), 'An email should have been sent');
        
    }

	/**
	 * @author Juan Ramirez
	 * @date 2024/06/13
	 * @description Given a opportunity
        When Record Type is Digital Tools
        And ContactId is null
        Then it sends an email
     *
	 */
    @isTest
    public static void sendEmailByEmailTemplateNoAccount_Test() {

		
        
        Opportunity oppor = [SELECT Id, Owner.Email, Owner.Name,contactId from Opportunity LIMIT 1];

        Test.startTest();
		
		String opportunityId = oppor.Id;
		String email = oppor.Owner.Email;
		String contactId = null;
		String emailTemplateDevName = 'Opportunity_Lead_Stage_Intro';
		String ownerName = oppor.Owner.Name;
		EmailHelper.sendEmailByEmailTemplate(emailTemplateDevName, contactId, opportunityId, email, ownerName, ''); 


        Test.stopTest();
        List<EmailMessage> emailMessageList = [SELECT Id, FromAddress from EmailMessage];
        Assert.isTrue(!emailMessageList.isEmpty(), 'An email should have been sent');
        
    }
}