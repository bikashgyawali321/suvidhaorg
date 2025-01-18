import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class FirebaseOptionsAndroid {
 
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDJshzF1hxqU_czp5XIijzxuuoowHXFkaY',
    appId: '1:675583055979:android:c839d5ab7e3b04df3f792e',
    messagingSenderId: '675583055979',
    projectId: 'suvidha-2901f',
    storageBucket: 'suvidha-2901f.firebasestorage.app',
    androidClientId: '1:675583055979:android:c839d5ab7e3b04df3f792e',
  );


  static FirebaseOptions get currentPlatform => android;
}
