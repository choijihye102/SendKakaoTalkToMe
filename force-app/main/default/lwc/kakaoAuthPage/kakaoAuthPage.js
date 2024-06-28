import getAuthUrl from '@salesforce/apex/KakaoAuth.getAuthUrl';
import embeded from '@salesforce/apex/KakaoMessageService.embeded';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { LightningElement, track } from 'lwc';

export default class KakaoAuthPage extends NavigationMixin(LightningElement) {
    @track message = '';
  


    handleAuth() {
        getAuthUrl()
            .then(authUrl => {
                window.location.href = authUrl;
                console.log(authUrl);
            })
            .catch(error => {
                this.showNotification('Error', 'Failed to get auth URL: ' + error.body.message, 'error');
            });
    }

    handleMessageChange(event) {
        this.message = event.target.value;
    }

    handleSendMessage() {
        embeded({ message: this.message })
            .then(() => {
                this.showNotification('Success', 'Message sent successfully', 'success');
            })
            .catch(error => {
                this.showNotification('Error', 'Failed to send message: ' + error.body.message, 'error');
            });
    }

    showNotification(title, message, variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }
}
