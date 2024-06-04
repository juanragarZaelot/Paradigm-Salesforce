/* 
  Created by Juan Ramirez, May 24/2024

    @Purpose/Methods:
    Process to manage all unit test about the flow to get maximun value from account to assign it to Intacct Customer Id field
    (Account_Track_Progress) 
*/
@isTest
public class FlowAccountTrackProgress_Test {

    /**
	 * @author Juan Ramirez
	 * @date 2024/05/24
	 * @description Given an Account
        When record type is 'Customer Accounts'
        And Type is 'Customer'
        And the account is inserted
        Then Intacct_Customer_Id__c is generated with the max value available
     * 
	 */
    @isTest
    public static void createAccount_Test() {

        Test.startTest();
        Account acc = (Account)TestDataFactory.createSObject(new Account(), TestDataFactory.CustomerAccountsDefaults.class);
        insert acc;
        Test.stopTest();
        Account accResult = [SELECT Id, Intacct_Customer_Id__c from Account LIMIT 1];
        Assert.areEqual(1, accResult.Intacct_Customer_Id__c, 'Intacct Customer Id should be the maximum available.');
    }

    /**
	 * @author Juan Ramirez
	 * @date 2024/05/24
	 * @description Given an Account
        When record type is 'Customer Accounts'
        And Type is 'Prospect'
        And the account is updated to 'Customer' Type 
        Then Intacct_Customer_Id__c is generated with the max value available
     * 
	 */
    @isTest
    public static void updateAccount_Test() {

        
        Account acc = (Account)TestDataFactory.createSObject(new Account(), TestDataFactory.CustomerAccountsDefaults.class);
        acc.Type = 'Prospect';
        insert acc;

        
        Test.startTest();
        acc.Type = 'Customer';
        update acc;
        Test.stopTest();
        Account accResult = [SELECT Id, Intacct_Customer_Id__c from Account LIMIT 1];
        Assert.areEqual(1, accResult.Intacct_Customer_Id__c, 'Intacct Customer Id should be the maximum available.');
    }
}