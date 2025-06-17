import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:ppb_fp_9/controller/authentication_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthenticationController>();

    void navigateRegister() {
      Get.toNamed('/register');
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(64, 128, 64, 64),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 48),
              Image.asset(
                'assets/LOGO.png',
                height: 130,
                width: 90,
              ),
              const SizedBox(height: 48),
              TextField(
                controller: authController.emailController,
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
                controller: authController.passwordController,
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
              Obx(() {
                return authController.errorCode.value.isNotEmpty
                    ? Column(
                  children: [
                    Text(authController.errorCode.value, style: TextStyle(color: Colors.red)),
                    const SizedBox(height: 12)
                  ],
                ) : const SizedBox.shrink();
              }),
              Obx(() {
                return SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: authController.isLoading.value ? null : () => authController.signIn(),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.all(16),
                      backgroundColor: Color(0xFF046526),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)
                      ),
                    ),
                    child: authController.isLoading.value
                        ? const SizedBox(
                            height: 20.0,
                            width: 20.0,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3.0,
                            ),
                          )
                        : const Text('Login', style: TextStyle(fontSize: 16)),
                  ),
                );
              }),
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
