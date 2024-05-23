/* 
  Created by Juan Ramirez, May 22/2024
 
  Purpose/Methods:
  - class to get all accounts and update Intacct Customer Id
 
 */
global class AccountBatch  implements Database.Batchable<SObject>, Database.Stateful{

    global Decimal rowNumber = 1;
    
    global Database.QueryLocator start(Database.BatchableContext context) {
        
        String query = 'SELECT Id,ia_crm__IntacctID__c, Intacct_Customer_Id__c, Name, Sponsored_by__c  from Account order by CreatedDate ';
		return Database.getQueryLocator(query);

    }

    global void execute(Database.BatchableContext context, List<Account> scope){

        for(Account acc: scope){
			acc.Intacct_Customer_Id__c = rowNumber;
            rowNumber++;
        }
        Database.update(scope, false);

    }

    global void finish(Database.BatchableContext context) {
		
	 }
}