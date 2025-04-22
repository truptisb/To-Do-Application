
import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/login_screen.dart';


import 'package:flutter_application_1/auth/signup_scree.dart';
import 'package:flutter_application_1/Dashboard/homepage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
  url: 'URL HERE',
  anonKey: 'Anon key',
);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
     
      home: DashboardScreen(),

      initialRoute: '/dashboard',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/dashboard' :(context) => const DashboardScreen(),
        '/sign_up': (context) => const SignupScreen(),
      }
    );
  }
  
}

