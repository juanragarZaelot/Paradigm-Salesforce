/* 
  Created by Juan Ramirez, March 15/2024

    @Purpose/Methods:
    Process to manage all unit test about the flow to get maximun value from account to assign it to Intacct Customer Id field
    (Account_Track_Progress) 
*/
@isTest
public class FlowAccountTrackProgress {

    @isTest
    public static void createAccount_Test() {

        Test.startTest();
        Account acc = (Account)TestDataFactory.createSObject(new Account(), TestDataFactory.CustomerAccountsDefaults.class);
        insert acc;
        Test.stopTest();
        Account accResult = [SELECT Id, Intacct_Customer_Id__c from Account LIMIT 1];
        Assert.areEqual(1, accResult.Intacct_Customer_Id__c, 'Intacct Customer Id should be the maximum available.');
    }
}