import { LightningElement, track } from 'lwc';
import getStudents from '@salesforce/apex/RegistrationController.getStudents';
import createRegistration from '@salesforce/apex/RegistrationController.createRegistration';

export default class StudentRegistrationForm extends LightningElement {
    @track selectedStudentId = '';
    @track courseType = '';
    @track courseName = '';
    @track registrationDate = '';
    @track students = [];
    @track isLoading = false;
    @track showSuccessMessage = false;
    
    isRegisterButtonDisabled = true;

    connectedCallback() {
        this.loadStudents();
        this.setTodayAsDefaultDate();
    }

    setTodayAsDefaultDate() {
        const today = new Date();
        const formattedDate = today.toISOString().split('T')[0];
        this.registrationDate = formattedDate;
    }

    async loadStudents() {
        this.isLoading = true;
        try {
            const result = await getStudents();
            this.students = result.map(student => ({
                label: student.name,
                value: student.id
            }));
        } catch (error) {
            console.error('Error loading students:', error);
        } finally {
            this.isLoading = false;
        }
    }

    handleStudentChange(event) {
        this.selectedStudentId = event.detail.value;
        this.validateForm();
    }

    handleCourseTypeChange(event) {
        this.courseType = event.target.value;
        this.validateForm();
    }

    handleCourseNameChange(event) {
        this.courseName = event.target.value;
        this.validateForm();
    }

    handleRegistrationDateChange(event) {
        this.registrationDate = event.target.value;
        this.validateForm();
    }

    validateForm() {
        this.isRegisterButtonDisabled = !(this.selectedStudentId && 
                                         this.courseType && 
                                         this.courseName && 
                                         this.registrationDate);
    }

    async handleRegister() {
        this.isLoading = true;
        try {
            const result = await createRegistration({
                studentId: this.selectedStudentId,
                courseType: this.courseType,
                courseName: this.courseName,
                registrationDate: this.registrationDate
            });
            
            if (result) {
                this.showSuccessMessage = true;
                // Reset form after successful registration
                this.selectedStudentId = '';
                this.courseType = '';
                this.courseName = '';
                this.registrationDate = '';
            } else {
                console.error('Registration failed');
            }
        } catch (error) {
            console.error('Error during registration:', error);
        } finally {
            this.isLoading = false;
        }
    }
}
