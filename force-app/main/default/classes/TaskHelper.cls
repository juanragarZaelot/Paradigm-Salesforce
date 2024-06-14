/* 
  Created by Juan Ramirez, June 13/2024
 
  Purpose/Methods:
  - class to manage the aprocesses about Task object
 
 */
public class TaskHelper {

    public static Task createTaskObject(String subject, Date activityDate, String nameId, String relatedTo, String priority, String status, String ownerId, String type){
        Task taskObject = new Task();
        taskObject.Subject = subject;
        taskObject.ActivityDate = activityDate;
        taskObject.WhoId = nameId;
        taskObject.WhatId = relatedTo;
        taskObject.Priority = priority;
        taskObject.Status = status;
        taskObject.OwnerId = ownerId;
        taskObject.Type = type;
        return taskObject;
    }
    
}