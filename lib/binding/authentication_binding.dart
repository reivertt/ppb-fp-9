import 'package:get/get.dart';
import 'package:ppb_fp_9/repository/authentication_repository.dart';
import 'package:ppb_fp_9/controller/authentication_controller.dart';

class AuthenticationBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthenticationRepository());
    Get.lazyPut(() => AuthenticationController());
  }
}