import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  String _errorCode = "";

  void navigateRegister() {
    if (!context.mounted) return;
    Navigator.pushReplacementNamed(context, 'register');
  }

  void navigateHome() {
    if (!context.mounted) return;
    Navigator.pushReplacementNamed(context, 'home');
  }

  void signIn() async {
    setState(() {
      _isLoading = true;
      _errorCode = "";
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      navigateHome();
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorCode = e.code;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFFDEFFE7),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(64, 128, 64, 64),
        child: Center(
          child: ListView(
            children: [
              const SizedBox(height: 48),
              // Icon(Icons.lock_outline, size: 100, color: Colors.blue[200]),
              Image.asset(
                'assets/LOGO.png',
                height: 130,
                width: 90,
                // color: Colors.blue[200],
              ),
              const SizedBox(height: 48),
              TextField(
                controller: _emailController,
                cursorColor: Color(0xFF046526),
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(color: Color(0xFF046526)),
                  hintStyle: TextStyle(color: Color(0xFF046526)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black38),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF046526)),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              const SizedBox(height: 12,),
              TextField(
                controller: _passwordController,
                cursorColor: Color(0xFF046526),
                style: TextStyle(color: Colors.black),
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: TextStyle(color: Color(0xFF046526)),
                  hintStyle: TextStyle(color: Color(0xFF046526)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black38),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF046526)),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _errorCode != ""
                  ? Column(
                  children: [Text(_errorCode), const SizedBox(height: 12)])
                  : const SizedBox(height: 0),
              OutlinedButton(
                onPressed: signIn,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.all(16),
                  backgroundColor: Color(0xFF046526),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6), // Radius sudut
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white, )
                    : const Text('Login', style: TextStyle(fontSize: 16),),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'t have an account?'),
                  TextButton(
                    onPressed: navigateRegister,
                    child: const Text('Register', style: TextStyle(color: Color(0xFF046526)),),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}