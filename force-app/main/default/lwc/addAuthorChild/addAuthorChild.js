import { LightningElement, api, wire } from 'lwc';
import getAccounts from '@salesforce/apex/AccountController.getAccounts';

export default class AddAuthorChild extends LightningElement {
    @api numberOfAuthors;
    selectedAuthors = [];

    @wire(getAccounts)
    accounts;

    get authorOptions() {
        return this.accounts.data ? this.accounts.data.map(account => ({ label: account.Name, value: account.Id })) : [];
    }

    handleAuthorChange(event) {
        console.log('handleauthorchange child')
        this.selectedAuthors = event.detail.value;
        this.dispatchEvent(new CustomEvent('authorchange', { detail: this.selectedAuthors }));
    }

}