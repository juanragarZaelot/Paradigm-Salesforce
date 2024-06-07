/* 
  Created by Juan Ramirez, May 22/2024
 
  Purpose/Methods:
  - class to get all accounts and update Intacct Customer Id
 
 */
global class AccountBatch  implements Database.Batchable<SObject>{

    
    global Database.QueryLocator start(Database.BatchableContext context) {
        
        String query = 'SELECT Id,ia_crm__IntacctID__c, Intacct_Customer_Id__c, Name, Sponsored_by__c  from Account WHERE (Type = \'Billed Customer\' OR Type = \'Customer\') order by CreatedDate ';
		return Database.getQueryLocator(query);

    }

    global void execute(Database.BatchableContext context, List<Account> scope){

        for(Account acc: scope){
			if(acc.Intacct_Customer_Id__c == null && acc.ia_crm__IntacctID__c != null){
                acc.Intacct_Customer_Id__c = Decimal.valueOf(acc.ia_crm__IntacctID__c);
            }
        }
        Database.update(scope, false);

    }

    global void finish(Database.BatchableContext context) {
		
	 }
}