// import 'dart:io';
import 'package:admin_panel/ui/desktopscafold/deskhome.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // Replace with actual values
    options: FirebaseOptions(
      apiKey: "AIzaSyBOBmVN43rGyz5NBEq35WrY33mwzW1Sxc0",
      appId: "1:355123910535:web:dee3f2616293f668af2522",
      messagingSenderId: "355123910535",
      projectId: "instant-services-28b10",
      storageBucket: "instant-services-28b10.appspot.com",
    ),
  );
  runApp(MyApp());
}

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: Deskhome(),
    );
  }
}
