/* 
  Created by Juan Ramirez, June 12/2024
 
  Purpose/Methods:
  - class to get all opportunities with record type Digital Tools and Stage Lead, Meeting Set, Meeting Complete
 
 */
global class OpportunityReminderSchedule implements Schedulable, Database.Batchable<SObject>{

    global void execute(SchedulableContext con){

        OpportunityReminderSchedule b = new OpportunityReminderSchedule();
        ID batchprocessid = Database.executeBatch(b);
  
    }

    global Database.QueryLocator start(Database.BatchableContext context) {

        Date dateBeforeMeeting = Date.today()-30;
        Date dateBeforeLead = Date.today()-15;
        DateTime startLeadDatetime = Datetime.newInstance(dateBeforeLead.year(), dateBeforeLead.month(),dateBeforeLead.day(),1,0,0);
        String query = 'SELECT Id,CloseDate,LeadSource, Name, OwnerId, ContactId,RecordType.Name,StageName,CreatedDate, Meeting_Set_Date__c, ' +
                         'Meeting_Date_Completed__c, Owner.Email, Owner.Name from Opportunity ' +
                        'WHERE RecordType.Name = \'Digital Tools\' AND StageName IN(\'Lead\', \'Meeting Set\', \'Meeting Complete\') ' + 
                        'AND (CreatedDate >=:startLeadDatetime OR Meeting_Date_Completed__c >=:dateBeforeMeeting) order by CreatedDate DESC ';
		System.debug('query: '+query);
		//RepairOrderHelper.initErrorRecords();
        return Database.getQueryLocator(query);

    }

    global void execute(Database.BatchableContext context, List<Opportunity> scope){

        
        if(scope.size() > 0){
			System.debug('[OpportunityReminderSchedule.execute] opportunities: '+JSON.serializePretty(scope));
            List<Task> tasksList = new List<Task>();
            List<Send_Email_Related_Opportunity__e> platformEventList = new List<Send_Email_Related_Opportunity__e>();
            OpportunityReminderScheduleHelper.processReminders(scope, tasksList, platformEventList);
            if(tasksList.size() > 0){
                //Database.insert(tasksList, false);
                System.debug('[OpportunityReminderSchedule.execute] tasksList: '+JSON.serializePretty(tasksList));
                insert tasksList;
            }
            if (!Test.isRunningTest() && platformEventList.size() > 0) {
                System.debug('[OpportunityReminderSchedule.execute] platformEventList: '+JSON.serializePretty(platformEventList));
                List<Database.SaveResult> srList = EventBus.publish(platformEventList);
            }
        }   

    }

    global void finish(Database.BatchableContext context) {
		
	 }

    public static void schedule() {
        String sch = '0 0 8 ? * MON-FRI *';
        OpportunityReminderSchedule m = new OpportunityReminderSchedule();
        String jobId = system.schedule('Opportunity Reminder Schedule Batch', sch, m);
    }
    
}