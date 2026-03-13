import { LightningElement, api, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getActiveCourses from '@salesforce/apex/CourseListController.getActiveCourses';

export default class CourseList extends NavigationMixin(LightningElement) {
  // Public properties configurable in Experience Builder
  @api maxItems = 10;
  @api statusValue = 'ACTIVE';

  // State
  @track courses = [];
  @track error;
  isLoading = false;

  // Computed
  get hasCourses() {
    return Array.isArray(this.courses) && this.courses.length > 0;
  }

  get errorMessage() {
    if (!this.error) return '';
    // Normalize Apex error shape
    if (Array.isArray(this.error?.body)) {
      return this.error.body.map(e => e.message).join(', ');
    }
    return this.error?.body?.message || this.error?.message || 'Unknown error';
  }

  connectedCallback() {
    this.fetchCourses();
  }

  async fetchCourses() {
    this.isLoading = true;
    this.error = undefined;
    try {
      const maxItems = this.normalizeMaxItems(this.maxItems);
      const statusValue = this.normalizeStatus(this.statusValue);
      const data = await getActiveCourses({ maxItems, statusValue });
      this.courses = Array.isArray(data) ? data : [];
    } catch (e) {
      this.error = e;
      this.courses = [];
    } finally {
      this.isLoading = false;
    }
  }

  normalizeMaxItems(value) {
    const n = Number(value);
    if (!Number.isFinite(n) || n <= 0) return 10;
    return Math.min(n, 200);
  }

  normalizeStatus(value) {
    const v = (value || '').toString().trim();
    return v.length ? v : 'ACTIVE';
  }

  handleNavigate(event) {
    const recordId = event.currentTarget?.dataset?.id;
    if (!recordId) return;
    // Open record page within the same Experience Cloud site
    this[NavigationMixin.Navigate]({
      type: 'standard__recordPage',
      attributes: {
        recordId,
        objectApiName: 'Course__c',
        actionName: 'view'
      }
    });
  }

  // simple form submission handler that redirects to thank-you page
  handleFormSubmit(event) {
    event.preventDefault();
    // debug: verify handler is invoked
    // eslint-disable-next-line no-console
    console.log('handleFormSubmit called');

    // you could collect field values here if needed:
    // const fields = event.target.elements;

    // attempt platform navigation first
    try {
      this[NavigationMixin.Navigate]({
        type: 'standard__webPage',
        attributes: {
          url: '/s/thankyou.html'
        }
      });
    } catch (e) {
      // fallback to simple redirect
      // eslint-disable-next-line no-console
      console.error('NavigationMixin failed, falling back to window.location', e);
      window.location.href = '/s/thankyou.html';
    }
  }
}
