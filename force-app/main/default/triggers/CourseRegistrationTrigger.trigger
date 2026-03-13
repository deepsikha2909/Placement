trigger CourseRegistrationTrigger on Course_Registration__c (after insert) {
    // Process email sending after registration creation
    if (Trigger.isAfter && Trigger.isInsert) {
        // Call the email sending method
        CourseRegistrationHandler.sendEmailOnRegistration(Trigger.new);
    }
}
