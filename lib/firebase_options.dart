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
        return macos;
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
    apiKey: 'AIzaSyBe5tiq6oAx5rJ4RSaEX6HQAQqW76FNO5o',
    appId: '1:355358501463:web:babe303d7fb07bb0bd5112',
    messagingSenderId: '355358501463',
    projectId: 'catnizer-appetizer',
    authDomain: 'catnizer-appetizer.firebaseapp.com',
    storageBucket: 'catnizer-appetizer.appspot.com',
    measurementId: 'G-7Q4V08EHNY',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDE3U1QXrCvNHalQNf4dH86SEaLuTB18r4',
    appId: '1:355358501463:android:86e2c58797e0f247bd5112',
    messagingSenderId: '355358501463',
    projectId: 'catnizer-appetizer',
    storageBucket: 'catnizer-appetizer.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB-hvcRxZ4YzFlsUGxU2ozvvW7lpovsvpQ',
    appId: '1:355358501463:ios:d6c9e56fc36c8437bd5112',
    messagingSenderId: '355358501463',
    projectId: 'catnizer-appetizer',
    storageBucket: 'catnizer-appetizer.appspot.com',
    iosClientId: '355358501463-g0isu8682e9690a87h5c8nkq7g8j0n89.apps.googleusercontent.com',
    iosBundleId: 'com.example.catnizer',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB-hvcRxZ4YzFlsUGxU2ozvvW7lpovsvpQ',
    appId: '1:355358501463:ios:d6c9e56fc36c8437bd5112',
    messagingSenderId: '355358501463',
    projectId: 'catnizer-appetizer',
    storageBucket: 'catnizer-appetizer.appspot.com',
    iosClientId: '355358501463-g0isu8682e9690a87h5c8nkq7g8j0n89.apps.googleusercontent.com',
    iosBundleId: 'com.example.catnizer',
  );
}
