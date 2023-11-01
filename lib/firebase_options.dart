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
        return ios;
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
    apiKey: 'AIzaSyCUi9umpOU2saipxiovvnh3PUfsUu29BRg',
    appId: '1:822975640099:web:b56d5c0100f91a2d07f796',
    messagingSenderId: '822975640099',
    projectId: 'social-app-c0fe7',
    authDomain: 'social-app-c0fe7.firebaseapp.com',
    storageBucket: 'social-app-c0fe7.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDT2UjFxw2DtnOOaSD5eB53SBFMNKpLJfQ',
    appId: '1:822975640099:android:3675d0a29453fce807f796',
    messagingSenderId: '822975640099',
    projectId: 'social-app-c0fe7',
    storageBucket: 'social-app-c0fe7.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA0N7ZxCCPn-45gNcdxo5SPnJlMcD02L0Y',
    appId: '1:822975640099:ios:2fbf6f1fa331ed5f07f796',
    messagingSenderId: '822975640099',
    projectId: 'social-app-c0fe7',
    storageBucket: 'social-app-c0fe7.appspot.com',
    iosBundleId: 'com.example.untitled10',
  );
}
