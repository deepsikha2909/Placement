/**
 * @description Controller for sending registration emails to students
 */
public with sharing class EmailController {
    
    /**
     * @description Sends registration email to a student
     * @param studentId The ID of the student to send email to
     * @return Boolean indicating success or failure
     */
    @AuraEnabled
    public static Boolean sendRegistrationEmail(String studentId) {
        try {
            // Get student details
            Student__c student = [
                SELECT Id, Name, Email__c
                FROM Student__c 
                WHERE Id = :studentId
                LIMIT 1
            ];
            
            if (student != null && student.Email__c != null) {
                // Create email message
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                
                // Set email properties
                email.setToAddresses(new String[] { student.Email__c });
                email.setSubject('Course Registration Invitation');
                
                // Construct Experience Cloud registration link
                // Note: In a real implementation, you would use the actual site URL
                String siteUrl = 'https://your-site-url--c.cs12.my.salesforce.com/s/register'; // Placeholder URL
                
                // Create email body with registration link
                String emailBody = 'Dear ' + student.Name + ',\n\n';
                emailBody += 'You have been invited to register for a course.\n\n';
                emailBody += 'Please click the link below to complete your registration:\n';
                emailBody += siteUrl + '\n\n';
                emailBody += 'Thank you,\n';
                emailBody += 'Placement Team';
                
                email.setPlainTextBody(emailBody);
                
                // Send email
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
                
                return true;
            } else {
                System.debug('Student not found or email not available');
                return false;
            }
        } catch (Exception e) {
            System.debug('Error sending registration email: ' + e.getMessage());
            return false;
        }
    }
}
