import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/login_screen.dart';


import 'package:flutter_application_1/auth/signup_scree.dart';
import 'package:flutter_application_1/Dashboard/homepage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
  url: 'https://upxqmznbsggechfzmctc.supabase.co',
  anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVweHFtem5ic2dnZWNoZnptY3RjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDUxNTcwODEsImV4cCI6MjA2MDczMzA4MX0.9gqztdwc6yxEAGezboX5xyBmsWllaIjJAGNM7I-5GYg',
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

