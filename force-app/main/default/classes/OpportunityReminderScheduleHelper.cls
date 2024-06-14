/* 
  Created by Juan Ramirez, June 13/2024
 
  Purpose/Methods:
  - class to calculate the dates of opportunities to create tasks reminders and send emails
 
 */
public class OpportunityReminderScheduleHelper {
 
    public static final String PRIORITY = 'High';
    public static final String STATUS = 'Open';
    public static final String TYPE = 'Call';
    public static final String SUBJECT_LEAD = 'Please continue to reach out to schedule a meeting';
    public static final String SUBJECT_MEETING_COMPLETE = 'Temperature check/Follow Up Reminder';
    public static final String EMAIL_TEMPLATE_LEAD = 'Follow_Up_Unable_to_Reach_CS';
    public static final String EMAIL_TEMPLATE_MEETING_SET = 'Follow_Up_Meeting_Reminder';
    public static final String EMAIL_FROM = 'juanragar.other@gmail.com';
    //array of seven boolean indicating working days, MONDAY is index 0
    public static final List<Boolean> IS_WORKING_DAY = new List<Boolean> { true, true, true, true, true, false, false };
    //count of the number of working days in the array
    private static final Integer WORKING_DAYS_IN_WEEK = 5;

    // MONDAY is January 1st, 1900.
    private static final Date MONDAY = Date.newInstance(1900, 1, 1);

    private static Integer getDayOfWeek(Date value) {
        return Math.mod(MONDAY.daysBetween(value), 7);
    }

    public static Integer getWorkingDays(Date startDate, Date endDate) {
        //save some calculations when the number of working days is 0
        if(WORKING_DAYS_IN_WEEK == 0 || startDate == null || endDate == null) {
            return 0;
        } else {
            Integer difference = startDate.daysBetween(endDate);
            if(difference == 0) {
                //If the 2 dates are the same day check if the day is a working day or not
                return IS_WORKING_DAY[getDayOfWeek(startDate)] ? 1 : 0;
            } else if(WORKING_DAYS_IN_WEEK == 7) {
                //when every day is a working day return the difference
                return difference;
            } else {
                //The guts of the solution
                Integer wholeWeeks = Math.floor(difference / 7).intValue();
                Integer workingDays = wholeWeeks * WORKING_DAYS_IN_WEEK;
                Integer dayOfWeek = getDayOfWeek(endDate);
                for(Integer remainder = Math.mod(difference, 7); remainder >= 0; remainder--) {
                    if(IS_WORKING_DAY[dayOfWeek]) {
                        workingDays++;
                    }
                    dayOfWeek--;
                    if(dayOfWeek < 0) {
                        dayOfWeek = 6;
                    }
                }
                return workingDays;
            }
        }
    }

    /*
     * @author Juan Ramirez
     * @date 2024/06/13
     * @description method to calculate the number of dates between dates and create reminders
     * @param opportunityList all opportunities to be processed
     */
	
	 public static void processReminders(List<Opportunity> opportunityList, List<Task> tasksList, List<Send_Email_Related_Opportunity__e> platformEventList){

        Integer numberDays;
        for(Opportunity oppor: opportunityList){
            System.debug('[OpportunityReminderScheduleHelper.processReminders] oppor: '+JSON.serializePretty(oppor));
            if(oppor.StageName == 'Lead'){
                numberDays = getWorkingDays(Date.valueOf(oppor.CreatedDate), Date.today());
                System.debug('[OpportunityReminderScheduleHelper.processReminders] numberDays Lead: '+numberDays);
                if(numberDays == 2 || numberDays == 5 || numberDays == 8 || numberDays == 10){
                    tasksList.add(TaskHelper.createTaskObject(SUBJECT_LEAD, Date.today(), oppor.ContactId, oppor.Id, PRIORITY, STATUS, oppor.ownerId, TYPE));
                }
                if(numberDays == 5){
                    platformEventList.add(createPlatFormEvent(EMAIL_TEMPLATE_LEAD, oppor.ContactId, oppor.Id, oppor.Owner.Email, oppor.Owner.Name, EMAIL_FROM));
                }
            } else if(oppor.StageName == 'Meeting Set'){
                if(oppor.Meeting_Set_Date__c == Date.today()){
                    platformEventList.add(createPlatFormEvent(EMAIL_TEMPLATE_MEETING_SET, oppor.ContactId, oppor.Id, oppor.Owner.Email, oppor.Owner.Name, EMAIL_FROM));
                }
            } else if(oppor.StageName == 'Meeting Complete'){
                numberDays = getWorkingDays(Date.valueOf(oppor.Meeting_Date_Completed__c), Date.today());
                System.debug('[OpportunityReminderScheduleHelper.processReminders] numberDays Meeting Complete: '+numberDays);
                if(numberDays == 5 || numberDays == 10 || numberDays == 15 || numberDays == 20){
                    tasksList.add(TaskHelper.createTaskObject(SUBJECT_MEETING_COMPLETE, Date.today(), oppor.ContactId, oppor.Id, PRIORITY, STATUS, oppor.ownerId, TYPE));
                }
            }
        }

     }

     /*
     * @author Juan Ramirez
     * @date 2024/06/13
     * @description method to insert Send Email Related Opportunity platform event
     * @param emailTemplateDevName email template name to find it
     * @param contactId Id of contact related to the Case or Account
     * @param opportunityId Id of the opportunity
     * @param email email of the opportunity used to send the email
	 * @param ownerName name of the owner used to send the email. It's the name of the user
     * @param emailFrom name of Organization-Wide Addresses
     */
     public static Send_Email_Related_Opportunity__e createPlatFormEvent(String emailTemplateDevName, String contactId, String opportunityId, String email, String ownerName, String emailFrom){
        Send_Email_Related_Opportunity__e event = new Send_Email_Related_Opportunity__e();

        event.Email_Template_Dev_Name__c = emailTemplateDevName;
        event.Contact_Id__c = contactId; 
        event.Opportunity_Id__c = opportunityId; 
        event.Email__c = email; 
        event.Owner_Name__c = ownerName; 
        event.Email_From__c = emailFrom;
        return event;
     }
    
}