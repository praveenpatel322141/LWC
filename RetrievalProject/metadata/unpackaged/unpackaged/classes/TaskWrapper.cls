global class TaskWrapper {
    public String subject;
    public String priority;
    public String status;
    public String externalId;

    private transient Contact con;

    public Task getTask() {
        this.con = [
            select AccountId
            from Contact
            where External_Id__c = :this.externalId
        ];

        return new Task(
            Subject = this.subject,
            Priority = this.priority,
            Status = this.status,
            WhatId = con.AccountId,
            WhoId = con.Id
        );
    }
}