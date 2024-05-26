import { LightningElement, wire, api, track } from 'lwc';
import getAllItemsAccounts from '@salesforce/apex/ShowAuthorsController.getAllItemsAccounts';


export default class ShowAuthors extends LightningElement {
    @api recordId;
    @track accounts;

    @wire(getAllItemsAccounts, { itemId: '$recordId' })
    wiredAccounts(result) {
        if (result) {
            if (result.data) {
                this.accounts = result.data;
                console.log('Accounts:', this.accounts); // Logowanie wyników do konsoli
            } else if (result.error) {
                console.error('Error:', result.error); // Logowanie błędu do konsoli
            }
        } else {
            console.warn('Result is undefined');
        }
    }
}