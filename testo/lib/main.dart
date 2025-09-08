import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/auth/ui/login_screen.dart';
import 'features/home/ui/home_screen.dart';
import 'core/session.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final token = await Session.getToken();
  runApp(ProviderScope(
      child: MyApp(initialRoute: token != null ? '/home' : '/login')));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Ecommerce',
      theme: ThemeData(useMaterial3: true),
      home: initialRoute == '/login' ? const LoginScreen() : const HomeScreen(),
    );
  }
}
