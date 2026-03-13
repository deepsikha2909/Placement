# Student Registration Tracking Management System

This project implements a student course registration system for Placement Heads to manage student enrollments.

## Features

1. **Student Registration Form** - LWC component for students to register for courses
2. **Registration Management** - Create Registration__c records with student lookup
3. **Email Integration** - Send registration emails to students
4. **Experience Cloud Support** - Component exposed for Experience Cloud pages

## Components

### LWC Component: studentRegistrationForm
- Displays a form with fields for:
  - Student (dropdown selection from Student__c object)
  - Course Type (text input)
  - Course Name (text input)
  - Registration Date (auto-filled with today's date)
- Handles form submission and registration creation
- Exposed for Experience Cloud with lightningCommunity__Page and lightningCommunity__Default targets

### Apex Classes
- **RegistrationController**: 
  - Provides methods to get student list and create registration records
- **EmailController**: 
  - Contains logic for sending registration emails to students

### Custom Objects
- **Registration__c**: Stores registration information with:
  - Student__c (lookup to Student__c object)
  - Course_Type__c (text field)
  - Course_Name__c (text field)
  - Registration_Date__c (date field)
  - Status__c (text field for tracking registration status)

## How to Use

1. Placement Head selects a student from the dropdown
2. Placement Head enters course details (type, name)
3. Placement Head clicks Register to create the registration record
4. System stores registration in Registration__c object with Student__c lookup
5. Placement Head can send email invitation to student using the EmailController

## Implementation Details

- Uses Apex with sharing for security
- Implements proper error handling
- Follows Salesforce best practices for DML operations
- Uses caching for performance optimization
- Includes proper metadata files for deployment
- Supports Experience Cloud with required targets
- Fixed compilation errors in Apex classes

## Security Requirements

- Guest User must have:
  - Read access to Student__c
  - Create access to Registration__c
  - Apex class access
