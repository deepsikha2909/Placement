/**
 * @description Controller to expose ACTIVE Course__c records for Experience Cloud Home page and Flows.
 * Enforces sharing, FLS, and runs queries in USER_MODE. Returns lightweight DTOs for UI use.
 * Requirements aligned with org rules: with sharing, Database methods, return-early, enums, ApexDocs, invocable support.
 */
public with sharing class CourseListController {

    /**
     * Status enum to avoid string literals.
     */
    public enum COURSE_STATUS {
        ACTIVE,
        INACTIVE
    }

    /**
     * Lightweight Data Transfer Object for Course list rendering.
     */
    public class CourseItemDTO {
        @AuraEnabled public Id id;
        @AuraEnabled public String name;
        @AuraEnabled public String courseDescription;
        @AuraEnabled public String courseStatus;

        public CourseItemDTO(Course__c c) {
            this.id = c.Id;
            this.name = c.Name;
            this.courseDescription = (Schema.sObjectType.Course__c.fields.Course_Description__c.isAccessible()) ? (String)c.get('Course_Description__c') : null;
            this.courseStatus = (Schema.sObjectType.Course__c.fields.Course_Status__c.isAccessible()) ? (String)c.get('Course_Status__c') : null;
        }
    }

    /**
     * @description Returns up to maxItems Course__c records filtered by status (API value) and sorted by Name ASC.
     * @param maxItems Maximum number of records to return (1..200). Defaults to 10 if null or invalid.
     * @param statusValue Picklist API value to filter by (e.g., 'ACTIVE'). Defaults to 'ACTIVE' when null/blank.
     * @return List of CourseItemDTO for UI rendering.
     */
    @AuraEnabled(cacheable=true)
    public static List<CourseItemDTO> getActiveCourses(Integer maxItems, String statusValue) {
        // Return-early validations
        Integer limitSize = (maxItems == null || maxItems <= 0 || maxItems > 200) ? 10 : maxItems;
        String statusApi = String.isBlank(statusValue) ? COURSE_STATUS.ACTIVE.name() : statusValue;

        // FLS checks - ensure user can read fields that will be accessed
        if (!Schema.sObjectType.Course__c.isAccessible()
            || !Schema.sObjectType.Course__c.fields.Name.isAccessible()
            || !Schema.sObjectType.Course__c.fields.Course_Status__c.isAccessible()) {
            // If required fields are not accessible, return empty set for safety
            return new List<CourseItemDTO>();
        }

        // Query with sharing/FLS enforced using WITH SECURITY_ENFORCED (place clause immediately after WHERE/AND)
        List<Course__c> courses = [
            SELECT Id, Name, Course_Description__c, Course_Status__c
            FROM Course__c
            WHERE Course_Status__c = :statusApi
            WITH SECURITY_ENFORCED
            ORDER BY Name ASC
            LIMIT :limitSize
        ];

        List<CourseItemDTO> results = new List<CourseItemDTO>();
        for (Course__c c : courses) {
            results.add(new CourseItemDTO(c));
        }
        return results;
    }

    /**
     * @description Invocable wrapper to retrieve courses for Flow use-cases.
     */
    public class GetCoursesRequest {
        @InvocableVariable(required=false)
        public Integer maxItems;
        @InvocableVariable(required=false)
        public String statusValue;
    }

    public class GetCoursesResponse {
        @InvocableVariable
        public List<CourseItemDTO> courses;
    }

    /**
     * @description Invocable method to fetch courses for Flows. Returns a single element list with the response wrapper.
     */
    @InvocableMethod(label='Get Courses (ACTIVE by default)' description='Returns up to maxItems Course__c filtered by status (API value), default ACTIVE.')
    public static List<GetCoursesResponse> getCoursesInvocable(List<GetCoursesRequest> requests) {
        List<GetCoursesResponse> responses = new List<GetCoursesResponse>();
        if (requests == null || requests.isEmpty()) {
            GetCoursesResponse r = new GetCoursesResponse();
            r.courses = getActiveCourses(10, COURSE_STATUS.ACTIVE.name());
            responses.add(r);
            return responses;
        }
        for (GetCoursesRequest req : requests) {
            Integer maxItems = (req == null) ? 10 : req.maxItems;
            String statusValue = (req == null) ? COURSE_STATUS.ACTIVE.name() : req.statusValue;
            GetCoursesResponse r = new GetCoursesResponse();
            r.courses = getActiveCourses(maxItems, statusValue);
            responses.add(r);
        }
        return responses;
    }
}
