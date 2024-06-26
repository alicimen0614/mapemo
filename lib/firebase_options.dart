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
    apiKey: 'AIzaSyC4EOisiqhaLulU7v-dwKt7fecf5xYSxcI',
    appId: '1:853048177308:web:1514c28374ee1957527359',
    messagingSenderId: '853048177308',
    projectId: 'e-commerce-ml-f4c7c',
    authDomain: 'e-commerce-ml-f4c7c.firebaseapp.com',
    storageBucket: 'e-commerce-ml-f4c7c.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDiSQWuVMTWKOkxwyiioskQ9jMTclp9Hjo',
    appId: '1:853048177308:android:ede5dd88c3fe43dc527359',
    messagingSenderId: '853048177308',
    projectId: 'e-commerce-ml-f4c7c',
    storageBucket: 'e-commerce-ml-f4c7c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBjHyi7h1r0-vEcdTmEwov13BDLxRcIi00',
    appId: '1:853048177308:ios:bc7b53a7d03b87ef527359',
    messagingSenderId: '853048177308',
    projectId: 'e-commerce-ml-f4c7c',
    storageBucket: 'e-commerce-ml-f4c7c.appspot.com',
    iosBundleId: 'com.example.eCommerceMl',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBjHyi7h1r0-vEcdTmEwov13BDLxRcIi00',
    appId: '1:853048177308:ios:3060dde92b38ab9e527359',
    messagingSenderId: '853048177308',
    projectId: 'e-commerce-ml-f4c7c',
    storageBucket: 'e-commerce-ml-f4c7c.appspot.com',
    iosBundleId: 'com.example.eCommerceMl.RunnerTests',
  );
}
