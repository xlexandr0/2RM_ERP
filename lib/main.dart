import 'package:flutter/material.dart';

import 'app_state.dart';
import 'home_shell.dart';
import 'login_screen.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppState.instance.initialize();
  runApp(const Erp2RMApp());
}

class Erp2RMApp extends StatelessWidget {
  const Erp2RMApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '2RM ERP',
      theme: buildTheme(),
      home: const AppRoot(),
    );
  }
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        if (!state.initialized) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return state.currentUser == null
            ? const LoginScreen()
            : const HomeShell();
      },
    );
  }
}
