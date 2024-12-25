import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_strong/config.dart';
import 'package:get_strong/controller/login.dart';
import 'package:get_strong/model/user.dart';
import 'package:get_strong/services/authentication.dart';
import 'package:get_strong/view/home.dart';

/// Login screen. This is extremely basic at the moment. 
/// Only email and password fields which are used for both login and signup. 
/// No password strength check, no error messages, no email verification
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