import { api, track, LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import ITEM_OBJECT from '@salesforce/schema/Item__c';
import addAuthorToItem from '@salesforce/apex/AccountJoinItemController.createAccountJoinItem';

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

        this.selectedAuthors.forEach(author => {
            addAuthorToItem({itemId: event.detail.id, authorId: author})
                .then(() => {
                    console.log('Author added to item');
                })
                .catch(error => {
                    this.handleError(error);
                });
        });
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
        } else if (this.numberOfAuthors < this.selectedAuthors.length) {
            this.selectedAuthors = this.selectedAuthors.slice(0, this.numberOfAuthors);
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
        const newAuthor = event.detail;
        if (!this.selectedAuthors.includes(newAuthor)) {
            this.selectedAuthors = [...this.selectedAuthors, newAuthor];
        } else {
            this.selectedAuthors = this.selectedAuthors.filter(author => author !== newAuthor);
        }
        console.log(this.selectedAuthors.length, this.numberOfAuthors)
        this.areAuthorFieldsFilled = this.selectedAuthors.length === this.numberOfAuthors;
    }
}