import 'package:flutter/material.dart';

class SignupFlowScreen extends StatelessWidget {
  const SignupFlowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const Center(
        child: Text(
          'Sign Up Flow - Coming Soon',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
