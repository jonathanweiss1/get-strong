import 'package:app/model/user.dart';

import 'services/authentication.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/login.dart';
import 'firebase_options.dart';
import 'view/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(AuthService());
  Get.put(LoginController());
  runApp(GetMaterialApp(
    home: LoginView(), 
    theme: ThemeData(
        primarySwatch: Colors.blue,
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
                  Get.to(() => HomeView());
                }
              }
            ),
            TextButton(child: const Text("Sign Up"),
            onPressed: () async {
                final GSUser? user = await authService.signUpUser(loginCtrl.emailEditingController.text, loginCtrl.passwordEditingController.text);
                if (user != null) {
                  Get.to(() => HomeView());
                }
              }
            )
          ],
        ),
      ),
    );
  }
}