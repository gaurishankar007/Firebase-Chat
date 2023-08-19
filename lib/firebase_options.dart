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
    apiKey: 'AIzaSyAfjr-aDw_zVDV7Hc-iFiWe6EEeXY2j_g4',
    appId: '1:443164608873:web:d362437c40d71013d395f8',
    messagingSenderId: '443164608873',
    projectId: 'fir-chat-b2405',
    authDomain: 'fir-chat-b2405.firebaseapp.com',
    storageBucket: 'fir-chat-b2405.appspot.com',
    measurementId: 'G-53DJDLKPC3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAgSHtVjps0_86MFvoiKZAvHa-sDV9kuUU',
    appId: '1:443164608873:android:075c480321641537d395f8',
    messagingSenderId: '443164608873',
    projectId: 'fir-chat-b2405',
    storageBucket: 'fir-chat-b2405.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAoi-jDXBj10qD3Vgs3ROr6pkt8VCRy2Io',
    appId: '1:443164608873:ios:c538eee44b77234cd395f8',
    messagingSenderId: '443164608873',
    projectId: 'fir-chat-b2405',
    storageBucket: 'fir-chat-b2405.appspot.com',
    androidClientId: '443164608873-ph9otl70kbtu4qcje5548i19cdf5car7.apps.googleusercontent.com',
    iosClientId: '443164608873-e6fnq2ae21g1h0vfjr6fch01m38jtk3h.apps.googleusercontent.com',
    iosBundleId: 'com.example.firebaseChat',
  );
}
