import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ppb_fp_9/controller/authentication_controller.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final authController = Get.put(AuthenticationController());
    final authController = Get.find<AuthenticationController>();


    void navigateLogin() {
      Get.back();
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(64, 128, 64, 64),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                controller: authController.usernameController,
                cursorColor: Color(0xFF046526),
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: "Username",
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
                    Text(
                      authController.errorCode.value,
                      style: TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 12)
                  ],
                ) : SizedBox.shrink();
              }),
              Obx(() {
                return SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: authController.isLoading.value ? null : () => authController.register(),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.all(16),
                      backgroundColor: Color(0xFF046526),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
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
                        : const Text('Register', style: TextStyle(fontSize: 16))
                  )
                );
              }),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account?'),
                  TextButton(
                    onPressed: navigateLogin,
                    child: const Text('Login now', style: TextStyle(color: Color(0xFF046526))),
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
