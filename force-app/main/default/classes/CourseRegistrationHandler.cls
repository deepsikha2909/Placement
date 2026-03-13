/**
 * @description Handler class for course registration related operations
 */
public with sharing class CourseRegistrationHandler {
    
    /**
     * @description Sends email to student when they register for a course
     * @param registrations List of newly created Course_Registration__c records
     */
    public static void sendEmailOnRegistration(List<Course_Registration__c> registrations) {
        try {
            // Prepare email templates and recipients
            List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();
            
            for (Course_Registration__c reg : registrations) {
                // In a real implementation, you would:
                // 1. Get the student's email from a related Contact or User record
                // 2. Use the email template to send the confirmation
                
                // For demonstration purposes, we'll just log that we would send an email
                System.debug('Would send email for registration: ' + reg.Id);
                
                // Example of how you would send an actual email:
                /*
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new String[] { 'student@example.com' }); // Replace with actual student email
                email.setSubject('Course Registration Confirmation');
                email.setPlainTextBody('Hello,\n\nThis is to confirm your registration for the course.\n\nStudent Name: ' + reg.Student_Name__c + '\nCourse Type: ' + reg.Course_Type__c + '\nCourse Name: ' + reg.Course_Name__c + '\nRegistration Date: ' + reg.Registration_Date__c + '\n\nThank you for registering!\n\nBest regards,\nPlacement Team');
                emailsToSend.add(email);
                */
            }
            
            // Send all emails
            // if (!emailsToSend.isEmpty()) {
            //     Messaging.sendEmail(emailsToSend);
            // }
            
        } catch (Exception e) {
            System.debug('Error sending registration email: ' + e.getMessage());
        }
    }
}
