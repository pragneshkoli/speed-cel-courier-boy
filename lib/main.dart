import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speed_cel_courier_boy_app/screens/splash_screen.dart';
import 'theme.dart';
import 'providers/auth_provider.dart';
import 'providers/courier_provider.dart';
import 'screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => CourierProvider()),
      ],
      child: MaterialApp(
        title: 'Courier Delivery App',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}