// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCP-g8l2uVD97dM1uzRb3JO8EGSo5DclvQ',
    appId: '1:752383861914:web:880d74bcfacb1cb5532b23',
    messagingSenderId: '752383861914',
    projectId: 'antiragging-27f01',
    authDomain: 'antiragging-27f01.firebaseapp.com',
    storageBucket: 'antiragging-27f01.appspot.com',
    measurementId: 'G-L2V35QBSB7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA1TtFUgHakfQ4GwLdiMZgTU8G1lWDjmFE',
    appId: '1:752383861914:android:21059eb151596357532b23',
    messagingSenderId: '752383861914',
    projectId: 'antiragging-27f01',
    storageBucket: 'antiragging-27f01.appspot.com',
  );
}
