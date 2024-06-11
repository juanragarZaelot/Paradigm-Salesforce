@isTest 

private class testCreateAssetonClosedWon {
	
	@isTest
	public static void createAssetonClosedWon_Test(){
		
		Account acc = (Account)TestDataFactory.createSObject(new Account(), TestDataFactory.CustomerAccountsDefaults.class);
        insert acc;

        Opportunity oppor = (Opportunity)TestDataFactory.createSObject(new Opportunity(), TestDataFactory.OpportunityOmmniDefaults.class);
		oppor.AccountId = acc.Id;
        insert oppor;

		Product2 product = (Product2)TestDataFactory.createSObject(new Product2(), TestDataFactory.Product2Defaults.class);
        insert product;

		Id pricebookId = Test.getStandardPricebookId();
        
		PricebookEntry priceBookEntryStandard = (PricebookEntry)TestDataFactory.createSObject(new PricebookEntry(), TestDataFactory.PricebookEntryDefaults.class);
		priceBookEntryStandard.Pricebook2Id = pricebookId;
		priceBookEntryStandard.Product2Id = product.Id;
        insert priceBookEntryStandard;

		Pricebook2 priceBook = (Pricebook2)TestDataFactory.createSObject(new Pricebook2(), TestDataFactory.Pricebook2Defaults.class);
        insert priceBook;

		PricebookEntry priceBookE = (PricebookEntry)TestDataFactory.createSObject(new PricebookEntry(), TestDataFactory.PricebookEntryDefaults.class);
		priceBookE.Pricebook2Id = priceBook.Id;
		priceBookE.Product2Id = product.Id;
        insert priceBookE;

		OpportunityLineItem opporLineItem = (OpportunityLineItem)TestDataFactory.createSObject(new OpportunityLineItem(), TestDataFactory.OpportunityLineItemDefaults.class);
        opporLineItem.OpportunityId = oppor.Id;
		opporLineItem.PricebookEntryId = priceBookE.Id;
		insert opporLineItem;

		Test.startTest();

		oppor.StageName= 'Closed Won';
		update oppor;
		
		delete opporLineItem;
		delete oppor;
		
		Test.stopTest();

		List<Opportunity> oppList = [SELECT name FROM Opportunity];

		Assert.areEqual(0,oppList.size(), 'It should not get any Opportunity');
		
	}
	
	
}