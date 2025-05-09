// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyAyryu4L0MnoLx8vZ_rqlyEkfG3cLXudb0',
    appId: '1:413841884950:web:cb0bbc9f1077d1aeed7237',
    messagingSenderId: '413841884950',
    projectId: 'app-ban-banh',
    authDomain: 'app-ban-banh.firebaseapp.com',
    storageBucket: 'app-ban-banh.firebasestorage.app',
    measurementId: 'G-MM4JHSGRR3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyACV1VB38Q5ZfCBBevshFYydpZXc3neqjA',
    appId: '1:413841884950:android:3a7fe1ec32f02052ed7237',
    messagingSenderId: '413841884950',
    projectId: 'app-ban-banh',
    storageBucket: 'app-ban-banh.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDkH7SZIz3rN_lh0oE_0ZP3WOCAS_ArM0Y',
    appId: '1:413841884950:ios:179a7f08fe7e8002ed7237',
    messagingSenderId: '413841884950',
    projectId: 'app-ban-banh',
    storageBucket: 'app-ban-banh.firebasestorage.app',
    iosBundleId: 'com.example.eCommerical',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDkH7SZIz3rN_lh0oE_0ZP3WOCAS_ArM0Y',
    appId: '1:413841884950:ios:179a7f08fe7e8002ed7237',
    messagingSenderId: '413841884950',
    projectId: 'app-ban-banh',
    storageBucket: 'app-ban-banh.firebasestorage.app',
    iosBundleId: 'com.example.eCommerical',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAyryu4L0MnoLx8vZ_rqlyEkfG3cLXudb0',
    appId: '1:413841884950:web:7075a0719c34e906ed7237',
    messagingSenderId: '413841884950',
    projectId: 'app-ban-banh',
    authDomain: 'app-ban-banh.firebaseapp.com',
    storageBucket: 'app-ban-banh.firebasestorage.app',
    measurementId: 'G-P0Z7P7TCJ9',
  );
}
