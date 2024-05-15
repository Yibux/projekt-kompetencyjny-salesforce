import { api, track, LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import ITEM_OBJECT from '@salesforce/schema/Item__c';

export default class CustomItemCreatePanel extends LightningElement {
    @api recordId;
    objectApiName = ITEM_OBJECT;
    @track numberOfAuthors = 1;
    selectedAuthors = [];
    areAuthorFieldsFilled = false;

    handleSuccess(event) {
        const evt = new ShowToastEvent({
            title: 'Record created',
            message: 'Record ID: ' + event.detail.id,
            variant: 'success',
        });
        this.dispatchEvent(evt);
    }

    handleError(error) {
        console.log(error);
        const evt = new ShowToastEvent({
            title: 'Error creating record',
            message: error.body.message,
            variant: 'error',
        });
        this.dispatchEvent(evt);
    }

    get authorIndexes() {
        console.log('author indexes')
        if (this.numberOfAuthors.toString() === 'NaN')
        {
            this.areAuthorFieldsFilled = false;
            return [];
        }
        this.areAuthorFieldsFilled = this.selectedAuthors.length === this.numberOfAuthors;
        console.log(this.selectedAuthors)
        return [...Array(this.numberOfAuthors).keys()];
    }

    handleNumberOfAuthorsChange(event) {
        this.areAuthorFieldsFilled = this.selectedAuthors.length === this.numberOfAuthors;
        console.log('handle number of authors change');
        this.numberOfAuthors = parseInt(event.target.value, 10);
        this.selectedAuthors = [];
    }

    handleAuthorChange(event) {
        console.log('handleauthorchange')
        this.selectedAuthors = this.selectedAuthors.concat(event.detail);
        console.log(this.selectedAuthors.length);
        this.areAuthorFieldsFilled = this.selectedAuthors.length === this.numberOfAuthors;
    }
}