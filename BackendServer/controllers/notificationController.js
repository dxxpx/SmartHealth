import { post } from 'axios';

async function sendNotification(fcmToken, title, body) {
    try {
        const response = await post('http://127.0.0.1:8000/send-notification/', {
            fcm_token: fcmToken,
            title: title,
            body: body,
        });
        console.log('Notification sent successfully:', response.data);
    } catch (error) {
        console.error('Error sending notification:', error);
    }
}

// Example usage
sendNotification('your-fcm-token', 'Test Title', 'Test Body');
