@isTest 

private class testCreateAssetonClosedWon {
	
	static testMethod void testCreateAssetonClosedWon(){
		
		Account a = [select Id from Account limit 1];
		PricebookEntry pbID = [select Id from PricebookEntry limit 1];
		Opportunity o = new Opportunity();
		OpportunityLineItem ol = new OpportunityLineItem();
		
		o.AccountId = a.Id;
		o.Name = 'test';
		o.StageName = 'Prospecting';
		o.CloseDate = date.today();
		insert o;
		
		ol.OpportunityId = o.Id;
		ol.Quantity = 1;
		ol.UnitPrice = 2.00;
		ol.PricebookEntryId = pbId.Id;
		
		insert ol;
		
		o.StageName= 'Closed Won';
		update o;
		
		delete ol;
		delete o;
		
		
		
	}
	
	
}