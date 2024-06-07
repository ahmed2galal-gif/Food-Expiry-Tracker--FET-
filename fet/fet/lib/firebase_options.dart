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
    apiKey: 'AIzaSyA1458zxvWFxpHdNRCuGxtM44lT4XhK3O8',
    appId: '1:670863775645:web:30125dcc5f14aceb558174',
    messagingSenderId: '670863775645',
    projectId: 'food-expiry-tracker-f807e',
    authDomain: 'food-expiry-tracker-f807e.firebaseapp.com',
    storageBucket: 'food-expiry-tracker-f807e.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAGa_W68y7CtrldG4o1TalGPn2X-SqNVXc',
    appId: '1:670863775645:android:de22eea90c295918558174',
    messagingSenderId: '670863775645',
    projectId: 'food-expiry-tracker-f807e',
    storageBucket: 'food-expiry-tracker-f807e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCc9Yxc1KsdWjI8VNji5b0ZgQ9OJ_hJoD0',
    appId: '1:670863775645:ios:f08647eef86652b5558174',
    messagingSenderId: '670863775645',
    projectId: 'food-expiry-tracker-f807e',
    storageBucket: 'food-expiry-tracker-f807e.appspot.com',
    iosBundleId: 'com.example.fet',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCc9Yxc1KsdWjI8VNji5b0ZgQ9OJ_hJoD0',
    appId: '1:670863775645:ios:e162c5640922198b558174',
    messagingSenderId: '670863775645',
    projectId: 'food-expiry-tracker-f807e',
    storageBucket: 'food-expiry-tracker-f807e.appspot.com',
    iosBundleId: 'com.example.fet.RunnerTests',
  );
}