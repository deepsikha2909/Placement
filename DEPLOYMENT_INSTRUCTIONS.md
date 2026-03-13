# Deployment Instructions

## Prerequisites

1. Salesforce Org with:
   - Student__c custom object with Email__c and Phone__c fields
   - Registration__c custom object with required fields
   - Proper permission sets for guest users

## Deployment Steps

1. **Deploy Apex Classes:**
   - RegistrationController.cls
   - EmailController.cls

2. **Deploy Lightning Web Component:**
   - studentRegistrationForm component files

3. **Deploy Custom Objects:**
   - Registration__c object (ensure all required fields exist)
   - Student__c object (ensure all required fields exist)

4. **Configure Security:**
   - Grant Guest User read access to Student__c
   - Grant Guest User create access to Registration__c
   - Grant Guest User access to the Apex classes

5. **Configure Experience Cloud:**
   - Add studentRegistrationForm component to Experience Cloud page
   - Configure the page to allow guest user access

## Verification

1. Verify that the component loads in Experience Cloud
2. Test student selection functionality
3. Test registration creation
4. Test email sending functionality
