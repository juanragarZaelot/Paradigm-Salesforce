@isTest
public with sharing class TestDataFactory {

    public class TestDataFactoryException extends Exception {
    }

    // Use the FieldDefaults interface to set up values you want to default in for all objects.
    /***************************************************************************/
    public interface IFieldDefaults {
        Map<Schema.SObjectField, Object> getFieldDefaults();
    }

    /*
    * When no Default Class is specified, the default will be the ObjectName + Defaults
    */
    public static SObject createSObject(SObject sObj) {
        // Check what type of object we are creating and add any defaults that are needed.
        String objectName = String.valueOf(sObj.getSObjectType());

        // Construct the default values class. Salesforce doesn't allow '__' in class names
        objectName = objectName.replace('__c', '');
        objectName = objectName.replace('__', '_'); // get the manage packages

        String defaultClassName = 'TestDataFactory.' + objectName + 'Defaults';
        // If there is a class that exists for the default values, then use them
        Type defaultCLS = Type.forName(defaultClassName);

        sObj = createSObject(sObj, defaultCLS);
        return sObj;
    }

    /*
    * Add Default field on the DefaultClass to the object
    * The DefaultClass is expected to be an implementation of IFieldDefault
    */
    public static SObject createSObject(SObject sObj, Type defaultClass) {
        IFieldDefaults defaults = (IFieldDefaults) defaultClass.newInstance();
        addFieldDefaults(sObj, defaults.getFieldDefaults());
        return sObj;
    }

    public static SObject createSObject(SObject sObj, String className) {
        String defaultClassName = 'TestDataFactory.' + className;
        // If there is a class that exists for the default values, then use them
        Type defaultClass = Type.forName(defaultClassName);

        IFieldDefaults defaults = (IFieldDefaults) defaultClass.newInstance();
        addFieldDefaults(sObj, defaults.getFieldDefaults());
        return sObj;
    }

    public static SObject[] createSObjectList(Sobject sObj, Integer numberOfObjects) {
        return createSObjectList(sObj, numberOfObjects, null);
    }

    public static SObject[] createSObjectList(Sobject sObj, Integer numberOfObjects, Type defaultClass) {
        SObject[] sObjs = new SObject[]{
        };
        SObject newObj;

        // Get one copy of the object
        if (defaultClass == null) {
            newObj = createSObject(sObj);
        } else {
            newObj = createSObject(sObj, defaultClass);
        }

        // Get the name field for the object
        String nameField = nameFieldMap.get(sObj.getSObjectType());
        if (nameField == null) {
            nameField = 'Name';
        }

        // Clone the object the number of times requested. Increment the name field so each record is unique
        for (Integer i = 0; i < numberOfObjects; i++) {
            SObject clonedSObj = newObj.clone(false, true);

            clonedSObj.put(nameField, (String) clonedSObj.get(nameField) + '' + i);

            sObjs.add(clonedSObj);
        }
        return sObjs;
    }

    private static void addFieldDefaults(SObject sObj, Map<SObjectField, Object> defaults) {
        // Loop through the map of fields and if they are null on the object, fill them.
        for (SObjectField field : defaults.keySet()) {
            if (sObj.get(field) == null) {
                sObj.put(field, defaults.get(field));
            }
        }
    }

    /**
    * This list need to have a entry per object, what its the field that should be changed when creating multiple records
    * For instance for contact the "LastName" should variate ==> LastName1, LastName2, LastName3, etc
    */
    private static Map<SObjectType, String> nameFieldMap = new Map<SObjectType, String>{
            Contact.SObjectType => 'LastName',
            Account.SObjectType => 'LastName',
            Case.SObjectType => 'Subject',
            User.SObjectType => 'Username'
    };

    /*************************************************************************************
     * 
     *  DEFAULTS
     * 
     * ********************************************************************************/

     public class CustomerAccountsDefaults implements IFieldDefaults {
        public Map<SObjectField, Object> getFieldDefaults() {
            
            String recTypeId = [SELECT Id FROM RecordType WHERE Name = 'Customer Accounts' AND SObjectType = 'Account'].Id;
            return new Map<SObjectField, Object>{
                    Account.Name => 'Test Name',
                    Account.Account_Nickname__c => 'Test Nickname',
                    Account.AccountNumber => '123456789',
                    Account.RecordTypeId => recTypeId,
                    Account.Type => 'Customer'
            };
        }
    }

    public class OpportunityDefaults implements IFieldDefaults {
        public Map<SObjectField, Object> getFieldDefaults() {
            String recTypeId = [SELECT Id FROM RecordType WHERE Name = 'Digital Tools' AND SObjectType = 'Opportunity'].Id;
            return new Map<SObjectField, Object>{
                    Opportunity.StageName => 'Prospecting',
                    Opportunity.Name => 'Test Opportunity',
                    Opportunity.CloseDate => Date.today().addDays(1),
                    Opportunity.RecordTypeId => recTypeId
            };
        }
    }

    public class OpportunityOmmniDefaults implements IFieldDefaults {
        public Map<SObjectField, Object> getFieldDefaults() {
            String recTypeId = [SELECT Id FROM RecordType WHERE Name = 'Omni/Nexus' AND SObjectType = 'Opportunity'].Id;
            return new Map<SObjectField, Object>{
                    Opportunity.StageName => 'Prospecting',
                    Opportunity.Name => 'Test Opportunity',
                    Opportunity.CloseDate => Date.today().addDays(1),
                    Opportunity.RecordTypeId => recTypeId
            };
        }
    }

    public class Product2Defaults implements IFieldDefaults {
        public Map<SObjectField, Object> getFieldDefaults() {
            return new Map<SObjectField, Object>{
                Product2.Description => 'Test Description',
                Product2.Family => 'Build Optimize',
                Product2.Name => 'Test Name',
                Product2.QuantityUnitOfMeasure => 'Each',
                Product2.ProductCode => 'code 20'
            };
        }
    }

    public class Pricebook2Defaults implements IFieldDefaults {
        public Map<SObjectField, Object> getFieldDefaults() {
            return new Map<SObjectField, Object>{
                Pricebook2.Description => 'Test Description',
                Pricebook2.Name => 'Test',
                Pricebook2.RecordTypeId => Schema.SObjectType.Pricebook2.getRecordTypeInfosByName().get('Billing Pricelist').getRecordTypeId()
            };
        }
    }

    public class PricebookEntryDefaults implements IFieldDefaults {
        public Map<SObjectField, Object> getFieldDefaults() {
            return new Map<SObjectField, Object>{
                PricebookEntry.UnitPrice => 25,
                PricebookEntry.IsActive => true,
                PricebookEntry.ia_crm__Tier_Pricing__c => '25'
            };
        }
    }

    public class OpportunityLineItemDefaults implements IFieldDefaults {
        public Map<SObjectField, Object> getFieldDefaults() {
            return new Map<SObjectField, Object>{
                OpportunityLineItem.Quantity => 2,
                OpportunityLineItem.UnitPrice => 1500
            };
        }
    }

    public class ContactDefaults implements IFieldDefaults { 
        public Map<SObjectField, Object> getFieldDefaults() {
            return new Map<SobjectField, Object> {
                Contact.FirstName => 'Fiest Name Test',
                Contact.LastName => 'Last Name Test',
                Contact.Email => 'test@test.com',
                Contact.Lead_Date__c => false,
                Contact.LeadSource => 'Portal - MyBFSBuilder'
            };
        }
    } 

    public class CampaignDefaults implements IFieldDefaults { 
        public Map<SObjectField, Object> getFieldDefaults() {
            return new Map<SobjectField, Object> {
                Campaign.Name => 'Cmapaign Name Test',
                Campaign.IsActive => true,
                Campaign.StartDate => Date.today(),
                Campaign.EndDate => Date.today() + 5,
                Campaign.Description => 'Test',
                Campaign.Status => 'In Progress'
            };
        }
    } 

    public class LeadDefaults implements IFieldDefaults { 
        public Map<SObjectField, Object> getFieldDefaults() {
            return new Map<SobjectField, Object> {
                Lead.FirstName => 'Test First Name',
                Lead.LastName => 'Test Last Name',
                Lead.Title => 'Test Title',
                Lead.LeadSource => 'Portal - MyBFSBuilder',
                Lead.Status => 'Qualified',
                Lead.Company => 'Test Company'
            };
        }
    } 

    public class CampaignMemberDefaults implements IFieldDefaults { 
        public Map<SObjectField, Object> getFieldDefaults() {
            return new Map<SobjectField, Object> {
                CampaignMember.CurrencyIsoCode => 'USD',
                CampaignMember.Status => 'Sent'
            };
        }
    } 

    public class UserAdminDefaults implements IFieldDefaults {
        public Map<SObjectField, Object> getFieldDefaults() {
            Id pId = [SELECT Id FROM Profile WHERE name = 'System Administrator' LIMIT 1].Id;
            return new Map<SobjectField, Object>{
                    User.LastName => 'Test Admin User',
                    User.Email => 'testAdminEmail@paradigm.com',
                    User.Alias => 'testAdm',
                    User.Username => 'unittestingAdmin@paradigm.com',
                    User.CommunityNickname => 'testAdminUser23513',
                    User.LocaleSidKey => 'en_US',
                    User.TimeZoneSidKey => 'GMT',
                    User.ProfileID => pId,
                    User.LanguageLocaleKey => 'en_US',
                    User.EmailEncodingKey => 'UTF-8',
                    User.IsActive => true
            };
        }
    }
    
}
