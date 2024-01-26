const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendNotificationOnNewDocument = functions.firestore
    .document('users/{email}')
    .onUpdate(async(change, context) => {
       
        const newData = change.after.data();

        var payload = {
            notification: {
                title: 'your email is updated',
                body: 'Your email is updated2',
                sound: 'beep',
                channel_id: 'HUNGRY',
                android_channel_id: 'HUNGRY',
                priority: 'high',
            }
        }
        try {
            const response = await admin.messaging().sendToDevice(newData.FCMToken, payload);
            console.log("correct", response)
        } catch (error) {
            console.log(error); 
        }
    });
