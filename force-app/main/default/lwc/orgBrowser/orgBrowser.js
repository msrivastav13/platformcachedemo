import { LightningElement, track, wire } from 'lwc';
//import getfetchObjectNames from '@salesforce/apex/OrgBrowserController.fetchObjectNames';
//import getfetchObjectNamesFromCache from '@salesforce/apex/OrgBrowserController.fetchObjectNamesFromCache';
import getfetchObjectNamesUsingGlobalDescribe from '@salesforce/apex/OrgBrowserController.fetchObjectNamesUsingGlobalDescribe';
//import getfetchObjectNamesUsingGlobalDescribeFromCache from '@salesforce/apex/OrgBrowserController.fetchObjectNamesUsingGlobalDescribeFromCache';

export default class OrgBrowser extends LightningElement {
    @track
    objectnames;
    @track
    objectnamescache;
    error;
    selectedObject ;
    selectedObjectcache ;

    @wire(getfetchObjectNamesUsingGlobalDescribe)
    wiredObjectNames({ error, data }) {
        if (data) {
            this.objectnames = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.objectnames = undefined;
        }
    }

    handleChange(event) {
        this.selectedObject = event.target.value;
        console.log(this.selectedObject);
    }
}
