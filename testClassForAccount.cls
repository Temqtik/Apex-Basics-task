public with sharing class testClassForAccount {
    public testClassForAccount() { }

    public class RequestObject {
        @InvocableVariable(required=true label='Account ID')
        public Id accountId;
        @InvocableVariable(required=true label='Account Name')
        public String accountName;
        @InvocableVariable(required=true label='Created Date')
        public Datetime created;
        @InvocableVariable(required=true label='Last Modified Date')
        public Datetime updated;
    }

    @InvocableMethod
    public static void createNewTask(List<RequestObject> requests){
        
        List<Task> taskToInsert = new List<Task>();
        List<Task> taskToUpdate = new List<Task>();

        for(RequestObject request : requests){
            if(request.created == request.updated){
                Task task = new Task();
                task.Subject = 'Negotiations with ' + request.accountName;
                task.WhatId = request.accountId;
                taskToInsert.add(task);
            } else{
                List<Task> accountTasks = [SELECT OwnerId FROM Task WHERE WhatId = :request.accountId];
                if(accountTasks.size() > 3) {
                    List<User> Users = new List<User>();
                    Users =  [SELECT Id FROM User];
                    User user = Users[Integer.valueOf(Math.random() * (Users.size() - 1))];
                    for(Task changeTask : accountTasks) {
                        changeTask.OwnerId = user.Id;
                        taskToUpdate.add(changeTask);
                    }
                }
            }       
        }

        if(!taskToInsert.isEmpty()){
            insert taskToInsert;
        }
        if(!taskToUpdate.isEmpty()){
            update taskToUpdate;
        }
    }
}
