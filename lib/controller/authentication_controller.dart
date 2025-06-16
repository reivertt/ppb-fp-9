import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ppb_fp_9/repository/authentication_repository.dart';

class AuthenticationController extends GetxController {
  static AuthenticationController get instance => Get.find();

  final authRepository = Get.find<AuthenticationRepository>();

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  RxBool isLoading = false.obs;
  RxString errorCode = "".obs;

  void register() async {
    print("cont-called");
    isLoading.value = true;
    errorCode.value = "";

    try {
      print("cont-attempt");
      final userCredential = await authRepository.registerWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      print("cont-back");
      if (userCredential.user != null) {
        await authRepository.saveUserData(userCredential.user!, usernameController.text.trim());
        // Get.offAllNamed('login');
      }
      print("cont-navigate");
    } catch (e) {
      print("cont-err");
      errorCode.value = e.toString();
    } finally {
      print("cont-stop load");
      isLoading.value = false;
      passwordController.text = "";
    }
  }

  Future<void> signIn() async {
    print("cont-called");
    isLoading.value = true;
    errorCode.value = "";

    try {
      print("cont-attempt");
      await authRepository.signInWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      print("cont-finished");
      // Get.offAllNamed('home');
      print("cont-navigate");
    } catch (e) {
      print("cont-err");
      errorCode.value = e.toString();
    } finally {
      print("cont-stop load");
      isLoading.value = false;
      passwordController.text = "";
    }
  }
}