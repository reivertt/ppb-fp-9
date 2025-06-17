import 'package:get/get.dart';
import 'package:ppb_fp_9/services/notification_service.dart';
import 'package:ppb_fp_9/binding/authentication_binding.dart';
import 'package:ppb_fp_9/repository/authentication_repository.dart';
import 'package:ppb_fp_9/screens/home.dart';
import 'package:ppb_fp_9/screens/login.dart';
import 'package:ppb_fp_9/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await NotificationService().init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((_) => Get.put(AuthenticationRepository()));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = Get.find<AuthenticationRepository>();
    return GetMaterialApp(
      theme: ThemeData(),
      initialBinding: AuthenticationBindings(),
      home: Obx(() {
        if (authRepository.firebaseUser.value != null) {
          return const HomeScreen();
        } else {
          return const LoginScreen();
        }
      }),
      getPages: [
        GetPage(name: '/home', page: () => const HomeScreen()),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/register', page: () => const RegisterScreen()),
      ],
    );
  }
}