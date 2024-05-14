import { api, track, LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { createRecord } from 'lightning/uiRecordApi';
import ITEM_OBJECT from '@salesforce/schema/Item__c';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import ACCOUNT_JOIN_ITEM_NAME from '@salesforce/schema/AccountJoinItem__c.Name';

export default class CustomItemCreatePanel extends LightningElement {
    @api recordId;
    objectApiName = ITEM_OBJECT;
    Name = ACCOUNT_JOIN_ITEM_NAME;
    // fields = [ITEM_OBJECT.Name, ITEM_OBJECT.Price__c, ITEM_OBJECT.Quantity__c, ITEM_OBJECT.Cover__c, ITEM_OBJECT.Release_Date__c,
    //     ITEM_OBJECT.Genre__c, ACCOUNT_OBJECT.Name];
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
}