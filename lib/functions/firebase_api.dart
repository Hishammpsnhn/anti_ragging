import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initializeFirebase() async {
    // Request FCM token
    String? fcmToken = await _firebaseMessaging.getToken();
    print('fcm token is $fcmToken');
    // Save or send the FCM token to Firestore
    // You can use a function like the one below to send the token to Firestoredd
    saveFCMTokenToFirestore(fcmToken);
  }

  Future<void> saveFCMTokenToFirestore(String? fcmToken) async {
    // Save the FCM token to Firestore (adjust the path accordingly)
    // This assumes you have a 'users' collection with documents identified by user ID
    // and a 'fcmToken' field in each document to store the FCM token

    // Replace 'userId' with the actual user ID or identifier in your app
    String userId = 'QzuDMGNXveeTk5JreshV2c20JTm2'; // Replace this with your user ID logic

    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'FCMToken': fcmToken,
    }, SetOptions(merge: true)); // Use merge to update the token without overwriting other fields
  }
}
