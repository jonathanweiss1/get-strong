import 'package:app/controller/train.dart';
import 'package:app/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'controller/home.dart';
import 'services/authentication.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/login.dart';
import 'firebase_options.dart';
import 'services/workoutplan_loader.dart';
import 'view/home.dart';
import 'config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(AuthService());
  Get.put(WorkoutPlanLoaderService());
  Get.put(LoginController());
  Get.put(HomeController());
  Get.put(TrainController());
  runApp(GetMaterialApp(
    home: LoginView(), 
    theme: ThemeData.light().copyWith(
      primaryColor: GSPrimaryColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFFFFFFF),
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: GSTextColor,
        ),
        actionsIconTheme: IconThemeData(color: GSTextColor)
      ),
      tabBarTheme: const TabBarTheme(
        indicator: BoxDecoration(border: Border(bottom: BorderSide(color: GSHighlightColor))),
        unselectedLabelColor: GSTextColor,
        labelColor: GSHighlightColor
        ),
    ),
    title: 'Get Strong!',
    debugShowCheckedModeBanner: false,
    ));
}

class LoginView extends GetView<LoginController> {
  final LoginController loginCtrl = Get.find();
  final AuthService authService = Get.find<AuthService>();

  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    if(authService.getCurrentUser() != null || DEBUG_SKIP_AUTH) {
      Future.microtask(() => Get.off(HomeView()));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Get Strong!"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(
                labelText: "E-mail"
              ),
              controller: loginCtrl.emailEditingController
            ),
            TextField(decoration: const InputDecoration(
              labelText: "Password",
              ),
              controller: loginCtrl.passwordEditingController,
              obscureText: true,
            ),
            TextButton(
              child: const Text("Log In"),
              onPressed: () async {
                final GSUser? user = await authService.signInUser(loginCtrl.emailEditingController.text, loginCtrl.passwordEditingController.text);
                if (user != null) {
                  Get.off(() => HomeView());
                }
              }
            ),
            TextButton(child: const Text("Sign Up"),
            onPressed: () async {
                final GSUser? user = await authService.signUpUser(loginCtrl.emailEditingController.text, loginCtrl.passwordEditingController.text);
                if (user != null) {
                  Get.off(() => HomeView());
                }
              }
            )
          ],
        ),
      ),
    );
  }
}