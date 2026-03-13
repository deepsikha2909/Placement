/**
 * @description Controller for student registration functionality
 * Provides methods for getting student list and creating registration records
 */
public with sharing class RegistrationController {
    
    /**
     * @description Returns a list of students for selection
     * @return List of student names with IDs
     */
    @AuraEnabled(cacheable=true)
    public static List<StudentSelection> getStudents() {
        List<StudentSelection> students = new List<StudentSelection>();
        
        try {
            // Query for students with basic information
            List<Student__c> studentList = [
                SELECT Id, Name, Email__c
                FROM Student__c 
                WHERE Name != null 
                ORDER BY Name
            ];
            
            for (Student__c student : studentList) {
                students.add(new StudentSelection(student.Id, student.Name));
            }
        } catch (Exception e) {
            System.debug('Error retrieving students: ' + e.getMessage());
        }
        
        return students;
    }
    
    /**
     * @description Creates a new registration record
     * @param studentId The ID of the student
     * @param courseType The course type
     * @param courseName The course name
     * @param registrationDate The registration date
     * @return Boolean indicating success or failure
     */
    @AuraEnabled
    public static Boolean createRegistration(String studentId, String courseType, String courseName, String registrationDate) {
        try {
            // Create a new registration record
            Course_Registration__c reg = new Course_Registration__c();
            reg.Student__c = studentId;
            reg.Course_Type__c = courseType;
            reg.Course_Name__c = courseName;
            reg.Registration_Date__c = Date.valueOf(registrationDate);
            
            // Insert the registration record
            Database.SaveResult result = Database.insert(reg);
            
            if (result.isSuccess()) {
                return true;
            } else {
                // Log error
                System.debug('Registration failed: ' + result.getErrors()[0].getMessage());
                return false;
            }
        } catch (Exception e) {
            System.debug('Error during registration: ' + e.getMessage());
            return false;
        }
    }
    
    /**
     * @description Data transfer object for student selection
     */
    public class StudentSelection {
        @AuraEnabled public String id;
        @AuraEnabled public String name;
        
        public StudentSelection(String id, String name) {
            this.id = id;
            this.name = name;
        }
    }
}
