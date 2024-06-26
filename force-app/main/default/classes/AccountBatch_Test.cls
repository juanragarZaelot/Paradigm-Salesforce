/* 
  Created by Juan Ramirez, May 22/2024
 
  Purpose/Methods:
  - class to process all unit test about AccountBatch
 
 */
@isTest
public class AccountBatch_Test {

    @TestSetup
    public static void loadData() {
        Account acc = (Account)TestDataFactory.createSObject(new Account(), TestDataFactory.CustomerAccountsDefaults.class);
        acc.ia_crm__IntacctID__c = '1';
        insert acc;

        acc.Intacct_Customer_Id__c = null;
        update acc;
        
    }

    @isTest
    public static void batch_Test() {
        Test.startTest();
        AccountBatch b = new AccountBatch();
        ID batchprocessid = Database.executeBatch(b);
        Test.stopTest();
        Account acc = [SELECT Id, Intacct_Customer_Id__c from Account LIMIT 1];
        Assert.isTrue(acc.Intacct_Customer_Id__c != null, 'Intacct Customer Id should has a value.');

    }
}