import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

/// Controller for login view. Essentially only handles text input.
class LoginController extends GetxController {
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
}