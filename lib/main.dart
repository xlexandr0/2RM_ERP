import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'app_state.dart';
import 'firebase_options.dart';
import 'login_screen.dart';
import 'services/notification_service.dart';
import 'theme.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
  RemoteMessage message,
) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(
    firebaseMessagingBackgroundHandler,
  );

  await NotificationService.initialize();

  await AppState.instance.init();

  runApp(
    const Erp2RMApp(),
  );
}

class Erp2RMApp extends StatelessWidget {
  const Erp2RMApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '2RM ERP',
      theme: buildAppTheme(),
      home: const LoginScreen(),
    );
  }
}