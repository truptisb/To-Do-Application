import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading=false;

 void _signup() async {
  if (!_formKey.currentState!.validate()) {
    return;
  }

  setState(() => _isLoading = true);
  try {
    final response = await AuthService().signUp(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (response.user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signup successful! Please login.')),
      );
      Navigator.pop(context); // Go back to login screen
    }
  } on AuthException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.message)),
    );
  } finally {
    setState(() => _isLoading = false);
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                )
              ],
            ),
              
             
            
            child: Form(key: _formKey,
            child: Column(mainAxisSize: MainAxisSize.min
            ,children: [Icon(Icons.task_alt_rounded,size: 60,color: Colors.indigo,),
            const SizedBox(height: 16,),
            Text('Create Your Account',style: TextStyle(fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.indigo[800]
            ),),
            const SizedBox(height: 24,),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email',prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),),
                      validator: (value) => value != null && value.contains('@')
                        ? null
                        : 'Enter a valid email',
                  ),
            const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value != null && value.length >= 6
                        ? null
                        : 'Password must be at least 6 characters',
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmController,
                    obscureText: true,
                   
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon: Icon(Icons.lock_reset),
                      border: OutlineInputBorder(),
                      
                    ),
                    validator: (value) =>
                        value == _passwordController.text ? null : 'Passwords do not match',
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _signup,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        backgroundColor: Colors.indigo,
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2,
                            )
                          : const Text('Sign Up',style: TextStyle(color: Colors.white),),
                    ),
                  ),
                  const SizedBox(height: 12),
                 Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    const Text(
      "Already have an account?",
      style: TextStyle(
        color: Colors.grey,
        fontSize: 14,
      ),
    ),
    TextButton(
      onPressed: () {
        Navigator.pop(context); // Go back to login
      },
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        foregroundColor: const Color(0xFF4F46E5), // Indigo shade
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      child: const Text("Login"),
    ),
  ],
),

            ]
            ),
          ),
        ),
      ),
    ),

    );
  }
}